#!/bin/sh
# ==========================================================================================================
# appbrahma-build-and-run-android.sh
# AppBrahma Android Unimobile App building and running
# Created by Venkateswar Reddy Melachervu on 16-11-2021.
# Updates:
#      17-12-2021 - Added gracious error handling and recovery mechansim for already added android platform
#      26-12-2021 - Added error handling and android sdk path check
# ===========================================================================================================
echo ""
echo "=========================================================================================================================================="
echo "Welcome to Unimobile app building and running on Android Emulator on MacOS."
echo "Sit back, relax, and sip a cuppa coffee while the dependencies are download, project is built, and run..."
echo "Unless the execution of this script stops, don´t be bothered nor worried about any warnings or errors displayed during the execution ;-)"
echo "=========================================================================================================================================="
echo ""

EXIT_ERROR_CODE=0

# OS version validation
# echo "MacOS version is : $(/usr/bin/sw_vers -productVersion)"
# Minimum version required is Big Sur - 11.0.1 due to Xcode 12+ requirement for ionic capacitor
if [[ $(/usr/bin/sw_vers -productVersion | awk -F. '{ print $1 }') -ge $OS_MAJOR_VERSION ]]; then
    if [[ $(/usr/bin/sw_vers -productVersion | awk -F. '{ print $2 }') -ge $OS_MINOR_VERSION ]]; then
        if [[ $(/usr/bin/sw_vers -productVersion | awk -F. '{ print $3 }') -ge $OS_PATCH_VERSION ]]; then
            echo "MacOS version requirement - $OS_MAJOR_VERSION.$OS_MINOR_VERSION.$OS_PATCH_VERSION - met, moving ahead with other checks..."
        else
            echo "You are running non-supported MacOS version $(/usr/bin/sw_vers -productVersion) for building and running AppBrahma generated Unimobile application project sources!"
            echo "Minimum required version is $OS_MAJOR_VERSION.$OS_MINOR_VERSION.$OS_PATCH_VERSION"
            echo "Aborting the build process!"
            EXIT_ERROR_CODE=$((EXIT_ERROR_CODE+1))
            exit $EXIT_ERROR_CODE
        fi
    else
        echo "You are running non-supported MacOS version $(/usr/bin/sw_vers -productVersion) for building and running AppBrahma generated Unimobile application project sources!"
        echo "Minimum required version is $OS_MAJOR_VERSION.$OS_MINOR_VERSION.$OS_PATCH_VERSION"
        echo "Aborting the build process!"
        EXIT_ERROR_CODE=$((EXIT_ERROR_CODE+1))
        exit $EXIT_ERROR_CODE
    fi
else
    echo "You are running non-supported MacOS version $(/usr/bin/sw_vers -productVersion) for building and running AppBrahma generated Unimobile application project sources!"
    echo "Minimum required version is $OS_MAJOR_VERSION.$OS_MINOR_VERSION.$OS_PATCH_VERSION"
    echo "Aborting the build process!"
    EXIT_ERROR_CODE=$((EXIT_ERROR_CODE+1))
    exit $EXIT_ERROR_CODE
fi

# Node validation
if [[ $(node --version | awk -F. '{ print $1 }') < $NODE_MAJOR_VERSION ]]; then
    echo "You are running non-supported Node major version $(node --version | awk -F. '{ print $1 }') for building and running AppBrahma generated Unimobile application project sources!"
    echo "Minimum required version is $NODE_MAJOR_VERSION+"
    echo "Aborting the build process!"
    EXIT_ERROR_CODE=$((EXIT_ERROR_CODE+1))
    exit $EXIT_ERROR_CODE
else
    echo "Node version requirement met, moving ahead with other checks..."
fi

# NPM validation
if [[ $(npm --version | awk -F. '{ print $1 }') < $NPM_MAJOR_VERSION ]]; then
    echo "You are running non-supported NPM major version $(npm --version | awk -F. '{ print $1 }') for building and running AppBrahma generated Unimobile application project sources!"
    echo "Minimum required version is $NPM_MAJOR_VERSION+"
    echo "Aborting the build process!"
    EXIT_ERROR_CODE=$((EXIT_ERROR_CODE+1))
    exit $EXIT_ERROR_CODE
else
    echo "NPM requirement met, moving ahead with other checks..."
fi

# ionic cli version validation
if [[ $(ionic --version | awk -F. '{ print $1 }') -lt $IONIC_CLI_MAJOR_VERSION ]]; then
    echo "You are running non-supported Ionic CLI major version $(ionic --version | awk -F. '{ print $1 }') for building and running AppBrahma generated Unimobile application project sources!"
    echo "Minimum required version is $IONIC_CLI_MAJOR_VERSION+"
    echo "Aborting the build process!"
    EXIT_ERROR_CODE=$((EXIT_ERROR_CODE+1))
    exit $EXIT_ERROR_CODE
else
    echo "Ionic CLI requirement met, moving ahead with other checks..."
fi


echo "AppBrahma build environment validation completed successfully. Moving ahead with building and running your Android application..."

echo "Installing node dependencies..."
if !(npm install); then
    echo "Error installing node dependencies. Aborting appbrahma build and run script!" 
    echo "Please retry running appbrahma build and run script after deleting the node_modules direcrtory in this project folder"
    EXIT_ERROR_CODE=$((EXIT_ERROR_CODE+1))
    exit $EXIT_ERROR_CODE
fi

echo "Building the project using ionic build..."
if !(ionic build); then
    echo "Error running ionic build. Aborting appbrahma build and run script!" 
    echo "Please retry running appbrahma build and run script after deleting the node_modules direcrtory in this project folder"
    EXIT_ERROR_CODE=$((EXIT_ERROR_CODE+1))
    exit $EXIT_ERROR_CODE
fi

echo "Adding capacitor Android platform"
if !(ionic cap add android); then
    echo "It appears android platform was already added. Removing and adding afresh for avoiding run time errors..."
    rm -rf android
    if !(ionic cap add android); then
        echo "Error adding Android platform. Aborting appbrahma build and run script!"
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

echo "Customizing the application icon and splash for Android..."
if !(cordova-res android --skip-config --copy); then
    echo "Error adding custom application icon and splash images to your Android application. Aborting appbrahma build and run script!"
    echo "Please retry running appbrahma build and run script after deleting the node_modules direcrtory in this project folder"
    EXIT_ERROR_CODE=$((EXIT_ERROR_CODE+1))
    exit $EXIT_ERROR_CODE
fi

echo "Starting Android simulator for running the app..."
if !(ionic cap run android); then
    echo "Error running Android simulator and running your Android application. Aborting appbrahma build and run script!"
    echo "Please retry running appbrahma build and run script after deleting the node_modules direcrtory in this project folder"
    EXIT_ERROR_CODE=$((EXIT_ERROR_CODE+1))
    exit $EXIT_ERROR_CODE
fi

# check for java run time
if [[ $(java -version | awk 'NR==1{print $3}' | awk -F. '{print $1}') -ge XCODE_MAJOR_VERSION ]]; then

fi
# check android tools existence and adb command availability
ANDROID_HOME='/Users/$USER/Library/Android/sdk'
if [ ! -d $ANDROID_HOME ] ; then 
    echo "Android SDK and platform tools are not installed or not available at the standard path."
    echo "Please install Android SDK and platform tools at the standard path and retry running Appbrahma build and run script"
    EXIT_ERROR_CODE=$((EXIT_ERROR_CODE+1))
    exit $EXIT_ERROR_CODE
fi
# add the path for running adb
$PATH='${PATH}:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools'
# add the server port
echo "Configuring Android simulator to access the Appbrahma server port on the network..."
if !(adb 8091 tcp:8091); then
    echo "Error configuring Android simulator to access the Appbrahma server port on the network. Aborting appbrahma build and run script!"
    echo "Please retry running appbrahma build and run script after deleting the node_modules direcrtory in this project folder"
    EXIT_ERROR_CODE=$((EXIT_ERROR_CODE+1))
    exit $EXIT_ERROR_CODE
fi

