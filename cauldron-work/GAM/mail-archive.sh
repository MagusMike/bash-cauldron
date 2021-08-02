#!/bin/bash
# June 27, 2019 Justin's GSuite mailbox export for suspended mailboxes. Ver. 1.00
# Ideas for improvment:  
#=== Run this automanted weekly, or monthly.  
#=== e-mail notification when complete? 
#=== Auto delete the suspended mailboxes when complete?  
#/Users/justinhatem/bin/gam/
#/Users/justinhatem/Scripts/

clear
# Set Variables
now=$(date +'%m-%d-%Y')
gamdir="/Users/jhatem/bin/gam"

# Log as well as output to screen.
LOG_LOCATION=/Users/jhatem/Scripts/
exec > >(tee -i $LOG_LOCATION/Info-$now.log)
exec 2>&1

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
echo
echo "Welcome $username! Today is $now."
echo
while true; do
    read -p "Would you like to create a list of suspended users? (Y/N)" yn
    case $yn in
        [Yy]* ) $gamdir/gam print users query 'isSuspended=True' > users-tmp; break;;
        [Nn]* ) Echo "ok, we'll skip it."; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

#Removing the label line from our file
sed -e '1d' users-tmp > users 
rm users-tmp

echo
read -p "Now enter the matter name: " matname
echo
echo "Thanks for entering $matname."
echo
	$gamdir/gam create vaultmatter name "$matname" description "Mail export for suspended users. Run by $username on $(date '+%m-%d-%Y %H:%M:%S')" collaborators "jvincent@wellframe.com"
echo
echo "I have to pause here, or sometimes the rest of the script executes before the Matter is available in GSuite."
sleep 10
echo "Here's the matter you created, take a moment to review:"
echo
$gamdir/gam info vaultmatter "$matname"

sleep 10

#read -p "Please copy and paste the oh Matter Number: "  matternum
echo
#echo "$username, you entered $matternum!"
echo
echo "Preparing to archive some mailboxes. "
sleep 11
for F in $(cat /Users/justinhatem/Scripts/users) ; do
  	# echo $F
  	# $gamdir/gam user $F show teamdrives
  	# This line will create the exports
	$gamdir/gam create export matter "$matname" name "$F Export run $now" corpus mail accounts $F
#For some reason, each export hits the Export API 20 times.  There is a max of 40 per minute, This sleep gets around that. 
sleep 33
done

echo
echo "Finished exporting user mailboxes.  Will now give them time to complete. This script will pause for 1 hour. The current time is: $(date '+%m-%d-%Y %H:%M:%S')."
echo
# sleep 3600
read -p "Press Y when it is OK to proceed with copying the exports to the Mail-Archive Team Drive." answer
echo
echo "Ok, that's enough sleeping.  It's time to copy the mailboxes.  Starting copy to the Mail-Archive Team Drive at: $(date '+%m-%d-%Y %H:%M:%S')."
echo
for F in $(cat /Users/justinhatem/Scripts/users) ; do
	$gamdir/gam download export "$matname" "$F Export run $now" targetfolder "/Volumes/GoogleDrive/Shared drives/Mail-Archive/"
#	$gamdir/gam download export "Full Backup" "$F Export run 06-28-2019" targetfolder "/Volumes/GoogleDrive/Shared drives/Mail-Archive/"

done
echo "Complete!"
echo
echo "Here's a list of mailbox archives and other files."
ls -l "/Volumes/GoogleDrive/Shared drives/Mail-Archive" | grep $now >> /Users/justinhatem/Scripts/Archive-$now.log
ls -goS "/Volumes/GoogleDrive/Shared drives/Mail-Archive" | grep $now > /Users/justinhatem/Scripts/smtplog.log
#cat /Users/justinhatem/Scripts/Archive-$now.log

#----- BEGIN SMTP Section------------
echo "Sending Mail log (this only works on the Wellframe network. Running remotely requires VPN)."
(
echo "HELO smtp.gmail.com";
sleep 1;
echo "MAIL FROM: <jhatem@wellframe.com>";
sleep 1;
echo "RCPT TO: <jhatem@wellframe.com>";
echo "RCPT TO: <jvincent@wellframe.com>";
echo "RCPT TO: <mwilliams@wellframe.com>";
sleep 1;
echo "DATA";
sleep 1;
echo -e "From: <jhatem@wellframe.com>";
echo -e "Subject: GSuite Mail Archive script";
echo -e "MIME-version: 1.0";
echo -e "content-type: multipart/mixed; boundary=sep";
echo -e "--sep";
echo -e "content-type: text/plain; charset=UTF-8";
echo -e  "Here is the log for archives run on $now. ";
echo -e "--sep";
echo -e "content-type: text/x-log; name="log.txt"";
echo -e "content-disposition: attachment; filename="log.txt"";
echo -e "content-transfer-encoding: base64";
echo -e "";
cat smtplog.log;
sleep 3;
echo -e "\n\n.";
sleep 3;
echo "QUIT";
) | telnet smtp-relay.gmail.com 25
#------------- END SMTP Section --------------

#--------- Cleanup section --------------
while true; do
    read -p "Would you like to some cleanup? (Y/N)" yn
    case $yn in
        [Yy]* ) echo "Now we'll do some cleanup.";
                echo "";
                $gamdir/gam update matter "$matname" action close;
                sleep 2;
                echo "";
                $gamdir/gam update matter "$matname" action delete;
                echo "";
                echo "Deleting the Suspended Users list, logs, and extra files.";
                rm /Users/justinhatem/Scripts/users;
                rm /Users/justinhatem/Scripts/*.log;
                rm /Users/justinhatem/Scripts/*.txt;
                rm "/Volumes/GoogleDrive/Shared drives/Mail-Archive/"*.xml;
                rm "/Volumes/GoogleDrive/Shared drives/Mail-Archive/"*.csv;
                echo "";
                echo "Let's see if $matname is Deleted.";
                echo "";
                $gamdir/gam info vaultmatter "$matname";
                break;;
        [Nn]* ) echo "ok, we'll skip it."; break;;
        * ) echo "Please answer yes or no.";;
    esac
done
#---- End cleanup tasks -------
echo "Done!"
exit


# ======================= notes and info =================
echo "Now we'll do some cleanup."
echo
$gamdir/gam update matter "$matname" action close
sleep 2
echo
$gamdir/gam update matter "$matname" action delete
echo
echo "Deleting the Suspended Users list and log files."
rm /Users/justinhatem/Scripts/users
rm /Users/justinhatem/Scripts/*.log
rm /Users/justinhatem/Scripts/*.txt
echo
echo "Let's see if $matname is Deleted."
echo
$gamdir/gam info vaultmatter "$matname"
# This will print all the vault matters:  $gamdir/gam print vaultmatters
# If you need to delete by Matter number, use uid:, like this- $gamdir/gam update matter uid:5bb2b6f4-7e5d-4dc9-a17e-57ac7233ff83 action close
exit
