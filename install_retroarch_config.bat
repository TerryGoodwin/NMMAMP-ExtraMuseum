@echo off

set ADB_FOLDER=c:\android\platform-tools
set THIS_PATH=%CD%

echo NMMAMP-ExtraMuseum RA Config Installer
echo --------------------------------------
echo Version 0.1.1.0 by Terry Goodwin
echo --------------------------------------
echo Android tools path: %ADB_FOLDER%
echo Running from path: %THIS_PATH%

echo.
echo Did you download your most recent RetroArch config from your file first before making changes?
echo If you proceed without doing this you may lose changes you've made.
echo To download the latest configuration, run get_latest_retroarch_config.bat
echo To quit the process and abort, close this window.

echo.
pause

echo.
echo Proceeding...

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
echo Pushing purpose-built RetroArch config into place...
call %ADB_FOLDER%\adb push %THIS_PATH%\retroarch\retroarch.cfg /mnt/media_rw/sdcard/Android/data/com.retroarch.ra32/files/retroarch.cfg || goto:configfailed
echo Config push success

goto:end

REM ----------------------------------- Error States -----------------------------------

:configfailed
echo.
echo Failed to push special RetroArch config - is it in the right place with the right name (retroarch\retroarch.cfg)?
echo It might be okay if this fails, but if this is your first time running this you won't be able to control the RetroArch menus...
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

REM ----------------------------------- The End -----------------------------------

:end
echo.
echo All finished!
echo To update the config again, first run get_latest_retroarch_config.bat to get the latest, then call install_retroarch_config.bat`
goto:endpause

:endpause
echo.
pause
