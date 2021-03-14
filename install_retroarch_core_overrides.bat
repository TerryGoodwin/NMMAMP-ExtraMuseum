@echo off

set ADB_FOLDER=c:\android\platform-tools
set THIS_PATH=%CD%

echo NMMAMP-ExtraMuseum RA Overrides Installer
echo -----------------------------------------
echo Version 0.1.3.0 by Terry Goodwin
echo -----------------------------------------
echo Android tools path: %ADB_FOLDER%
echo Running from path: %THIS_PATH%

echo.
echo Did you download your most recent overrides from your devices first before making changes?
echo If you proceed without doing this you may lose changes you've made.
echo To download the latest configuration, run get_latest_retroarch_core_overrides.bat
echo.
echo WARNING! Don't do this while RetroArch is running! Your changes might not
echo take effect and may be lost!

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
echo Pushing purpose-built RetroArch core overrides into place...
call %ADB_FOLDER%\adb push %THIS_PATH%\retroarch\config /mnt/sdcard/RetroArch/ || goto:configfailed
echo Overrides push success

goto:end

REM ----------------------------------- Error States -----------------------------------

:configfailed
echo.
echo Failed to push core overrides - is the retroarch\configs folder where it should be?
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

:aborted
echo.
echo Aborted, nothing installed
goto:endpause

:end
echo.
echo All finished!
echo To update the config again, first run get_latest_retroarch_config.bat to get the latest, then call install_retroarch_config.bat`
goto:endpause

:endpause
echo.
pause
