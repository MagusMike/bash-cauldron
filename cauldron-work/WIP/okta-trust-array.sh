#!/bin/bash

######################################################################
#
# INSTALLATION OF REQUIRED SOFTWARE FOR NEW MACBOOKS
#
######################################################################
#
###### variables and arrays
#

app_array=(xcodeclt pip3 dependency devicetrust)


######## statement to run installation through array while prompting users via display text about a new installation

for app in "${app_array[@]}"; do
  jamf policy -event install-$app
  echo "installing $app"
  osascript -e 'display notification "Applications starting install... " with title "Requests running... " subtitle "Processing new installation "'
done

######echo "installing ${app_array[0]}" 
######echo "installing ${app_array[1]}"
######echo "installing ${app_array[2]}"
######echo "installing ${app_array[3]}"
######echo "installing ${app_array[4]}"
######echo "installing ${app_array[5]}"

echo "All done"

echo "JAMF logs to see installation success or failure"

######## user input for restart to finish configurations, installs, and removal of media