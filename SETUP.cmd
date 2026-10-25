@echo off
setlocal
cd /d "%~dp0"
where python >nul 2>nul
if errorlevel 1 goto missing
where npm.cmd >nul 2>nul
if errorlevel 1 goto missing
cd backend
if not exist .venv\Scripts\python.exe python -m venv .venv
if errorlevel 1 goto failed
.venv\Scripts\python.exe -m pip install -r requirements.txt
if errorlevel 1 goto failed
.venv\Scripts\python.exe init_env.py
if errorlevel 1 goto failed
cd ..\frontend
call npm.cmd ci
if errorlevel 1 goto failed
echo.
echo Setup complete. Open START_BACKEND.cmd and START_FRONTEND.cmd.
pause
exit /b 0
:missing
echo Python and Node.js/npm must be installed and available in PATH.
pause
exit /b 1
:failed
echo Setup failed. Review the error above before continuing.
pause
exit /b 1
