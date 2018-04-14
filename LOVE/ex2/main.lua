function newblip (vel)
  local x, y = 0, 0
  return {
  
    tempo_anterior = 0,
    tempo_wait = 0,
    morto = false,
    
    update = coroutine.wrap (function (self)
      local width, height = love.graphics.getDimensions( )
      while true do
        x = x+3
        if x > width then
        -- volta para a esquerda da janela
          x = 0
        end
        wait(vel/150, self)
      end
    end),
  
    affected = function (pos)
      if pos>x and pos<x+10 then
      -- "pegou" o blip
        return true
      else
        return false
      end
    end,
    draw = function ()
      love.graphics.rectangle("line", x, y, 10, 10)
    end
  }
end

function wait(segundos, blip)
  
  blip.morto = true
  blip.tempo_wait = segundos
  coroutine.yield()
  
end

function newplayer ()
  local x, y = 0, 200
  local width, height = love.graphics.getDimensions( )
  return {
  try = function ()
    return x
  end,
  update = function (dt)
    x = x + 0.5
    if x > width then
      x = 0
    end
  end,
  draw = function ()
    love.graphics.rectangle("line", x, y, 30, 10)
  end
  }
end


function love.keypressed(key)
  if key == 'a' then
    pos = player.try()
    for i in ipairs(listabls) do
      local hit = listabls[i].affected(pos)
      if hit then
        table.remove(listabls, i) -- esse blip "morre" 
        return -- assumo que apenas um blip morre
      end
    end
  end
end


function love.load()
  player =  newplayer()
  listabls = {}
  for i = 1, 5 do
    listabls[i] = newblip(i)
  end
end


function love.draw()
  player.draw()
  for i = 1,#listabls do
    listabls[i].draw()
  end  
end

function love.update(dt)
  tempo = love.timer.getTime()
  player.update(dt)
  
  for i = 1,#listabls do
    
    if (tempo - listabls[i].tempo_anterior) >=  listabls[i].tempo_wait then
      listabls[i].morto = false  
      listabls[i].tempo_anterior = tempo
    end
    
    if listabls[i].morto == false then
      listabls[i]:update()
    end
    
  end  
  
end
  