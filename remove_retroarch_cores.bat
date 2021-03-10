@echo off

cls

set ADB_FOLDER=c:\android\platform-tools
set THIS_PATH=%CD%

echo NMMAMP-ExtraMuseum RA Cores Uninstaller
echo ---------------------------------------
echo Version 0.1.1.0 by Terry Goodwin
echo ---------------------------------------
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

:listcores
echo.
echo Getting list of installed cores...
call %ADB_FOLDER%\adb shell ls /data/data/com.retroarch.ra32/cores || goto:listcoresfailed

echo.
echo Enter full file name of core (e.g. genesis_plus_gx_libretro_android.so)
echo (Type stop to stop removing cores)
set /p CORE="Core file name: "

if "%CORE%"=="stop" (goto end)
if "%CORE%"=="exit" (goto end)
if "%CORE%"=="quit" (goto end)

echo.
echo Uninstalling core %CORE%
call %ADB_FOLDER%\adb shell rm -f \"/data/data/com.retroarch.ra32/cores/%CORE%\" || goto:removefailed
goto:listcores

REM ----------------------------------- Error States -----------------------------------

:listcoresfailed
echo.
echo Failed to list RetroArch cores - have you removed the cores directory on the device by hand?
echo Run install_retroarch_cores.bat to install some cores
goto:endpause

:removefailed
echo.
echo Failed to remove RetroArch core - did you misspell the file name?
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
echo To remove more cores run this file again.
echo Note that removing cores from retroarch\cores and running install_retroarch_cores.bat will not delete them from your device, you must use remove_retroarch_cores.bat or remove_all_retroarch_cores.bat
goto:endpause

:endpause
echo.
pause
