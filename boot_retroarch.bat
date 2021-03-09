@echo off

set ADB_FOLDER=c:\android\platform-tools
set THIS_PATH=%CD%

echo NMMAMP-ExtraMuseum Boot RetroArch
echo ---------------------------------
echo Version 0.1.0.0 by Terry Goodwin
echo ---------------------------------
echo Android tools path: %ADB_FOLDER%
echo Running from path: %THIS_PATH%

echo.
echo Getting devices with ADB, will start daemon if it needs to...
call %ADB_FOLDER%\adb devices || goto:devicesfailed
echo ADB success

echo.
echo Booting RetroArch...
call %ADB_FOLDER%\adb shell monkey -p com.retroarch.ra32 1 || goto:bootingfailed
echo RetroArch booting success

goto:end

REM ----------------------------------- Error States -----------------------------------

:devicesfailed
echo.
echo Couldn't start ADB or check for devices - are the Android tools installed? Is the path at the top this file correct?
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
echo To get back to the built-in games launcher, run reboot_device.bat
echo To launch RetroArch again, run this file.
goto:endpause

:endpause
echo.
pause
