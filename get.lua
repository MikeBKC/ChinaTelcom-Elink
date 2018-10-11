#!/usr/bin/lua 

local json = require('cjson')
local wifista = require("wifista")

--[[
--函数名: staInfo
--参数 formatStr 可选(mac, MAC, radio, SSID, ssid)
--返回值 根据可选参数,返回以参数分组的sta 列表 .无参数则默认返回sta数组形式
--]]
local function staInfo(formatStr,func)
    local formatStrs={mac="MAC",MAC="MAC",radio="RadioType",SSID="SSID",ssid="SSID"}
    local formatFunc=func
    local staFormatList={}
    local stalist=wifista.stainfo()
    if formatStrs[formatStr] == "MAC" then
        for _,sta in pairs(stalist) do
            staFormatList[sta.MAC] = not formatFunc and sta or formatFunc(sta)
        end
        stalist = staFormatList
    elseif formatStrs[formatStr] then
        for _,sta in pairs(stalist) do
            local tmpRadioType= sta[formatStrs[formatStr]]
            if not staFormatList[tmpRadioType] then
                staFormatList[tmpRadioType]={}
            end
            staFormatList[tmpRadioType]:insert(not formatFunc and sta or formatFunc(sta))
        end
        stalist = staFormatList
    else
        if formatFunc then
            for num,sta in pairs(stalist) do
                staFormatList[num] = formatFunc(sta)
            end
            stalist = staFormatList
        end
    end
    return stalist 
end
function split( str,reps )
	local resultStrList = {}
	string.gsub(str,'[^'..reps..']+',function ( w )
		table.insert(resultStrList,w)
	end)
	return resultStrList
end
function fromSysGet(cmd)
    local file = io.popen(cmd)
    local data=file:read()
    file:close()
    return data
end
function getRoaming()
       local json_str = fromSysGet("cat /tmp/roam_tmp.json") 
       local roaming_json = json.decode(json_str)
       local time = tonumber(roaming_json.start_time)

    return staInfo("",function (sta)
        local new_sta={}
        if tonumber(sta["OnlineTime"]) > time and tonumber(sta["onlineTime"]) < time+10 then
            new_sta["mac"]=sta["MAC"]:gsub(":","")
            new_sta["connect_time"]=sta["onlineTime"]
            new_sta["rssi"]="-20"
            return new_sta
        end
        return nil
    end)
end
function getAllChildDev()

    return staInfo("",function (sta)
        local new_sta={}
        new_sta["mac"]=sta["MAC"]:gsub(":","")
        new_sta["vmac"]=new_sta["mac"]
        new_sta["connecttype"]=1

    end)
    --[[
    local req={}
    for i=1,2,1 do
        req[i]={}
        --req[i]=getOneChildDev()
        req[i].mac="00E034A46D3A"
        req[i].vmac="00E034A46D3A"
        req[i].connecttype=1
    end
    return req
    ]]
end
function getRssiInfo(mac_list)
    local list_tmp={}
    for k,v in pairs(mac_list) do
        mac_list[v]="yes"
    end
    return staInfo("",function (sta)
        local new_sta={}
        new_sta["mac"]=sta["MAC"]:gsub(":","")
        new_sta["band"]=sta["RadioType"]
        new_sta["rssi"]=-23
        if mac_list[new_sta["mac"]] then
            return new_sta
        end

    end)
end
function getWiFi()
    local config = require("elink_config")
    local wifi={}

    local g2json=fromSysGet('uttelink.sh get wirelessinfo')
    local g2jsondata=json.decode(g2json)

    wifi[1]={}
    wifi[1].radio={}
    wifi[1].radio.mode="2.4G"
    wifi[1].radio.channel=tonumber(g2jsondata.channel)
    wifi[1].radio.txpower="0"
    wifi[1].ap={}
    wifi[1].ap[1]={}
    wifi[1].ap[1].apidx=0
    wifi[1].ap[1].enable="yes"
    wifi[1].ap[1].ssid=g2jsondata.ssid
    wifi[1].ap[1].key=g2jsondata.password
    wifi[1].ap[1].auth=string.lower(g2jsondata.authmode)
    wifi[1].ap[1].encrypt=string.lower(g2jsondata.encryptmethod)
    if config.dev_wlan_type:find("5G") then
        local g5json=fromSysGet('uttelink.sh get wireless5ginfo')
        local g5jsondata=json.decode(g5json)
        wifi[2]={}
        wifi[2].radio={}
        wifi[2].radio.mode="5G"
        wifi[2].radio.channel=tonumber(g5jsondata.channel)
        wifi[2].radio.txpower="0"
        wifi[2].ap={}
        wifi[2].ap[1]={}
        wifi[2].ap[1].apidx=0
        wifi[2].ap[1].enable="yes"
        wifi[2].ap[1].ssid=g5jsondata.ssid
        wifi[2].ap[1].key=g5jsondata.password
        wifi[2].ap[1].auth=string.lower(g5jsondata.authmode)
        wifi[2].ap[1].encrypt=string.lower(g5jsondata.encryptmethod)
    end

    --[[
    for i=1,2 do
    wifi[i]={}
    wifi[i].radio={}
    wifi[i].radio.mode="2.4G"
    wifi[i].radio.channel=12
    wifi[i].ap={}
    for j=1,2 do
    wifi[i].ap[j]={}
    wifi[i].ap[j].apidx=i-1
    wifi[i].ap[j].enable="yes"
    wifi[i].ap[j].ssid="ssid"
    wifi[i].ap[j].key="WiFikey"
    wifi[i].ap[j].auth="open"
    wifi[i].ap[j].encrypt="none"

    end
    end
    --]]
    return wifi

end
-----------------------------------------
--ytt-------------
-----------------------------------------

--所有无线接口及分类
function getWirelessIfname()
	local ifname = {}
	ifname = {ra0="2.4G",ra1="2.4G",rai0="5G",rai1="5G"}
	return ifname
end

--第一个无线接口及分类
function firstWirelessIfname()
	local ifname = {}
	ifname = {ra0="2.4G",rai0="5G"}
	return ifname
end

--根据信号百分比算rssi
function percenTorssi(percen)
	local rssi = ""
	if percen and percen <= 23 then
		rssi = tostring(math.ceil(percen*10/26-90))
	elseif percen and percen < 100 then
		rssi = tostring(math.ceil((percen-24)*10/26-80))
	else
		rssi = tostring(math.random(-50,-40))
	end
	return rssi
end

--转换无线模式
function WirelessMode()
	local wiremode = {}
	wiremode = {
	["11a"] = "11a",
	["11b"] = "11b",
	["11g"] = "11g",
	["11n"] = "11n",
	["11a/n"] = "11n",
	["11b/g"] = "11g",
	["11b/g/n"] = "11n",
	["11a/n/ac"] = "11ac",
	["unknow"] = "11n",
	}
	return wiremode
end

--WLAN邻居信息
function WlanNeighborInfo()
	local index = 0
	local tmpinfo,nebrinfo = {},{}
	local cmdscan,cmdscre = "",""
	local wiremode = WirelessMode()
	local ifname = firstWirelessIfname()
	for k,v in pairs(ifname) do
		cmdscan = "iwpriv "..k.." set CountryRegionABand=0;iwpriv "..k.." set SiteSurvey=1"
		cmdscre = "iwpriv "..k.." get_site_survey"
		os.execute(cmdscan)
		local file = io.popen(cmdscre)
		for line in file:lines() do
			tmpinfo = split(line," ")
			if tonumber(tmpinfo[1]) and #tmpinfo then
				index = index + 1
				nebrinfo[index] = {}
				nebrinfo[index].channel = tonumber(tmpinfo[1])
				nebrinfo[index].ssidname = tmpinfo[2]
				nebrinfo[index].bssid = tmpinfo[3]
				nebrinfo[index].rssi = percenTorssi(tonumber(tmpinfo[5]))
				nebrinfo[index].standard = wiremode[tmpinfo[6]]
				nebrinfo[index].networktype = "AP"
				nebrinfo[index].rfband = v
			end
            if index > 5 then
                break;
            end
		end
		file:close()
	end
    return nebrinfo
end

--取实际信道值
function Channelinfo()
	local channel = {}
    local ifname = firstWirelessIfname()
	local cmd = ""
	for k,v in pairs(ifname) do
		cmd = "iwconfig "..k.." | grep 'Channel' | awk {'print $2'} | awk -F= {'print $2'}"
        channel[v] = tonumber(fromSysGet(cmd))
	end
	return channel
end

-----------------------------------------
-----------------------------------------

function getWiFiswitch()
    local s = fromSysGet('uttelink.sh get wirelessactive')
    if s == "Yes" then
        s='{"wirelessactive":"ON"}'
    else
        s='{"wirelessactive":"OFF"}'
    end
    local sdata=json.decode(s)
    local req = {}
    req.status=sdata.wirelessactive
    return req
end
function getledswitch()
    local s = fromSysGet('uttelink.sh get ledswith')
    if s and s=="" then
        s='{"ledswith":"OFF"}'
    else
        s='{"ledswith":"ON"}'
    end
    local sdata=json.decode(s)
    local req={}
    req.status=sdata.ledswith
    return req
end
function getWiFitimer()
    local req={}
    req[1]={}
    req[1].weekday="1"
    --req[1].time="21:56"
    req[1].time="17:30"
    req[1].enable="0"
    req[2]={}
    req[2].weekday="2"
    req[2].time="17:30"
    req[2].enable="1"
    return req
end
function getOneChildDev()
    local req={}
    return req
end
function getChildStatus()
end

function getmodel()
    local config=require("elink_config")
    return config.dev_model
    --local modelCmd = "uname  -a |awk -F '[ ]' '{print $5}'"
    --return fromSysGet(modelCmd)
end

function getswversion()
    local versionCmd = "uname  -a |awk -F '[ -]' '{print $6}'"
    return fromSysGet(versionCmd)
end

function gethdversion()
    local hwCmd = "uname  -v |awk -F '[ - ]' '{print $1}'"
    local hwTmp = fromSysGet(hwCmd)
    if(string.lower(string.sub(hwTmp,string.len(hwTmp)-2,string.len(hwTmp)-1)) == "v") then
        return string.lower(string.sub(hwTmp,string.len(hwTmp)-2,string.len(hwTmp)))..".0"
    else
        return "v1.0"
    end
end

function getGW()
    local GWCmd="route -n | awk '{print $2}'|grep '\\<[^0a-zA-Z]'"
    local GW = fromSysGet(GWCmd)
    return GW
end

function getmac(eth)
    local macCmd="ifconfig "..eth.." |awk '/HWaddr/{print $5}'"
    local macData=fromSysGet(macCmd)
    return macData
end


--输入：无
--输出：序列号 共34位
--功能：获取序列号
function getSn()
    local config = require("elink_config")
    --前22位向电信申请 + 12为WAN口mac地址
    local sn = config.sn .. string.gsub(getmac("br1"),':','')       --wanEth配置在config.lua中
    return sn
end

--输入：无
--输出：WAN口IP地址
--功能：获取WAN口的IP地址
function getIp()
    local wanIpCmd = "ifconfig br1 | awk '/inet addr/{print $2}'"
    local ip_str=fromSysGet(wanIpCmd)
    if ip_str and tonumber(ip_str:len()) > 5 then
        local wanIp = string.sub(fromSysGet(wanIpCmd), 6, -1)
        return wanIp
    end
end
local function getOneChildDev()
    local req={}
    return req
end

--获取支持的频段
function getBandSupport()
	local band = {}
	local index = 0
	local ifname = firstWirelessIfname()
	for k,v in pairs(ifname) do
		index = index + 1
		band[index] = v
	end
	return  band
end

--取系统运行时间
--单位:秒
function getUpTime()
	local time = 0
	local Tfile = io.open("/proc/uptime","r")
	if Tfile then
		time = Tfile:read("*n")
		Tfile:close()
	end
	return tostring(math.ceil(time))
end

--取工作模式
--roueter:路由(默认) bridge:桥接 repeater:中继(暂无)
function getWorkMode()
	return "bridge"
end

--取接入方式
--PPPOE/STATIC/DHCP
function getNetType()
	return "DHCP"
end

--获取上行速率
--单位:kbps
function getUpLoadSpeed()
	return "100"
end

--获取下行速率
--单位:kbps
function getDownLoadSpeed()
	return "125"
end

--取接口信息
--返回表,以接口名称为键值
--待优化:只取传入的接口信息，问题是如何遍历传入的接口，减少循环次数
function getIfnameInfo()
	local tmpif,tmp,info = {},{},{}
	local file = io.open("/proc/net/dev","r")
	if file then
		for line in file:lines() do
			tmpif = split(line,":")
			if tmpif[2] then
				tmp = split(tmpif[2]," ")
				tmpif[1] = string.gsub(tmpif[1], "^%s*(.-)%s*$", "%1") --去空格
				info[tmpif[1]] = {}
				info[tmpif[1]].rxbyte = tonumber(tmp[1])
				info[tmpif[1]].txbyte = tonumber(tmp[9])
				info[tmpif[1]].rxpack = tonumber(tmp[2])
				info[tmpif[1]].txpack = tonumber(tmp[10])
				info[tmpif[1]].rxerror = tonumber(tmp[3])
				info[tmpif[1]].txerror = tonumber(tmp[11])
				info[tmpif[1]].rxdrop = tonumber(tmp[4])
				info[tmpif[1]].txdrop = tonumber(tmp[12])
			end
		end
		file:close()
	end
	--print(json.encode(info))
	return info
end

--取ssid名称,返回以接口名为键值的表
function getSsidName()
	local tmpif,ssid,tmpssid = {},{},{}
	local file = io.popen("iwconfig 2>/dev/null")
	for line in file:lines() do
		if string.sub(line,1,1) ~= " " then
			tmpif = split(line," ")
			if tmpif[4] then
				tmpssid = split(tmpif[4],":")
				if tmpssid[2] then
					ssid[tmpif[1]] = string.sub(tmpssid[2],2,-2)
				end
			end
		end
	end
	file:close()
	print(json.encode(ssid))
	return ssid
end

--获取无线运行信息,基于ssid统计
--返回接口信息的表
function getWlanStats()
	local tmprf = ""
	local j,i,index = 0,0,0
	local ifname,info,wlaninfo,ssid = {},{},{},{}
	info = getIfnameInfo()
	ifname = getWirelessIfname()
	ssid = getSsidName()
	for k,v in pairs(ifname) do
		if info[k].rxbyte and info[k].rxbyte ~= 0 then
			index = index + 1
			wlaninfo[index] = {}
			wlaninfo[index].apidx = index
			wlaninfo[index].ssid = ssid[k]
			wlaninfo[index].band = v
			wlaninfo[index].totalBytesSent = info[k].txbyte
			wlaninfo[index].totalBytesReceived = info[k].rxbyte
			wlaninfo[index].totalPacketsSent = info[k].txpack
			wlaninfo[index].totalPacketsReceived = info[k].rxpack
			wlaninfo[index].errorsSent = info[k].txerror
			wlaninfo[index].errorsReceived = info[k].rxerror
			wlaninfo[index].discardPacketsSend = info[k].txdrop
			wlaninfo[index].discardPacketsReceived = info[k].rxdrop
		end
	end
	--print(json.encode(wlaninfo))
	return wlaninfo
end

--获取WLAN邻居信息
function getWlanNeighborInfo()
	return WlanNeighborInfo()
end

--获取信道值
function getChannel()
	--return Channelinfo()
    local channelInfo={}
    channelInfo["2.4G"]=11 
    channelInfo["5G"]=56
    return channelInfo
end
function getLoad()
    local load_table={}
    load_table["2.4G"]="80%"
    load_table["5G"]="70%"
    return load_table

end
function getElinkStat()
    local elinkstat={}
    elinkstat["connectedGateway"]="yes"
    return elinkstat
end
function getTerminalNum()
    local terminalNum={}
    terminalNum["wireNum"]=3
    terminalNum["2.4GwirelessNum"]=1
    terminalNum["5GwirelessNum"]=2
    return terminalNum
end
function getMemoryUseRate()
    return "35%"
end
function getCpuRate()
    return "24%"
end
function getRealDevinfo()
    return staInfo("",function (sta)
        local new_sta={}
        new_sta["mac"]=sta["MAC"]:gsub(":","")
        new_sta["hostname"]=sta["MAC"]
        new_sta["onlineTime"]=tostring(sta["OnlineTime"])
        new_sta["uploadspeed"]="1"
        new_sta["downloadspeed"]="2"
        new_sta["connecttype"]=1
        new_sta["band"]=sta["RadioType"]
        new_sta["rssi"]="-98"

    end)
end
