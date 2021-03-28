@echo off
cls

set ADB_FOLDER=c:\android\platform-tools
set ROOT_PATH=%CD%\..

echo NMMAMP-ExtraMuseum Launcher Data Installer
echo ------------------------------------------
echo Version 1.0.0.1 by Terry Goodwin
echo ------------------------------------------
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
echo *********************************************************************
echo Copying over frontend game list...
echo *********************************************************************
echo.
set /p CONTINUE="Proceed? (y/n): "

if "%CONTINUE%"=="y" (goto continue_gamelist)
if "%CONTINUE%"=="yes" (goto continue_gamelist)
if "%CONTINUE%"=="Y" (goto continue_gamelist)
if "%CONTINUE%"=="YES" (goto continue_gamelist)
goto:screenshots

:continue_gamelist
echo.
echo Pushing game list into place...
call %ADB_FOLDER%\adb push %ROOT_PATH%\frontend\gamelist.json /data/data/com.tgoodwin.emlauncher/ || goto:listfailed
echo Gamelist push success

:screenshots
echo.
echo *********************************************************************
echo Copying over frontend screenshots...
echo *********************************************************************
echo.
set /p CONTINUE="Proceed? (y/n): "

if "%CONTINUE%"=="y" (goto continue_screenshots)
if "%CONTINUE%"=="yes" (goto continue_screenshots)
if "%CONTINUE%"=="Y" (goto continue_screenshots)
if "%CONTINUE%"=="YES" (goto continue_screenshots)
goto:systems

:continue_screenshots
echo.
echo Pushing screenshots into place...
call %ADB_FOLDER%\adb push %ROOT_PATH%\frontend\screenshots /data/data/com.tgoodwin.emlauncher/ || goto:screenshotsfailed
echo Screenshots push success

:systems
echo.
echo *********************************************************************
echo Copying over frontend system icons...
echo *********************************************************************
echo.
set /p CONTINUE="Proceed? (y/n): "

if "%CONTINUE%"=="y" (goto continue_systems)
if "%CONTINUE%"=="yes" (goto continue_systems)
if "%CONTINUE%"=="Y" (goto continue_systems)
if "%CONTINUE%"=="YES" (goto continue_systems)
goto:thumbnails

:continue_systems
echo.
echo Pushing system icons into place...
call %ADB_FOLDER%\adb push %ROOT_PATH%\frontend\systems /data/data/com.tgoodwin.emlauncher/ || goto:systemsfailed
echo Playlists push success

:thumbnails
echo.
echo *********************************************************************
echo Copying over frontend thumbnails...
echo *********************************************************************
echo.
set /p CONTINUE="Proceed? (y/n): "

if "%CONTINUE%"=="y" (goto continue_thumbnails)
if "%CONTINUE%"=="yes" (goto continue_thumbnails)
if "%CONTINUE%"=="Y" (goto continue_thumbnails)
if "%CONTINUE%"=="YES" (goto continue_thumbnails)
goto:end

:continue_thumbnails
echo.
echo Pushing thumbnails into place...
call %ADB_FOLDER%\adb push %ROOT_PATH%\frontend\thumbnails /data/data/com.tgoodwin.emlauncher/ || goto:thumbnailsfailed
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
