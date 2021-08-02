#!/bin/bash

if [[ -e /Applications/zoom.us.app ]] && [[ -e /Applications/Openvpn\ Connect ]]; then
  echo "opening app and setting dock shortcut"
  open "/Applications/Google Chrome.app"
  open /Applications/zoom.us.app
  open /Applications/Slack.app
  open "/Applications/OpenVPN Connect/OpenVPN Connect.app"
  sleep 5
  defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Google Chrome.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>";
  defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/OpenVPN Connect/OpenVPN Connect.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>";
  defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Slack.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>";
  defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/zoom.us.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>";
  sleep 5
  defaults delete com.apple.dock persistent-apps; killall Dock
else
  echo "applications not found in /Applications/"
  exit 1
fi

exit 0
