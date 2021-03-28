@echo off

cls

set ADB_FOLDER=c:\android\platform-tools
set THIS_PATH=%CD%

echo NMMAMP-ExtraMuseum All RA Data Uninstaller
echo ------------------------------------------
echo Version 0.1.4.1 by Terry Goodwin
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
echo *********************************************************************
echo Removing RetroArch cores...
echo *********************************************************************
echo.
echo Getting list of installed cores...
call %ADB_FOLDER%\adb shell ls /data/data/com.retroarch.ra32/cores || goto:listcoresfailed

echo.
set /p CONFIRM="Uninstall all cores? (y/n): "

if "%CONFIRM%"=="y" (goto uninstall_cores)
if "%CONFIRM%"=="yes" (goto uninstall_cores)
if "%CONFIRM%"=="Y" (goto uninstall_cores)
if "%CONFIRM%"=="YES" (goto uninstall_cores)
goto:playlists

:uninstall_cores
echo.
echo Uninstalling all cores
call %ADB_FOLDER%\adb shell rm -r /data/data/com.retroarch.ra32/cores || goto:coresfailed
call %ADB_FOLDER%\adb shell mkdir /data/data/com.retroarch.ra32/cores || goto:coresfailed

:playlists
echo.
echo *********************************************************************
echo Removing RetroArch playlists...
echo *********************************************************************
echo.
echo Getting list of installed playlists...
call %ADB_FOLDER%\adb shell ls /mnt/sdcard/RetroArch/playlists || goto:listcoresfailed

echo. 
echo Have you downloaded any playlists you want to keep before removing them?
echo.
set /p CONFIRM="Uninstall all playlists? (y/n): "

if "%CONFIRM%"=="y" (goto uninstall_playlists)
if "%CONFIRM%"=="yes" (goto uninstall_playlists)
if "%CONFIRM%"=="Y" (goto uninstall_playlists)
if "%CONFIRM%"=="YES" (goto uninstall_playlists)
goto:thumbnails

:uninstall_playlists
echo.
echo Uninstalling all playlists
call %ADB_FOLDER%\adb shell rm -r /mnt/sdcard/RetroArch/playlists || goto:playlistsfailed
call %ADB_FOLDER%\adb shell mkdir /mnt/sdcard/RetroArch/playlists || goto:playlistsfailed

:thumbnails
echo.
echo *********************************************************************
echo Removing RetroArch thumbnails...
echo *********************************************************************
echo.
set /p CONFIRM="Uninstall all thumbnails? (y/n): "

if "%CONFIRM%"=="y" (goto uninstall_thumbnails)
if "%CONFIRM%"=="yes" (goto uninstall_thumbnails)
if "%CONFIRM%"=="Y" (goto uninstall_thumbnails)
if "%CONFIRM%"=="YES" (goto uninstall_thumbnails)
goto:end

:uninstall_thumbnails
echo.
echo Uninstalling all thumbnails
call %ADB_FOLDER%\adb shell rm -r /data/data/com.retroarch.ra32/thumbnails || goto:thumbnailsfailed
call %ADB_FOLDER%\adb shell mkdir /data/data/com.retroarch.ra32/thumbnails || goto:thumbnailsfailed
goto:end

REM ----------------------------------- Error States -----------------------------------

:listcoresfailed
echo.
echo Failed to list RetroArch cores - have you removed the cores directory on the device by hand?
echo Run install_retroarch_cores.bat to install some cores
goto:playlists

:coresfailed
echo.
echo Failed to remove RetroArch cores - has the directory been removed?
goto:playlists

:listplaylistsfailed
echo.
echo Failed to list RetroArch playlists - have you removed the playlists directory on the device by hand?
goto:thumbnails

:playlistsfailed
echo.
echo Failed to remove RetroArch playlists - has the directory been removed?
goto:thumbnails

:thumbnailsfailed
echo.
echo Failed to remove RetroArch thumbnails - has the directory been removed?
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
