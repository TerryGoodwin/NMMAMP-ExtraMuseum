@echo off

cls

set ADB_FOLDER=c:\android\platform-tools
set THIS_PATH=%CD%

echo NMMAMP-ExtraMuseum ROMs Uninstaller
echo -----------------------------------
echo Version 0.1.1.0 by Terry Goodwin
echo -----------------------------------
echo Android tools path: %ADB_FOLDER%
echo Running from path: %THIS_PATH%

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

:listroms
echo.
echo Getting list of installed ROMs...
call %ADB_FOLDER%\adb shell ls /system/media/GAME-EXTRA || goto:listromsfailed

echo.
echo Enter full file name of ROM (e.g. rom_name.bin)
echo (Type stop to stop removing ROMs)
set /p ROM="Core file name: "

if "%ROM%"=="stop" (goto end)
if "%ROM%"=="exit" (goto end)
if "%ROM%"=="quit" (goto end)

echo.
echo Uninstalling ROM %ROM%
call %ADB_FOLDER%\adb shell rm -f \"/system/media/GAME-EXTRA/%ROM%\" || goto:removefailed
goto:listroms

REM ----------------------------------- Error States -----------------------------------

:listromsfailed
echo.
echo Failed to list ROMs - have you removed the GAME-EXTRA directory on the device by hand?
echo Run install_roms.bat to install some ROMs
goto:endpause

:removefailed
echo.
echo Failed to remove ROM - did you misspell the file name?
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

REM ----------------------------------- The End -----------------------------------

:end
echo.
echo All finished!
echo To remove more ROMs run this file again.
echo Note that removing ROMs locally from GAME-EXTRA and running install_roms.bat will not delete them from your device, you must use remove_roms.bat or remove_all_roms.bat
goto:endpause

:endpause
echo.
pause
