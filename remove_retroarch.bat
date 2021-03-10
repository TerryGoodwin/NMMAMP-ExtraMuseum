@echo off

cls

set ADB_FOLDER=c:\android\platform-tools
set THIS_PATH=%CD%

echo NMMAMP-ExtraMuseum RetroArch Uninstaller
echo ----------------------------------------
echo Version 0.1.1.0 by Terry Goodwin
echo ----------------------------------------
echo Android tools path: %ADB_FOLDER%
echo Running from path: %THIS_PATH%

echo.
echo Getting devices with ADB, will start daemon if it needs to...
call %ADB_FOLDER%\adb devices || goto:devicesfailed
echo ADB success

echo.
echo Uninstall RetroArch? This will not remove any installed ROMs - run remove_roms.bat or remove_all_roms.bat to uninstall ROMs.
set /p CONFIRM="Proceed with uninstalling RetroArch? (y/n): "

if "%CONFIRM%"=="y" (goto uninstall)
if "%CONFIRM%"=="yes" (goto uninstall)
if "%CONFIRM%"=="Y" (goto uninstall)
if "%CONFIRM%"=="YES" (goto uninstall)
goto:aborted

:uninstall
echo.
echo Uninstalling RetroArch...
call %ADB_FOLDER%\adb uninstall com.retroarch.ra32 || goto:removefailed

echo.
echo Removing RetroArch data... (should already be gone, but just in case...)
call %ADB_FOLDER%\adb shell rm -r /mnt/media_rw/sdcard/Android/data/com.retroarch.ra32 || goto:removedatafailed
call %ADB_FOLDER%\adb shell rm -r /data/data/com.retroarch.ra32 || goto:removedatafailed
goto:end

:aborted
echo.
echo Aborted, nothing uninstalled
goto:endpause

REM ----------------------------------- Error States -----------------------------------

:removefailed
echo.
echo Failed to uninstall RetroArch - was it even installed??
goto:endpause

:removedatafailed
echo.
echo Failed to remove RetroArch data - maybe it was already gone?
goto:endpause

:devicesfailed
echo.
echo Couldn't start ADB or check for devices - are the Android tools installed? Is the path at the top this file correct?
goto:failed

REM ----------------------------------- The End -----------------------------------

:end
echo.
echo All finished!
echo If you had ROMs installed, they're probably still there - run remove_roms.bat or remove_all_roms.bat to uninstall ROMs
goto:endpause

:endpause
echo.
pause
