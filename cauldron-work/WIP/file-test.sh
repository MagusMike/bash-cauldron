#!/bin/bash

# # # # # # # # # # # # 
#
# test file output to be read from another scrips
# 
# # # # # # # # # # # #


echo "this is a test"

echo > /private/tmp/hud.sh <<EOF #!/binbash


icon="${directory}/logo4.png"
directory="/private/tmp/eni"

### Directory check for icon download
if [[ ! -d "${directory}" ]]; then
  echo "making directory"
  mkdir "${directory}"
else
  echo "directory exists"
fi

/usr/bin/curl -s -o ${directory}/logo4.png https://pbs.twimg.com/profile_images/939197801182896128/hV12uUUs_400x400.jpg

/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType "fs" -lockHUD -title "test title" -icon "$icon" -description "test description while running" -alignDescription "center" -alignHeading "center

echo "test number two" <<EOF

chmod 755 /private/tmp/hud.sh 

/private/tmp/hud.sh

echo "test number 3 - hud should be running"

sleep 3

echo "test number 4 - hud should be running"

sleep 3

exit 0