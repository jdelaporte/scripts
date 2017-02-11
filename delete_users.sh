#!/bin/bash
#JRD
#SCript to delete users and home directories
#Let's make sure they are student users, first.
#userdel 
# -r removes home and mail spool
 
names=( $(cat csit_inactive_unix.csv) )

for name in "${names[@]:0:10}"
do
	tempuid=$(getent passwd ${name} | cut -d : -f3) 
	if [[ $tempuid -gt 1001 && $tempuid -le 1011 ]]
	then
		echo "Removing ${name} user" 
		userdel -r ${name}
	else
		echo "${name} is not in the desired user range"
	fi
done

