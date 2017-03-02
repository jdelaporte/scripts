#!/bin/bash
#JRD
#Script to delete users and home directories
#Let's make sure they are student users, first.
#Let's record name, UID, and result to a file
#userdel 
# -r removes home and mail spool

names=( $(cat csit_inactive_unix.csv) )
outfile=delete_users_output.txt
year1=2016
year2=2015
tempuid=""
keepusers=users_to_NOT_delete.txt

for name in "${names[@]:0:10}"
do
tempuid=$(getent passwd ${name} | cut -d : -f3)

if grep -q ${name} ${keepusers}
then
		echo "" >> $outfile
		echo "user: $name" >> $outfile
		echo "    UID: $tempuid" >> $outfile
		echo "    result: ${name} is a staff user. Do NOT delete." | tee >> $outfile

else
	if [[ -z $tempuid ]]
	then tempuid="No uid found"
 
	elif [[ $tempuid -gt 1001 && $tempuid -le 2020 ]]
	then
		echo "" >> $outfile
		echo "user: $name" >> $outfile
		echo "    UID: $tempuid" >> $outfile
		last ${name} | cut -d ' ' -f8 | egrep "${year1}|${year2}"
			if [[ $? -eq 0 ]]
			then
				echo "    result: Leaving user intact for now since login occurred in $year1 or $year2." | tee >> $outfile
			else
				echo "    result: Removing ${name} user" | tee >> $outfile 
#				userdel -r ${name} | tee >> $outfile
			fi
	else
		echo "" >> $outfile
		echo "user: $name" >> $outfile
		echo "    result: ${name} is not in the desired user range" | tee >> $outfile
	fi
fi
done
