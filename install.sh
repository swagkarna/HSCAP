#!/bin/bash

if [ "$1" == "-i" ]; then
  sudo rm -r '/opt/HSCAP' 2> /dev/null
  sudo rm -rf '/bin/hscap' 2> /dev/null
  sudo cp -r '../HSCAP/' '/opt/HSCAP/'
  
cat >"/bin/hscap" <<-EOF
  cd /opt/HSCAP
	case \$1 in
	  -r | -remove)
      sudo rm -r '/opt/HSCAP'
      sudo rm -rf '/bin/hscap'
      echo "HSCAP Was Uninstalled"
	  ;;
	  -s | -start)
      sudo bash /opt/HSCAP/main.sh -s
      exit
	  ;;
	  -d | -disclaimer)
      sudo bash /opt/HSCAP/main.sh -d
      exit
	  ;;
	  -v | -version)
      sudo bash /opt/HSCAP/main.sh -v
      exit
	  ;;
	  -h | -help | "")
      sudo bash /opt/HSCAP/main.sh -h
      exit
	  ;;
	esac
EOF
  
  sudo chmod +x '/opt/HSCAP'
  sudo chmod +x '/bin/hscap'
  echo "HSCAP Was Installed"
fi

if [ "$1" == "-r" ]; then
  sudo rm -r '/opt/HSCAP' 2> /dev/null
  sudo rm -rf '/bin/hscap' 2> /dev/null
  echo "HSCAP Was Uninstalled"
fi
