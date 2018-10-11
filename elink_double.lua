
local socket = require("socket.core")
socket.unix = require("socket.unix")



function elinka(sock)
    local json = require("cjson")
    local dh = require("dh1")
    local aes = require("aes")
    local config = require("elink_config")
    require("get")
    require("set")
    require"base64"
    local flag = sock.flag
    local tcp_init = sock.sock
    local connect = sock.connect
    local socket = sock.socket
    local tcp 


    local sendMsgLog={}
    sendMsgLog.timeout = 1
    sendMsgLog.time = 0
    sendMsgLog.headtime = -2
    sendMsgLog.keepalive = 0
    sendMsgLog.cfg = 0
    sendMsgLog.dev_report = 0
    sendMsgLog.status = 0
    sendMsgLog.keepaliveFlag=false
    local devinfo={}
    devinfo.sequence=1


    local function setTimeOut(num)
        sendMsgLog.timeout=num
        sendMsgLog.time = os.time()
    end

    local function checkTimeOut()
        return tonumber((os.time() - sendMsgLog.time) + 1) > tonumber(sendMsgLog.timeout*5)

    end

    local function tcpSendData(data)
        devinfo.sequence=devinfo.sequence+1
        tcp:send(string.pack('>I>I',0x3f721fb5,#data)..data)

    end
    local function sendSecretData(reqinfo)
        local jsondata= json.encode(reqinfo)
        --print(flag.."send:  "..jsondata)
        local aesdata= aes.encrypt_cbc(jsondata,devinfo.secret)
        tcpSendData(aesdata)
    end
    local function keepAlive()
        local reqinfo={}
        reqinfo.type="keepalive"
        reqinfo.sequence=devinfo.sequence
        sendMsgLog.keepalive=devinfo.sequence
        reqinfo.mac=devinfo.mac
        if (os.time() - sendMsgLog.headtime)  >  3 then
            sendSecretData(reqinfo)
            sendMsgLog.headtime = os.time()
        end
        --[[
        local jsondata=json.encode(reqinfo)
        print("sendjson:    "..jsondata)
        local aesdata= aes.encrypt_cbc(jsondata,devinfo.secret)
        tcpSendData(tcp, aesdata)
        ]]
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

    local function tcpRecivedData()
        while true do
            local recvt, sendt, status = socket.select({tcp}, nil, 0.05)
            if #recvt > 0  then
                local data,receive_status=tcp:receive(8)
                if receive_status ~= "closed" then
                    if data then
                        local _, datalen=string.unpack('>I>I',data)
                        --print("tcp recive 4 byte len "..datalen)
                        data=tcp:receive(datalen)
                        return data
                    end
                else
                    --print("TCP closed")
                    return nil
                end
            else

                if checkTimeOut()   then
                    --print(flag.." time out "..tostring(checkTimeOut()))
                    return nil
                else
                    if  sendMsgLog.keepaliveFlag then
                        --print("KeepAlive")
                        keepAlive()
                    end
                    --print("yield end")
                    coroutine.yield()
                    --print("yield start")
                end
            end
        end
        return nil
    end

    local function send2GwKeyngreq()
        local reqinfo={}
        reqinfo.type="keyngreq"
        reqinfo.sequence=devinfo.sequence
        reqinfo.version="V2017.1.0"
        reqinfo.mac=devinfo.mac
        reqinfo.keymodelist={}
        reqinfo.keymodelist[1]={}
        reqinfo.keymodelist[1].keymode="dh"
        setTimeOut(1)

        local data=json.encode(reqinfo)
        --print(json.encode(reqinfo))
        tcpSendData(data)
        --print("recive from gw Keyngreq")
        --print(tcpRecivedData())
    end

    local function send2GwDH()
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

        local data=json.encode(reqinfo)
        setTimeOut(1)

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

    local function recivedSecretData()
        local data = tcpRecivedData()
        if data then
            local respjson=aes.decrypt_cbc(data, devinfo.secret)
            --print(flag.." get:"..respjson)
            local jsondata= json.decode(respjson)
            return jsondata
        else
            --print("get rec error")
            return nil
        end
    end


    local function send2GwReg()
        local reqinfo={}
        reqinfo.type="dev_reg"
        reqinfo.sequence=devinfo.sequence
        reqinfo.mac=devinfo.mac

        reqinfo.data={}
        reqinfo.data.vendor=devinfo.vendor
        reqinfo.data.model=devinfo.model
        reqinfo.data.sn=devinfo.sn
        reqinfo.data.ipaddr=getIp()

        reqinfo.data.swversion=devinfo.swversion
        reqinfo.data.hdversion=devinfo.hdversion
        reqinfo.data.url=devinfo.url
        reqinfo.data.wireless=devinfo.wireless

        sendSecretData(reqinfo)
        --sendMsgLog.timeout = 1
        setTimeOut(1)

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


    local function ACK(num)
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

    local function send2GwChildDev()
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
        --sendMsgLog.timeout = 1
        setTimeOut(1)

    end

    local function send2GwStatus(i,wifi, wifiswitch, ledswitch, wifitimer)
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
            --sendMsgLog.timeout = 1
            setTimeOut(1)
        else
            --print("send2GwStatus error i")
        end
    end

    local function setConfig(data)
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
            elseif data.ctrlcommand then
                setCtrlCommand(data)
                --end
                --if data.upgrade then
                --setUpGrade(data.upgrade)
            end
        end
    end

    local function getStatus(data)
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


    local function checkChildDev()
        return false
    end

    local function buildDevinfo()
        --devinfo.mac="0022aa112233"
        if(devinfo.mac == nil) then
            devinfo.mac=string.gsub(getmac(config.wan_eth),':','')
        end
        devinfo.vendor=config.dev_vendor
        if(devinfo.model == nil) then
            devinfo.model=getmodel()
        end
        if(devinfo.swversion == nil) then
            devinfo.swversion=getswversion()
        end
        if(devinfo.hdversion == nil) then
            devinfo.hdversion=gethdversion()
        end
        devinfo.url=config.dev_url
        devinfo.wireless="yes"
        if(devinfo.sn == nil) then
            devinfo.sn=getSn()
        end
        if not devinfo.ipaddr then
            devinfo.ipaddr = getIp()
        end
        devinfo.host = getGW()
        if devinfo.host == nil or devinfo.host == "" then 
            --print("get GW error")
            return false
        else
            --print('GW:'..host)

            local tcp_tmp , flag =  connect(tcp,devinfo.host)
            if flag then
                tcp = tcp_tmp
                --            if tcp:connect(devinfo.host, "32768") then
                return true
            else
                --   print("tcp connect "..host.." error")
                return false
            end
        end

        return true
    end

    local function keepRun()
        sendMsgLog.keepaliveFlag = true
        while true do
            --print("func keepRun")
            local recivedata = recivedSecretData()
            if recivedata then
                if checkChildDev() then
                    --send.type = "dev_report" 
                    send2GwChildDev()
                end
                if recivedata.type == "ack" then
                    setTimeOut(4)
                    --if recivedata.sequence == sendMsgLog.keepalive then
                    --    --sendMsgLog.timeout = 4
                    --elseif recivedata.sequence == sendMsgLog.dev_report then
                    --    --print ("get ack dev_report")
                    --elseif recivedata.sequence == sendMsgLog.status then
                    --    --print ("get ack status")
                    --end
                elseif recivedata.type == "cfg" then
                    setConfig(recivedata.set)
                    ACK(recivedata.sequence)
                elseif recivedata.type == "get_status" then
                    local sequences, wifi, wifiswitch, ledswitch, wifitimer =getStatus(recivedata)
                    send2GwStatus(sequences, wifi, wifiswitch, ledswitch, wifitimer)
                    --send.type="status"
                end
            else
                print(flag.."get keep run error")
                return nil
            end
        end
    end


    local function reg()
        while true do
            print(flag.."func reg")
            local recdata = tcpRecivedData()
            if recdata then
                local recjson = json.decode(recdata)
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
        tcp = tcp_init()
        tcp:settimeout(0.5)
        coroutine.yield()
        --print(flag.."main")
        sendMsgLog.keepaliveFlag=false
        if buildDevinfo() then
            if fromSysGet("uttcli get sysConf brideg_mode_flag") == "0"  and flag == "TCP" then 
                os.execute("uttcli set  sysConf  sysConf brideg_mode_flag 1 ")
                os.execute("elink_route_bridge.sh &")
            end
            send2GwKeyngreq()
            reg()
            --tcp:close()
        end
        tcp:close()
        tcp=nil
        collectgarbage("collect")
    end
end

function tcp_connect(sock,host)
    local flag = sock:connect(host,"32768")

    return sock, flag
end
function unix_connect(sock,host)
    local flag = sock:connect("/tmp/ctc_elinkap.sock")
    return sock, flag
end


coFunc= coroutine.create(elinka)
cafunc = coroutine.create(elinka)


local tcp_soc={}
tcp_soc.sock=socket.tcp
tcp_soc.connect=tcp_connect
tcp_soc.flag="TCP"
tcp_soc.socket=socket


local unix_soc={}
unix_soc.sock=socket.unix
unix_soc.connect=unix_connect
unix_soc.flag="UNIX"
unix_soc.socket=socket

coroutine.resume(coFunc,tcp_soc)
coroutine.resume(cafunc,unix_soc)


while true do
    if coroutine.status(coFunc) == "dead" then
        --print("TCP error")
        coFunc = coroutine.create(elinka)
        coroutine.resume(coFunc,tcp_soc)
    else   
        coroutine.resume(coFunc)
    end
    if coroutine.status(cafunc) == "dead" then
        --print("UNIX error")
        cafunc = coroutine.create(elinka)
        coroutine.resume(cafunc,unix_soc)
    else
        coroutine.resume(cafunc)
    end
    socket.select(nil,nil,0.01)
end
