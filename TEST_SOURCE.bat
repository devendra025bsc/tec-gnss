@echo off
setlocal
cd /d "%~dp0"
where py >nul 2>nul
if errorlevel 1 (echo Python launcher not found. Install Python 3.11 x64.& exit /b 1)
py -3.11 -m compileall -q src
if errorlevel 1 (echo Python syntax check failed.& exit /b 1)
echo Source syntax check passed.
echo Run BUILD_EXE.bat on Windows to build the executable.
pause
