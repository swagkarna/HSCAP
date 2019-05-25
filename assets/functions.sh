#!/bin/bash

#Compare - Version Is **Greater** Than "Minimum Required Version"
function compare_versions {
	awk -v n1="${1}" -v n2="${2}" 'BEGIN{if (n1>n2) exit 0; exit 1}'
}

#Compare - Bash Version Is **Greater Or Equal** Than "Minimum Required Bash Version"
function comp_bash_version {
	awk -v n1="$BashVersion" -v n2="$MinBashVersion" 'BEGIN{if (n1>=n2) exit 0; exit 1}'
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

#Check - See If HSCAP Or ".config" Needs To Be Updated
function check_updt {
	if [ $UpdateScript = "yes" ]; then
		cd /opt

		if compare_versions "${hscap_last_version}" "${ScriptVersion}"; then
	  	sudo rm -rf /opt/HSCAP
	  	sudo git clone "https://github.com/midnightsonne/HSCAP.git"
	  	sudo chown -R anderson /opt/HSCAP
		fi

		if compare_versions "${config_last_version}" "${ConfigVersion}"; then
	  	sudo rm -rf /opt/HSCAP/.config
	  	wget $urlconfig /opt/HSCAP/.config
	  	sudo chown -R anderson /opt/HSCAP/.config
		fi
	fi
}

#Check - User Has All Packages Needed To Run The Script
function check_dpkg {

	# - These Are The Essential Packages Needed To Run Script
	Essential_PKGS=(
		"mdk3"
		"mdk4"
		"aircrack-ng"
		"xterm"
		"x11-xserver-utils"
	)

	if [ $UpdatePackages = "yes" ]; then
		echo -en "\n ${CAMRK} Please Wait A Second ... "
		for Essential_PKGS in "${Essential_PKGS[@]}"; do
    	if [ $(dpkg-query -W -f='${Status}' $Essential_PKGS 2> /dev/null | grep -c "ok installed") -eq 0 ]; then
    		sudo apt-get -y install $Essential_PKGS 2> /dev/null > /dev/null
    	fi
		done
		echo -e "\r ${CGMRK} You HAVE All Required Packages ! "
	fi
}

#Check - User Has CapsLock **Enabled Or Disabled**
function check_caps {
	if [ $(xset -q | grep Caps | cut -c 22-24) != "off" ]; then
		echo -en "\n ${CBMRK} You HAVE CapsLock ON - Script Requires CapsLock OFF "
		sleep 2 && clear && exit
	fi
}

#Function - End Script Cleaning Temporary Files and Stopping Services
function end_script {
	clear

	echo -e "$CWE"
	echo -e " Cleaning Temporary Files ... \n"

	cd $TmpDIR

	sudo rm -rf *.csv > /dev/null 2>&1
  sudo rm -rf *.txt > /dev/null 2>&1
  sudo rm -rf *.cap > /dev/null 2>&1
  sudo rm -rf *.netxml > /dev/null 2>&1

	echo -e " Stopping Services ... \n"

  sudo airmon-ng stop "$Interface" > /dev/null 2>&1

	echo -e " Exiting Script ... \n"

	sleep 0.5 && clear && exit
}
