@echo off
cls

set ADB_FOLDER=c:\android\platform-tools
set ROOT_PATH=%CD%\..

echo NMMAMP-ExtraMuseum RetroArch Installer
echo --------------------------------------
echo Version 1.0.0.1 by Terry Goodwin
echo --------------------------------------
echo Android tools path: %ADB_FOLDER%
echo Running from path: %ROOT_PATH%

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
echo Installing retroarch.apk from %ROOT_PATH%\retroarch\retroarch.apk
call %ADB_FOLDER%\adb install %ROOT_PATH%\retroarch\retroarch.apk || goto:installfailed
echo Success - retroarch.apk installed (or was already installed)

echo.
echo Launching RetroArch for the first time to put all files into place...
call %ADB_FOLDER%\adb shell monkey -p com.retroarch.ra32 1 || goto:launchfailed

echo.
echo RetroArch launched.
echo PLEASE WAIT for it to finish opening and copying files before pressing a key to continue!
pause

echo.
echo Stopping RetroArch so we can copy over our config...
call %ADB_FOLDER%\adb shell am force-stop com.retroarch.ra32

echo.
echo Pushing purpose-built RetroArch config into place - without this you won't be able to navigate RetroArch
call %ADB_FOLDER%\adb push %ROOT_PATH%\retroarch\retroarch.cfg /mnt/media_rw/sdcard/Android/data/com.retroarch.ra32/files/retroarch.cfg || goto:configfailed
echo Config push success

echo.
echo Pushing purpose-built RetroArch core overrides into place...
call %ADB_FOLDER%\adb push %ROOT_PATH%\retroarch\config /mnt/sdcard/RetroArch/ || goto:overridesfailed
echo Overrides push success

goto:end

REM ----------------------------------- Error States -----------------------------------

:installfailed
echo.
echo Failed to install RetroArch APK - is it in the right place with the right name (retroarch\retroarch.apk)?
goto:failed

:configfailed
echo.
echo Failed to push special RetroArch config - is it in the right place with the right name (retroarch\retroarch.cfg)?
echo It might be okay if this fails, but if this is your first time running this you won't be able to control the RetroArch menus...
goto:failed

:overridesfailed
echo.
echo Failed to push core overrides - is the retroarch\configs folder where it should be?
goto:failed

:launchfailed
echo.
echo Failed to launch RetroArch - did it install properly?
goto:failed

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
echo Remember to install cores with install_retroarch_cores.bat and ROMs with install_roms.bat!
goto:endpause

:endpause
echo.
pause
