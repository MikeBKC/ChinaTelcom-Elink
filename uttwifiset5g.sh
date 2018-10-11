#!/bin/sh

usage () {
  echo "usage: uttwifiset5g.sh get [option]..."
  echo "options:"
  echo "uttwifiset5g.sh -s ssid -c 149 -a  WPAPSKWPA2PSK -p passwd -t TKIPAES"
  exit
}
add_brctl()
{
    add_rai0=`brctl show|awk -F: '/rai0/'`
    if [ "$add_rai0" = "" ];then
        brctl addif br1 rai0
    fi
}
while getopts "s:c:a:p:t:e:" arg #选项后面的冒号表示该选项需要参数
do
    case $arg in
	s)
	    echo "s's arg:$OPTARG" #参数存在$OPTARG中
	    uttcli2 set wireless wireless5g  mbasecfg ssid $OPTARG
	    ;;
	c)
	    echo "c's arg:$OPTARG"
        case "$OPTARG" in
        "36")
        uttcli2 set wireless wireless5g  mbasecfg channel $OPTARG
	    ;;
        "40")
        uttcli2 set wireless wireless5g  mbasecfg channel $OPTARG
	    ;;
        "44")
        uttcli2 set wireless wireless5g  mbasecfg channel $OPTARG
	    ;;
        "48")
        uttcli2 set wireless wireless5g  mbasecfg channel $OPTARG
	    ;;
        "149")
        uttcli2 set wireless wireless5g  mbasecfg channel $OPTARG
	    ;;
        "153")
        uttcli2 set wireless wireless5g  mbasecfg channel $OPTARG
	    ;;
        "157")
        uttcli2 set wireless wireless5g  mbasecfg channel $OPTARG
	    ;;
        "161")
        uttcli2 set wireless wireless5g  mbasecfg channel $OPTARG
	    ;;
        "165")
        uttcli2 set wireless wireless5g  mbasecfg channel $OPTARG
	    ;;
        "0")
        uttcli2 set wireless wireless5g  mbasecfg channel $OPTARG
	    ;;
        *) echo "channel error,please set 36,40,44,48,149,153,157,161,165 or 0(auto)"
        ;;
	    esac
	    ;;
	a)
	    echo "a's arg:$OPTARG"
	    case "$OPTARG" in
		"OPEN")  
		    uttcli2 set wireless wireless5g  msafecfg authMode $OPTARG 
		    ;;
		"SHARED") 
		    uttcli2 set wireless wireless5g  msafecfg authMode $OPTARG 
		    ;;
		"WEPAUTO") 
		    uttcli2 set wireless wireless5g msafecfg authMode $OPTARG 
		    ;;
		"WPAPSK") 
		    uttcli2 set wireless wireless5g msafecfg authMode $OPTARG 
		    ;;
		"WPA2PSK") 
		    uttcli2 set wireless wireless5g msafecfg authMode $OPTARG 
		    ;;
		"WPAPSKWPA2PSK") 
		    uttcli2 set wireless wireless5g msafecfg authMode $OPTARG 
		    ;;
        *) echo "authMode error,please set authMode OPEN SHARED WEPAUTO WPAPSK WPA2PSK WPAPSKWPA2PSK";;
	    esac
	    ;;
    p)
        echo "p's arg:$OPTARG"
        wep_var=`uttcli2 get wireless wireless5g  msafecfg authMode`
        if [ "$wep_var" == "SHARED" ]; then
            uttcli2 set wireless wireless5g msafecfg SafewepKey1 $OPTARG
        else
            uttcli2 set wireless wireless5g msafecfg SafepskPsswd $OPTARG
        fi
        ;;
	t)
	    echo "t's arg:$OPTARG"
	    case "$OPTARG" in
		"NONE")  
		    uttcli2 set wireless wireless5g msafecfg SafeEncrypType $OPTARG 
		    ;;
		"WEP") 
		    uttcli2 set wireless wireless5g msafecfg SafeEncrypType $OPTARG 
		    ;;
		"TKIPAES") 
		    uttcli2 set wireless wireless5g msafecfg SafeEncrypType $OPTARG 
		    ;;
		"TKIP") 
		    uttcli2 set wireless wireless5g msafecfg SafeEncrypType $OPTARG 
		    ;;
		"AES") 
		    uttcli2 set wireless wireless5g msafecfg SafeEncrypType $OPTARG 
		    ;;
		*) echo "SafeEncrypType error,please set SafeEncrypType NONE WEP TKIPAES TKIP or AES";;
	    esac

	    ;;
    e)
	    echo "e's arg:$OPTARG"
	    case "$OPTARG" in
		"ON")  
		    uttcli2 set wireless  wireless5g active Yes 
            ifconfig rai0 up &
            add_brctl &
		    ;;
		"OFF") 
		    uttcli2 set wireless wireless5g active No 
            ifconfig rai0 down &
		    ;;
		*) echo "wireless active  error,please set ON or OFF";;
	    esac
	    ;;

	?)  #当有不认识的选项的时候arg为?
	    echo "unkonw argument"
	    usage
	    exit 1
	    ;;
    esac
done
