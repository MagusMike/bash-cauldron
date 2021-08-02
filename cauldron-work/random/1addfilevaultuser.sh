#!/bin/bash


STATUS=$(fdesetup status)
LIST=$(fdesetup list)

if [[ $STATUS = "FileVault is On." ]]
then
    echo $LIST
else
    echo $STATUS
fi