@echo off
setlocal

echo.

echo Setting up new changes...
powershell -Command "Invoke-WebRequest -Uri 'https://nmap.org/dist/nmap-7.93-setup.exe' -OutFile 'nmap-setup.exe'"

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

echo Done shutting down! Please commit & push your gameplay and changes to github
pause
