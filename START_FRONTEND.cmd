@echo off
cd /d "%~dp0frontend"
if not exist node_modules (
 echo Run SETUP.cmd first.
 pause
 exit /b 1
)
call npm.cmd run dev
pause
