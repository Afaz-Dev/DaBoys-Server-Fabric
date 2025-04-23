@echo off
setlocal

REM === Step 1: Navigate to your Fabric server directory ===
REM cd /d "C:\Users\Firda\Documents\Minecraft Servers\DaBoys-Server-Fabric"

REM === Step 2: Pull latest changes from GitHub ===
git fetch origin
git pull
echo Fetched and pulled latest changes from GitHub.

REM === Step 3: Start the Minecraft server ===
echo.
echo Starting server...
java -Xmx6G -Xms6G -jar fabric-server-mc.1.21.4-loader.0.16.10-launcher.1.0.1.jar
echo Server process has exited.

REM === Step 4: Wait until logs confirm clean shutdown and session.lock is not locked ===
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

REM === Step 5: Commit and push changes ===
git add .
git commit -m "Auto-sync after clean server shutdown"
git push

echo Done syncing with GitHub!
pause
