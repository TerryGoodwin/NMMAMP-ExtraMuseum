@echo off

set ADB_FOLDER=c:\android\platform-tools
set THIS_PATH=%CD%

echo NMMAMP-ExtraMuseum RA Overrides Downloader
echo ------------------------------------------
echo Version 0.1.3.0 by Terry Goodwin
echo ------------------------------------------
echo Android tools path: %ADB_FOLDER%
echo Running from path: %THIS_PATH%

echo.
echo This will download core overrides from your My Arcade to retroarch\config
echo If you proceed, any existing configs at that location will be overwritten without asking.

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
call %ADB_FOLDER%\adb pull /mnt/sdcard/RetroArch/config %THIS_PATH%\retroarch\ || goto:pullfailed
echo Config pull success

goto:end

REM ----------------------------------- Error States -----------------------------------

:pullfailed
echo.
echo Failed to pull core overrides - has RetroArch been installed and run on the device?
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
echo Aborted, nothing downloaded
goto:endpause

:end
echo.
echo All finished!
goto:endpause

:endpause
echo.
pause
