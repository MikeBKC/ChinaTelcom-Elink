
#!/bin/sh
#
#
# usage: see function usage()
#





usage () {
  echo "usage: uttelinkget.sh get [option]..."
  echo "options:"
  echo "  -h              : print this help"
  echo "  wanmac          : get wan mac"
  echo "  wanip           : get wan ip"
  echo "  haswireless           : get haswireless"
  echo "  wirelessactive           : get wirelessactive"
  echo "  wirelesssn           : get wirelesssn"
  echo "  wirelessinfo           : get wirelessinfo"
  echo "  wireless5ginfo           :get wireless5ginfo"
  echo "  wirelesstimer           : get wirelesstimer"
  echo "  stainfo           : get stainfo"
  echo "  ledswith           : get ledswith"
  exit
}
modle=`uname -m`
if [ "$1" = "get" ];then
case "$2" in
    "-h") usage;;
    "wanmac") 
	wanmac=`uttcli get interface 1 ethernet mac` 
	echo "{\"wanmac\":\"$wanmac\"}";;
    "wanip")
	#wanip=`uttcli get interface 0 ethernet static ip`
	wanip=`ifconfig eth2.2 | grep 'inet ' | sed s/^.*addr://g | sed s/Bcast.*$//g`
	echo "{\"wanip\":\"$wanip\"}";;
    #"manufacturerinfo") #放入了elink_config.lua
	#echo "{\"manufacturer\": \"utt\",\"model\": \"$modle\",\"url\": \"http://www.utt.com.cn/\"}";;
    "haswireless") #后续更改
	echo "{\"haswireless\":\"YES\"}" ;;
    "wirelessactive")
	wirelessactive=`uttcli get wireless wireless active`
    echo $wirelessactive;;
    "wirelesssn") 
	wirelesssn=`uttcli get_uttsn`
	echo "{\"wirelesssn\":\"$wirelesssn\"}" ;; 
    "wirelessinfo")
	ssid=`uttcli get wireless wireless mbasecfg ssid`
	passwd=`uttcli get wireless wireless msafecfg SafepskPsswd`
	channel=`uttcli get wireless wireless mbasecfg channel`
	authmode=`uttcli get wireless wireless msafecfg authMode`
	encryptmethod=`uttcli get wireless wireless msafecfg SafeEncrypType`
	echo "{\"ssid\":\"$ssid\",\"password\":\"$passwd\",\"channel\":\"$channel\",\"authmode\":\"$authmode\",\"encryptmethod\":\"$encryptmethod\"}" ;;
    "wireless5ginfo")
	ssid=`uttcli get wireless wireless5g  mbasecfg ssid`
	passwd=`uttcli get wireless wireless5g  msafecfg SafepskPsswd`
	channel=`uttcli get wireless wireless5g  mbasecfg channel`
	authmode=`uttcli get wireless wireless5g  msafecfg authMode`
	encryptmethod=`uttcli get wireless wireless5g  msafecfg SafeEncrypType`
	echo "{\"ssid\":\"$ssid\",\"password\":\"$passwd\",\"channel\":\"$channel\",\"authmode\":\"$authmode\",\"encryptmethod\":\"$encryptmethod\"}" ;;
    "wirelesstimer")
	wirelesstimer=`uttcli get wireless  mbasecfg WlanTimeEn`
	if [ "$wirelesstimer" = "Disable" ]; then
	    echo "{\"wirelesstimer\": \"OFF\"}"
	else
	    echo "{\"wirelesstimer\": \"ON\"}"
	fi ;;
    "stainfo")
	stainfo=`cat /proc/net/statsPerIp`
	echo $stainfo ;;
    "ledswith")
	ledswith=`mmap 10000064`
	if [ "$ledswith" = "0x10000064: 0x00000000" ] ; then
	    #echo "{\"ledswith\":\"ON\"}"
	    echo "ON"
	else
	    #echo "{\"ledswith\":\"OFF\"}"
	    echo "OFF"
	fi ;;
    *) 
	echo "you command error"
	usage
	return ;;
esac

elif [ "$1" = "set" ]; then
    if [ "$2" = "softUpdate" ]; then
	wget -O /kernelImage "$3"
	uttCrcCheckTool
	if [ "$4" = "1" ]; then
	    echo "reboot"
	    reboot
	elif [ "$4" = "0" ]; then
	    echo "Don't restart"
	else
	    echo "you command error"
	fi
    else 
	 echo "you command error"
    fi

elif [ "$1" = "-h" ]; then
    usage
else
    echo "you command error"

fi
