@echo off
setlocal EnableExtensions
cd /d "%~dp0"

echo ============================================================
echo  GPS TEC-DB TEC Advanced  --  DEBUG CONSOLE BUILD
echo ============================================================
echo  Same as BUILD_EXE.bat but console=True so tracebacks show.
echo ============================================================
echo.

if not exist "%~dp0.venv\Scripts\python.exe" (
    echo ERROR: .venv not found. Run BUILD_EXE.bat first.
    pause
    exit /b 1
)

set TMPSPEC=%TEMP%\gps_tec_debug.spec
"%~dp0.venv\Scripts\python.exe" -c "import pathlib; s=pathlib.Path(r'%~dp0GPS_TEC_DB_TEC.spec').read_text(); s=s.replace('console=False','console=True'); s=s.replace(\"name='GPS_TEC_Advanced'\",\"name='GPS_TEC_Advanced_DEBUG'\",1); pathlib.Path(r'%TMPSPEC%').write_text(s)"

if exist "%~dp0build" rmdir /s /q "%~dp0build"
if exist "%~dp0dist"  rmdir /s /q "%~dp0dist"

set WORK="%~dp0build"
set DIST="%~dp0dist"
"%~dp0.venv\Scripts\python.exe" -m PyInstaller --noconfirm --clean --workpath %WORK% --distpath %DIST% "%TMPSPEC%"
if errorlevel 1 ( echo DEBUG BUILD FAILED. & pause & exit /b 1 )

echo.
echo DEBUG BUILD SUCCESSFUL.
echo Launch from a Command Prompt window to see full tracebacks:
echo   %~dp0dist\GPS_TEC_Advanced_DEBUG\GPS_TEC_Advanced_DEBUG.exe
echo.
pause
exit /b 0
