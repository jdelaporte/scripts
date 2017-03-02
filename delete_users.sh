#!/bin/bash
#JRD
#Script to delete users and home directories
#Let's make sure they are student users, first.
#Let's record name, UID, and result to a file
#userdel 
# -r removes home and mail spool
names=( $(cat csit_inactive_unix.csv) )
outfile=deleted_users_output.txt
year1=2016
year2=2015
tempuid=""
keepusers=users_to_NOT_delete.txt
userhome=""

for name in "${names[@]:0:10}"
do
tempuid=$(getent passwd ${name} | cut -d : -f3)
userhome=$(getent passwd ${name} | cut -d : -f6)
if grep -q ${name} ${keepusers}
then
		echo "" | tee -a $outfile
		echo "user: $name" | tee -a $outfile
		echo "    UID: $tempuid" >> $outfile
		echo "    result: ${name} is a staff user. Do NOT delete." | tee -a $outfile

else
	if [[ -z $tempuid ]]
	then tempuid="No uid found"
 
	elif [[ $tempuid -gt 1001 && $tempuid -le 2020 ]]
	then
		echo "" | tee -a $outfile
		echo "user: $name" | tee -a $outfile
		echo "    UID: $tempuid" >> $outfile
		last ${name} | egrep "${year1}|${year2}" >> /dev/null
			if [[ $? -eq 0 ]]
			then
				echo "    result: Leaving user intact for now since login occurred in $year1 or $year2." | tee -a $outfile
			else
				echo 'echo "Your account is marked for deletion from shaula. Please contact the Tech Help Desk immediately if you believe this is an error."' >> ${userhome}/.bash_profile
				echo 'echo "Your account is marked for deletion from shaula. Please contact the Tech Help Desk immediately if you believe this is an error."' >> ${userhome}/.profile
				echo "    result: Removing ${name} user" | tee -a $outfile 
#				userdel -r ${name} | tee -a $outfile
			fi
	else
		echo "" | tee -a $outfile
		echo "user: $name" | tee -a $outfile
		echo "    result: ${name} is not in the desired user range" | tee -a $outfile
	fi
fi
done
