
led1 = 3
led2 = 6
alarme1 = 1
alarme2 = 2
speed = 1000
led2State = 0
but1 = 0
but2 = 0
timerstate=1
local meusleds = {led1, led2}

local button1 = 1
local led1 = 3
local antigo = 0
ultimo = 0

string_localizacao = "vazio"
local meuid = "meuidreativo"
local m = mqtt.Client("clientid " .. meuid, 120)


function usaGoogleApi()

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
      print("END LISTAAP")
      print("------------------")
      --print(saida)
      print("------------------")


      http.post('https://www.googleapis.com/geolocation/v1/geolocate?key=AIzaSyC9gT96jbjCxgHLVV4Ng9DiGAaJQJNaZvw',
  'Content-Type: application/json\r\n',saida,
  function(code, data)
    if (code < 0) then
      print("HTTP request failed :", code)
    else
      print(code, data)
        print("data = ",data)
    end

      print("HTTP_POST_data = ",data)

      if (data == nil) then
        data = "\"location\":{\"lat\": -22.9767944,  \"lng\": -43.2375936 }, \"accuracy\": 1317.0";
      end

      latitude_comeco,latitude_final = string.find(data,"lat")
      longitude_comeco,longitude_final = string.find(data,"lng")
      acc_inicio,acc_final = string.find(data,"accuracy")
    
      string_localizacao = string.sub(data,latitude_final+4,longitude_comeco-5) .. ";" .. string.sub(data,longitude_final+4,acc_inicio-5)  
      
      print("stringLocalização = ",string_localizacao)
      
      --publica(c,"[Teste de mensagem: "..string_localizacao.." ]")
      m:publish("localizacao",string_localizacao,0,0, function(client) print("UsaGoogleApi over") end)
    end)

       
  end
  wifi.sta.getap(listap)

  

end

print("MeuId = ",meuid)
print("M = ", m)

function publica(c, botao)
  c:publish("ApertouA", botao,0,0, function(client) print("mandouMensagem!") end)
end

function novaInscricao (c)
  print("start novaInscrição");  

  local msgsrec = 0
  function novamsg (c, t, m)
    print("start NovaMsg");
  
    print ("mensagem ",msgsrec,", topico: ",t,", dados: ",m)
    msgsrec = msgsrec + 1
    print("Latitude e Longitude")
    usaGoogleApi()
    --print(string_localizacao)
    --publica(cliente,"Latitude e Longitude")
    --publica(c,"[Teste de mensagem: "..string_localizacao.." ]")

    print("end NovaMsg");
  end

  c:on("message", novamsg)
  print("end novaInscrição");  
end

function conectado (client)
 print("function conectado OIOIOI");
 publica(client, meuid)
 cliente=client
 cliente:subscribe("pede_localizacao_api", 0, novaInscricao)
 print("end function conectado")
end 


m:connect("test.mosquitto.org", 1883, 0, 
             conectado,
             function(client, reason) print("failed reason: "..reason) end)



function mqttcb(topic, message)
   print("Received from topic: " .. topic .. " - message:" .. message)
  local str = {}
  local i=1
  string.gsub(message,"{(.-)}", function (a) str[i]=a i=i+1 end)
end





for _,ledi in ipairs (meusleds) do
  gpio.mode(ledi, gpio.OUTPUT)
end

for _,ledi in ipairs (meusleds) do
  gpio.write(ledi, gpio.LOW);
end

gpio.mode(led1, gpio.OUTPUT)
gpio.mode(led2, gpio.OUTPUT)

gpio.write(led1, gpio.LOW);
gpio.write(led2, gpio.LOW);

gpio.mode(alarme1,gpio.INT,gpio.PULLUP)
gpio.mode(alarme2,gpio.INT,gpio.PULLUP)



function apertou_botao_old(tempo)
  if tempo >= antigo + 1000000 then
      antigo = time
      wifi.sta.getap(listap)
      usaGoogleApi()
  end
end



gpio.mode(alarme1,gpio.INT,gpio.PULLUP)
gpio.mode(alarme2,gpio.INT,gpio.PULLUP)

function apertou_botao (alarme)
  agora = tmr.now()
  if agora - ultimo < 1000000 then
    return "Nao passou o intervalo"
  end
  ultimo = agora
  usaGoogleApi()
end
gpio.trig(alarme1, "down", apertou_botao)
gpio.trig(alarme2, "down", apertou_botao)
