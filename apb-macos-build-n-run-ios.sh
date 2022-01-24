#!/bin/sh
# =================================================================================
# appbrahma-build-and-run-ios.sh
# AppBrahma Android Unimobile App building and running
# Created by Venkateswar Reddy Melachervu on 16-11-2021.
# Updates:
#      17-12-2021 - Added gracious error handling and recovery mechansim for already added android platform
# ================================================================================= 

# set option to exit in case of an error in executing a command
# set -e
# keep track of the last executed command
#trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
#trap 'echo "\"${last_command}\" command failed with exit code $?."' EXIT

# Required version values
OS_MAJOR_VERSION=10
OS_MINOR_VERSION=0
OS_PATCH_VERSION=1
XCODE_MAJOR_VERSION=12
XCODE_MINOR_VERSION=0
XCODE_PATCH_VERSION=1
NODE_MAJOR_VERSION=v12
NPM_MAJOR_VERSION=6
XCODE_SELECT_MIN_VERSION=2300
COCOAPODS_MAJOR_VERSION=1
IONIC_CLI_MAJOR_VERSION=6
IONIC_CLI_MINOR_VERSION=16
EXIT_ERROR_CODE=0

echo ""
echo "=========================================================================================================================================="
echo "Welcome to Unimobile app building and running on Android Emulator on Linux."
echo "Sit back, relax, and sip a cuppa coffee while the dependencies are download, project is built, and run..."
echo "Unless the execution of this script stops, don´t be bothered nor worried about any warnings or errors displayed during the execution ;-)"
echo "=========================================================================================================================================="
echo ""

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

# Xcode version validation
if [[ $(/usr/bin/xcodebuild -version | awk 'NR==1{print $2}' | awk -F. '{print $1}') -ge XCODE_MAJOR_VERSION ]]; then
    if [[ $(/usr/bin/xcodebuild -version | awk 'NR==1{print $2}' | awk -F. '{print $2}') -ge XCODE_MINOR_VERSION ]]; then
        if [[ $(/usr/bin/xcodebuild -version | awk 'NR==1{print $2}' | awk -F. '{print $3}') -ge XCODE_PATCH_VERSION ]]; then
            echo "Xcode version requirement - $XCODE_MAJOR_VERSION.$XCODE_MINOR_VERSION.$XCODE_PATCH_VERSION - met, moving ahead with other checks..."
        else
            echo "You are running non-supported Xcode version $(/usr/bin/xcodebuild -version | awk 'NR==1{print $2}') for building and running AppBrahma generated Unimobile application project sources!"
            echo "Minimum required version is $XCODE_MAJOR_VERSION.$XCODE_MINOR_VERSION.$XCODE_PATCH_VERSION"
            echo "Aborting the build process!"
            EXIT_ERROR_CODE=$((EXIT_ERROR_CODE+1))
            exit $EXIT_ERROR_CODE
        fi
    else
        echo "You are running non-supported Xcode version $(/usr/bin/xcodebuild -version | awk 'NR==1{print $2}') for building and running AppBrahma generated Unimobile application project sources!"
        echo "Minimum required version is $XCODE_MAJOR_VERSION.$XCODE_MINOR_VERSION.$XCODE_PATCH_VERSION"
        echo "Aborting the build process!"
        EXIT_ERROR_CODE=$((EXIT_ERROR_CODE+1))
        exit $EXIT_ERROR_CODE
    fi
else
    echo "You are running non-supported Xcode version $(/usr/bin/xcodebuild -version | awk 'NR==1{print $2}') for building and running AppBrahma generated Unimobile application project sources!"
    echo "Minimum required version is $XCODE_MAJOR_VERSION.$XCODE_MINOR_VERSION.$XCODE_PATCH_VERSION"
    echo "Aborting the build process!"
    EXIT_ERROR_CODE=$((EXIT_ERROR_CODE+1))
    exit $EXIT_ERROR_CODE
fi

# xcode-select command tools verification
if [[ $(xcode-select --version | awk '{ print $3 }') < $XCODE_SELECT_MIN_VERSION ]]; then
    echo "You are running non-supported xcode-select version $(xcode-select --version | awk '{ print $3 }' | awk -F. '{ print $1 }') for building and running AppBrahma generated Unimobile application project sources!"
    echo "Minimum required version is $XCODE_SELECT_MIN_VERSION+"
    echo "Aborting the build process!"
    EXIT_ERROR_CODE=$((EXIT_ERROR_CODE+1))
    exit $EXIT_ERROR_CODE
else
    echo "xcode-select requirement met, moving ahead with other checks..."
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

# cocoapods install check
if [[ $(pod --version | awk -F. '{ print $1 }') < $COCOAPODS_MAJOR_VERSION ]]; then
    echo "Cocoapods is not installed or a non-supported version $(pod --version | awk -F. '{ print $1 }') is running for building and running AppBrahma generated Unimobile application project sources!"
    echo "Minimum required version is $COCOAPODS_MAJOR_VERSION+"
    echo "Aborting the build process!"
    EXIT_ERROR_CODE=$((EXIT_ERROR_CODE+1))
    exit $EXIT_ERROR_CODE
else
    echo "Cocoapods requirement met, moving ahead with other checks..."
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

# install capacitor cli and core
#echo "Installing capacitor core and cli needed for running the Unimobile app..."
#npm install @capacitor/core
#npm install @capacitor/cli --save-dev


echo "AppBrahma build environment validation completed successfully. Moving ahead with building and running your iOS application..."

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

echo "Adding capacitor iOS platform"
if !(ionic cap add ios); then
    echo "It appears ios platform was already added. Removing and adding afresh for avoiding run time errors..."
    rm -rf ios
	if !(ionic cap add ios); then
		echo "Error adding ios platform. Aborting appbrahma build and run script!"
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

echo "Customizing the application icon and splash for iOS..."
if !(cordova-res ios --skip-config --copy); then
    echo "Error adding custom application icon and splash images to your iOS application. Aborting appbrahma build and run script!"
    echo "Please retry running appbrahma build and run script after deleting the node_modules direcrtory in this project folder"
    EXIT_ERROR_CODE=$((EXIT_ERROR_CODE+1))
    exit $EXIT_ERROR_CODE
fi

echo "Starting iOS simulator for running the app..."
if !(ionic cap run ios); then
    echo "Error running iOS simulator and running your iOS application. Aborting appbrahma build and run script!"
    echo "Please retry running appbrahma build and run script after deleting the node_modules direcrtory in this project folder"
    EXIT_ERROR_CODE=$((EXIT_ERROR_CODE+1))
    exit $EXIT_ERROR_CODE
fi
