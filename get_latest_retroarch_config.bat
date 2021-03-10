@echo off

set ADB_FOLDER=c:\android\platform-tools
set THIS_PATH=%CD%

echo NMMAMP-ExtraMuseum RA Config Downloader
echo ---------------------------------------
echo Version 0.1.1.0 by Terry Goodwin
echo ---------------------------------------
echo Android tools path: %ADB_FOLDER%
echo Running from path: %THIS_PATH%

echo.
echo This will download retroarch.cfg from your My Arcade to retroarch\retroarch.new.cfg
echo If you proceed, an existing file at that location with that name will be overwritten without asking.

echo.
set /p CONTINUE="Proceed? (y/n): "

if "%CONTINUE%"=="y" (goto continue)
if "%CONTINUE%"=="yes" (goto continue)
if "%CONTINUE%"=="Y" (goto continue)
if "%CONTINUE%"=="YES" (goto continue)
goto:aborted

:continue
echo.
echo Proceeding...

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
echo Pulling RetroArch config...
call %ADB_FOLDER%\adb pull /mnt/media_rw/sdcard/Android/data/com.retroarch.ra32/files/retroarch.cfg %THIS_PATH%\retroarch\retroarch.new.cfg || goto:pullfailed
echo Config pull success

goto:end

REM ----------------------------------- Error States -----------------------------------

:pullfailed
echo.
echo Failed to pull RetroArch config - has RetroArch been installed and run on the device?
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

:aborted
echo.
echo Aborted, nothing downloaded
goto:endpause

:end
echo.
echo All finished!
echo Make your changes to retroarch.new.cfg and rename it to retroarch.cfg before calling install_retroarch_config.bat to upload it to your device.
echo It is recommended that you back up your last known good configuration file before replacing it!
echo You may need to restart RetroArch for any changes to take effect.
goto:endpause

:endpause
echo.
pause
