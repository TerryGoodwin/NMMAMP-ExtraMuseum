@echo off

set ADB_FOLDER=c:\android\platform-tools
set THIS_PATH=%CD%

echo NMMAMP-ExtraMuseum Stock ROMs Extractor
echo ---------------------------------------
echo Version 0.1.3.0 by Terry Goodwin
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

echo.
echo Extracting stock ROMs installed on the device into path:
echo %THIS_PATH%\GAME\
call %ADB_FOLDER%\adb pull /system/media/GAME %THIS_PATH%\ || goto:pullfailed
echo Stock ROM extraction success

goto:end

REM ----------------------------------- Error States -----------------------------------

:pullfailed
echo.
echo Failed to extract ROMs - is your device turned on?
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
echo IMPORTANT: Be careful with experimenting with the location of these files on your device -
echo you could end up losing files and breaking the stock functionality
goto:endpause

:endpause
echo.
pause
