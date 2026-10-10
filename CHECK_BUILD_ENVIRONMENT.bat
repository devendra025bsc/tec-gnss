@echo off
setlocal EnableExtensions
cd /d "%~dp0"

echo ============================================================
echo  GPS_TEC_Advanced  --  BUILD ENVIRONMENT CHECK
echo ============================================================
echo.

echo [CHECK 1] Python 3.11 via "py" launcher...
where py >nul 2>nul
if errorlevel 1 ( echo   FAIL: "py" launcher not found. & goto CHECK2 )
py -3.11 --version >nul 2>nul
if errorlevel 1 ( echo   FAIL: Python 3.11 not installed. & goto CHECK2 )
echo   OK:
py -3.11 --version

:CHECK2
echo.
echo [CHECK 2] Private .venv...
if exist "%~dp0.venv\Scripts\python.exe" (
    echo   OK: .venv exists.
) else (
    echo   INFO: .venv not yet created. BUILD_EXE.bat creates it automatically.
)

echo.
echo [CHECK 3] Runtime dependencies...
if not exist "%~dp0.venv\Scripts\python.exe" ( echo   SKIP: .venv not found. & goto CHECK4 )
"%~dp0.venv\Scripts\python.exe" -c "import numpy,pandas,matplotlib,requests,hatanaka; print('  OK: numpy',numpy.__version__,'pandas',pandas.__version__,'matplotlib',matplotlib.__version__,'hatanaka',hatanaka.__version__)"
if errorlevel 1 echo   FAIL: Some dependencies missing. Run BUILD_EXE.bat.

:CHECK4
echo.
echo [CHECK 4] PyInstaller bootloader...
if not exist "%~dp0.venv\Scripts\python.exe" ( echo   SKIP: .venv not found. & goto SUMMARY )
"%~dp0.venv\Scripts\python.exe" -c "import pathlib,PyInstaller; p=pathlib.Path(PyInstaller.__file__).parent/'bootloader'/'Windows-64bit-intel'; ok=(p/'runw.exe').exists() and (p/'run.exe').exists(); print('  OK: PyInstaller',PyInstaller.__version__) if ok else print('  FAIL: bootloader missing'); raise SystemExit(0 if ok else 1)"

:SUMMARY
echo.
echo ============================================================
echo  Run BUILD_EXE.bat to build the EXE.
echo ============================================================
echo.
pause
exit /b 0
