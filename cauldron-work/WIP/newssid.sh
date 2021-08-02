#!/bin/bash

################################################################
#
# setup new interface, SSID, and password for WiFi settings
#
################################################################

loggedInUser=$(stat -f%Su /dev/console)
loggedInUID=$(id -u "$loggedInUser")

if [[ "$loggedInUser" != "root" ]] || [[ "$loggedInUID" -ne 0 ]]; then

cat << EOF > /private/tmp/scriptssid.sh
#!/bin/bash

networksetup -setairportnetwork en0 theGoodframe "YzQo4#Cq?cX3NzszNF9Q"

exit 0
EOF

else
    echo "No user logged in. Can't run as user, so exiting"
    exit 0
fi

if [ -e /private/tmp/scriptssid.sh ]; then
    /bin/chmod +x /private/tmp/scriptssid.sh
    /bin/launchctl asuser "$loggedInUID" sudo -iu "$loggedInUser" "/private/tmp/scriptssid.sh"
    sleep 2
    echo "Cleaning up..."
    /bin/rm -f "/private/tmp/script.sh"
else
    echo "Oops! Couldn't find the script to run. Something went wrong!"
    exit 1
fi