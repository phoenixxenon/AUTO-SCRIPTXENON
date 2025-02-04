#!/bin/bash
# Color
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'
# Getting
MYIP=$(wget -qO- ipv4.icanhazip.com);
echo "Checking VPS"
clear
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/etc/xray/vmessgrpc.json")
	if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
		echo ""
		echo "You have no existing clients! by NT"
		exit 1
	fi
	
	clear
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/etc/xray/vlessgrpc.json")
	if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
		echo ""
		echo "You have no existing clients! by NT"
		exit 1
	fi
	
	clear
	echo ""
	echo " Select the existing client you want to remove by NT"
	echo " Press CTRL+C to return"
	echo " ==============================="
	echo "     No  Expired   User"
	grep -E "^### " "/etc/xray/vmessgrpc.json" | cut -d ' ' -f 2-3 | nl -s ') '
	grep -E "^### " "/etc/xray/vlessgrpc.json" | cut -d ' ' -f 2-3 | nl -s ') '
	until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
		if [[ ${CLIENT_NUMBER} == '1' ]]; then
			read -rp "Select one client [1]: " CLIENT_NUMBER
		else
			read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
		fi
	done
user=$(grep -E "^### " "/etc/xray/vmessgrpc.json" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^### " "/etc/xray/vmessgrpc.json" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
user=$(grep -E "^### " "/etc/xray/vlessgrpc.json" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^### " "/etc/xray/vlessgrpc.json" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
sed -i "/^### $user $exp/,/^},{/d" /etc/xray/vmessgrpc.json
sed -i "/^### $user $exp/,/^},{/d" /etc/xray/vlessgrpc.json
rm -f /etc/xray/$user-tls.json
systemctl restart vmess-grpc.service
systemctl restart vless-grpc.service
clear
echo ""
echo "==============================="
echo "  NT XRAY GRPC VMESS VLESS Account Deleted  "
echo "==============================="
echo "Username  : $user"
echo "Expired   : $exp"
echo "==============================="
