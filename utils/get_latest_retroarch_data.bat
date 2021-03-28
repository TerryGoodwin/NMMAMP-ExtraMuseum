@echo off
cls

set ADB_FOLDER=c:\android\platform-tools
set ROOT_PATH=%CD%\..

echo NMMAMP-ExtraMuseum RA Data Downloader
echo -------------------------------------
echo Version 1.0.0.0 by Terry Goodwin
echo -------------------------------------
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
echo Getting RetroArch config...
echo *********************************************************************
echo.
echo This will download retroarch.cfg from your My Arcade to retroarch\retroarch.new.cfg
echo If you proceed, an existing file at that location with that name will be overwritten without asking.

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
echo Pulling RetroArch config...
call %ADB_FOLDER%\adb pull /mnt/sdcard/Android/data/com.retroarch.ra32/files/retroarch.cfg %ROOT_PATH%\retroarch\retroarch.new.cfg || goto:configfailed
echo Config pull success

:overrides
echo.
echo *********************************************************************
echo Getting RetroArch core overrides...
echo *********************************************************************
echo.
echo This will download core overrides from your My Arcade to retroarch\config
echo If you proceed, any existing configs at that location will be overwritten without asking.

echo.
set /p CONTINUE="Proceed? (y/n): "

if "%CONTINUE%"=="y" (goto continue_overrides)
if "%CONTINUE%"=="yes" (goto continue_overrides)
if "%CONTINUE%"=="Y" (goto continue_overrides)
if "%CONTINUE%"=="YES" (goto continue_overrides)
goto:thumbnails

:continue_overrides
echo.
echo Proceeding...

echo.
echo Pulling RetroArch core overrides...
call %ADB_FOLDER%\adb pull /mnt/sdcard/RetroArch/config %ROOT_PATH%\retroarch\ || goto:overridesfailed
echo Core overrides pull success

:thumbnails
echo.
echo *********************************************************************
echo Getting RetroArch thumbnails...
echo *********************************************************************
echo.
echo This will download thumbnails from your My Arcade to retroarch\thumbnails
echo If you proceed, any existing thumbnails at that location will be overwritten without asking.

echo.
set /p CONTINUE="Proceed? (y/n): "

if "%CONTINUE%"=="y" (goto continue_thumbnails)
if "%CONTINUE%"=="yes" (goto continue_thumbnails)
if "%CONTINUE%"=="Y" (goto continue_thumbnails)
if "%CONTINUE%"=="YES" (goto continue_thumbnails)
goto:playlists

:continue_thumbnails
echo.
echo Proceeding...

echo.
echo Pulling RetroArch thumbnails...
call %ADB_FOLDER%\adb pull /data/data/com.retroarch.ra32/thumbnails %ROOT_PATH%\retroarch\ || goto:thumbnailsfailed
echo Thumbnails pull success

:playlists
echo.
echo *********************************************************************
echo Getting RetroArch playlists...
echo *********************************************************************
echo.
echo This will download playlists from your My Arcade to retroarch\playlists
echo If you proceed, any existing playlists at that location will be overwritten without asking.

echo.
set /p CONTINUE="Proceed? (y/n): "

if "%CONTINUE%"=="y" (goto continue_playlists)
if "%CONTINUE%"=="yes" (goto continue_playlists)
if "%CONTINUE%"=="Y" (goto continue_playlists)
if "%CONTINUE%"=="YES" (goto continue_playlists)
goto:end

:continue_playlists
echo.
echo Proceeding...

echo.
echo Pulling RetroArch playlists...
call %ADB_FOLDER%\adb pull /mnt/sdcard/RetroArch/playlists %ROOT_PATH%\retroarch\ || goto:playlistsfailed
echo Playlists pull success

goto:end

REM ----------------------------------- Error States -----------------------------------

:configfailed
echo.
echo Failed to pull RetroArch config - has RetroArch been installed and run on the device?
goto:overrides

:overridesfailed
echo.
echo Failed to pull core overrides - has RetroArch been installed and run on the device?
goto:thumbnails

:thumbnailsfailed
echo.
echo Failed to pull thumbnails - has RetroArch been installed and run on the device?
goto:playlists

:playlistsfailed
echo.
echo Failed to pull playlists - has RetroArch been installed and run on the device?
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
