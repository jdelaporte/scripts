#!/bin/bash
#JRD
names=( $(cat csit_inactive_unix.csv) )
for name in "${names[@]:0:30}"
do
echo "Adding ${name} user"	
useradd -c ${name} -m -d /home/${name} -k /etc/skel -s /bin/bash ${name}
done
