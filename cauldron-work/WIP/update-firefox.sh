#!/usr/bin/env bash

######################################################################
#
#  Update Software through Self Service - Smart Groups and Notifications
#
######################################################################
#
#
###### variables and arrays
#
firefox_url="https://download.mozilla.org/?product=firefox-latest-ssl&os=osx&lang=en-US"
url_version=$(cat /private/tmp/ffversion.txt | awk '{print $2}' | cut -c 71-76)
appversion=$(defaults read /Applications/Firefox.app/Contents/Info.plist CFBundleGetInfoString)
finder=$(ps acx | grep Finder | awk '{print $1}' | head -n 1 | cut -c 1-5)
directory="/private/tmp/firefox"
icon="${directory}/logo4.png"
loggedInUser=$(last | grep "still logged in" | head -n 1 | awk '{print $1}') #$(dscl . -read "/Users/$(who am i | awk '{print $1}')" RealName | sed -n 's/^ //g;2p')
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
windowType="hud" #hud #fs #utility
button1="Update"
button2="Quit"
description="Hi $loggedInUser,
Firefox.app version is outdated and must be updated. Please Select Update to install the newer version, or Quit to postpone.
Please contact IT by email at it@wellframe.com if you run into errors"
timeout="300"
title="Update"
alignDescription="left" 
alignHeading="left"
alignCountdown="center"
iconSize="250"
defaultButton="1"

###### check for latest version and currently installed version
curl $firefox_url > /private/tmp/ffversion.txt

if [[ $url_version == $appversion ]]; then
  echo "version up to date"
  exit 0
else
 echo "check for updates and install them"
 sleep 5
fi 

###### Create directory and grab icon image from specified URL and place into /tmp

if [[ ! -d "${directory}" ]]; then
  echo "making directory"
  mkdir "${directory}"
  echo "${directory} setup"
else
  echo "directory exists"
fi

/usr/bin/curl -s -o ${directory}/logo4.png https://pbs.twimg.com/profile_images/939197801182896128/hV12uUUs_400x400.jpg

###### JAMF Helper window as it appears for targeted computers

userChoice=$("$jamfHelper" -windowType "$windowType" -lockHUD -title "$title" -timeout "${timeout}" -defaultButton "$defaultButton" -countdown -icon "$icon" -description "$description" -alignCountdown "$alignCountdown" -alignDescription "$alignDescription" -alignHeading "$alignHeading" -button1 "$button1" -button2 "$button2" -)

if [ "$userChoice" == "0" ]; then
    echo "User selected START"
    jamf policy -event install-firefox
elif [ "$userChoice" == "2" ]; then
    echo "Timeout was reached or User selected Quit..."
fi

####### Check logs

echo "check the logs in JAMF for details"
exit 0