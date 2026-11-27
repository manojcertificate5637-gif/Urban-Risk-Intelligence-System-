@echo off
title CRIS - Urban Resilience Intelligence System

echo ==========================================
echo CRIS - Urban Resilience Intelligence System
echo ==========================================
echo.

REM Check if Python is available
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python not found in PATH
    echo Please install Python 3.11+ from https://python.org
    pause
    exit /b 1
)

REM Check if Node.js is available
node --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Node.js not found in PATH
    echo Please install Node.js 22+ from https://nodejs.org
    pause
    exit /b 1
)

echo [1/4] Setting up backend...
cd /d "%~dp0backend"

REM Create virtual environment if not exists
if not exist ".venv" (
    echo Creating virtual environment...
    python -m venv .venv
)

REM Activate venv and install dependencies
call .venv\Scripts\activate.bat
python -m pip install --upgrade pip >nul 2>&1
echo Installing Python dependencies...
python -m pip install -r requirements.txt >nul 2>&1

REM Run migrations
echo Running database migrations...
python -m alembic upgrade head >nul 2>&1

echo [2/4] Starting backend server...
start "CRIS Backend" cmd /k "cd /d "%~dp0backend" && call .venv\Scripts\activate.bat && python -m uvicorn app.main:app --host 127.0.0.1 --port 8000"

REM Wait for backend to start
echo Waiting for backend to start...
timeout /t 8 /nobreak >nul

echo [3/4] Setting up frontend...
cd /d "%~dp0frontend"

REM Install npm dependencies if node_modules doesn't exist
if not exist "node_modules" (
    echo Installing npm dependencies (this may take a minute)...
    npm ci --legacy-peer-deps >nul 2>&1
)

echo [4/4] Starting frontend dev server...
start "CRIS Frontend" cmd /k "cd /d "%~dp0frontend" && npm run dev"

REM Wait for frontend to compile
echo Waiting for frontend to compile...
timeout /t 10 /nobreak >nul

echo.
echo ==========================================
echo CRIS is now running!
echo ==========================================
echo.
echo Frontend: http://localhost:5173
echo Backend API: http://127.0.0.1:8000
echo API Docs: http://127.0.0.1:8000/docs
echo.
echo Demo Credentials:
echo   Admin: admin@cris.gov / Admin@123456
echo   Departments: <dept>@cris.gov / Dept@123456
echo   (departments: emergency, traffic, water, electricity, disaster, surveillance)
echo.
echo Opening in browser...
start http://localhost:5173
start http://127.0.0.1:8000/docs
echo.
echo Close the backend/frontend command windows to stop the services.
echo ==========================================
pause