GPS TEC-DB TEC Advanced
=======================
Advanced GPS RINEX → STEC / VTEC processor with live BKG station discovery,
Kyoto storm-index annotation, adaptive elevation cutoff, and multi-day batch
processing.  Built on the algorithm of Dr. Gopi K. Seemala (IIG, India).

QUICK START
-----------
1. Prerequisites (one time only)
   - Install Python 3.11 (64-bit) from https://www.python.org/downloads/
     ✓ Tick "Add python.exe to PATH" during installation.

2. Build the EXE
   Double-click  BUILD_EXE.bat
   - Creates a private .venv  (your global Python is NEVER changed)
   - Downloads & installs numpy, pandas, matplotlib, requests, hatanaka
   - Runs PyInstaller 6.11.1 inside the private environment
   - Output:  dist\GPS_TEC_Advanced\GPS_TEC_Advanced.exe

3. Distribute
   Zip the entire   dist\GPS TEC-DB TEC Advanced\   folder.
   Users do NOT need Python installed.

SCRIPTS INCLUDED
----------------
BUILD_EXE.bat              Main build script (run this first)
BUILD_DEBUG.bat            Builds with a console window for traceback reading
CHECK_BUILD_ENVIRONMENT.bat  Verifies Python, .venv, deps, PyInstaller bootloader
CHECK_PYINSTALLER.bat      Quick bootloader-only check / repair instructions

SOURCE FILES  (src\)
--------------------
launch_gui.py          Entry point; handles PyInstaller freeze and crash logging
gps_tec_gui.py         Tkinter GUI — date picker, live station search, processing
gps_tec_complete.py    Core RINEX → TEC processor (DCB, nav, STEC, VTEC, plots)
gps_tec_batch.py       CLI batch processor (day / month / year)
data_manager.py        Live BKG station discovery, RINEX + nav download
kyoto_indices.py       Kyoto HAPI Dst/AE/ASY-SYM fetch + storm-phase annotation
cutoff.py              Adaptive elevation mask selection
performance.py         CPU worker count + optional CuPy GPU detection

KEY FEATURES vs ORIGINAL GPS_TEC.EXE
--------------------------------------
✓ Live BKG/IGS/EUREF/MGEX/GREF station search for any UTC date range
✓ Automatic multi-day multi-station batch processing
✓ Kyoto geomagnetic storm annotation (Dst / AE / ASY-SYM via HAPI)
✓ Optional quiet-day VTEC overlay for storm-impact comparison
✓ Adaptive elevation cutoff (AUTO mode) or fixed mask
✓ Daily independent carrier-phase leveling per satellite arc
✓ Optional CuPy GPU acceleration for large datasets
✓ CMN / STD output files compatible with original GPS-TEC format
✓ Publication-quality STEC+VTEC PNG plots with storm-phase shading
✓ Local RINEX file support (file dialog)
✓ Plot existing TEC CSV or Seemala-compatible CMN data directly without reprocessing
✓ Direct HTTPS file download from a provider URL with optional Basic or Bearer authentication
  (credentials are used for that download only and are not saved)
✓ Hatanaka .crx / .crx.gz and Unix .Z decompression built in

TROUBLESHOOTING
---------------
"Python 3.11 not found"
  → Install from https://www.python.org/downloads/

"Bootloader missing"
  → Run: .venv\Scripts\python.exe -m pip install --force-reinstall --no-cache-dir pyinstaller==6.11.1

"DCB download failed"
  → Place P1C1yymm.DCB and P1P2yymm_ALL.DCB in the per-day dcb\ folder,
    then reprocess. The program reuses cached files automatically.

"Navigation download failed"
  → Download the daily IGS BRDC file from:
      https://geodesy.noaa.gov/corsdata/rinex/<year>/<doy>/
    and supply it via the --nav argument (CLI) or place in nav\ folder.

EXE crashes on startup?
  → Run BUILD_DEBUG.bat, then launch the DEBUG EXE from a Command Prompt
    to see the full Python traceback.

LICENSE
-------
GPS TEC-DB TEC Advanced is released for educational and scientific use.
See individual source files for library licence notices (requests: Apache 2;
matplotlib: PSF; numpy: BSD; hatanaka: MIT; pandas: BSD).

The original GPS-TEC algorithm is described in:
  Seemala, G.K. (2023), Chapter 4 - Estimation of ionospheric TEC from GNSS
  observations, in Earth Observation, Atmospheric Remote Sensing, Elsevier,
  pp. 63-84. https://doi.org/10.1016/B978-0-323-99262-6.00022-5


PLOT EXISTING DATA
------------------
Click "PLOT EXISTING TEC CSV / CMN" to load already-computed data and create
a STEC/VTEC PNG without downloading or processing RINEX. CSV files must contain
a timestamp (datetime/timestamp column or timestamp index) plus STEC and VTEC
columns. CMN input follows the ten-column format described in the GPS-TEC
Readme; set START UTC to the correct date before importing a single-day CMN.

OFFICIAL URL / API DOWNLOAD
---------------------------
"Download from URL / API" accepts an HTTPS direct-file URL and optional Basic
(username/password) or Bearer-token authentication. Secrets are not persisted.
This supports providers that expose direct authenticated downloads. It does
not automate interactive OAuth/browser logins or bypass provider permissions.
For NASA CDDIS/Earthdata or another provider requiring browser-based OAuth,
download through that provider's authorized workflow, then use ADD LOCAL RINEX.
Use only official URLs and credentials you are authorized to use.

SCIENTIFIC CAUTION
------------------
No artificial min/max normalization or guessed observation date is applied.
The processor requires a readable RINEX observation date and the required CODE
DCB products. The absolute TEC accuracy still depends on observation quality,
DCB availability, receiver-bias assumptions, and broadcast ephemeris quality.
Review the generated diagnostic files and plots before scientific publication.

GITHUB STATION INDEX + FULL-YEAR DOWNLOAD
-----------------------------------------
The new button “GitHub station index + DOWNLOAD FULL YEAR” loads a public raw
JSON station catalogue from a GitHub repository and lets you search its metadata.
It then checks each day of the selected year at the chosen official BKG HTTPS
network and downloads only daily observation files actually present in the archive.
The CSV manifest records all days, including missing days and errors.

GitHub stores station metadata/indexes only; it is not used as a mirror for the
bulk RINEX archive. See docs\GITHUB_STATION_INDEX_AND_ANNUAL_DOWNLOAD.md and
 github_index\stations.example.json for setup instructions and the JSON schema.
