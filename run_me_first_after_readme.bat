@echo off
cls

set ADB_FOLDER=c:\android\platform-tools
set THIS_PATH=%CD%

echo NMMAMP-ExtraMuseum Untethered Boot
echo ----------------------------------
echo Version 1.0.0.0 by Terry Goodwin
echo ----------------------------------
echo Android tools path: %ADB_FOLDER%
echo Running from path: %THIS_PATH%

echo.
echo This will install the launcher, RetroArch, and all other data.
echo Please make sure your device is turned on, waiting at the game select
echo screen, and it is plugged into your computer via USB.
echo.
echo All of this can easily be reversed by running the "remove_all.bat"
echo script, which will return everything to how it was.
echo.
echo These scripts do not modify any of the existing data on your device,
echo they just add some more stuff and modify one single configuration
echo setting.
echo.
echo WARNING! Please make sure no other Android devices are connected!
echo.
set /p CONFIRM="Proceed with installation? (y/n): "

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

echo.
echo Installing retroarch.apk - may fail if already installed, but that's fine...
call %ADB_FOLDER%\adb install %THIS_PATH%\retroarch\retroarch.apk || goto:installfailed
echo Success - retroarch.apk installed (or was already installed)

:launchretroarch
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

:retroarchconfig
echo.
echo Pushing purpose-built RetroArch config into place...
call %ADB_FOLDER%\adb push %THIS_PATH%\retroarch\retroarch.cfg /mnt/media_rw/sdcard/Android/data/com.retroarch.ra32/files/retroarch.cfg || goto:configfailed
echo Config push success

:retroarchoverrides
echo.
echo Pushing purpose-built RetroArch core overrides into place...
call %ADB_FOLDER%\adb push %THIS_PATH%\retroarch\config /mnt/sdcard/RetroArch/ || goto:overridesfailed
echo Overrides push success

:retroarchcores
echo.
echo Copying over RetroArch cores...
call %ADB_FOLDER%\adb push %THIS_PATH%\retroarch\cores /data/data/com.retroarch.ra32/ || goto:coresfailed
echo Cores push success

:playlists
echo.
echo Pushing RetroArch playlists into place...
call %ADB_FOLDER%\adb push %THIS_PATH%\retroarch\playlists /mnt/sdcard/RetroArch/ || goto:playlistsfailed
echo Playlists push success

:roms
echo.
echo Copying over ROMs...
call %ADB_FOLDER%\adb push %THIS_PATH%\roms /data/data/com.retroarch.ra32 || goto:romsfailed
echo ROMs push success

:bios
echo.
echo Copying over BIOS...
call %ADB_FOLDER%\adb push %THIS_PATH%\bios /mnt/sdcard/RetroArch || goto:biosfailed
call %ADB_FOLDER%\adb shell cp /mnt/sdcard/RetroArch/bios/* /mnt/sdcard/RetroArch/ || goto:biosfailed
call %ADB_FOLDER%\adb shell rm -r /mnt/sdcard/RetroArch/bios || goto:biosfailed
echo BIOS push success

:thumbnails
echo.
echo Copying over RetroArch thumbnails...
call %ADB_FOLDER%\adb push %THIS_PATH%\retroarch\thumbnails /data/data/com.retroarch.ra32/ || goto:thumbnailsfailed
echo Thumbnails push success

:launcher
echo.
echo Installing emlauncher.apk from %THIS_PATH%\frontend\emlauncher.apk
call %ADB_FOLDER%\adb install %THIS_PATH%\frontend\emlauncher.apk || goto:installlauncherfailed
echo Success - emlauncher.apk installed (or was already installed)

:gamelist
echo.
echo Pushing game list into place...
call %ADB_FOLDER%\adb push %THIS_PATH%\frontend\gamelist.json /data/data/com.tgoodwin.emlauncher/ || goto:listfailed
echo Gamelist push success

:screenshots
echo.
echo Pushing screenshots into place...
call %ADB_FOLDER%\adb push %THIS_PATH%\frontend\screenshots /data/data/com.tgoodwin.emlauncher/ || goto:screenshotsfailed
echo Screenshots push success

:systems
echo.
echo Pushing system icons into place...
call %ADB_FOLDER%\adb push %THIS_PATH%\frontend\systems /data/data/com.tgoodwin.emlauncher/ || goto:systemsfailed
echo Playlists push success

:emthumbnails
echo.
echo Pushing thumbnails into place...
call %ADB_FOLDER%\adb push %THIS_PATH%\frontend\thumbnails /data/data/com.tgoodwin.emlauncher/ || goto:emthumbnailsfailed
echo Thumbnails push success

:packagexml
echo.
echo Pushing clean package restrictions XML...
call %ADB_FOLDER%\adb push %THIS_PATH%\config\package-restrictions.stock.xml /data/system/users/0/package-restrictions.xml || goto:packagesfailed

:reboot
echo.
echo Rebooting...
call %ADB_FOLDER%\adb reboot

echo.
echo Waiting for 45 seconds for device to reboot...
echo Installation will resume automatically soon.
echo PLEASE be patient, and don't touch anything!
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
goto:launchretroarch

:launchfailed
echo.
echo Failed to launch RetroArch - did it install properly?
goto:retroarchconfig

:configfailed
echo.
echo Failed to push special RetroArch config - is it in the right place with the right name (retroarch\retroarch.cfg)?
echo It might be okay if this fails, but if this is your first time running this you won't be able to control the RetroArch menus...
goto:retroarchoverrides

:overridesfailed
echo.
echo Failed to push core overrides - is the retroarch\configs folder where it should be?
echo This won't change much more than the position on the screen of the games, so continuing...
goto:retroarchcores

:coresfailed
echo.
echo Failed to push RetroArch cores - has the directory (retroarch\cores) been moved or deleted?
echo It might be okay if this fails, but if this is your first time running this you might not have any cores available...
goto:playlists

:playlistsfailed
echo.
echo Failed to push playlists - is the retroarch\playlists folder where it should be?
goto:roms

:romsfailed
echo.
echo Failed to push BIOS/ROMs etc. - has the directory (GAME-EXTRA) been moved or deleted?
echo It might be okay if this fails, but if this is your first time running this you might not have any ROMs available...
goto:bios

:biosfailed
echo.
echo Failed to push BIOS files - has the directory (bios) been moved or deleted?
echo It might be okay if this fails, but if this is your first time running this you might not have any BIOS files available...
goto:thumbnails

:thumbnailsfailed
echo.
echo Failed to push RetroArch thumbnails - has the directory (retroarch\thumbnails) been moved or deleted?
goto:launcher

:installlauncherfailed
echo.
echo Failed to install launcher APK - is it in the right place with the right name (frontend\emlauncher.apk)?
goto:failed

:listfailed
echo.
echo Failed to push game list json- is it in the right place with the right name (frontend\gamelist.json)?
goto:screenshots

:screenshotsfailed
echo.
echo Failed to push screenshots - is the frontend\screenshots folder where it should be?
goto:systems

:systemsfailed
echo.
echo Failed to push system icons - is the frontend\systems folder where it should be?
goto:emthumbnails

:emthumbnailsfailed
echo.
echo Failed to push thumbnails - is the frontend\thumbnails folder where it should be?
goto:packagexml

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

:aborted
echo.
echo Aborted, did nothing
goto:endpause

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
