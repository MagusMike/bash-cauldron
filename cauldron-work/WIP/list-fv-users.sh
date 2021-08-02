#!/bin/bash

STATUS=$(fdesetup status)
LIST=$(fdesetup list | cut -f1 -d",")

if [[ $STATUS = "FileVault is On." ]]
then
    echo "<result>"$LIST"</result>"
else
    echo "<result>"$STATUS"</result>"
fi