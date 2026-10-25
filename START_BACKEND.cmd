@echo off
cd /d "%~dp0backend"
if not exist .venv\Scripts\python.exe (
 echo Run SETUP.cmd first.
 pause
 exit /b 1
)
.venv\Scripts\python.exe -m uvicorn app.main:app --reload
pause
