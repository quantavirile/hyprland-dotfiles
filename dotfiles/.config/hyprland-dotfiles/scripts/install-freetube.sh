#!/bin/bash

# Set the temporary directory
TEMP_DIR="/tmp"

# Function to get the installed FreeTube version
get_installed_version() {
  freetube_version=$(freetube --version 2>/dev/null | grep -oP "v[0-9]+\.[0-9]+\.[0-9]+")
  echo "$freetube_version"
}

# Fetch the latest pre-release version dynamically
LATEST_VERSION=$(curl -s https://github.com/FreeTubeApp/FreeTube/releases | grep -oP "v[0-9]+\.[0-9]+\.[0-9]+-beta" | head -n 1)

if [ -z "$LATEST_VERSION" ]; then
  echo "No pre-release version found. Exiting."
  exit 1
fi

# Extract the version number for comparison
LATEST_VERSION_NUMBER=$(echo "$LATEST_VERSION" | grep -oP "v[0-9]+\.[0-9]+\.[0-9]+")

# Check if FreeTube is already installed
INSTALLED_VERSION=$(get_installed_version)

if [ "$INSTALLED_VERSION" == "$LATEST_VERSION_NUMBER" ]; then
  echo "FreeTube version $LATEST_VERSION_NUMBER is already installed. No action needed."
  exit 0
fi

# Construct the download URL and file name
# DL_URL="https://github.com/FreeTubeApp/FreeTube/releases/download/${LATEST_VERSION}/freetube-${LATEST_VERSION}-amd64.pacman"
# FILE_NAME="freetube-${LATEST_VERSION}-amd64.pacman"
LATEST_VERSION_NO_V="${LATEST_VERSION#v}"
DL_URL="https://github.com/FreeTubeApp/FreeTube/releases/download/${LATEST_VERSION}/freetube-${LATEST_VERSION_NO_V}-amd64.pacman"
FILE_NAME="freetube-${LATEST_VERSION_NO_V}-amd64.pacman"

# Download the file using aria2
aria2c -s16 -x16 --dir="$TEMP_DIR" "$DL_URL"

# Check if the download was successful
if [ $? -ne 0 ]; then
  echo "Failed to download $FILE_NAME. Please check the URL."
  exit 1
fi

# Install the downloaded .pacman file
sudo pacman -U --noconfirm "$TEMP_DIR/$FILE_NAME"

# Check if the installation was successful
if [ $? -eq 0 ]; then
  echo "Installation of FreeTube version ${LATEST_VERSION} is complete."
else
  echo "Installation failed."
  exit 1
fi

# Cleanup downloaded files
rm "$TEMP_DIR/$FILE_NAME"
