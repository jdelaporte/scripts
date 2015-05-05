#!/bin/zsh

#Find all file in photos folder 
#According to month and year
#Move to appropriate folder
#Chown
#Chmod

CWD="/raid/plex_media/photos/";
cd $CWD;
declare -i diffdate;

for year in $(seq 2004 2005);
do
	for mo in $(seq 1 2);
	do
		
	workingdir=${CWD}${year}/${mo}/
	echo "workingdir is $workingdir"	

	if test ! -d $workingdir
	then mkdir -p $workingdir
	chown plex.nobody $workingdir 
	fi

# Get the number of days since the 1st of 
# the following month.

	diffdate=$(python -c "import datetime; print (datetime.datetime.now()-datetime.datetime(${year},${mo}+1,01)).days");

#	echo "The difference in days between now and ${year}-${mo}-01 is $diffdate days."
	
#swap out okdir for execdir after testing

	find . -mtime +${diffdate} okdir mv -t $workingdir ;	
	done;
done;

