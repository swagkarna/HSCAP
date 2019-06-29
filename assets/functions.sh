#!/bin/bash

#Compare - Version Is Greater* Than "Minimum Required Version"
function compare_versions_greater {
  awk -v n1="${1}" -v n2="${2}" 'BEGIN{if (n1>n2) exit 0; exit 1}'
}

#Compare - Bash Version Is Greater* Or Equal* Than "Minimum Required Bash Version"
function compare_versions_greater_equal {
  awk -v n1="${1}" -v n2="${2}" 'BEGIN{if (n1>=n2) exit 0; exit 1}'
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
  if compare_versions_greater_equal "${BashVersion}" "${MinBashVersion}"; then
    echo -e "\n ${CGMRK} You HAVE An Acceptable Bash Version ! "
  else
    echo -e "\n ${CBMRK} You DON'T Have An Acceptable Bash Version ( $BashVersion ) "
    echo -en "\n ${CAMRK} Minimum Required BASH Version: $MinBashVersion "
    sleep 2 && clear && exit
  fi
}

#Check - User Has CapsLock Enabled* Or Disabled*
function check_caps {
  if [ $(xset -q | grep Caps | cut -c 22-24) != "off" ]; then
    echo -en "\n ${CBMRK} You HAVE CapsLock ON - Script Requires CapsLock OFF "
    sleep 2 && clear && exit
  fi
}

#Check - User Has Internet Connection
function check_conn {
  if ping -c 1 google.com; then
    HasConnection=Yes
  fi
} > /dev/null 2>&1

#Check - See If HSCAP And Packages Needs To Be Updated
function check_updt {
  check_conn
  
  if [ "$UpdateScript" = "Yes" ] && [ "$HasConnection" = "Yes" ]; then
    cd /opt || exit
    
    echo -en "\n ${CAMRK} Please Wait A Second ... "
    if compare_versions_greater "${exploita_last_version}" "${ScriptVersion}"; then
      sudo rm -rf /opt/HSCAP
      sudo git clone "https://github.com/midnightsonne/HSCAP.git"
      sudo chown -R "$UserName" /opt/HSCAP
    fi
    
    if compare_versions_greater "${config_last_version}" "${ConfigVersion}"; then
      sudo rm -rf /opt/HSCAP/.config
      wget "$urlconfig" /opt/HSCAP/.config
      sudo chown -R "$UserName" /opt/HSCAP/.config
    fi
    
    echo -e "\r ${CGMRK} You HAVE Script's Latest Version ! "
  else
    if [ "$HasConnection" != "Yes" ]; then
      echo -e "\n ${CBMRK} Update Failed - No Internet Connection "
    else
      echo -e "\n ${CAMRK} Update Failed - Update Disabled "
    fi
  fi
  
  # - These Are The Essential Packages Needed To Run Script
  Essential_PKGS=(
    "mdk3"
    "mdk4"
    "aircrack-ng"
    "xterm"
    "x11-xserver-utils"
  )
  
  if [ "$UpdatePackages" = "Yes" ] && [ "$HasConnection" = "Yes" ]; then
    for Essential_PKGS in "${Essential_PKGS[@]}"; do
      if [ $(dpkg-query -W -f='${Status}' "$Essential_PKGS" 2> /dev/null | grep -c "ok installed") -eq 0 ]; then
        sudo apt-get -y install "$Essential_PKGS" > /dev/null 2>&1
      fi
    done
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
