@echo off
setlocal
cd /d "%~dp0"

echo ============================================================
echo  GPS_TEC_Advanced  --  PYINSTALLER BOOTLOADER CHECK
echo ============================================================
echo.

if not exist "%~dp0.venv\Scripts\python.exe" (
    echo INFO: .venv not found.  Run BUILD_EXE.bat to create it.
    pause
    exit /b 1
)

"%~dp0.venv\Scripts\python.exe" -c "import pathlib,PyInstaller; p=pathlib.Path(PyInstaller.__file__).parent/'bootloader'/'Windows-64bit-intel'; print('Location  :', PyInstaller.__file__); print('Version   :', PyInstaller.__version__); print('runw.exe  :', (p/'runw.exe').exists()); print('run.exe   :', (p/'run.exe').exists()); ok=(p/'runw.exe').exists() and (p/'run.exe').exists(); print(); print('STATUS    : OK' if ok else 'STATUS    : BOOTLOADER MISSING'); raise SystemExit(0 if ok else 1)"
if errorlevel 1 (
    echo.
    echo Repair command:
    echo   .venv\Scripts\python.exe -m pip install --force-reinstall --no-cache-dir "pyinstaller==6.11.1"
    echo.
    pause
    exit /b 1
)

echo.
echo BOOTLOADER OK.
pause
exit /b 0
