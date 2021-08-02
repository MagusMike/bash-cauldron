#!/bin/sh
#####################################################################################################
#
# Update or install Firefox.app
#
####################################################################################################
#
# HISTORY
#
#	Version: 1.0
#
#	- Joe Farage, 18.03.2015
#	Version: 2.0
#
#	- Mike Williams, 2021.05.24
#
####################################################################################################
# Script to download and install Firefox.
#
# Variables

lang="en-US"
directory="/private/tmp/firefox"
dmgfile="FF.dmg"
logfile="/Library/Logs/FirefoxInstallScript.log"
OSvers_URL=$( sw_vers -productVersion | sed 's/[.]/_/g' )
userAgent="Mozilla/5.0 (Macintosh; Intel Mac OS X ${OSvers_URL}) AppleWebKit/535.6.2 (KHTML, like Gecko) Version/5.2 Safari/535.6.2"
latestver=`/usr/bin/curl -s -A "$userAgent" https://www.mozilla.org/${lang}/firefox/new/ | grep 'data-latest-firefox' | sed -e 's/.* data-latest-firefox="\(.*\)".*/\1/' -e 's/\"//' | /usr/bin/awk '{print $1}'`
url="https://download.mozilla.org/?product=firefox-latest-ssl&os=osx&lang=en-US"	

###########

echo "Latest Version is: $latestver"

	# Get the version number of the currently-installed FF, if any.
if [ -e "/Applications/Firefox.app" ]; then
	currentinstalledver=`/usr/bin/defaults read /Applications/Firefox.app/Contents/Info CFBundleShortVersionString`
	echo "Current installed version is: $currentinstalledver"
	if [ ${latestver} = ${currentinstalledver} ]; then
		echo "Firefox is current. Exiting"
		exit 0
	fi
else
	currentinstalledver="none"
	echo "Firefox is not installed"
fi

if [ -d ${directory} ]; then
  echo "${directory} exists"
else
  echo "${directory} does not exist, setting up now"
  mkdir -p ${directory}
fi

	
echo "Latest version of the URL is: $url"
echo "`date`: Download URL: $url" >> ${logfile}

# Compare the two versions, if they are different or Firefox is not present then download and install the new version.
if [ "${currentinstalledver}" != "${latestver}" ]; then
  /bin/echo "`date`: Current Firefox version: ${currentinstalledver}" >> ${logfile}
  /bin/echo "`date`: Available Firefox version: ${latestver}" >> ${logfile}
	/bin/echo "`date`: Downloading newer version." >> ${logfile}
	/usr/bin/curl -JL ${url} -o ${directory}/${dmgfile}
	/bin/echo "`date`: Mounting installer disk image." >> ${logfile}
	/usr/bin/hdiutil attach ${directory}/${dmgfile} -nobrowse -quiet
	/bin/echo "`date`: Installing..." >> ${logfile}
	cp -a -f  "/Volumes/Firefox/Firefox.app" /Applications/
		
	/bin/sleep 10
	/bin/echo "`date`: Unmounting installer disk image." >> ${logfile}
	/usr/bin/hdiutil detach $(/bin/df | /usr/bin/grep Firefox | awk '{print $1}') -quiet
	/bin/sleep 10
	/bin/echo "`date`: Deleting disk image." >> ${logfile}
	/bin/rm ${directory}/${dmgfile}

	#double check to see if the new version got updated
	newlyinstalledver=`/usr/bin/defaults read /Applications/Firefox.app/Contents/Info CFBundleShortVersionString`
    if [ "${latestver}" = "${newlyinstalledver}" ]; then
      /bin/echo "`date`: SUCCESS: Firefox has been updated to version ${newlyinstalledver}" >> ${logfile}
    else
      /bin/echo "`date`: ERROR: Firefox update unsuccessful, version remains at ${currentinstalledver}." >> ${logfile}
      /bin/echo "--" >> ${logfile}
			exit 1
		fi
  
# If Firefox is up to date already, just log it and exit.       
else
		/bin/echo "`date`: Firefox is already up to date, running ${currentinstalledver}." >> ${logfile}
    /bin/echo "--" >> ${logfile}
fi	

exit 0