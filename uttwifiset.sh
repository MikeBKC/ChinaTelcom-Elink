#!/bin/sh

usage () {
  echo "usage: uttwifiset.sh get [option]..."
  echo "options:"
  echo "uttwifiset.sh -s ssid -c 2 -a  WPAPSKWPA2PSK -p passwd -t TKIPAES"
  exit
}
add_brctl()
{
    add_ra0=`brctl show|awk -F: '/ra0/'`
    if [ "$add_ra0" = "" ];then
        brctl addif br1 ra0
    fi
}
while getopts "s:c:a:p:t:e:l:" arg #选项后面的冒号表示该选项需要参数
do
    case $arg in
	s)
	    echo "s's arg:$OPTARG" #参数存在$OPTARG中
	    uttcli2 set wireless wireless  mbasecfg ssid $OPTARG
	    ;;
	c)
	    echo "c's arg:$OPTARG"
	    if [ $OPTARG -gt 13 -o $OPTARG -lt 0 ] ; then
		echo "chancel error,please set 0-13"
	    elif [ "$OPTARG" = "0" ] ; then
		uttcli2 set wireless wireless  mbasecfg AutoChannelSelect 2
		uttcli2 set wireless wireless  mbasecfg channel $OPTARG
	    else
		uttcli2 set wireless wireless  mbasecfg AutoChannelSelect 0
		uttcli2 set wireless wireless  mbasecfg channel $OPTARG

	    fi
	    ;;
	a)
	    echo "a's arg:$OPTARG"
	    case "$OPTARG" in
		"OPEN")  
		    uttcli2 set wireless wireless  msafecfg authMode $OPTARG 
		    ;;
		"SHARED") 
		    uttcli2 set wireless wireless  msafecfg authMode $OPTARG 
		    ;;
		"WEPAUTO") 
		    uttcli2 set wireless wireless msafecfg authMode $OPTARG 
		    ;;
		"WPAPSK") 
		    uttcli2 set wireless wireless msafecfg authMode $OPTARG 
		    ;;
		"WPA2PSK") 
		    uttcli2 set wireless wireless msafecfg authMode $OPTARG 
		    ;;
		"WPAPSKWPA2PSK") 
		    uttcli2 set wireless wireless msafecfg authMode $OPTARG 
		    ;;
		*) echo "authMode error,please set authMode OPEN SHARED WEPAUTO WPAPSK WPA2PSK or WPAPSKWPA2PSK";;
	    esac

	    ;;
	p)
	    echo "p's arg:$OPTARG"
        wep_var=`uttcli2 get wireless wireless  msafecfg authMode`
        if [ "$wep_var" == "SHARED" ]; then
	        uttcli2 set wireless wireless msafecfg SafewepKey1 $OPTARG
        else
	        uttcli2 set wireless wireless msafecfg SafepskPsswd $OPTARG
        fi
	    ;;
	t)
	    echo "t's arg:$OPTARG"
	    case "$OPTARG" in
		"NONE")  
		    uttcli2 set wireless wireless msafecfg SafeEncrypType $OPTARG 
		    ;;
		"WEP") 
		    uttcli2 set wireless wireless msafecfg SafeEncrypType $OPTARG 
		    ;;
		"TKIPAES") 
		    uttcli2 set wireless wireless msafecfg SafeEncrypType $OPTARG 
		    ;;
		"TKIP") 
		    uttcli2 set wireless wireless msafecfg SafeEncrypType $OPTARG 
		    ;;
		"AES") 
		    uttcli2 set wireless wireless msafecfg SafeEncrypType $OPTARG 
		    ;;
		*) echo "SafeEncrypType error,please set SafeEncrypType NONE WEP TKIPAES TKIP or AES";;
	    esac

	    ;;
	e)
	    echo "e's arg:$OPTARG"
	    case "$OPTARG" in
		"ON")  
            uttcli2 set wireless wireless active Yes
            ifconfig ra0 up &
            add_brctl &
		    ;;
		"OFF") 
            uttcli2 set wireless wireless active No 
            ifconfig ra0 down & 
		    ;;
		*) echo "wireless active  error,please set ON or OFF";;
	    esac

	    ;;
	l)
	    echo "l's arg : $OPTARG"
	    case "$OPTARG" in
		"ON")  mmap W 10000064 0X0 ;;
		"OFF") mmap W 10000064 0X1 ;;
		*) echo " led active error,please set ON or OFF";;
	    esac

	    ;;
	?)  #当有不认识的选项的时候arg为?
	    echo "unkonw argument"
	    usage
	    exit 1
	    ;;
    esac
done
#bridge_vif.sh是判断当获取上层地址后，起个虚接口管理地址
Elink_flag=`uttcli get sysConf  Elink_flag`
if [ "$Elink_flag" == "1" ]; then
    bridge_vif.sh add
    uttcli2 set sysConf  sysConf Elink_flag 0
fi
