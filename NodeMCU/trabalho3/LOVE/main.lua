local mqtt = require("mqtt_library")
--local socket = require("socket")
mensagem_exibida= "Sem requerimento do nodeMCU"
j=0

function mqttcb(topic, message)
   print("Topico : " .. topic .. " - Mensagem:" .. message.." click: ".. j)
   mensagem_exibida ="Topico : " .. topic .. " - Mensagem:" .. message.." click: ".. j
   j=j+1
   local str = {}
   local i=1
   string.gsub(message,"{(.-)}", function (a) str[i]=a i=i+1 end)
end

function love.keypressed(key)
  local mx, my=love.mouse.getPosition()
  if(key == 'a') then
    mqtt_client:publish("pede_localizacao_api", "localizacao_requerida")
  end
end

function love.load()
  width, height = love.graphics.getDimensions( )
  controle = true
  mqtt_client = mqtt.client.create("test.mosquitto.org", 1883, mqttcb)
  mqtt_client:connect("meuidreativo")
  mqtt_client:subscribe({"ApertouA"})
  mqtt_client:subscribe({"localizacao"})
end


function love.draw()
   love.graphics.print(mensagem_exibida, 18, height/2)
end

function love.update(dt)
  mqtt_client:handler()
end
  