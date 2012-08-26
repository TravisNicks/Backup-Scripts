#!/bin/bash

# Written 8/25/12, Travis Nicks
# This script backs up various directories on two servers. 
# It is set in the crontab to run every Tuesday morning at 12:01 am.
# 	crontab -e
# 	1 0 * * 2 sh /some/directory/ScriptName.sh > /some/directory/log.log

# Set variables for the username accessing the servers.  SSH and user accounts
# for the backup system on the servers are required prior to running.
 
BACKUP_SERVER1="username@server01name.com"
BACKUP_SERVER2="username@server02name.com"

# A verbose rsync command that outputs to the backup log via crontab.  In case 
# something goes wrong this helps track it down.

RSYNC_CMD="/usr/bin/rsync --progress -azvHe"

# Using a custom ssh port.

REMOTE_CMD="ssh -vq -p 1234"

# Variables for the desired location for the backups to be stored.

DESTDIR1="/some/backup/directory01"
DESTDIR2="/some/backup/directory02"


# ---------------------------------------------------------------------------
# In order to backup a new location a new complete rsync line must be added.

# A date and note to help when reviewing logs.

/bin/date
echo "Backing up Server01 to Netgear."

# The important thing here is that the RSYNC is followed by the ssh then the 
# --rsync-path attribute.  This allows the backup system to remotely execute
# without root login.  It must be added as a sudoer on the server.

$RSYNC_CMD "${REMOTE_CMD}" --rsync-path="sudo rsync" ${BACKUP_SERVER1}:/usr/local $DESTDIR1
$RSYNC_CMD "${REMOTE_CMD}" --rsync-path="sudo rsync" ${BACKUP_SERVER1}:/etc/apache2 $DESTDIR1
$RSYNC_CMD "${REMOTE_CMD}" --rsync-path="sudo rsync" ${BACKUP_SERVER1}:/home $DESTDIR1
$RSYNC_CMD "${REMOTE_CMD}" --rsync-path="sudo rsync" ${BACKUP_SERVER1}:/var/spool $DESTDIR1
$RSYNC_CMD "${REMOTE_CMD}" --rsync-path="sudo rsync" ${BACKUP_SERVER1}:/var/mail $DESTDIR1

# A second block for the next set of directories on the second server.

/bin/date
echo "Backing up Server02 to Netgear."

$RSYNC_CMD "${REMOTE_CMD}" --rsync-path="sudo rsync" ${BACKUP_SERVER2}:/usr/local $DESTDIR2
$RSYNC_CMD "${REMOTE_CMD}" --rsync-path="sudo rsync" ${BACKUP_SERVER2}:/etc/apache2 $DESTDIR2
$RSYNC_CMD "${REMOTE_CMD}" --rsync-path="sudo rsync" ${BACKUP_SERVER1}:/home $DESTDIR1
$RSYNC_CMD "${REMOTE_CMD}" --rsync-path="sudo rsync" ${BACKUP_SERVER2}:/var/spool $DESTDIR2
$RSYNC_CMD "${REMOTE_CMD}" --rsync-path="sudo rsync" ${BACKUP_SERVER2}:/var/mail $DESTDIR2

# A note to identify when complete.  This note makes no statement as to status.

/bin/date
echo "Script complete."