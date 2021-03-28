@echo off
cls

set ADB_FOLDER=c:\android\platform-tools
set ROOT_PATH=%CD%\..

echo NMMAMP-ExtraMuseum Launcher Installer
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
echo Installing emlauncher.apk from %ROOT_PATH%\frontend\emlauncher.apk
call %ADB_FOLDER%\adb install %ROOT_PATH%\frontend\emlauncher.apk || goto:installfailed
echo Success - emlauncher.apk installed (or was already installed)

goto:end

REM ----------------------------------- Error States -----------------------------------

:installfailed
echo.
echo Failed to install launcher APK - is it in the right place with the right name (frontend\emlauncher.apk)?
goto:failed

:devicesfailed
echo.
echo Couldn't start ADB or check for devices - are the Android tools installed? Is the path at the top this file correct?
goto:failed

:failed
echo.
echo Finished with errors - things may not have worked. Resolve any errors, and try again.
goto:endpause

REM ----------------------------------- The End -----------------------------------

:end
echo.
echo All finished!
echo Remember to set the Extra Museum launcher as the default by running set_extra_launcher.bat or you won't be able to get past the Android dialog!
goto:endpause

:endpause
echo.
pause
