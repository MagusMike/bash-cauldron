#!/bin/bash

################################################################
#
# remove 8x8 from /Applications
#
################################################################

app_run=$(ps acx | grep 8x8 | head -n 1 | awk '{print $5,$6}')
eightby="/Applications/8x8 Work.app"

if [[ $app_run == "8x8 Work" ]]; then
kill -9 $(pgrep "8x8 Work")
fi

if [[ -e $eightby ]]; then
  echo "attempting to remove 8x8"
  rm -rf /Applications/8x8\ Work.app
else
  echo "application not found"
fi 

sleep 5

exit 0