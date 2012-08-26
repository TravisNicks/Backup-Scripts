#!/bin/bash

# Written 8/25/12, Travis Nicks
# This script backups up postgres databases on two servers via pg_dump.
# It is set in the crontab to run every Tuesday morning at 12:01 am.
# 	crontab -e
# 	1 0 * * 2 sh /some/directory/ScriptName.sh > /some/directory/log.log

# Set variables for the username accessing the servers.  SSH and user accounts
# for the backup system on the servers are required prior to running.

BACKUP_SERVER1="username@server01name.com"
BACKUP_SERVER2="username@server02name.com"


# A verbose ssh command that outputs to the backup log via crontab.  In case 
# something goes wrong this helps track it down.

REMOTE_CMD="ssh -vq -p 1021"


# Variables for the desired location for the backups to be stored.

DESTDIR1="/some/backup/directory01"
DESTDIR2="/some/backup/directory02"


# ---------------------------------------------------------------------------
# Since pg_dump is used with select databases, each new backup required will 
# need its own line in the script.

# A date and note to help when reviewing logs.

/bin/date
echo "Backing up Server01 to Netgear".

# A verbose pg_dump command that outputs to the backup log via crontab. 
# The user for backup should be able to execute the pg_dump command.  Be sure
# to check permissions if there are problems.  At the end of the command
# is the file name formatting to make each backup's file name date specific
# (e.g. /some/directory/directory01/db_backups/MyDatabase-2012-08-01-12.sql.gz).

$REMOTE_CMD $BACKUP_SERVER1 "pg_dump -v --username=dbuser --host=localhost dbname" | gzip -c > ${DESTDIR1}/db_backups/DatabaseName-$(date +%Y_%m_%d_%H).sql.gz


# A second block for the next database and server combination.
/bin/date
echo "Backing up Server02 to Netgear"
$REMOTE_CMD $BACKUP_SERVER2 "pg_dump -v --username=dbuser --host=localhost dbname" | gzip -c > ${DESTDIR2}/db_backups/DatabaseName-$(date +%Y_%m_%d_%H).sql.gz


# A note to identify when complete.  This note makes no statement as to status.

/bin/date
echo "DB Backups complete."

