#!/bin/bash

function compare_bash_version {
	awk -v n1="$BashVersion" -v n2="$MinBashVersion" 'BEGIN{if (n1>=n2) exit 0; exit 1}'
}

function check_bash {
  if compare_bash_version; then
    echo -e "\n You HAVE An Acceptable Bash Version ! "
  else
    echo -e "\n You DON'T Have An Acceptable Bash Version ( $BashVersion ) "
    echo -e "\n Minimum Required BASH Version: $MinBashVersion "
    exit
  fi
}

function check_root {
	if [ $(whoami) = "root" ]; then
		echo -e "\n You HAVE Root Permissions ! "
	else
		echo -e "\n You DON'T Have Root Permissions "
		echo -e "\n Do: 'sudo bash $ScriptName' "
		exit
	fi
}

function check_monitor {
  mode=$(iwconfig "$interface" 2> /dev/null | grep Mode: | awk '{print $4}' | cut -d ':' -f 2)

  if [[ $mode != "Monitor" ]]; then
    clear && echo -e "\n This Interface Is Not With Monitor Mode Enabled "
  	exit
  fi
}
