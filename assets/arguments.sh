#!/bin/bash

clear

case $1 in
  -d | -disclaimer)
    echo -e "$CYW"
    echo -e " ## Disclaimer and License : "
    echo
    echo -e " $CAMRK The author does not hold any responsibility for the bad use of this tool. "
    echo -e " $CAMRK Remember that attacking targets without prior consent is illegal. "
    echo -e " $CAMRK Use HSCAP only for educational purposes. "
    echo -e " $CAMRK This project is licensed under the $CLBE GPL v3.0 $CYW License. "
    echo -en "$CNC" "\n Press [ENTER] to continue ... "
    read continue
    
    clear && exit
  ;;
  -v | -version)
    if [ -e "/opt/HSCAP" ]; then
      Installed=$CLBE"YES"
    else
      Installed=$CLRD"NO"
    fi
    
    echo -e "$CYW"
    echo -e " ## Script Version and Author : "
    echo
    echo -e " $CAMRK Script Version = $ScriptVersion "
    echo -e " $CAMRK Config Version = $ConfigVersion "
    echo -e " $CAMRK Min Bash Version = $MinBashVersion "
    echo
    echo -e " $CAMRK Script Author = $ScriptAuthor "
    echo -e " $CAMRK Script Name = $ScriptName "
    echo
    echo -e " $CAMRK Is Installed : $Installed "
    echo -en "$CNC" "\n Press [ENTER] to continue ... "
    read continue
    
    clear && exit
  ;;
  -h | -help | "")
    echo -e "$CYW"
    echo -e " ## Help : "
    echo
    echo -e " -start           -s    -Start HSCAP "
    echo -e " -disclaimer      -d    -Show Disclaimer "
    echo -e " -version         -v    -Show Version "
    echo -e " -help            -h    -Show This Message "
    echo -en "$CNC" "\n Press [ENTER] to continue ... "
    read continue
    
    clear && exit
  ;;
esac
