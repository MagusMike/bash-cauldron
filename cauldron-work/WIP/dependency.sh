#!/bin/sh
echo "Python location"
python3 -c "import sys; print(sys.executable)"
echo "Python version"
python3 --version
echo "Python3 Dependency version"
echo "********************"
python3 -m pip show pyobjc-framework-SystemConfiguration
echo "********************"
python3 -m pip show pyOpenSSL
echo "********************"