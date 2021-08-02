#!/bin/bash

#### Check for installation of 8x8, update or install based off of arch type.

# Variables for script
directory="/private/tmp/8x8"
vendorDMG="work-v7.8.2.dmg"
app="8x8 Work.app"
arch_name="$(uname -m)"
enrollmentTimeout=150
timeoutCounter=0
app_url="https://vod-updates.8x8.com/ga/work-dmg-v7.8.2-2.dmg"

################################################################


if [ "${arch_name}" = "x86_64" ]; then
  if [ "$(sysctl -in sysctl.proc_translated)" = "1" ]; then
    echo "Running on Rosetta 2"
    exit 0
  else
    echo "Running on native Intel"
    # change directory to /private/tmp to make this the working directory
    if [[ -d "/Applications/${app}" ]]; then
      echo "app exists, exiting installation"
      exit 0
    else
      echo "${app} not found, attempting to download and install"
      if [[ -d "${directory}" ]]; then
        echo "directory exists"
        cd "${directory}"
      else
        echo "directory does not exist, making directory now"
        mkdir "${directory}"
        cd "${directory}"
      fi
      # install the package
      /usr/bin/curl -JL "$app_url" -o "${vendorDMG}"
      echo "************************************"
      echo "attaching .dmg to setup install"
      hdiutil attach "${directory}/${vendorDMG}" -nobrowse
    fi
  fi
elif [ "${arch_name}" = "arm64" ]; then
  echo "Running on ARM"
  # change directory to /private/tmp to make this the working directory
  if [[ -d "/Applications/${app}" ]]; then
    echo "app exists, exiting installation"
    exit 0
  else
    echo "${app} not found, attempting to download and install"
    if [[ -d "${directory}" ]]; then
      echo "directory exists"
      cd "${directory}"
    else
      echo "directory does not exist, making directory now"
      mkdir "${directory}"
      cd "${directory}"
    fi
  # install the package
  /usr/bin/curl -JL "$app_url" -o "${vendorDMG}"
  echo "************************************"
  echo "attaching .dmg to setup install"
  hdiutil attach "${directory}/${vendorDMG}" -nobrowse
  fi
else
  echo "Unknown architecture: ${arch_name}"
  exit 0
fi


if [ -e "/Applications/${app}" ]; 
then
  echo "$app located, check for updates - exiting installation"
  exit 0 
else
  echo "$app not located, continue to install"
   cp -a -f "/Volumes/8x8 Work/8x8 Work.app" /Applications/
  echo "************************************"
  echo "files on the move"
fi

until [[ -e "/Applications/${app}" ]]; do
	if [[ $timeoutCounter -ge $enrollmentTimeout ]];
	then
		echo "Gave up waiting for the 8x8 Desktop to install"
		exit 1
	else
		echo "Waiting for the 8x8 Desktop to install. Timeout counter: \${timeoutCounter} of ${enrollmentTimeout}."
		((timeoutCounter++))
		sleep 2
	fi
done

sleep 5

defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/8x8 Work.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>";

### Check for resources and files left over

if [ -e "/Volumes/8x8 Work" ]; then
  echo "detach attached dmg file"
  hdiutil detach -force "/Volumes/8x8 Work"
else
  echo "no disk attached"
fi

if [[ -e "${directory}/${vendorDMG}" ]]; then
  echo "${directory}/${vendorDMG} exists, cleanup starting"
  rm -Rf "${directory}"
else
  echo "${directory}/${vendorDMG} does not exist, completion imminent"
fi

### Check for logs in JAMF

echo "Check installation logs in JAMF"

exit 0