@echo off
setlocal EnableExtensions EnableDelayedExpansion
cd /d "%~dp0"

echo ============================================================
echo  GPS TEC-DB TEC Advanced  --  BUILD SCRIPT
echo ============================================================
echo  Creates a private .venv  -  global Python is NEVER changed
echo ============================================================
echo.

where py >nul 2>nul
if errorlevel 1 ( echo ERROR: Python launcher "py" not found. Install Python 3.11 from https://www.python.org/downloads/ & goto FAIL )

py -3.11 --version >nul 2>nul
if errorlevel 1 ( echo ERROR: Python 3.11 is not installed. Download from https://www.python.org/downloads/ & goto FAIL )

echo [1/8] Python 3.11 found:
py -3.11 --version
echo.

echo [2/8] Setting up private build environment (.venv)...
if not exist "%~dp0.venv\Scripts\python.exe" (
    py -3.11 -m venv "%~dp0.venv"
    if errorlevel 1 ( echo ERROR: Could not create .venv & goto FAIL )
    echo        .venv created.
) else (
    echo        .venv already exists, reusing.
)
echo.

echo [3/8] Upgrading pip inside .venv...
"%~dp0.venv\Scripts\python.exe" -m pip install --quiet --upgrade pip
if errorlevel 1 goto FAIL
echo.

echo [4/8] Installing / pinning runtime dependencies...
"%~dp0.venv\Scripts\python.exe" -m pip install --quiet -r "%~dp0requirements.txt"
if errorlevel 1 ( echo ERROR: Dependency installation failed. Check internet connection. & goto FAIL )
echo        Done.
echo.

echo [5/8] Force-pinning numpy to latest 1.x (required for PyInstaller compatibility)...
"%~dp0.venv\Scripts\python.exe" -m pip install --quiet --force-reinstall "numpy>=1.26,<2.0"
if errorlevel 1 ( echo ERROR: numpy pin failed. & goto FAIL )
"%~dp0.venv\Scripts\python.exe" -c "import numpy; v=tuple(int(x) for x in numpy.__version__.split('.')[:2]); print('  numpy',numpy.__version__); raise SystemExit(0 if v[0]==1 else 1)"
if errorlevel 1 ( echo ERROR: numpy is still >=2.0 after pin. Delete .venv and retry. & goto FAIL )
echo.

echo [6/8] Installing PyInstaller 6.11.1 into .venv...
"%~dp0.venv\Scripts\python.exe" -m pip install --quiet --force-reinstall "pyinstaller==6.11.1" "pyinstaller-hooks-contrib"
if errorlevel 1 ( echo ERROR: PyInstaller installation failed. & goto FAIL )
"%~dp0.venv\Scripts\python.exe" -c "import pathlib,PyInstaller; p=pathlib.Path(PyInstaller.__file__).parent/'bootloader'/'Windows-64bit-intel'; ok=(p/'runw.exe').exists() and (p/'run.exe').exists(); print('  PyInstaller',PyInstaller.__version__,'bootloader','OK' if ok else 'MISSING'); raise SystemExit(0 if ok else 1)"
if errorlevel 1 ( echo ERROR: PyInstaller bootloader missing. & goto FAIL )
echo.

echo [7/8] Checking application source...
"%~dp0.venv\Scripts\python.exe" -m compileall -q "%~dp0src"
if errorlevel 1 ( echo ERROR: Syntax error in src\ & goto FAIL )
echo        All source files OK.
echo.

echo [8/8] Building EXE (this may take 2-4 minutes)...
if exist "%~dp0build" rmdir /s /q "%~dp0build"
if exist "%~dp0dist"  rmdir /s /q "%~dp0dist"

set SPEC="%~dp0GPS_TEC_DB_TEC.spec"
set WORK="%~dp0build"
set DIST="%~dp0dist"
"%~dp0.venv\Scripts\python.exe" -m PyInstaller --noconfirm --clean --workpath %WORK% --distpath %DIST% %SPEC%
if errorlevel 1 ( echo ERROR: PyInstaller returned an error. & goto FAIL )

set "EXE=%~dp0dist\GPS_TEC_Advanced\GPS_TEC_Advanced.exe"
if not exist "%EXE%" ( echo ERROR: Build completed but EXE not found at: & echo        %EXE% & goto FAIL )

echo.
echo ============================================================
echo  BUILD SUCCESSFUL
echo ============================================================
echo  EXE : %EXE%
echo  Distribute the folder: %~dp0dist\GPS_TEC_Advanced\
echo  Users do NOT need Python installed.
echo ============================================================
echo.
choice /C YN /N /M "Launch the new EXE now? [Y/N]: "
if errorlevel 2 goto DONE
start "" "%EXE%"

:DONE
pause
exit /b 0

:FAIL
echo.
echo ============================================================
echo  BUILD FAILED  --  see error message above
echo ============================================================
echo  TIP: Delete the .venv folder and rerun if dependency errors persist.
echo  Your global Python was NOT modified.
pause
exit /b 1
