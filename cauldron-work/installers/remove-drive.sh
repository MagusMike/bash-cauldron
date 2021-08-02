#!/bin/bash

#### Check for installation of google drive, then remove it.

# Variables for script
app="Google Drive.app"
ticker=$(ps acx | grep "Google Drive" | head -n 1 | awk '{print $1}') 

### check for app and remove it
echo "searching for installation of Google Drive... "
if [[ -e "/Applications/${app}" ]]; then
  echo "$app located, attempting to remove all google drive apps"
  if [[ $ticker -gt 0 ]]; then
    echo "Google Drive process running, killing it now"
    killall "Google Drive"
    sleep 2
  fi
  rm -rf "/Applications/${app}"
else
 echo "$app not located, no need to uninstall"
fi

sleep 5


 
### Check for logs in JAMF

echo "Check installation logs in JAMF"

exit 0