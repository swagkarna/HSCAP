#!/bin/bash

if [ $1 = "-disclaimer" ] || [ $1 = "-d" ]; then
  clear

  echo -e $CYW
  echo -e " ## Disclaimer and License : \n"
  echo -e " $CAMRK The author does not hold any responsibility for the bad use of this tool. "
  echo -e " $CAMRK Remember that attacking targets without prior consent is illegal. "
  echo -e " $CAMRK Use it only for educational purposes. "
  echo -e " $CAMRK This project is licensed under the $CLBE GPL v3.0 $CYW License. "

  echo -en $CYW "\n Press [ENTER] to continue ... "
  read continue

  clear && exit
fi

if [ $1 = "-version" ] || [ $1 = "-v" ]; then
  clear

  if [ -e "/opt/HSCAP" ]; then
  	Installed=$CLBE"YES"
  else
  	Installed=$CLRD"NO"
  fi

  echo -e $CYW
  echo -e " ## Script Version and Author : \n"
  echo -e " $CAMRK Version = $ScriptVersion "
  echo -e " $CAMRK Script Author = $ScriptAuthor "
  echo -e " $CAMRK Script Name = $ScriptName "
  echo -e " $CAMRK Tested Bash Version = $MinBashVersion "
  echo -e " $CAMRK Is Installed : $Installed "

  echo -en $CYW "\n Press [ENTER] to continue ... "
  read continue

  clear && exit
fi

if [ $1 = "-help" ] || [ $1 = "-h" ]; then
  clear

  echo -e $CYW
  echo -e " ## Help : \n"
  echo -e " $CAMRK Arguments      --    -- "
  echo
  echo -e " -disclaimer      -d    -Show Disclaimer "
  echo -e " -version         -v    -Show Version "
  echo -e " -help            -h    -Show This Message "

  echo -en $CYW "\n Press [ENTER] to continue ... "
  read continue

  clear && exit
fi
