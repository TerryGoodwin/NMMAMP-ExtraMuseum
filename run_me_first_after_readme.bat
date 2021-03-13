@echo off

set ADB_FOLDER=c:\android\platform-tools
set THIS_PATH=%CD%

echo NMMAMP-ExtraMuseum Untethered Boot
echo ----------------------------------
echo Version 0.1.2.0 by Terry Goodwin
echo ----------------------------------
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
echo Installing retroarch.apk - may fail if already installed, but that's fine...
call %ADB_FOLDER%\adb install %THIS_PATH%\retroarch\retroarch.apk || goto:installfailed
echo Success - retroarch.apk installed (or was already installed)

:retroarchconfig
echo.
echo Pushing purpose-built RetroArch config into place...
call %ADB_FOLDER%\adb push %THIS_PATH%\retroarch\retroarch.cfg /mnt/media_rw/sdcard/Android/data/com.retroarch.ra32/files/retroarch.cfg || goto:configfailed
echo Config push success

:retroarchcores
echo.
echo Copying over RetroArch cores...
call %ADB_FOLDER%\adb push %THIS_PATH%\retroarch\cores /data/data/com.retroarch.ra32/ || goto:coresfailed
echo Cores push success

:roms
echo.
echo Copying over BIOS/ROMs etc....
call %ADB_FOLDER%\adb push %THIS_PATH%\GAME-EXTRA /system/media/ || goto:romsfailed
echo ROMs push success

:launcher
echo.
echo Installing emlauncher.apk from %THIS_PATH%\frontend\emlauncher.apk
call %ADB_FOLDER%\adb install %THIS_PATH%\frontend\emlauncher.apk || goto:installlauncherfailed
echo Success - emlauncher.apk installed (or was already installed)

echo.
echo Pushing clean package restrictions XML...
call %ADB_FOLDER%\adb push %THIS_PATH%\config\package-restrictions.stock.xml /data/system/users/0/package-restrictions.xml || goto:packagesfailed

:reboot
echo.
echo Rebooting...
call %ADB_FOLDER%\adb reboot

echo.
echo Waiting for 45 seconds for device to reboot...
echo PLEASE be patient!
ping 192.0.2.2 -n 1 -w 45000 > delete_me

echo.
echo Tapping EM Launcher...
call %ADB_FOLDER%\adb shell input tap 100 240

echo.
echo Tapping Always...
call %ADB_FOLDER%\adb shell input tap 100 300

goto:end

REM ----------------------------------- Error States -----------------------------------

:installfailed
echo.
echo Failed to install RetroArch APK - is it in the right place with the right name (retroarch\retroarch.apk)?
goto:retroarchconfig

:configfailed
echo.
echo Failed to push special RetroArch config - is it in the right place with the right name (retroarch\retroarch.cfg)?
echo It might be okay if this fails, but if this is your first time running this you won't be able to control the RetroArch menus...
goto:retroarchcores

:coresfailed
echo.
echo Failed to push RetroArch cores - has the directory (retroarch\cores) been moved or deleted?
echo It might be okay if this fails, but if this is your first time running this you might not have any cores available...
goto:roms

:romsfailed
echo.
echo Failed to push BIOS/ROMs etc. - has the directory (GAME-EXTRA) been moved or deleted?
echo It might be okay if this fails, but if this is your first time running this you might not have any ROMs available...
goto:launcher

:installlauncherfailed
echo.
echo Failed to install launcher APK - is it in the right place with the right name (frontend\emlauncher.apk)?
goto:failed

:packagesfailed
echo.
echo Failed to push stock package restrictions configuration - it may be fine and still work, so proceeding...
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

:bootingfailed
echo.
echo Failed to boot RetroArch - did it install correctly?
goto:failed

:failed
echo.
echo Finished with errors - things may not have worked. Resolve any errors, and try again.
goto:endpause

REM ----------------------------------- The End -----------------------------------

:end
echo.
echo All finished!
echo.
echo You should now be looking at the new frontend!
echo.
echo From here you can launch the original museum, or the extra museum (probably RetroArch)
echo.
echo To add more ROMs or cores to RetroArch run install_roms.bat and install_retroarch_cores.bat
echo.
echo To update the RetroArch config, first run get_latest_retroarch_config.bat to get the latest, then call install_retroarch_config.bat`
echo.
echo To return everything to stock, run remove_all.bat
goto:endpause

:endpause
echo.
pause
