#!/bin/bash

#Compare - Bash Version Is **Greater Or Equal** Than "Minimum Required Bash Version"
function comp_bash_version {
	awk -v n1="$BashVersion" -v n2="$MinBashVersion" 'BEGIN{if (n1>=n2) exit 0; exit 1}'
}

#Check - User Has The Required "Minimum Bash Version"
function check_bash {
  if comp_bash_version; then
    echo -e "\n ${CGMRK} You HAVE An Acceptable Bash Version ! "
  else
    echo -e "\n ${CBMRK} You DON'T Have An Acceptable Bash Version ( $BashVersion ) "
    echo -en "\n ${CAMRK} Minimum Required BASH Version: $MinBashVersion "
    sleep 2 && clear && exit
  fi
}

#Check - User Has Root Permissions
function check_root {
	if [ $(whoami) = "root" ]; then
		echo -e "\n ${CGMRK} You HAVE Root Permissions ! "
	else
		echo -e "\n ${CBMRK} You DON'T Have Root Permissions "
		echo -en "\n ${CAMRK} Do: 'sudo bash $ScriptName' "
		sleep 2 && clear && exit
	fi
}

#Check - User Has CapsLock **Enabled Or Disabled**
function check_caps {
	if [ $(xset -q | grep Caps | cut -c 22-24) != "off" ]; then
		echo -en "\n ${CBMRK} You HAVE CapsLock ON - Script Requires CapsLock OFF "
		sleep 2 && clear && exit
	fi
}

#Check - Monitor Mode Is Enabled On The Selected Interface
function check_monitor {
  MonMode=$(iwconfig "$interface" 2> /dev/null | grep Mode: | awk '{print $4}' | cut -d ':' -f 2)

  if [[ $MonMode != "Monitor" ]]; then
    clear && echo -e "\n This Interface Doesn't Have Monitor Mode Enabled "
  	sleep 2 && end_script
  fi
}

#Function - End Script Cleaning Temporary Files and Stopping Services
function end_script {
	clear

	echo -e "$CWE"
	echo -e " Cleaning Temporary Files ... \n"

	sudo rm -rf "${TmpDIR}bl.txt" > /dev/null 2>&1

	echo -e " Stopping Services ... \n"

  sudo airmon-ng stop "$interface" > /dev/null 2>&1

	echo -e " Exiting Script ... \n"

	sleep 0.5 && clear && exit
}