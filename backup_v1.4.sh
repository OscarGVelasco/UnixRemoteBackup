#!/bin/bash
# backup.sh a script to back-copy files to a mounted remote directory
# Usage - backup.sh machine_name mount_directory local_directory
#                  - 1) machine_name is the name of your machine-or-user on box2
#                  - 2) mount_directory is the LOCAL directory in which remote dir will be mounted 				(Name has to match with a local directory to mount correctly and must be empty)
#                  - 3) local_directory is the local directory that will be copied (backed-up) to the remote machine
# **It is NEEDED to use the crontab as ROOT - if not mount command will not work.
# Example of use with the Crontab:
# 05 2 * * Mon /home/oscar/Escritorio/Scripts/backup_v1.3.sh brisa /backup /home/oscar box2.dep.usal.es
# This will:
#	1- mount the remote directory of box2:brisa on /backup
#	2- copy the whole /home/oscar dir (but just the new/modified files) on the mounted dir /backup (and thus, on box2) at 2:05AM every Monday
#
# 	Known common Error Troubleshoting:
# **Mount Partition filesystem error** Install nfs-common drivers:
# sudo apt-get install nfs-common
# **Start the service
# sudo service portmap start
#
# 1.4 Version July 2019 - Oscar G. Velasco - Cic Lab-19
#     * Added rsync command for copying instead of cp
#   - 1.3 Version March 2019 - Oscar G. Velasco - Cic Lab-19
#	    *added umount error code checking
# 	- 1.2 Version July 2018 - Oscar G. Velasco - Cic Lab-19

start=`date +%s`
if [ ! -d "$3" ]; then 
>&2 echo "Error: Local directory $3 does not appear to exist."
exit -1
fi
file_name=$3"/backup.log"
touch $file_name
chmod 0777 $file_name
echo -e "\n">>$file_name
echo "************************************************">>$file_name
echo "		Starting back-up at: $(date)">>$file_name
if [ $# == "0" -o $# -lt "4" ]; then
echo "ERROR: Bad input [arg-> $# ] Usage-> backup.sh machine_name mount_directory local_directory">>$file_name
exit 0
fi
mkdir -p $2>>$file_name 2>&1
machine_name=$1
mount_directory=$2
local_directory=$3
server=$4
echo "Mounting remote dir: $server:/volume1/$machine_name">>$file_name
mount $server:/volume1/$machine_name $mount_directory>>$file_name 2>&1
if [ $? != "0" ]; then
echo "ERROR: Mount command failed with status: $?">>$file_name
# Just in case it has been partially mounted...
umount /$mount_directory>>$file_name
exit 0
fi
echo "Checking free space availability on remote machine.">>$file_name
# This prevents in case the user has specified wrong the directories from not to fill de / partition
availSpace=$(df $mount_directory | awk 'NR==2 { print $4 }')
reqSpace=$(du -s $local_directory|awk 'NR==1 {print $1}')
if [ "$availSpace" -lt "$reqSpace" ]; then
  echo "ERROR: not enough Space on remote device." >>$file_name
  echo "are the target and remote directories correct?" >>$file_name
  umount /$mount_directory>>$file_name 2>&1
  exit 1
fi
echo "Copying...">>$file_name
rsync -vazh --info=3 $local_directory $mount_directory>>$file_name
end=`date +%s`
echo -e "\n">>$file_name
echo "Backup finished on $((end-start)) seconds.">>$file_name
sync $file_name
umount /$mount_directory>>$file_name 2>&1
if [ $? != "0" ]; then
echo "Umount command failed with status: $?">>$file_name
exit 2
fi
echo "Done [Successful]">>$file_name
exit 33
