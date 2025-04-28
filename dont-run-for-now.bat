@echo off
setlocal

REM === Step 1: Navigate to your Fabric server directory ===
REM cd /d "C:\Users\Firda\Documents\Minecraft Servers\DaBoys-Server-Fabric"

REM === Step 2: Pull latest changes from GitHub ===
git fetch origin
git pull
echo Fetched and pulled latest changes from GitHub.

REM === Step 3: Check protocol and rcon changes ===

REM Check if Ncat is already installed
if exist "C:\Program Files (x86)\Nmap\ncat.exe" (
    echo All changes already set. Skipping updates... Ensure that you have pulled the github repo
) else (
    echo Ncat not found. Setting up changes... Ensure that you have pulled the github repo, else stop this file immediately
    echo ...
    powershell -Command "Invoke-WebRequest -Uri 'https://nmap.org/dist/nmap-7.93-setup.exe' -OutFile 'nmap-setup.exe'"

    echo ...
    echo Proceed with requested prompts...
    echo ...
    nmap-setup.exe

    REM Remove the installer after installation
    echo Cleaning...
    if exist "nmap-setup.exe" del "nmap-setup.exe"
)

REM Verify that Ncat is installed
if exist "C:\Program Files (x86)\Nmap\ncat.exe" (
    echo Changes in good order. Proceeding... 
    echo.
    echo ============================
    echo WARNING: Make sure you have pulled any changes in Github Desktop.
    echo Else, restart this process and server.
    echo ============================
    echo.
    ncat --version
) else (
    echo Changes failed! Report to Afaz. Exiting...
    exit /b
)

REM === Step 4: Start the Minecraft server ===
echo.
echo Starting server...

java -Xmx6G -Xms6G -jar fabric-server-mc.1.21.4-loader.0.16.10-launcher.1.0.1.jar

echo Server process has exited.

REM === Step 5: Wait until logs confirm clean shutdown and session.lock is not locked ===
echo Verifying shutdown and session safety...

:waitForSessionLockRelease
(
    REM Try to lock the file to confirm it is not in use
    >"world\session.lock" (
        echo session.lock is not locked. Proceeding...
    )
) 2>nul || (
    echo session.lock is still in use. Waiting...
    timeout /t 2 >nul
    goto waitForSessionLockRelease
)

REM === Step 6: Commit and push changes ===
git add .
git commit -m "Auto-sync after clean server shutdown"
git push

echo Done syncing with GitHub!
pause
