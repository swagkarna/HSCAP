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

echo -en "\\033]0;HandShake Capture\\a"
handshake_capture

end_script
