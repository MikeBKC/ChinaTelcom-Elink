function setWiFi(data)
    local config = require("elink_config")
    for i,wifidata in pairs(data) do
        local mode = wifidata.radio.mode
        local enable = "yes"
        local havessid = false
        local wifiswitch = fromSysGet('uttcli2 getbynm wireless wireless active')
        if(mode == "2.4G") then
            local file = io.open("./wireless2g.dat","w")
            for j,apdata in pairs(wifidata.ap) do
                if apdata.ssid then
                    os.execute("ifconfig ra0 down")
                    file:write("SSID"..j.."="..apdata.ssid.."\n")
                    havessid = true
                    if apdata.auth then                           
                        if(apdata.auth == "share") then
                            apdata.auth = "shared" 
                        end
                        file:write("AuthMode="..string.upper(apdata.auth)..";"..string.upper(apdata.auth).."\n")
                    end
                    if apdata.encrypt then                           
                        if(apdata.auth == "shared") then
                            apdata.encrypt = "wep"
                        end
                        file:write("EncrypType="..string.upper(apdata.encrypt)..";"..string.upper(apdata.encrypt).."\n")
                    end
                    if apdata.key then
                        if(apdata.encrypt == "wep") then
                            file:write("Key1Str"..j.."="..apdata.key.."\n")
                        else 
                            file:write("WPAPSK"..j.."="..apdata.key.."\n")
                        end
                    end
                    file:write("Channel="..wifidata.radio.channel.."\n")
                    if wifidata.radio.channel == 0 then
                        file:write("AutoChannelSelect=2")
                    else
                        file:write("AutoChannelSelect=0")
                    end

                    file:close()

                    if havessid then  
                        os.execute("cat /etc_ro/Wireless/default2g.dat >/etc/Wireless/RT2860/RT2860.dat")
                        os.execute("cat ./wireless2g.dat >>/etc/Wireless/RT2860/RT2860.dat")
                    end
                    if enable == "yes" and wifiswitch == "Yes" then
                        os.execute("ifconfig ra0 up &")
                    end

                    os.execute("uttwifiset.sh -s ".. apdata.ssid.. " -c "..wifidata.radio.channel.." -a ".. string.upper(apdata.auth).. " -p ".. apdata.key.. " -t ".. string.upper(apdata.encrypt) .."& ")
                end
                --file:write("Channel="..wifidata.radio.channel.."\n")
                --if wifidata.radio.channel == 0 then
                    --file:write("AutoChannelSelect=2")
                --else
                    --file:write("AutoChannelSelect=0")
                --end
                --file:close()

               -- if havessid then  
                 --   os.execute("cat ./default2g.dat >/etc/Wireless/RT2860/RT2860.dat")
                   -- os.execute("cat ./wireless2g.dat >>/etc/Wireless/RT2860/RT2860.dat")
                --end
                --if enable == "yes" and wifiswitch == "Yes" then
                  --  os.execute("ifconfig ra0 up &")
                --end
            end

        elseif mode == "5G"  and config.dev_wlan_type:find("5G") then
            local file=io.open("./wireless5g.dat","w")
            local havessid = false
            for j,apdata in pairs(wifidata.ap) do
                if apdata.ssid then
                    os.execute("ifconfig rai0 down")
                    file:write("SSID"..j.."="..apdata.ssid.."\n")
                    havessid= true
                    if apdata.auth then                
                        if(apdata.auth == "share") then
                            apdata.auth = "shared"
                        end
                        file:write("AuthMode="..string.upper(apdata.auth)..";"..string.upper(apdata.auth).."\n")
                    end
                    if apdata.encrypt then              
                        if(apdata.auth == "shared") then
                            apdata.encrypt = "wep"
                        end
                        file:write("EncrypType="..string.upper(apdata.encrypt)..";"..string.upper(apdata.encrypt).."\n")
                    end
                    if apdata.key then
                        if(apdata.encrypt == "wep") then
                            file:write("Key1Str"..j.."="..apdata.key.."\n")
                        else
                            file:write("WPAPSK"..j.."="..apdata.key.."\n")
                        end
                    end
                    file:write("Channel="..wifidata.radio.channel.."\n")
                    if wifidata.radio.channel == 0 then
                        file:write("AutoChannelSelect=2")
                    else
                        file:write("AutoChannelSelect=0")
                    end
                    file:close()
                    if havessid then  
                        os.execute("cat /etc_ro/Wireless/default5g.dat >/etc/Wireless/iNIC/iNIC_ap.dat")
                        os.execute("cat ./wireless5g.dat >>/etc/Wireless/iNIC/iNIC_ap.dat")
                    end
                    if enable == "yes" and wifiswitch == "Yes" then
                        os.execute("ifconfig rai0 up &")
                    end
                    os.execute("uttwifiset5g.sh -s ".. apdata.ssid.. " -c "..wifidata.radio.channel.." -a ".. string.upper(apdata.auth).. " -p ".. apdata.key.. " -t ".. string.upper(apdata.encrypt) .."& ")
                end
                --file:write("Channel="..wifidata.radio.channel.."\n")
                --if wifidata.radio.channel == 0 then
                    --file:write("AutoChannelSelect=2")
                --else
                    --file:write("AutoChannelSelect=0")

                --end

                --file:close()
                --if havessid then  
                    --os.execute("cat ./default5g.dat >/etc/Wireless/iNIC/iNIC_ap.dat")
                    --os.execute("cat ./wireless5g.dat >>/etc/Wireless/iNIC/iNIC_ap.dat")
                --end
                --if enable == "yes" and wifiswitch == "Yes" then
                    --os.execute("ifconfig rai0 up &")
                --end
            end
        end
    end
end
function setWiFiswitch(data)
    local config = require("elink_config")
    if data and data.status then
        if data.status == "ON" then
            if config.dev_wlan_type:find("5G") then
                os.execute("uttwifiset5g.sh -e ON ")
            end
            os.execute("uttwifiset.sh -e ON ")
        else
            os.execute("uttwifiset.sh -e OFF ")
            if config.dev_wlan_type:find("5G") then
                os.execute("uttwifiset5g.sh -e OFF")
            end
        end
    end
end

function setledswitch(data)
    --print("set ledswitch:",data.status)
    local config = require("elink_config")
    if data and data.status then
        if data.status == "ON" then
            if config.dev_wlan_type:find("5G") then
                os.execute("uttwifiset5g.sh -l ON ")
            end
            os.execute("uttwifiset.sh -l ON ")
        else
            os.execute("uttwifiset.sh -l OFF ")
            if config.dev_wlan_type:find("5G") then
                os.execute("uttwifiset5g.sh -l OFF")
            end
        end
    end
end

--参数：wps(on/off) 
--返回值：无 
--功能：开启或关闭WPS功能 
function setWpsSwitch(data)
    --print("set Wpsswitch:",data.status)
    local wps = data.status
    if wps == "ON" then 
        os.execute("iwpriv ra0 set WscConfMode=7;iwpriv ra0 set WscMode=2;iwpriv ra0 set WscGetConf=1;iwpriv rai0 set WscConfMode=7;iwpriv rai0 set WscMode=2;iwpriv rai0 set WscGetConf=1") 
    elseif wps == "OFF" then 
        os.execute("iwpriv ra0 set WscConfMode=0;iwpriv rai0 set WscConfMode=0") 
    end 
end

function setUpGrade(data)
    print("set wget :",data.downurl)
    print("set reboot:",data.isreboot)
end

function setWiFitimer(data)
    for i,timedata in pairs(data) do
        print("set weekday:", timedata.weekday)
        print("set time:",timedata.time)
        print("set timerEnable:",timedata.enable)
    end
end

--参数：无 
--返回值：无 
--功能：系统重启 
function reboot() 
    os.execute("reboot") 
end     

--参数：无 
--返回值：无 
--功能：恢复出厂设置 
function reset() 
    os.execute("killall -SIGUSR2 nvram_daemon") 
end     

--参数：无 
--返回值：wanStatus 0:down 1:up 
--功能：获取WAN口接连状态 
function getWanStatus() 
    --local wanStatus = tonumber(string.sub(fromSysGet("cat " .. WAN_STATUS_FILE), 0, -2)) 
    return 0
end  

--参数：ctrlcommand字段
--返回值：无
--功能：重启/恢复出厂/保存文件
function setCtrlCommand(data)
    if data.ctrlcommand == "reboot" then
        reboot()
    elseif data.ctrlcommand == "reset" then
        reset()
    elseif data.ctrlcommand == "save" then
        print("ctrlcommand is save /tmp/ctc_elinkap.json")
    end
end
function setRoaming(data)
    local json=require("cjson")
    local json_str = json.encode(data)
    print("enable:",data.enable)
    print("threshold_rssi:",data.threshold_rssi)
    print("report_interval:",data.report_interval)
    print("start_time:",data.start_time)
    print("start_rssi:",data.start_rssi)
    os.execute("echo -e '"..json_str.."' >/tmp/roam_tmp.json &")
end
function setDisMac(data)
    for index, mac in pairs(data.mac) do
        print(mac)
    end
end
