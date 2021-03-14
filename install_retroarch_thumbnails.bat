@echo off

set ADB_FOLDER=c:\android\platform-tools
set THIS_PATH=%CD%

echo NMMAMP-ExtraMuseum RA Thumbnails Installer
echo ------------------------------------------
echo Version 0.1.3.0 by Terry Goodwin
echo ------------------------------------------
echo Android tools path: %ADB_FOLDER%
echo Running from path: %THIS_PATH%

echo.
echo Getting devices with ADB, will start daemon if it needs to...
call %ADB_FOLDER%\adb devices || goto:devicesfailed
echo ADB success

echo.
echo Getting root access for various protected actions...
call %ADB_FOLDER%\adb root || goto:rootfailed

echo.
echo Remounting the file system so we can write to protected areas...
call %ADB_FOLDER%\adb remount || goto:remountfailed

echo.
echo Copying over RetroArch thumbnails...
call %ADB_FOLDER%\adb push %THIS_PATH%\retroarch\thumbnails /data/data/com.retroarch.ra32/ || goto:thumbnailsfailed
echo Thumbnails push success

goto:end

REM ----------------------------------- Error States -----------------------------------

:thumbnailsfailed
echo.
echo Failed to push RetroArch thumbnails - has the directory (retroarch\thumbnails) been moved or deleted?
goto:endpause

:devicesfailed
echo.
echo Couldn't start ADB or check for devices - are the Android tools installed? Is the path at the top this file correct?
goto:failed

:rootfailed
echo.
echo Failed to initiate adb root, is your My Arcade powered on and plugged into a USB data cable?
goto:failed

:remountfailed
echo.
echo Failed to remount filesystem, without this we can't push files to the My Arcade... Aborting :(
goto:failed

:failed
echo.
echo Finished with errors - things may not have worked. Resolve any errors, and try again.
goto:endpause

REM ----------------------------------- The End -----------------------------------

:end
echo.
echo All finished!
echo To add more thumbnails run this file again.
echo Note that removing thumbnails from retroarch\thumbnails and running this again will not delete them from your device.
goto:endpause

:endpause
echo.
pause
