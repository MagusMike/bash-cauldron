#!/bin/sh

echo "Checking for the existence of the Apple Command Line Developer Tools"

/usr/bin/xcode-select -p &> /dev/null

if [[ $? -ne 0 ]]; then
    echo "Apple Command Line Developer Tools not found."
    touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
    installationPKG=$(/usr/sbin/softwareupdate --list | /usr/bin/grep -B 1 -E 'Command Line Tools' | /usr/bin/tail -2 | /usr/bin/awk -F'*' '/^ *\\*/ {print $2}' | /usr/bin/sed -e 's/^ *Label: //' -e 's/^ *//' | /usr/bin/tr -d '\n')
    echo "Installing ${installationPKG}"
    /usr/sbin/softwareupdate --install "${installationPKG}" --verbose
else
    echo "Apple Command Line Developer Tools are already installed."
fi

exit