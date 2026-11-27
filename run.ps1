<# 
.CRIS - Urban Resilience Intelligence System
Run script for Windows PowerShell
#>

Write-Host "Starting CRIS - Urban Resilience Intelligence System" -ForegroundColor Cyan

$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition

Write-Host "Starting CRIS Backend..." -ForegroundColor Yellow
$backendProc = Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$projectRoot\backend'; python -m uvicorn app.main:app --host 127.0.0.1 --port 8000" -PassThru

Start-Sleep -Seconds 5

Write-Host "Starting CRIS Frontend..." -ForegroundColor Yellow
$frontendProc = Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$projectRoot\frontend'; npm run dev" -PassThru

Start-Sleep -Seconds 3

Write-Host "Opening in browser..." -ForegroundColor Yellow
Start-Process "http://localhost:5173"
Start-Process "http://127.0.0.1:8000/docs"

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "CRIS is starting up!" -ForegroundColor Green
Write-Host "Frontend: http://localhost:5173" -ForegroundColor White
Write-Host "Backend API: http://127.0.0.1:8000" -ForegroundColor White
Write-Host "API Docs: http://127.0.0.1:8000/docs" -ForegroundColor White
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Demo Credentials:" -ForegroundColor Yellow
Write-Host "  Admin: admin@cris.gov / Admin@123456" -ForegroundColor White
Write-Host "  Departments: <dept>@cris.gov / Dept@123456" -ForegroundColor White
Write-Host ""
Write-Host "Close the backend/frontend windows to stop services." -ForegroundColor Gray
Read-Host "Press Enter to exit"