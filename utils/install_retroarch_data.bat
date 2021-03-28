@echo off
cls

set ADB_FOLDER=c:\android\platform-tools
set ROOT_PATH=%CD%\..

echo NMMAMP-ExtraMuseum RA Data Installer
echo ------------------------------------
echo Version 1.0.0.0 by Terry Goodwin
echo ------------------------------------
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
echo Copying over RetroArch config...
echo *********************************************************************
echo.
echo Did you download your most recent RetroArch config from your device first before making changes?
echo If you proceed without doing this you may lose changes you've made.
echo To download the latest configuration, run get_latest_retroarch_config.bat
echo.
echo WARNING! Don't do this while RetroArch is running! Your changes won't
echo take effect and when you quit RetroArch it will overwrite them anyway!

echo.
set /p CONTINUE="Proceed? (y/n): "

if "%CONTINUE%"=="y" (goto continue_config)
if "%CONTINUE%"=="yes" (goto continue_config)
if "%CONTINUE%"=="Y" (goto continue_config)
if "%CONTINUE%"=="YES" (goto continue_config)
goto:overrides

:continue_config
echo.
echo Proceeding...

echo.
echo Pushing purpose-built RetroArch config into place...
call %ADB_FOLDER%\adb push %ROOT_PATH%\retroarch\retroarch.cfg /mnt/media_rw/sdcard/Android/data/com.retroarch.ra32/files/retroarch.cfg || goto:configfailed
echo Config push success

:overrides
echo.
echo *********************************************************************
echo Copying over RetroArch core overrides...
echo *********************************************************************
echo.
echo Did you download your most recent overrides from your devices first before making changes?
echo If you proceed without doing this you may lose changes you've made.
echo To download the latest configuration, run get_latest_retroarch_core_overrides.bat
echo.
echo WARNING! Don't do this while RetroArch is running! Your changes might not
echo take effect and may be lost!

echo.
set /p CONTINUE="Proceed? (y/n): "

if "%CONTINUE%"=="y" (goto continue_overrides)
if "%CONTINUE%"=="yes" (goto continue_overrides)
if "%CONTINUE%"=="Y" (goto continue_overrides)
if "%CONTINUE%"=="YES" (goto continue_overrides)
goto:cores

:continue_overrides
echo.
echo Proceeding...

echo.
echo Pushing purpose-built RetroArch core overrides into place...
call %ADB_FOLDER%\adb push %ROOT_PATH%\retroarch\config /mnt/sdcard/RetroArch/ || goto:overridesfailed
echo Overrides push success

:playlists
echo.
echo *********************************************************************
echo Copying over RetroArch playlists...
echo *********************************************************************
echo.
echo Did you download your most recent playlists from your devices first before making changes?
echo If you proceed without doing this you may lose changes you've made.
echo To download the latest playlists, run get_latest_retroarch_playlists.bat
echo.
echo WARNING! Don't do this while RetroArch is running! Your changes might not
echo take effect and may be lost!

echo.
set /p CONTINUE="Proceed? (y/n): "

if "%CONTINUE%"=="y" (goto continue_playlists)
if "%CONTINUE%"=="yes" (goto continue_playlists)
if "%CONTINUE%"=="Y" (goto continue_playlists)
if "%CONTINUE%"=="YES" (goto continue_playlists)
goto:cores

:continue_playlists
echo.
echo Proceeding...

echo.
echo Pushing RetroArch playlists into place...
call %ADB_FOLDER%\adb push %ROOT_PATH%\retroarch\playlists /mnt/sdcard/RetroArch/ || goto:playlistsfailed
echo Playlists push success

:cores
echo.
echo *********************************************************************
echo Copying over RetroArch cores...
echo *********************************************************************
echo.
set /p CONTINUE="Proceed? (y/n): "

if "%CONTINUE%"=="y" (goto continue_cores)
if "%CONTINUE%"=="yes" (goto continue_cores)
if "%CONTINUE%"=="Y" (goto continue_cores)
if "%CONTINUE%"=="YES" (goto continue_cores)
goto:thumbnails

:continue_cores
echo.
echo Copying over RetroArch cores...
call %ADB_FOLDER%\adb push %ROOT_PATH%\retroarch\cores /data/data/com.retroarch.ra32/ || goto:coresfailed
echo Cores push success

:thumbnails
echo.
echo *********************************************************************
echo Copying over RetroArch thumbnails...
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
echo Copying over RetroArch thumbnails...
call %ADB_FOLDER%\adb push %ROOT_PATH%\retroarch\thumbnails /data/data/com.retroarch.ra32/ || goto:thumbnailsfailed
echo Thumbnails push success

goto:end

REM ----------------------------------- Error States -----------------------------------

:configfailed
echo.
echo Failed to push special RetroArch config - is it in the right place with the right name (retroarch\retroarch.cfg)?
echo It might be okay if this fails, but if this is your first time running this you won't be able to control the RetroArch menus...
goto:overrides

:overridesfailed
echo.
echo Failed to push core overrides - is the retroarch\configs folder where it should be?
goto:playlists

:playlistsfailed
echo.
echo Failed to push playlists - is the retroarch\playlists folder where it should be?
goto:cores

:coresfailed
echo.
echo Failed to push RetroArch cores - has the directory (retroarch\cores) been moved or deleted?
echo It might be okay if this fails, but if this is your first time running this you might not have any cores available...
goto:thumbnails

:thumbnailsfailed
echo.
echo Failed to push RetroArch thumbnails - has the directory (retroarch\thumbnails) been moved or deleted?
goto:end

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
