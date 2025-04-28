@echo off
setlocal

echo.

REM Check if Ncat is already installed
if exist "C:\Program Files (x86)\Nmap\ncat.exe" (
    echo All changes already set. Skipping updates... Ensure that you have pulled the github repo
) else (
    echo Ncat not found. Setting up changes... \n Ensure that you have pulled the github repo, else stop this file immediately
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


echo Starting server...
java -Xmx10G -Xms10G -jar fabric-server-mc.1.21.4-loader.0.16.10-launcher.1.0.1.jar

echo Server process has exited.

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

echo Done shutting down! Please commit and push your gameplay and changes to github
pause
