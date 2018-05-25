-- voltar ao retangulo1:
-- •em love.keypressed, enviar evento para um canal do servidor mosquitto teste, contendo (tecla, x, y) 
--     •inscrever-se nesse mesmo canal 
--     •programar a reação à tecla na callback
--     •depois que estiver funcionando, criar segundo programa löve que faz a mesma coisa!




--Luis Claudio e Lucas 

local mqtt = require("mqtt_library")
function retangulo (x,y,w,h)
  local X, Y, rx, ry, rw, rh = x, y, x, y, w, h
  local function naimagem (mx, my, x, y) 
    return (mx>x) and (mx<x+w) and (my>y) and (my<y+h)
  end
  return{
    draw=
      function()
        local mx, my=love.mouse.getPosition()
        if naimagem(mx,my,rx,ry) then
          love.graphics.setColor( 1, 1, 0, 255 )
        else
          love.graphics.setColor( 1, 255, 1, 255 )          
        end
        love.graphics.rectangle("line",rx,ry,rw,rh)
      end,
    
    keypressed =
      function (key)
          local mx, my=love.mouse.getPosition()
          if key == 'b' and naimagem (mx,my, rx, ry) then
             ry = Y
             rx = X
          end
          if key == "down" and naimagem (mx,my, rx, ry) then
            ry = ry + 15
          end
          if key == "right" and naimagem (mx,my, rx, ry) then
            rx = rx + 15
          end
          if key == "up" and naimagem (mx,my, rx, ry) then
            ry = ry - 15
          end
          if key == "left" and naimagem (mx,my, rx, ry) then
            rx = rx - 15
          end
      end
    }
end

function mqttcb(topic, message)
   print("Received from topic: " .. topic .. " - message:" .. message)
   local str = {}
   local i=1
   string.gsub(message,"{(.-)}", function (a) str[i]=a i=i+1 end)
   retan.keypressed(str[1])
end

function love.keypressed(key)
  local mx, my=love.mouse.getPosition()
  if key == 'a' then
    mqtt_client:publish("apertou-tecla", "{"..key.."}".."{"..mx.."}".."{"..my.."}")
  end
end

function love.load()

  controle = true
  mqtt_client = mqtt.client.create("test.mosquitto.org", 1883, mqttcb)
  mqtt_client:connect("meuid")
  retan = retangulo (20,20,200,150) 
end


function love.draw()
   if controle then
     retan.draw()
   end
end

function love.update(dt)
  mqtt_client:handler()
end
  