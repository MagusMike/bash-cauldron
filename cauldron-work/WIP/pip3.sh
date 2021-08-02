#!/bin/sh

echo "Running pip3 install --upgrade pip"
sudo pip3 install --upgrade pip

echo "Running pip3 install pyobjc-framework-SystemConfiguration"
sudo pip3 install pyobjc-framework-SystemConfiguration

echo "pip3 install pyOpenSSL"
sudo pip3 install pyOpenSSL

exit