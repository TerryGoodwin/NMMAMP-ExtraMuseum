@echo off
cls

set ADB_FOLDER=c:\android\platform-tools
set ROOT_PATH=%CD%\..

echo NMMAMP-ExtraMuseum All ROMs Uninstaller
echo ---------------------------------------
echo Version 1.0.0.0 by Terry Goodwin
echo ---------------------------------------
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
echo Getting list of installed ROMS...
call %ADB_FOLDER%\adb shell ls /data/data/com.retroarch.ra32/roms || goto:listromsfailed

echo.
set /p CONFIRM="Uninstall all ROMs? (y/n): "

if "%CONFIRM%"=="y" (goto uninstall)
if "%CONFIRM%"=="yes" (goto uninstall)
if "%CONFIRM%"=="Y" (goto uninstall)
if "%CONFIRM%"=="YES" (goto uninstall)
goto:aborted

:uninstall
echo.
echo Uninstalling all ROMs
call %ADB_FOLDER%\adb shell rm -r /data/data/com.retroarch.ra32/roms || goto:removefailed
call %ADB_FOLDER%\adb shell mkdir /data/data/com.retroarch.ra32/roms || goto:removefailed
goto:end

:aborted
echo.
echo Aborted, nothing uninstalled
goto:endpause

REM ----------------------------------- Error States -----------------------------------

:listromsfailed
echo.
echo Failed to list ROMs - have you removed the GAME-EXTRA directory on the device by hand?
echo Run install_roms.bat to install some ROMs
goto:endpause

:removefailed
echo.
echo Failed to remove ROMs - has the directory been removed?
goto:listcores

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
echo Note that removing ROMs locally from GAME-EXTRA and running install_roms.bat will not delete them from your device, you must use remove_roms.bat or remove_all_roms.bat
goto:endpause

:endpause
echo.
pause
