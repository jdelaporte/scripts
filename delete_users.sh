#!/bin/bash
#JRD
#SCript to delete users and home directories
#Let's make sure they are student users, first.
#userdel 
# -r removes home and mail spool
 
names=( $(cat csit_inactive_unix.csv) )
outfile=users_login_record.txt
year1=2016
year2=2017
tempuid=""

for name in "${names[@]:0:10}"
do
	tempuid=$(getent passwd ${name} | cut -d : -f3)
	if [[ -z $tempuid ]]
	then tempuid="No uid found"
 
	elif [[ $tempuid -gt 1001 && $tempuid -le 1020 ]]
	then
		echo "" >> $outfile
		echo "user: $name" >> $outfile
		echo "    UID: $tempuid" >> $outfile
		last ${name} | cut -d ' ' -f8 | egrep "${year1}|${year2}"
			if [[ $? -eq 0 ]]
			then
				echo "    message: Leaving user intact for now since login occurred in $year1 or $year2." | tee >> $outfile
			else
				echo "    message: Removing ${name} user" | tee >> $outfile 
				userdel -r ${name} | tee >> $outfile
			fi
	else
		echo "" >> $outfile
		echo "user: $name" >> $outfile
		echo "    message: ${name} is not in the desired user range" | tee >> $outfile
	fi
done

