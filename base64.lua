
--此库需要优化 把 ".." 换成 表

function encodeBase64(source_str)  
    local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'  
    local s64 = ''  
    local str = source_str  
  
    while #str > 0 do  
        local bytes_num = 0  
        local buf = 0  
  
        for byte_cnt=1,3 do  
            buf = (buf * 256)  
            if #str > 0 then  
                buf = buf + string.byte(str, 1, 1)  
                str = string.sub(str, 2)  
                bytes_num = bytes_num + 1  
            end  
        end  
  
        for group_cnt=1,(bytes_num+1) do  
            local b64char = math.fmod(math.floor(buf/262144), 64) + 1 
            if b64char < 0 then
                b64char = 64+b64char
            end

            s64 = s64 .. string.sub(b64chars, b64char, b64char)  
            buf = buf * 64 
        end  
  
        for fill_cnt=1,(3-bytes_num) do  
            s64 = s64 .. '='  
        end  
    end  
  
    return s64  
end  
  
function decodeBase64(str64) 
--    file=io.open("./logdecode.data","a+")
    local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'  
    local temp={}  
    for i=1,64 do  
        temp[string.sub(b64chars,i,i)] = i  
    end  
    temp['=']=0  
    local str=""  
    for i=1,#str64,4 do  
        if i>#str64 then  
            break  
        end  
        local data = 0  
        local str_count=0  
        for j=0,3 do  
            local str1=string.sub(str64,i+j,i+j)  
            if not temp[str1] then  
                return  
            end  

            if temp[str1] < 1 then  
                data = data * 64  
            else  
                data = data * 64 + temp[str1]-1  
                str_count = str_count + 1  
            end  
--file:write(data)
        end  
--        file:write("A")
        for j=16,0,-8 do  
            if str_count > 0 then 
                str=str..string.char(math.floor(data/(2^j)))  
                data=math.fmod(data,(2^j))  
                str_count = str_count - 1  
            end  
        end  
    end  
  
    local last = tonumber(string.byte(str, string.len(str), string.len(str)))  
    if last == 0 then  
        str = string.sub(str, 1, string.len(str) - 1)  
    end  
--    file:close()
    return str  
end  

--[[
aa='eyJDbWRUeXBlIjoiUVVFUllfTUVNX0lORk8iLCJTZXF1ZW5jZUlkIjoiMHgwMDAwMDg5OCJ9'
b1='eyJDbWRUeXBlIjoiR0VUX1NZU1RFTV9JTkZPIiwiU2VxdWVuY2VJZCI6IjB4MDAwMDAyMzYifQ=='
b2='eyJDbWRUeXBlIjoiR0VUX1RJTUVfRFVSQVRJT04iLCJTZXF1ZW5jZUlkIjoiMHgwMDAwMDIwOCJ9'
b3='eyJDbGFzc05hbWUiOiJjb20uaHVhd2VpLm9wZW5saWZlLnNtYXJ0Z2F0ZXdheS5kZXZpY2VzZXJ2aWNlLmFjY2Vzc3NlcnZpY2VzLkFjY2Vzc0luZm9RdWVyeVNlcnZpY2UiLCJQYXJhbWV0ZXIiOltdLCJNZXRob2QiOiJnZXRXQU5JZkxpc3QiLCJDbWRUeXBlIjoiY29udGFpbmVyU2VydmljZS5kb0FjdGlvbiIsIlNlcXVlbmNlSWQiOiIweDAwMDBmNzgyIn0='
b4='eyJDbGFzc05hbWUiOiJjb20uaHVhd2VpLm9wZW5saWZlLnNtYXJ0Z2F0ZXdheS5kZXZpY2VzZXJ2aWNlLmFjY2Vzc3NlcnZpY2VzLkFjY2Vzc0luZm9RdWVyeVNlcnZpY2UiLCJQYXJhbWV0ZXIiOltdLCJNZXRob2QiOiJnZXRXQU5JZkxpc3QiLCJDbWRUeXBlIjoiY29udGFpbmVyU2VydmljZS5kb0FjdGlvbiIsIlNlcXVlbmNlSWQiOiIweDAwMDBmMTg1In0='
b5='eyJDbWRUeXBlIjoiUVVFUllfQ1BVX0lORk8iLCJTZXF1ZW5jZUlkIjoiMHgwMDAwMDAyMyJ9'
b6='eyJDbWRUeXBlIjoiR0VUX1NZU1RFTV9JTkZPIiwiU2VxdWVuY2VJZCI6IjB4MDAwMDAxNzAifQ=='
b7='eyJDbWRUeXBlIjoiR0VUX1RJTUVfRFVSQVRJT04iLCJTZXF1ZW5jZUlkIjoiMHgwMDAwMDA0MCJ9'
b8='eyJDbGFzc05hbWUiOiJjb20uaHVhd2VpLm9wZW5saWZlLnNtYXJ0Z2F0ZXdheS5kZXZpY2VzZXJ2aWNlLmFjY2Vzc3NlcnZpY2VzLkFjY2Vzc0luZm9RdWVyeVNlcnZpY2UiLCJQYXJhbWV0ZXIiOltdLCJNZXRob2QiOiJnZXRXQU5JZkxpc3QiLCJDbWRUeXBlIjoiY29udGFpbmVyU2VydmljZS5kb0FjdGlvbiIsIlNlcXVlbmNlSWQiOiIweDAwMDA2YjcifQ=='

print(decodeBase64(aa))
print(decodeBase64(b1))
print(decodeBase64(b2))
print(decodeBase64(b3))
print(decodeBase64(b4))
print(decodeBase64(b5))
print(decodeBase64(b6))
print(decodeBase64(b7))
print(decodeBase64(b8))
--]]
