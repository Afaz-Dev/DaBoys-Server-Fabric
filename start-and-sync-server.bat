@echo off
setlocal

REM === Step 1: Navigate to your Fabric server directory ===
REM cd /d "C:\Users\Firda\Documents\Minecraft Servers\DaBoys-Server-Fabric"

REM === Step 2: Pull latest changes ===
git fetch origin
git pull
echo Fetched and pull Github repo

REM === Step 3: Start the Minecraft server ===
REM This will run the server and wait until it closes
echo.
echo Starting server...
java -Xmx6G -Xms6G -jar fabric-server-mc.1.21.4-loader.0.16.10-launcher.1.0.1.jar
echo Server stopped.

REM === Step 4: Wait until session.lock is gone ===
REM This avoids committing while world is still saving
:waitForSessionLock
if exist "world\session.lock" (
    echo Waiting for session.lock to disappear...
    timeout /t 2 >nul
    goto waitForSessionLock
)

REM === Step 5: Commit and push changes ===
git add .
git commit -m "Auto-sync after server session"
git push

echo Done syncing with GitHub!
pause
