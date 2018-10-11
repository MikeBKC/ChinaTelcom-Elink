
local socket = require("socket.core")
local json = require("cjson")
local dh = require("dh1")
local aes = require("aes")

require("uttdata.get")
require("uttdata.set")
require"base64"

local tcp=socket.tcp()

tcp:settimeout(5)

function tcpSendData(data)
    devinfo.sequence=devinfo.sequence+1
    tcp:send(string.pack('>I>I',0x3f721fb5,#data)..data)
end
---[[
function tcpRecivedData()
    local data=tcp:receive(8)
    if data then
        flag, datalen=string.unpack('>I>I',data)
        --print("tcp recive 4 byte len "..datalen)
        data=tcp:receive(datalen)
        return data
    else
        return nil
    end
end


--]]
sendMsgLog={}
sendMsgLog.timeout = 0
sendMsgLog.keepalive = 0
sendMsgLog.cfg = 0
sendMsgLog.dev_report = 0
sendMsgLog.status = 0
devinfo={}
devinfo.sequence=1

function send2GwKeyngreq()
    local reqinfo={}
    reqinfo.type="keyngreq"
    reqinfo.sequence=devinfo.sequence
    reqinfo.mac=devinfo.mac
    reqinfo.keymodelist={}
    reqinfo.keymodelist[1]={}
    reqinfo.keymodelist[1].keymode="dh"

    data=json.encode(reqinfo)
    --print(json.encode(reqinfo))
    tcpSendData(data)
    --print("recive from gw Keyngreq")
    --print(tcpRecivedData())
end

function send2GwDH()
    local reqinfo={}
    reqinfo.type="dh"
    reqinfo.sequence=devinfo.sequence
    reqinfo.mac=devinfo.mac
    reqinfo.data={}

    local p, pub, priv=dh.gkey()
    devinfo.pubkey=pub
    devinfo.privkey=priv

    --	print("pubkey: "..pub)
    --	print("privkey:"..priv)

    reqinfo.data.dh_key=encodeBase64(devinfo.pubkey)
    reqinfo.data.dh_p=encodeBase64(p)
    reqinfo.data.dh_g=encodeBase64(string.pack('B','5'))
    --print("sendto gw dh")

    data=json.encode(reqinfo)
    --print(json.encode(reqinfo))
    tcpSendData(data)
    --print("recive from gw dh")
    --[[
    local dhrespjson=(tcpRecivedData(tcp))
    if dhrespjson then
    print(dhrespjson)
    dhrespinfo=json.decode(dhrespjson)
    --print("gw dhkey:"..dhrespinfo.data.dh_key)
    --devinfo.secret=dh.gsecret(devinfo.privkey, decodeBase64(dhrespinfo.data.dh_key))
    print("dh pub "..dhrespinfo.data.dh_key)
    devinfo.secret=dh.gsecret(decodeBase64(dhrespinfo.data.dh_key), devinfo.privkey)
    --print("secret:"..devinfo.secret)
    else
    print("gw dh error")
    end
    --]]
end

function recivedSecretData()
    local data = tcpRecivedData()
    if data then
        local respjson=aes.decrypt_cbc(data, devinfo.secret)
        --print("get:"..respjson)
        local jsondata= json.decode(respjson)
        return jsondata
    else
        --print("get rec error")
        return nil
    end
end

function sendSecretData(reqinfo)
    local jsondata= json.encode(reqinfo)
    --print("send:  "..jsondata)
    local aesdata= aes.encrypt_cbc(jsondata,devinfo.secret)
    tcpSendData(aesdata)
end

function send2GwReg()
    local reqinfo={}
    reqinfo.type="dev_reg"
    reqinfo.sequence=devinfo.sequence
    reqinfo.mac=devinfo.mac

    reqinfo.data={}
    reqinfo.data.vendor=devinfo.vendor
    reqinfo.data.model=devinfo.model

    reqinfo.data.swversion=devinfo.swversion
    reqinfo.data.hdversion=devinfo.hdversion
    reqinfo.data.url=devinfo.url
    reqinfo.data.wireless=devinfo.wireless

    sendSecretData(reqinfo)
    sendMsgLog.timeout = 1

    --[[
    print("reg: "..jsondata)
    local jsondata= json.encode(reqinfo)
    local aesdata= aes.encrypt_cbc(jsondata,devinfo.secret)
    tcpSendData(tcp,aesdata)
    --]]
    --[[
    local regrespjson = recivedSecretData()
    if regrespjson then
    --print("regrespjson:"..regrespjson)
    else
    print("reg error")
    end
    --]]
    --[[
    local aesregrespjson=(tcpRecivedData(tcp))
    if aesregrespjson then
    --print(aesregrespjson)
    regrespjson=aes.decrypt_cbc(aesregrespjson, devinfo.secret)
    else
    print("reg error")
    end
    --]]

end

function KeepAlive()
    local reqinfo={}
    reqinfo.type="keepalive"
    reqinfo.sequence=devinfo.sequence
    sendMsgLog.keepalive=devinfo.sequence
    reqinfo.mac=devinfo.mac
    sendSecretData(reqinfo)
    --[[
    local jsondata=json.encode(reqinfo)
    print("sendjson:    "..jsondata)
    local aesdata= aes.encrypt_cbc(jsondata,devinfo.secret)
    tcpSendData(tcp, aesdata)
    --]]
    --
    --	local aesregrespjson=(tcpRecivedData(tcp))
    --	if aesregrespjson then
    --		--print(aesregrespjson)
    --		regrespjson=aes.decrypt_cbc(aesregrespjson, devinfo.secret)
    --		print("Keepalivejson:"..regrespjson)
    --	else
    --		print("keepalive error")
    --	end	
end

function ACK(num)
    local reqinfo={}
    reqinfo.type="ack"
    if num then
        reqinfo.sequence=num
    else
        --print("ACK:error")
        reqinfo.sequence=devinfo.sequence
    end
    reqinfo.mac=devinfo.mac
    sendSecretData(reqinfo)
    --[[
    local jsondata=json.encode(reqinfo)
    print("sendjson:    "..jsondata)
    local aesdata= aes.encrypt_cbc(jsondata,devinfo.secret)
    tcpSendData(tcp, aesdata)
    --]]
end

function send2GwChildDev()
    local reqinfo={}
    reqinfo.type = "dev_report"
    reqinfo.sequence = devinfo.sequence
    sendMsgLog.dev_report = "NO"

    reqinfo.mac=devinfo.mac 
    --reqinfo.dev={}
    if true then
        reqinfo.dev = getAllChildDev()
    else
        reqinfo.dev[1]={}
        --reqinfo.dev[1].mac=devinfo.mac
        reqinfo.dev[1].mac="112233665544"

        reqinfo.dev[1].vmac="001122335566"
        reqinfo.dev[1].connecttype = 1
    end

    sendSecretData(reqinfo)
    sendMsgLog.timeout = 1

end

function send2GwStatus(i,wifi, wifiswitch, ledswitch, wifitimer)
    if i then
        --print("send2GwStatus ok i")
        local reqinfo = {}
        reqinfo.type = "status"
        reqinfo.sequence = i
        sendMsgLog.status = i
        reqinfo.mac = devinfo.mac
        reqinfo.status = {}
        reqinfo.status.wifi = wifi
        reqinfo.status.wifiswitch = wifiswitch
        reqinfo.status.ledswitch = ledswitch
        reqinfo.status.wifitimer = wifitimer
        sendSecretData(reqinfo)
        sendMsgLog.timeout = 1
    else
        --print("send2GwStatus error i")
    end
end

function setConfig(data)
    if data then
        if data.wifiswitch then
            setWiFiswitch(data.wifiswitch)
        --end
        --if data.ledswitch then
        --end
        --if data.wifitimer then
            --setWiFitimer(data.wifitimer)
        --end
        --if data.wpsswitch then
           -- setWpsSwitch(data.wpsswitch)
        --end
        elseif data.wifi then
            setWiFi(data.wifi)
        --end
        --if data.upgrade then
            --setUpGrade(data.upgrade)
        end
    end
end

function getStatus(data)
    --[[
    data={}
    data.type="get_status"
    data.sequence = 89
    data.mac=devinfo.mac
    data.get={}
    data.get[1]={}
    data.get[1].name="WiFi"
    data.get[2]={}
    data.get[2].name="WiFiswitch"
    data.get[3]={}
    data.get[3].name="ledswitch"
    data.get[4]={}
    data.get[4].name="WiFitimer"
    print("伪造收到get_status:  "..json.encode(data))

    --]]
    local WiFi={} 
    local WiFiswitch={}
    local ledswitch={}
    local WiFitimer={}
    local sequences
    if data then
        if data.get then
            sequences = data.sequence
            for i,v in pairs(data.get) do
                if v then
                    if v.name == "wifi" then
                        WiFi=getWiFi()
                    elseif v.name == "wifiswitch" then
                        WiFiswitch=getWiFiswitch()
                    elseif v.name == "ledswitch" then
                        ledswitch=getledswitch()
                    elseif v.name == "wifitimer" then
                        WiFitimer=getWiFitimer()
                    end
                end
            end
        end
    end
    return sequences, WiFi, WiFiswitch, ledswitch, WiFitimer
end

--睡眠函数
function sleep(n)
    os.execute("sleep " .. n)
end

function checkChildDev()
    return false
end

function buildDevinfo()
    --devinfo.mac="0022aa112233"
    devinfo.mac=string.gsub(getmac("br1"),':','')
    devinfo.vendor="raisecom"
    devinfo.model=getmodel()
    devinfo.swversion=getswversion()
    devinfo.hdversion=gethdversion()
    devinfo.url='http://www.raisecom.com/'
    devinfo.wireless="yes"

    local host = getGW()
    if host == nil or host == "" then 
        --print("get GW error")
        return false
    else
        --print('GW:'..host)
        if tcp:connect(host, "32768") then
            return true
        else
         --   print("tcp connect "..host.." error")
            return false
        end
    end

    return true
end

function keepRun()
    while true do
        local recivedata = recivedSecretData()
        if recivedata then
            if checkChildDev() then
                --send.type = "dev_report" 
                send2GwChildDev()
            end
            if recivedata.type == "ack" then
                KeepAlive()
                if recivedata.sequence == sendMsgLog.keepalive then
                    sendMsgLog.timeout = 4

                elseif recivedata.sequence == sendMsgLog.dev_report then
                    --print ("get ack dev_report")
                elseif recivedata.sequence == sendMsgLog.status then
                    --print ("get ack status")
                end
            elseif recivedata.type == "cfg" then
                setConfig(recivedata.set)
                ACK(recivedata.sequence)
                --KeepAlive()
            elseif recivedata.type == "get_status" then
                local sequences, wifi, wifiswitch, ledswitch, wifitimer =getStatus(recivedata)
                send2GwStatus(sequences, wifi, wifiswitch, ledswitch, wifitimer)
                --send.type="status"
            end
        else
            --print("get error")
            KeepAlive()
            sendMsgLog.timeout = sendMsgLog.timeout-1
            if sendMsgLog.timeout <= 0 then
                return nil
            end
        end
        sleep(1)
    end
end


function reg()
    while true do
        local recdata = tcpRecivedData()
        if recdata then
            recjson = json.decode(recdata)
            if recjson then
                if recjson.type == "keyngack" then
                    send2GwDH()
                elseif recjson.type == "dh" then
                    devinfo.secret=dh.gsecret(decodeBase64(recjson.data.dh_key), devinfo.privkey)
                    send2GwReg()
                    return keepRun()
                end
            end
        else
            return nil
        end
    end
end

while true do
    if buildDevinfo() then
       if fromSysGet("uttcli get sysConf brideg_mode_flag") == "0" then 
            os.execute("uttcli set  sysConf  sysConf brideg_mode_flag 1 ")
            os.execute("elink_route_bridge.sh &")
        end
        send2GwKeyngreq()
        reg()
        tcp:close()
    end
    sleep(2)
end


