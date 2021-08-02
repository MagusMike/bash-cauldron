#!/bin/sh
####################################################################################################
#
# Enable standard users for Filevault to unlock disk on reboot.
# 
####################################################################################################
#
# DEFINE VARIABLES & READ IN PARAMETERS
#
####################################################################################################
#
# HARDCODED VALUES ARE SET HERE

adminuser=""
adminpass=""
stduser=$(id -p | head -n 1 | awk '{print $2}')
stdpass="$(/usr/bin/osascript -e 'Tell current application to display dialog "Please enter your password" default answer "" with title "Update Filevault Policy" with text buttons {"OK"} default button 1 with hidden answer' -e 'text returned of result')"

# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 4 AND, IF SO, ASSIGN TO "message"

if [ "$4" != "" ] && [ "$message" == "" ]; then
    adminuser=$4
fi

# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 5 AND, IF SO, ASSIGN TO "background"

if [ "$5" != "" ] && [ "$background" == "" ]; then
    adminpass=$5
fi

# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 6 AND, IF SO, ASSIGN TO "background"

if [ "$6" != "" ] && [ "$stduser" == "" ]; then
    stduser=$6
fi

# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 7 AND, IF SO, ASSIGN TO "background"

if [ "$7" != "" ] && [ "$stdpass" == "" ]; then
    stdpass=$7
fi

####################################################################################################
# 
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
####################################################################################################

if [ "$7" != "" ]; then
	echo "Error:  The parameter is blank.  Please specify a username or password"
	exit 1
else
    echo "editing plist variables with input"
    plutil -replace Password -string $7 /private/tmp/addFVUser.plist
fi

if [ "$6" != "" ]; then
	echo "Error:  The parameter is blank.  Please specify a username or password"
	exit 1
else
    echo "editing plist variables with input"
    plutil -replace Username -string $6 /private/tmp/addFVUser.plist
fi