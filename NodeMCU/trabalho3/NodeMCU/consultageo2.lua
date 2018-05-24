http.post('https://www.googleapis.com/geolocation/v1/geolocate?key=AIzaSyC9gT96jbjCxgHLVV4Ng9DiGAaJQJNaZvw',
  'Content-Type: application/json\r\n',saida,
  function(code, data)
    if (code < 0) then
      print("HTTP request failed :", code)
    else
      print(code, data)
    end
  end)

-- print AP list in old format (format not defined)
function listap(t)
    saida ="[[\n"
    saida=saida.."{\n\"WifiAccessPoints\": [\n"
    for k,v in pairs(t) do
      macAdress = v:match("%w+:%w+:%w+:%w+:%w+:%w+")
      macStart, macEnd = v:find(macAdress)
      channel = v:sub(macEnd+2)
      signalStrength = v:sub(v:find("-"),v:find(",",v:find("-")+1)-1)
      
      saida=saida.."\t{\n\t\t\"macAddress\": \"".. macAdress.."\",\n\t\t\"signalStrength\": "..signalStrength.. ",\n\t\t\"channel\": "..channel.."\n\t},\n"
      
      --print("\nSSID = ", k, "\tmacAdress = ",macAdress,"\tChannel = ",channel,"\tSignalStrength = ",signalStrength,"\n")
      
      --print(k.." : "..v, "\n")
    end
    saida=string.sub(saida, 0,-3)
    saida=saida.."\n]\n}\n]]"
    --print(saida)
end
wifi.sta.getap(listap)
