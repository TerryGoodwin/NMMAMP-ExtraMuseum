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
echo Rebooting device... Thank you for visiting the Extra Museum.
call %ADB_FOLDER%\adb reboot || goto:rebootingfailed
echo RetroArch booting success

goto:end

REM ----------------------------------- Error States -----------------------------------

:devicesfailed
echo.
echo Couldn't start ADB or check for devices - are the Android tools installed? Is the path at the top this file correct?
goto:failed

:rebootingfailed
echo.
echo Failed to reboot device! This is very unusual... You should probably turn it off with the button on the front.
goto:failed

:failed
echo.
echo Finished with errors - things may not have worked. Resolve any errors, and try again.
goto:endpause

REM ----------------------------------- The End -----------------------------------

:end
echo.
echo All finished!
echo To launch RetroArch again, run boot_retroarch.bat
goto:endpause

:endpause
echo.
pause
