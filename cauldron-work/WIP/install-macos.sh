#!/bin/bash
#
# ERASE AND INSTALL with checks
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# USER VARIABLES
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

adminuser="wellframeit"

adminpass="WadeWllWait77&&"

## Current user
loggedInUser=$(dscl . -read "/Users/$(who am i | awk '{print $1}')" RealName | sed -n 's/^ //g;2p')

## latest version to install
installerversion=$(softwareupdate --list-full-installers | sed '3!d' |  grep -Eo '[+-]?[0-9]+([.][0-9]+)+([.][0-9]+)?')

## powerlog check
powerlog=$(/usr/bin/pmset -g batt | head -n 1)

## The startossinstall log file path
osinstallLogfile="/private/tmp/startosinstall.log"

### application version
appcheck="/Applications/Install macOS Big Sur.app"

### time stamp
timestamp=$(date "+DATE: %Y-%m-%d%n TIME: %H:%M:%S")

## runs command to find the free space in GB from the Data drive
freespace=$(df -hl /System/Volumes/Data | awk '{print $4}' | tail -1 | cut -c 1-3)
requiredDiskSpaceSizeGB="35"
diskinfo=$(expr $freespace - $requiredDiskSpaceSizeGB)

## Jamf Helper
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
windowType="utility"
button1="START"
button2="QUIT"
defaultButton="button1"
## Title to be used for userDialog
description="Hi $loggedInUser, You are choosing to erase and install the current version of macOS
Please select START or QUIT to start the erase and install process or stop "
## Title to be used for userDialog (only applies to Utility Window)
title="Erase and Install"
alignDescription="left" 
alignHeading="left"
alignCountdown="center"

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

### User input to double check the erase and install options
userChoice=$("$jamfHelper" -windowType "$windowType" -lockHUD -title "$title" -defaultButton "$defaultButton" -icon "$icon" -description "$description" -alignCountdown "$alignCountdown" -alignDescription "$alignDescription" -alignHeading "$alignHeading" -button1 "$button1" -button2 "$button2")

if [ "$userChoice" == "0" ]; then
    echo "User selected START" | tee -a $osinstallLogfile
elif [ "$userChoice" == "2" ]; then
    echo "User selected to QUIT, exiting now." | tee -a $osinstallLogfile
    exit 1
fi

echo " [current disk space] ${freespace}GB - ${requiredDiskSpaceSizeGB}GB [required space for download and install] " | tee -a $osinstallLogfile
if [[ ${diskinfo} -gt 35 ]]; then
  echo " = ${diskinfo}GB [success] " | tee -a $osinstallLogfile
else 
  echo " = ${diskinfo}GB [failure] " | tee -a $osinstallLogfile
  exit 1
fi

touch ${osinstallLogfile}

## Loop for "acPowerWaitTimer" seconds until either AC Power is detected or the timer is up
echo " Running AC power check" | tee -a $osinstallLogfile

if [[ $powerlog = "'Now drawing from 'AC Power'" ]]; then
  echo " Power Check: OK - AC Power Detected " | tee -a ${osinstallLogfile}
else
  echo " ::ERROR:: AC power required to continue ...exiting erase-install " | tee -a ${osinstallLogfile}
  exit 1
fi

echo " Checking for application Install macOS Big Sur.app " | tee -a ${osinstallLogfile}


while [[ ! -e $appcheck ]]; do
  if [[ ! -e $appcheck ]]; then
    echo " $timestamp " | tee -a ${osinstallLogfile}
    echo 'download required to continue' | tee -a ${osinstallLogfile}
    softwareupdate -d --fetch-full-installer --full-installer-version ${installerversion} --verbose | tee -a ${osinstallLogfile}
  else
    echo 'installation media found'
  fi
done

osascript -e 'display notification "application now available " with title "Erase and Install"'
sleep 2
killall jamfHelper

echo "installation about to start... " | tee -a ${osinstallLogfile}

### Running erase install 
echo "All set, starting upgrade" | tee -a ${osinstallLogfile}

## Begin Upgrade
echo "Running a command as echo $adminpass | /Applications/Install\ macOS\ Big\ Sur.app/Contents/Resources/startosinstall --agreetolicense --nointeraction --eraseinstall --newvolumename 'Macintosh HD' --user ${adminuser} --stdinpass"  | tee -a ${osinstallLogfile}
echo $adminpass | /Applications/Install\ macOS\ Big\ Sur.app/Contents/Resources/startosinstall --agreetolicense --nointeraction --eraseinstall --newvolumename 'Macintosh HD' --user ${adminuser} --stdinpass 

sleep 3

exit 0