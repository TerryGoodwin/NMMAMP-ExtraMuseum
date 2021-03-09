@echo off

set ADB_FOLDER=c:\android\platform-tools
set THIS_PATH=%CD%

echo NMMAMP-ExtraMuseum ROM Installer
echo --------------------------------
echo Version 0.1.0.0 by Terry Goodwin
echo --------------------------------
echo Android tools path: %ADB_FOLDER%
echo Running from path: %THIS_PATH%

echo.
echo Getting devices with ADB, will start daemon if it needs to...
call %ADB_FOLDER%\adb devices || goto:devicesfailed
echo ADB success

echo.
echo Getting root access for various protected actions...
call %ADB_FOLDER%\adb root || goto:rootfailed
echo Root access success

echo.
echo Remounting the file system so we can write to protected areas...
call %ADB_FOLDER%\adb remount || goto:remountfailed
echo Remount success

echo.
echo Copying over BIOS/ROMs etc....
call %ADB_FOLDER%\adb push %THIS_PATH%\GAME-EXTRA /system/media/ || goto:romsfailed
echo ROMs push success

goto:end

REM ----------------------------------- Error States -----------------------------------

:romsfailed
echo.
echo Failed to push BIOS/ROMs etc. - has the directory (GAME-EXTRA) been moved or deleted?
echo It might be okay if this fails, but if this is your first time running this you might not have any ROMs available...
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
echo To add more ROMS run this file again.
echo Note that removing ROMs from GAME-EXTRA and running this again will not delete them from your device.
goto:endpause

:endpause
echo.
pause
