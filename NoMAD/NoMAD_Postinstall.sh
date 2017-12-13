#!/bin/bash

# Post-installation script for NoMAD
# Author : Johan McGwire - mcgwire@battelle.org

# This script re-boots the launch agent for NoMAD after Richard Purves's pre-install script
# Credit to Richard for the main bulk of the script

# Where is everything?
install_dir=$( /usr/bin/dirname $0 )

# Logging stuff starts here
LOGFOLDER="/private/var/log"
LOGFILE="${LOGFOLDER}/NoMAD-Postinstall.log"

if [ ! -d "$LOGFOLDER" ];
then
	/bin/mkdir "$LOGFOLDER"
fi

if [ ! -f "$LOGFILE" ];
then
	/usr/bin/touch ${LOGFILE}
fi

function logme()
{
# Check to see if function has been called correctly
	if [ -z "$1" ]; then
		/bin/echo "$(date '+%F %T') - logme function call error: no text passed to function! Please recheck code!"
		/bin/echo "$(date '+%F %T') - logme function call error: no text passed to function! Please recheck code!" >> ${LOGFILE}		
		exit 1
	fi

# Log the passed details
	/bin/echo "$(date '+%F %T') - $1"
	/bin/echo "$(date '+%F %T') - $1" >> ${LOGFILE}
}

# Start the preinstallation process.
logme "NoMAD Post-Installation Script"

# Find if there's a console user or not. Blank return if not.
consoleuser=$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')


# Find if there's a launch agent present
logme "Checking for LaunchAgent presence."
laloc="/Library/LaunchAgents/com.trusourcelabs.NoMAD.plist"
if [ -f "$laloc" ];
then
	# Restart the launch agent.
	logme "loading NoMAD LaunchAgent at: $laloc"
	/usr/bin/sudo -iu "$consoleuser" launchctl load "$laloc"
else
	logme "NoMAD LaunchAgent not found"
fi

logme "LaunchAgent restart completed"