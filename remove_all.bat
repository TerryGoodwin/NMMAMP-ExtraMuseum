@echo off

set ADB_FOLDER=c:\android\platform-tools
set THIS_PATH=%CD%

echo NMMAMP-ExtraMuseum Remove Extra Museum
echo --------------------------------------
echo Version 0.1.2.0 by Terry Goodwin
echo --------------------------------------
echo Android tools path: %ADB_FOLDER%
echo Running from path: %THIS_PATH%

echo.
echo Uninstall everything? This will uninstall the launcher, RetroArch, any ROMs, cores, and other data that's been added by these scripts.
set /p CONFIRM="Proceed with uninstalling? (y/n): "

if "%CONFIRM%"=="y" (goto proceed)
if "%CONFIRM%"=="yes" (goto proceed)
if "%CONFIRM%"=="Y" (goto proceed)
if "%CONFIRM%"=="YES" (goto proceed)
goto:aborted

:proceed
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

:uninstalllauncher
echo.
echo Uninstalling Extra Museum launcher...
call %ADB_FOLDER%\adb uninstall com.tgoodwin.emlauncher || goto:uninstalllauncherfailed

:packagexml
echo.
echo Pushing clean package restrictions XML...
call %ADB_FOLDER%\adb push %THIS_PATH%\config\package-restrictions.stock.xml /data/system/users/0/package-restrictions.xml || goto:packagefailed

:uninstall
echo.
echo Uninstalling RetroArch...
call %ADB_FOLDER%\adb uninstall com.retroarch.ra32 || goto:uninstallfailed

:removedata
echo.
echo Removing RetroArch data... (should already be gone, but just in case...)
call %ADB_FOLDER%\adb shell rm -r /mnt/media_rw/sdcard/Android/data/com.retroarch.ra32 || goto:removedatafailed
call %ADB_FOLDER%\adb shell rm -r /data/data/com.retroarch.ra32 || goto:removedatafailed

:removeroms
echo.
echo Removing BIOS/ROMs etc....
call %ADB_FOLDER%\adb shell rm -r /system/media/GAME-EXTRA || goto:removeromsfailed

:reboot
echo.
echo Rebooting...
call %ADB_FOLDER%\adb shell reboot
goto:end

:aborted
echo.
echo Aborted, nothing uninstalled
goto:endpause

REM ----------------------------------- Error States -----------------------------------

:uninstalllauncherfailed
echo.
echo Failed to uninstall Extra Museum launcher - was it already removed?
goto:packagexml

:packagefailed
echo.
echo Failed to push clean package restrictions XML - proceeding...
goto:uninstall

:uninstallfailed
echo.
echo Failed to uninstall RetroArch - was it already removed?
goto:removedata

:removedatafailed
echo.
echo Failed to remove RetroArch data - maybe it was already gone?
goto:removeroms

:removeromsfailed
echo.
echo Failed to remove ROMs - has the directory been removed?
goto:reboot

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
echo All finished! Everything has been removed (unless there was an error...)
echo To re-install, run run_me_first_after_readme.bat
goto:endpause

:endpause
echo.
pause
