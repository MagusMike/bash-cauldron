#!/bin/bash
# Version 1.4 Jul 18, 2019
#/Users/jhatem/bin/gam/
clear

# Set Variables
now=$(date +'%m-%d-%Y')
gamdir="/Users/jhatem/bin/gam"
newpass="6n^FycS+*PqS4JA5&;PG=7sy,?_R"
LOG_LOCATION=/Users/jhatem/Scripts/

# Output to screen and log.
exec > >(tee -i $LOG_LOCATION/Offboard-$now.log)
exec 2>&1

#echo "The Gam directory is $gamdir"
#echo
#$gamdir/gam info user jhatem

#Check GAM version before we get started
echo "Checking GAM version before we get started."
$gamdir/gam version
echo ""

# Give the option to upgrade GAM before we start
while true; do
    read -p "Would you like to upgrade GAM to the latest version? (Y/N)" yn
    case $yn in
        [Yy]* ) bash <(curl -s -S -L https://git.io/install-gam) -l; break;;
        [Nn]* ) Echo "ok, we'll skip it."; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo "Here we go, starting at: $(date '+%m-%d-%Y %H:%M:%S')"
read -p "Enter Your Name: " username
echo "You entered $username"
echo ""
read -p "Please enter the e-mail for the user to be offboarded:" offuser
echo ""
echo "You entered $offuser"
echo ""
read -p "Please enter the e-mail for the new owner:" newowner
echo ""
echo "You entered $newowner"
echo ""

echo "Let's do some user account cleanup! "

#for F in $(cat /Users/justinhatem/Scripts/users) ; do

#Change old user's password
echo "Changing $offuser's password."
$gamdir/gam update user $offuser password $newpass
echo ""

#Add the new owner as a delegate for the mailbox. 
echo "Adding $newowner as a delegate for $offuser's mailbox."
$gamdir/gam user $offuser delegate to $newowner
echo ""

#Transfer all Google Drive data	
echo "Changing ownership of all Google Drive files from $offuser to $newowner."
$gamdir/gam create datatransfer $offuser gdrive $newowner privacy_level shared,private
echo ""

echo "Changing all calendar entries to $newowner."
#Transfer calendar entries from one user to another, and release all calendar entries by old user:
#$gamdir/gam create datatransfer $offuser calendar $newowner release_resources true
$gamdir/gam calendar $offuser add owner $newowner
echo ""

#Remove a user from all groups
echo "Removing $offuser from all groups and lists."
$gamdir/gam user $offuser delete groups
#done
echo ""

#remove user from global address list
echo "Removing $offuser from Global Address List."
$gamdir/gam update user $offuser gal off
echo ""

#read -p "Press Y when it is OK to proceed with full user DELETE or control + Z to bail out." answer

#Option to SUSPEND account
while true; do
    read -p "Would you like to SUSPEND the user? (Y/N)" yn
    case $yn in
        [Yy]* ) $gamdir/gam update user $offuser suspended on; break;;
        [Nn]* ) Echo "ok, we'll skip it."; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

#Option to DELETE Account
while true; do
    read -p "Would you like to PERMANENTLY DELETE the user? (Y/N)" yn
    case $yn in
        [Yy]* ) $gamdir/gam delete user $offuser; break;;
        [Nn]* ) Echo "ok, we'll skip it."; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

#---- Scripted Detele -----
#for F in $(cat /Users/justinhatem/Scripts/users) ; do
#$gamdir/gam delete user $F
#done

# ------------ Mobile Account Wipe  ---------------------- 
#  figure out mobile account wipe !!! Cool stuff

# Create a copy of the log for e-mailing 
Echo "Preparing log file to be sent"
cat $LOG_LOCATION/Offboard-$now.log > output.log
echo ""

#ls -goS "/Volumes/GoogleDrive/Shared drives/Mail-Archive" | grep $now > /Users/justinhatem/Scripts/smtplog.log

# --------------  SMTP Notificatoin -----------------------------------
(
echo "HELO Wellframe.com";
sleep 1;
echo "MAIL FROM: <jhatem@wellframe.com>";
sleep 1;
echo "RCPT TO: <jhatem@wellframe.com>";
echo "RCPT TO: <jvincent@wellframe.com>";
echo "RCPT TO: <mwilliams@wellframe.com>";
echo "RCPT TO: <mpellerin@wellframe.com>";
sleep 1;
echo "DATA";
sleep 1;
echo -e "From: <jhatem@wellframe.com>";
echo -e "Subject: GSuite User Offboard Log for $offuser";
echo -e "MIME-version: 1.0";
echo -e "content-type: multipart/mixed; boundary=sep";
echo -e "--sep";
echo -e "content-type: text/plain; charset=UTF-8";
echo -e  "Here is the log history for the offboarding script run on $now for user $offuser. ";
echo -e "--sep";
echo -e "content-type: text/x-log; name="log.txt"";
echo -e "content-disposition: attachment; filename="log.txt"";
echo -e "content-transfer-encoding: base64";
echo -e "";
cat output.log;
sleep 3;
echo -e "\n\n.";
sleep 3;
echo "QUIT";
) | telnet smtp-relay.gmail.com 587

#------------------------------------------

#Checking for the number of suspended accounts.
echo "Checking for the number of suspended accounts.  If there are several, please run the Mail Archive script."
$gamdir/gam print users query 'isSuspended=True'

# --------------------   End of doing stuff, for now. ------------------
exit
#---------------------   End of doing stuff, for now. ------------------


#----  Other handy snippets. 
while true; do
    read -p "Would you like to create a list of suspended users? (Y/N)" yn
    case $yn in
        [Yy]* ) $gamdir/gam print users query 'isSuspended=True' >> users; break;;
        [Nn]* ) Echo "ok, we'll skip it."; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

