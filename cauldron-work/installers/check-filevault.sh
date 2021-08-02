#!/bin/bash

STATUS=$(fdesetup status)
LIST=$(fdesetup list | cut -f1 -d",")

if [[ $(fedsetup status) = "FileVault is on." ]]
then
    echo $LIST
else
    echo $STATUS
fi