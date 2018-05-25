-- print AP list in old format (format not defined)
function listap(t)
    
    for k,v in pairs(t) do
      macAdress = v:match("%w+:%w+:%w+:%w+:%w+:%w+")
      macStart, macEnd = v:find(macAdress)
      SignalStrength = v:sub(macEnd+2)
      
      saida:write("\t{\n\t\t\"macAddress\": \"")
      
      print(k.." : "..v, "\n")
    end
end
wifi.sta.getap(listap)

table = {
          {MatWiFi02 3,-91,00:1e:e5:75:cc:73,6}
ACB : 4,-81,f4:6d:04:5d:75:bc,11
ICA : 3,-65,f8:1a:67:a4:bc:80,4
CADASTRO Wi-Fi PUC : 0,-82,64:e9:50:11:df:50,11
VDG-Secretaria : 4,-84,50:c7:bf:86:a7:9e,5
Wi-Fi PUC : 0,-81,18:9c:5d:50:2b:81,6
ICA2 : 3,-65,64:70:02:93:e4:44,4
Room649L : 3,-90,50:c7:bf:8c:8b:fe,1
VDG-7 : 3,-87,e8:de:27:66:17:ee,7
LAB_552 : 2,-78,98:fc:11:d0:a8:36,6
HP8784D0 : 0,-84,78:ac:c0:87:84:d0,10
reativos : 3,-54,50:92:b9:09:d1:a2,11
NETGEAR28 : 3,-86,2c:b0:5d:38:74:10,7

        }