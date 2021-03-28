@echo off
cls

set ADB_FOLDER=c:\android\platform-tools
set ROOT_PATH=%CD%\..

echo NMMAMP-ExtraMuseum Setting Extra Museum Launcher
echo ------------------------------------------------
echo Version 1.0.0.1 by Terry Goodwin
echo ------------------------------------------------
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
echo Pushing clean package restrictions XML...
call %ADB_FOLDER%\adb push %ROOT_PATH%\config\package-restrictions.stock.xml /data/system/users/0/package-restrictions.xml || goto:configfailed

:reboot
echo.
echo Rebooting...
call %ADB_FOLDER%\adb reboot

echo.
echo Waiting for 45 seconds for device to reboot...
echo PLEASE be patient!
ping 192.0.2.2 -n 1 -w 45000 > delete_me

echo.
echo Tapping EM Launcher...
call %ADB_FOLDER%\adb shell input tap 100 240

echo.
echo Tapping Always...
call %ADB_FOLDER%\adb shell input tap 100 300

goto:end

REM ----------------------------------- Error States -----------------------------------

:devicesfailed
echo.
echo Couldn't start ADB or check for devices - are the Android tools installed? Is the path at the top this file correct?
goto:endpause

:rootfailed
echo.
echo Failed to initiate adb root, is your My Arcade powered on and plugged into a USB data cable?
goto:failed

:remountfailed
echo.
echo Failed to remount filesystem, without this we can't push files to the My Arcade... Aborting :(
goto:failed

:configfailed
echo.
echo Failed to push stock package restrictions configuration - it may be fine and still work, so proceeding...
goto:reboot

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
