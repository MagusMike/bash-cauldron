#!/bin/sh
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -targetdisk / -activate -configure -clientopts -setmenuextra -menuextra no 
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -targetdisk / -configure -users wellframeit -access -on -privs -all
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -targetdisk / -configure -allowAccessFor -specifiedUsers -privs -all
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -targetdisk / -restart -agent -menu
/usr/sbin/systemsetup -setremotelogin on
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -config -clientopts -setmenuextra -menuextra no
exit 0