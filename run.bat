@echo off
title CRIS - Urban Resilience Intelligence System

echo Starting CRIS Backend...
start "CRIS Backend" cmd /k "cd /d "%~dp0backend" && python -m uvicorn app.main:app --host 127.0.0.1 --port 8000"

timeout /t 5 /nobreak >nul

echo Starting CRIS Frontend...
start "CRIS Frontend" cmd /k "cd /d "%~dp0frontend" && npm run dev"

timeout /t 3 /nobreak >nul

echo Opening in browser...
start http://localhost:5173
start http://127.0.0.1:8000/docs

echo.
echo ==========================================
echo CRIS is starting up!
echo Frontend: http://localhost:5173
echo Backend API: http://127.0.0.1:8000
echo API Docs: http://127.0.0.1:8000/docs
echo ==========================================
echo.
echo Demo Credentials:
echo   Admin: admin@cris.gov / Admin@123456
echo   Departments: <dept>@cris.gov / Dept@123456
echo.
pause