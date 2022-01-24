#!/bin/sh
# ==========================================================================================================
# appbrahma-build-and-run-android.sh
# AppBrahma Android Unimobile App building and running
# Created by Venkateswar Reddy Melachervu on 16-11-2021.
# Updates:
#      17-12-2021 - Added gracious error handling and recovery mechansim for already added android platform
#      26-12-2021 - Added error handling and android sdk path check
#      20-01-2022 - Created script for linux
# ===========================================================================================================

# Required version values
NODE_MAJOR_VERSION=16
NPM_MAJOR_VERSION=6
IONIC_CLI_MAJOR_VERSION=6
IONIC_CLI_MINOR_VERSION=16
JAVA_MIN_VERSION=11
EXIT_ERROR_CODE=0

echo ""
echo "=========================================================================================================================================="
echo "Welcome to Unimobile app building and running on Android Emulator on Linux."
echo "Sit back, relax, and sip a cuppa coffee while the dependencies are download, project is built, and run..."
echo "Unless the execution of this script stops, don´t be bothered nor worried about any warnings or errors displayed during the execution ;-)"
echo "=========================================================================================================================================="
echo ""

# OS version validation
echo "You linux distribution name and version are:"
lsb_release -a

# Node validation
node_version=$(node --version | awk -F. '{ print $1 }')
# remove the first character
nodejs=${node_version#?}
if [ $nodejs -lt $NODE_MAJOR_VERSION ]; then
    echo "You are running non-supported NodeJS major version $(node --version | awk -F. '{ print $1 }') for building and running AppBrahma generated Unimobile application project sources!"
    echo "Minimum required version is $NODE_MAJOR_VERSION+"
    echo "Aborting the build process. Please install a stable and LTS NodeJS release of major version $NODE_MAJOR_VERSION and retry."    
    EXIT_ERROR_CODE=$((EXIT_ERROR_CODE+1))
    exit $EXIT_ERROR_CODE
else
    echo "Node version requirement - $NODE_MAJOR_VERSION - met, moving ahead with other checks..."
fi

# NPM validation
npm_version=$(npm --version | awk -F. '{ print $1 }')
if [ $npm_version -lt $NPM_MAJOR_VERSION ]; then
    echo "You are running non-supported NPM major version $(npm --version | awk -F. '{ print $1 }') for building and running AppBrahma generated Unimobile application project sources!"
    echo "Minimum required version is $NPM_MAJOR_VERSION+"
    echo "Aborting the build process. Please install a stable and LTS NPM release of major version $NPM_MAJOR_VERSION and retry."
    EXIT_ERROR_CODE=$((EXIT_ERROR_CODE+1))
    exit $EXIT_ERROR_CODE
else
    echo "NPM version requirement - $NPM_MAJOR_VERSION - met, moving ahead with other checks..."
fi

# ionic cli version validation
ionic_cli_version=$(ionic --version | awk -F. '{ print $1 }')
if [ $ionic_cli_version -lt $IONIC_CLI_MAJOR_VERSION ]; then
    echo "You are running non-supported Ionic CLI major version $ionic_cli_version for building and running AppBrahma generated Unimobile application project sources!"
    echo "Minimum required version is $IONIC_CLI_MAJOR_VERSION+"
    echo "Aborting the build process. Please install a stable and LTS angular cli release of major version $IONIC_CLI_MAJOR_VERSION and retry."
    EXIT_ERROR_CODE=$((EXIT_ERROR_CODE+1))
    exit $EXIT_ERROR_CODE
else
    echo "Ionic CLI version requirement - $IONIC_CLI_MAJOR_VERSION - met, moving ahead with other checks..."
fi

# check for java run time
java_version=$(java --version | awk 'NR==1 {print $2}'| awk -F. '{print $1}')
if [ $java_version -lt $JAVA_MIN_VERSION ]; then
    echo "You are running non-supported Java version $java_version for building and running AppBrahma generated Unimobile application project sources!"
    echo "Minimum required version is $JAVA_MIN_VERSION+"
    echo "Aborting the build process. Please install a stable and LTS java release of major version $JAVA_MIN_VERSION and retry."
    EXIT_ERROR_CODE=$((EXIT_ERROR_CODE+1))
    exit $EXIT_ERROR_CODE
else
    echo "Java version requirement - $JAVA_MIN_VERSION - met, moving ahead with other checks..."
fi

echo "AppBrahma build environment validation completed successfully. Moving ahead with building and running your unimobile ionic android application..."

# instal nodejs dependencies
echo "Installing nodejs dependencies..."
if !(npm install); then
    echo "Error installing node dependencies. Aborting appbrahma unimobile build and run script!" 
    echo "Please retry running appbrahma build and run script after deleting the node_modules direcrtory in this project folder"
    EXIT_ERROR_CODE=$((EXIT_ERROR_CODE+1))
    exit $EXIT_ERROR_CODE
fi

# ionic build
echo "Building the project using ionic build..."
if !(ionic build); then
    echo "Error running ionic build. Aborting appbrahma unimobile build and run script!" 
    echo "Please retry running appbrahma build and run script after deleting the node_modules direcrtory in this project folder"
    EXIT_ERROR_CODE=$((EXIT_ERROR_CODE+1))
    exit $EXIT_ERROR_CODE
fi

# add capacitor
echo "Adding capacitor Android platform"
# if !(ionic cap add android); then
#    echo "It appears android platform was already added. Removing and adding afresh for avoiding run time errors..."
#    rm -rf android
#    if !(ionic cap add android); then
#        echo "Error adding Android platform. Aborting appbrahma unimobile build and run script!"
#        echo "Please retry running appbrahma build and run script after deleting the node_modules direcrtory in this project folder"
#        exit 8;
#    fi
# fi

ionic cap add android 2>/dev/null
# $? is the result of last command executed - 0 in case of success and greater than 0 in case of error
if [ $? -gt 0 ]; then
    echo "It appears android platform was already added. Removing and adding afresh for avoiding run time errors..."
    rm -rf android
    ionic cap add android 2>/dev/null
    if [ $? -gt 0 ]; then
	echo "Error adding Android platform. Aborting appbrahma unimobile build and run script!"
	echo "Please retry running appbrahma build and run script after deleting the node_modules direcrtory in this project folder"
	EXIT_ERROR_CODE=$((EXIT_ERROR_CODE+1))
	exit $EXIT_ERROR_CODE
    fi
fi

# install cordova-res module
echo "Installing node module cordova-res for customizing the application icon and splash for Android..."
if !(npm install -g cordova-res); then
    echo "Error installing cordova-res for customizing unimobile application icon and splash images for your Android application. Aborting appbrahma unimobile build and run script!"
    echo "Please retry after installing the cordova-res"
    EXIT_ERROR_CODE=$((EXIT_ERROR_CODE+1))
    exit $EXIT_ERROR_CODE
fi

# splash and app icon resources
echo "Customizing the application icon and splash for Android..."
if !(cordova-res android --skip-config --copy); then
    echo "Error adding custom application icon and splash images to your Android application. Aborting appbrahma unimobile build and run script!"
    echo "Please retry running appbrahma build and run script after deleting the node_modules direcrtory in this project folder"
    EXIT_ERROR_CODE=$((EXIT_ERROR_CODE+1))
    exit $EXIT_ERROR_CODE
fi

# check android sdk and tools existence
# ANDROID_HOME='/Users/$USER/Library/Android/sdk'
# if [ ! -d $ANDROID_HOME ] ; then 
#    echo "Android SDK and platform tools are not installed or not available at the standard path."
#    echo "Please install Android SDK and platform tools at the standard path and retry running Appbrahma build and run script"
#    exit 11;
# fi

# check android sdk and tools availability
devices=$(adb devices 2>/dev/null)
# $? is the result of last command executed - 0 in case of success and greater than 0 in case of error
if [ $? -gt 0 ]; then
    echo "Android SDK and tools appear to be not installed or ANDROID_HOME and tools directory are NOT in PATH! Please install the same, set the environment variabales and retry!"
    EXIT_ERROR_CODE=$((EXIT_ERROR_CODE+1))
    exit $EXIT_ERROR_CODE
fi

# run android simulator
echo "Starting Android simulator for running the app..."
if !(ionic cap run android); then
    echo "Error running Android simulator and running your Android application. Aborting appbrahma build and run script!"
    echo "Please retry running appbrahma build and run script after deleting the node_modules direcrtory in this project folder"
    EXIT_ERROR_CODE=$((EXIT_ERROR_CODE+1))
    exit $EXIT_ERROR_CODE
fi

# configure simulator to access the server port on the network
# first redirect the error message to a blackhole/null device to avoid confusion to the user
# check android tools existence and adb command availability
# ANDROID_HOME='/Users/$USER/Library/Android/sdk'
# if [ ! -d $ANDROID_HOME ] ; then 
#    echo "Android SDK and platform tools are not installed or not available at the standard path."
#    echo "Please install Android SDK and platform tools at the standard path and retry running Appbrahma build and run script"
#    exit 17;
# fi
# add the path for running adb
# $PATH='${PATH}:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools'
# add the server port
echo "Configuring Android simulator to access the Appbrahma server port on the network..."
adb reverse tcp:8091 tcp:8091 2>/dev/null
# $? is the result of last command executed - 0 in case of success and greater than 0 in case of error
if [ $? -gt 0 ]; then
    echo "Android SDK tools appear to be not installed or ANDROID_HOME and tools directory are NOT in PATH! Please install the same, set the environment variabales and retry!"
    EXIT_ERROR_CODE=$((EXIT_ERROR_CODE+1))
    #echo "Exit error code $EXIT_ERROR_CODE"
    exit $EXIT_ERROR_CODE
fi
