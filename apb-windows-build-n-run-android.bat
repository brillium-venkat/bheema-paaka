:: =================================================================================
:: appbrahma-build-and-run-android.bat
:: AppBrahma Android Unimobile App building and running
:: Created by Venkateswar Reddy Melachervu on 16-11-2021.
:: Updates:
::      17-12-2021 - Added gracious error handling and recovery mechansim for already added android platform
:: ================================================================================= 
@echo off
setlocal
echo 
echo ==========================================================================================================================================
echo Welcome to Unimobile app building and running on Android Emulator on Linux.
echo Sit back, relax, and sip a cuppa coffee while the dependencies are download, project is built, and run...
echo Unless the execution of this script stops, don´t be bothered nor worried about any warnings or errors displayed during the execution ;-)
echo ==========================================================================================================================================
echo 

call npm install
if ERRORLEVEL 1 (
    echo Error installing node dependencies for building
    goto :ERROR
)

call ionic build
if ERRORLEVEL 1 (
    echo Error building ionic project
    goto :ERROR
)

:: redirect the error out to NUL to avoid confusing the user with error text
call ionic cap add android 2> NUL
if ERRORLEVEL 1 (
    echo It appears an Android platform was already added. Deleting it and adding Android platform for avoiding any run errors...
    rmdir android /s /q
    call ionic cap add android 2> NUL
    if ERRORLEVEL 1 (
        echo Error adding android platform. Please resolve the error and re-run the script
        goto :ERROR
    )
)

:: install cordova-res node module for custom icons and spalsh handling
call npm install -g cordova-res 2> NUL
if ERRORLEVEL 1 (
    echo Error in installing cordova-res node module. Please resolve the node module install error and retry this script!    
)

call cordova-res android --skip-config --copy
if ERRORLEVEL 1 (
    echo Error creating android spalsh and icon resources
    goto :ERROR
)

call ionic cap run android
if ERRORLEVEL 1 (
    echo Error starting android platform
    goto :ERROR
)

call adb reverse tcp:8091 tcp:8091 
endlocal
exit 0
:: Error handling for any command execution
:ERROR
endlocal
exit 1
