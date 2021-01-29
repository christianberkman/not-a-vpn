#!/bin/bash

#
# Copyright (c) 2021 christianberkman
# Released under MIT License
#
# Bash Script to manage not-a-vpn via sshuttle
#

# COnfig
source not-a-vpn-config.sh
REMOTE="$USER@$HOST:$PORT $SUBNETS"

# Formatting vars
BLINK="\e[5m"
BOLD="\e[1m"
RED="\e[31m"
GREEN="\e[32m"
LINE="----------------------------------------------------------"
RESET="\e[0m"


# Get sshuttle PID from sshuttle.pid
get_sshuttle_pid () {
	SSHUTTLE_PID=$(cat sshuttle.pid 2>/dev/null)
}

# Check if sshuttle is already running, if so exit
check_already_running () {
	get_sshuttle_pid
	if [ -n "$SSHUTTLE_PID" ]
	then
		echo -e "${GREEN}sshuttle is already running!${RESET} (PID ${BOLD}$SSHUTTLE_PID${RESET})"
		echo
		exit
	fi
}

# Print Header
echo # A bit of space before the script
echo $LINE   
echo -e "${BLINK}Not${RESET} a VPN via ${BOLD}sshuttle${RESET}"
echo
echo -e "Remote:\t\t\t${BOLD}${REMOTE}${RESET}"
echo -e "Options:\t\t${BOLD}${OPTIONS}${RESET}"
echo -e "Extra options:\t\t${BOLD}${OPTIONS_ALT}${RESET}"
echo $LINE
echo

# Switch mode
case $1 in
	
	# Normal start (deamon mode)
	start)
		check_already_running
		
		echo -e "${GREEN}Starting...$RESET"
	
		COMMAND="sshuttle -D $OPTIONS -r $REMOTE"
		# Use OPTIONS_ALT if mode is 'start alt'
		if [ "$2" = "alt" ]
		then
			COMMAND="sshuttle -D $OPTIONS_ALT -r $REMOTE"
		fi
		
		echo -e "${BOLD}Command:${RESET} $COMMAND"
		$COMMAND
		echo

		# Check if sshuttle really started		
		get_sshuttle_pid
		if [ -z "$SSHUTTLE_PID" ]
		then
			echo -e "${RED}${BOLD}Error:${RESET} sshuttle failed to start"
			echo "Please run verbose mode"
		else
			echo -e "${GREEN}sshuttle started successfully${RESET} (PID ${BOLD}$SSHUTTLE_PID${RESET})"
		fi
		
	;;
	
	# Verbose mode
	verbose)
		check_already_running

		echo -e "${GREEN}Starting...$RESET (verbose mode)"

		COMMAND="sshuttle -vv $OPTIONS -r $REMOTE"
		# Use OPTIONS_ALT if mode is 'verbose alt'
		if [ "$2" = "alt" ]
		then
			COMMAND="sshuttle -vv $OPTIONS_ALT -r $REMOTE"
		fi

		echo -e "${BOLD}Command:${RESET} $COMMAND"
		echo -e "Press ${BOLD}CTRL+C${RESET} to stop sshuttle"
		$COMMAND
		echo
	;;
	
	# Check if sshuttle is running
	check)
		get_sshuttle_pid
		if [ -n "$SSHUTTLE_PID" ]
		then
			echo -e "${GREEN}sshuttle is running${RESET} (PID ${BOLD}$SSHUTTLE_PID${RESET})"
			echo
			echo -e "You can stop by using ${BOLD}./not-a-vpn.sh stop${RESET} or ${BOLD}kill $SSHUTTLE_PID${RESET}"
			echo
			echo "Last 10 syslog entries for sshuttle:"
			echo
			cat /var/log/syslog | grep sshuttle | tail -n 10
			
		else
			echo -e "${RED}sshuttle is not running${RESET}"
			echo
			echo -e "Verify if sshuttle is running by finding it's ${BOLD}PID${RESET} in the list below"
			echo
			ps aux | grep sshuttle
			echo
		fi
	;;
	
	# Stop sshuttle (if running)
	stop)
		get_sshuttle_pid
		if [ -z "$SSHUTTLE_PID" ]
		then
			echo -e "${RED}sshuttle is not running${RESET}"
			echo
			echo -e "Verify if sshuttle is running by finding it's ${BOLD}PID${RESET} in the list below"
			echo -e "and kill manually using ${BOLD}killPID${RESET}"
			echo
			ps aux | grep sshuttle
			echo
			
		else
			echo -e "${GREEN}sshuttle is running${RESET} (PID ${BOLD}$SSHUTTLE_PID${RESET})"
			echo
			
			kill $SSHUTTLE_PID

			# Check if sshuttle was really killed (probably overkill)
			get_sshuttle_pid
			if [ -z "$SSHUTTLE_PID" ]
			then
				echo -e "${BOLD}Stopped sshuttle${RESET}"
			else
				echo -e "${RED}Could not stop sshuttle${RESET}"
				echo -e "Please run ${BOLD}./not-a-vpn.sh check${RESET}"
			fi
		fi
	;;
	
	*)
		echo -e "${RED}Invalid mode${RESET} $1"
		echo -e "Valid modes: ${BOLD}start, start alt, verbose, verbose alt, check, stop${RESET}"
	;;
esac

echo # A bit of empty space after the script
exit




