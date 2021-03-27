@echo off

set ADB_FOLDER=c:\android\platform-tools
set THIS_PATH=%CD%

echo NMMAMP-ExtraMuseum Launcher Data Installer
echo ------------------------------------------
echo Version 0.1.4.0 by Terry Goodwin
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

:thumbnails
echo.
echo Pushing thumbnails into place...
call %ADB_FOLDER%\adb push %THIS_PATH%\frontend\thumbnails /data/data/com.tgoodwin.emlauncher/ || goto:thumbnailsfailed
echo Thumbnails push success

goto:end

REM ----------------------------------- Error States -----------------------------------

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
goto:thumbnails

:thumbnailsfailed
echo.
echo Failed to push thumbnails - is the frontend\thumbnails folder where it should be?
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
goto:endpause

:endpause
echo.
pause
