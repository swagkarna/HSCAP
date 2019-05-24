#!/bin/bash

if [ $1 = "-i" ]; then
  if [ -e "/opt/HSCAP" ]; then
    sudo rm -r '/opt/HSCAP/'
    sudo cp -r '../HSCAP/' '/opt/HSCAP/'
    sudo chmod +x '/opt/HSCAP/'

sudo rm -rf '/bin/hscap' 2> /dev/null
cat >"/bin/hscap" <<-EOF
  sudo bash /opt/HSCAP/main.sh

  if [ $1 = "-r" ]; then
    sudo rm -r '/opt/HSCAP/'
    sudo rm -rf '/bin/hscap'
    echo "HSCAP Was Uninstalled"
  fi
EOF
    echo "HSCAP Was Re-Installed"
  else
    sudo cp -r '../HSCAP/' '/opt/HSCAP/'
    sudo chmod +x '/opt/HSCAP'

cat >"/bin/hscap" <<-EOF
  sudo bash /opt/HSCAP/main.sh

  if [ $1 = "-r" ]; then
    sudo rm -r '/opt/HSCAP/'
    sudo rm -rf '/bin/hscap'
    echo "HSCAP Was Uninstalled"
  fi
EOF
    echo "HSCAP Was Installed"
  fi
fi
