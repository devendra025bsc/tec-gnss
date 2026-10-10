GPS TEC-DB TEC Advanced — DCB / NETWORK NOTES
==============================================

DCB Source
----------
The processor uses CODE monthly DCB products from the AIUB web service:

  Primary:   https://www.aiub.unibe.ch/download/CODE/{year}/
  Fallback:  http://www.aiub.unibe.ch/download/CODE/{year}/

The legacy ftp.aiub.unibe.ch FTP endpoint is intentionally NOT used because
it frequently times out or hangs on university / institutional networks.

Files used (per observation month):
  P1C1yymm.DCB(.Z)      — GPS satellite P1-C1 differential code bias
  P1P2yymm_ALL.DCB(.Z)  — GPS+GLONASS satellite & receiver P1-P2 DCB
  P1P2yymm.DCB(.Z)      — fallback (satellite-only; receiver DCB = 0)

Downloaded files are cached in the per-day  dcb\  subfolder and reused
automatically on subsequent runs.

Offline / Firewall Operation
-----------------------------
If the AIUB server is unreachable, download the DCB files manually:

  https://www.aiub.unibe.ch/download/CODE/

Place them in the correct  gps_tec_data\<year>\<doy>\<station>\dcb\  folder
(or wherever the log says it is looking) before rerunning the processor.

Navigation File
---------------
The processor tries these sources in order:
  1. https://geodesy.noaa.gov/corsdata/rinex/<year>/<doy>/brdc<doy>0.<yy>n.gz
  2. https://igs.bkg.bund.de/root_ftp/IGS/BRDC/<year>/<doy>/BRDC00WRD_R_...
  3. https://igs.bkg.bund.de/root_ftp/IGS/BRDC/<year>/<doy>/BRDC00IGS_R_...

If all fail, supply the navigation file manually via:
  - GUI: the program will prompt or fall back to a cached file
  - CLI: --nav /path/to/BRDC...rnx
