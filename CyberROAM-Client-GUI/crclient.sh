#!/bin/bash
#This script/app is not property of CyberROAM or any company affilates.
#This script/app is licenced under GPL v2 ; url : http://www.gnu.org/licenses/gpl-2.0.html

#exports:
export addr="./crclient"
export username="user.name"

while :
do
cn=$(zenity  --width=300 --height=220 --list \
  --title="CyberROAM Login.." \
  --text "<b>This script is not created by cyberROAM</b>" \
  --column="No." --column="Options"  \
    1 Login \
    2 Logout \
    3 Exit )

	case $cn in
	1) cd $addr ; ./crclient -u $username -f ./crclient/crclient.conf -d ./crc.log ; chmod -R 777 ./crc.log ; zenity --info --text "$(tail -1 ./crc.log)" ; exit 0;;
	2) cd $addr ; ./crclient -l $username -f ./crclient/crclient.conf -d ./crc.log ; chmod -R 777 ./crc.log ; zenity --info --text "$(tail -1 ./crc.log)" ; exit 0;;
	3) exit 0
	esac
done
