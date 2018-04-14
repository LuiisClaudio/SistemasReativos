function retangulo (x,y,w,h)
  local originalx, originaly, rx, ry, rw, rh = x, y, x, y, w, h
  return {
    draw = 
      function ()
        love.graphics.rectangle("line", rx, ry, rw, rh)
      end,
    keypressed = 
      function ()
        local mx, my = love.mouse.getPosition() 
        if key == 'b' and naimagem (mx,my, rx, ry, rw, rh) then
          ry = 200
        end
        if love.keyboard.isDown("down")   and naimagem(mx, my, rx, ry, rw, rh)  then
          ry = ry + 10
        end
        if love.keyboard.isDown("right")   and naimagem(mx, my, rx, ry, rw, rh)  then
          rx = rx + 10
        end
      end
  }
end


function love.load()
  ret_table = {
    retangulo(50, 100, 100, 100),
    retangulo(100, 240, 100, 100),
    retangulo(180, 380, 100, 100),
    retangulo(230, 450, 100, 100)
    }
end

function naimagem (mx, my, x, y, w, h) 
  return (mx>x) and (mx<x+w) and (my>y) and (my<y+h)
end

function love.keypressed(key)
  
  for i = 1, #ret_table do
    ret_table[i].keypressed(key)
  end
  
end

function love.update (dt)
  local mx, my = love.mouse.getPosition() 
end

function love.draw ()
  for i = 1, #ret_table do
    ret_table[i].draw()
  end
end

