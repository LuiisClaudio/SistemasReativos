-- print AP list in old format (format not defined)
function listap(t)
    local saida = file.open("aps.txt","w")
    print("{\n\t\"WifiAccessPoints\": [\n")
    
    
    
    for k,v in pairs(t) do
      macAdress = v:match("%w+:%w+:%w+:%w+:%w+:%w+")
      macStart, macEnd = v:find(macAdress)
      channel = v:sub(macEnd+2)
      signalStrength = v:sub(v:find("-"),v:find(",",v:find("-")+1)-1)
      
      print("\t{\n\t\t\"macAddress\": \"", macAdress,"\",\n\t\t\"signalStrength\": ",signalStrength, ",\n\t\t\"channel\": ",channel,"\n\t},")
      
      --print("\nSSID = ", k, "\tmacAdress = ",macAdress,"\tChannel = ",channel,"\tSignalStrength = ",signalStrength,"\n")
      
      --print(k.." : "..v, "\n")
    end
    
    print("]\n}")
end
wifi.sta.getap(listap)
