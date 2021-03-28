@echo off
cls

set ADB_FOLDER=c:\android\platform-tools
set ROOT_PATH=%CD%\..

echo NMMAMP-ExtraMuseum ROM Installer
echo --------------------------------
echo Version 1.0.0.0 by Terry Goodwin
echo --------------------------------
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
echo Copying over ROMs...
call %ADB_FOLDER%\adb push %ROOT_PATH%\roms /data/data/com.retroarch.ra32 || goto:romsfailed
echo ROMs push success

:bios
echo.
echo Copying over BIOS...
call %ADB_FOLDER%\adb push %ROOT_PATH%\bios /mnt/sdcard/RetroArch || goto:biosfailed
call %ADB_FOLDER%\adb shell cp /mnt/sdcard/RetroArch/bios/* /mnt/sdcard/RetroArch/ || goto:biosfailed
call %ADB_FOLDER%\adb shell rm -r /mnt/sdcard/RetroArch/bios || goto:biosfailed
echo BIOS push success

goto:end

REM ----------------------------------- Error States -----------------------------------

:romsfailed
echo.
echo Failed to push ROMs - has the directory (roms) been moved or deleted?
echo It might be okay if this fails, but if this is your first time running this you might not have any ROMs available...
goto:bios

:biosfailed
echo.
echo Failed to push BIOS files - has the directory (bios) been moved or deleted?
echo It might be okay if this fails, but if this is your first time running this you might not have any BIOS files available...
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
echo To add more ROMS/BIOS files run this file again.
echo Note that removing ROMs from /roms and running this again will not delete them from your device.
goto:endpause

:endpause
echo.
pause
