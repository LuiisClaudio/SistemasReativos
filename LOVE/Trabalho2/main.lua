local frame_width, frame_height = love.graphics.getDimensions( )
local tubo_cenario = {}
local tipo_de_tubo = {}
local tempo_atual = 0
local date_table = os.date("*t")
local minutos, segundos = date_table.min, date_table.sec
local dificuldade = 5

function love.load()
  math.randomseed(os.time()) 
  letra = love.graphics.newFont("fonts/SuperMario256.TTF", 18)

 --Decide se o jogo vai estar perdido
  gameOver = false

  -- imagens usada no jogo
  jogador_sing_img = love.graphics.newImage("imgs/jogador_sing.png")
  tube_high1 = love.graphics.newImage("imgs/tube1.png")
  tube_high2 = love.graphics.newImage("imgs/tube1_80.png")
  tube_high3 = love.graphics.newImage("imgs/tube1_60.png")
  tube_high4 = love.graphics.newImage("imgs/tube1_40.png")
  tube_low1 = love.graphics.newImage("imgs/tube2.png")
  tube_low2 = love.graphics.newImage("imgs/tube2_80.png")
  tube_low3 = love.graphics.newImage("imgs/tube2_60.png")
  tube_low4 = love.graphics.newImage("imgs/tube2_40.png")
  coin_img = love.graphics.newImage("imgs/coin.png")
  background = love.graphics.newImage("imgs/bg.png")
  ground = love.graphics.newImage("imgs/ground.png")

  --lista de tubos dos jogos
  tipo_de_tubo[1] = tube_high1
  tipo_de_tubo[2] = tube_high2
  tipo_de_tubo[3] = tube_high3
  tipo_de_tubo[4] = tube_high4
  tipo_de_tubo[5] = tube_low1
  tipo_de_tubo[6] = tube_low2
  tipo_de_tubo[7] = tube_low3
  tipo_de_tubo[8] = tube_low4

  -- cria jogador
  jogador = novo_jogador() 

  --Decide se o jogo vai estar pausado
  pause = true 

end

function love.update(dt)
	if not pause then
		local dis = -1
		local x_jogador, x_width_jogador, y_jogador, y_height_jogador = jogador.pos()
		local aux = 1
		
		
		date_table = os.date("*t")
		local minute, second = date_table.min, date_table.sec
		
		tempo_atual = tempo_atual + dt

		
		-- game over se nao tem mais vida
		if y_jogador == jogador.chao then
			gameOver = true
		end
		
		--jogador extrapolou os limites do cenario
		if jogador.bateu_algo == true then
			gameOver = true
			--overSong:play()
		end
	
			if jogador.vidas == 0 then
			gameOver = true
		end

		if math.abs(segundos - second) == aux then
			cria_novos_tubos()
			--aux = aux + 1
		elseif testa_lista_vazia(tubo_cenario) then
			cria_novos_tubos()
		else
			update_list_objetos(dt, tubo_cenario, dis)
		end
		
		-- se o usuario aperto space, faz o jogador pular
		if love.keyboard.isDown('space') then
			jogador.y_velocidade = jogador.altura_do_pulo
		end

		jogador.update(dt)

		-- para cada objeto, verifica se jogador colidiu com o mesmo
		testa_colisao(tubo_cenario)
	end
	if gameOver then
		controle_de_pausa()
	end
end

function love.draw()
	if gameOver == false then
		for i = 0, love.graphics.getWidth() / background:getWidth() do
			for j = 0, love.graphics.getHeight() / background:getHeight() do
				love.graphics.draw(background, i * background:getWidth(), j * background:getHeight())
			end
		end
		
		--love.graphics.setBackgroundColor(0,0,1, 100)
  

		-- Desenha os tubos
		for i in ipairs(tubo_cenario) do
			tubo_cenario[i].draw()
		end

		-- Desenha o jogador
		jogador.draw()
    
  
		love.graphics.setFont(letra)
		--love.graphics.setColor(1, 0, 0, 100)
		love.graphics.print("Pontuacao: "..jogador.pontos)
		
		for i = 0, love.graphics.getWidth() / ground:getWidth() do
			for j = 0, love.graphics.getHeight() / ground:getHeight() do
				love.graphics.draw(ground, i * ground:getWidth(), love.graphics.getHeight() - ground:getHeight() + 100)
			end
		end

	else 
		-- Mostra tela de game over
  		love.graphics.setBackgroundColor(1, 0, 0, 1)
  		love.graphics.print("Game Over", frame_width/2 - 100, frame_height/2)	
      love.graphics.print("Pontuacao: "..jogador.pontos)
	end
end

--Pausa o jogo
function controle_de_pausa () 
	pause = true
	if love.keyboard.isDown("q") then
		love.event.quit()
	end
end

-- criacao dos tubos
function cria_novos_tubos()
	local i = #tubo_cenario
	date_table = os.date("*t")
	segundos = date_table.sec
	local numero_sorteado1 = math.random(1,4)
	local numero_sorteado2 = math.random(5,8)

	local random_tubo1 = tipo_de_tubo[numero_sorteado1]
	local random_tubo2 = tipo_de_tubo[numero_sorteado2]
	
	tubo_cenario[i+1] = novo_tubo(random_tubo1, numero_sorteado1, i+1)
	tubo_cenario[i+2] = novo_tubo(random_tubo2, numero_sorteado2, i+2)
	
end

-- função que verifica se jogador colidiu com algum objeto
function testa_colisao(list)
	for i, objeto in ipairs(list) do
		if objeto then
			local posx, posy_high, posy_low = objeto.pos()
				if jogador.bateu(posx, posy_high, posy_low) then
					table.remove(list, i)
					gameOver = true
				end
		end
	end
end

-- chama update de objetos que já podem ser atualziados
function update_list_objetos (dt, list, dis)
	for i in ipairs(list) do	
		if not list[i].wait_objeto then
			list[i]:update(dt, i, dis*dificuldade)
		elseif (tempo_atual >= list[i].wait_objeto) then
			list[i].wait_objeto = nil
			list[i]:update(dt, i, dis*dificuldade)
		end
	end	
end


function testa_lista_vazia(lst)
	if next(lst) == nil then
   		return true
	end
	return false
end

function novo_jogador()
  local x, width, height = 200, jogador_sing_img:getWidth(), jogador_sing_img:getHeight()
  --local y = frame_height-(height+3)
  local y = frame_height - (frame_height/2) - (height/2)

  return {
  pontos = 0,
  vidas = 1,
  bateu_algo = false,
  chao = frame_height ,
  y_velocidade = 100,
  altura_do_pulo = -250,
  gravidade = -1000,
  
 
  draw = function () 
    love.graphics.draw(jogador_sing_img, x, y)
  end,
  update = function (dt)
  	if jogador.y_velocidade ~= 0 then
  		y = y + jogador.y_velocidade * dt          
		jogador.y_velocidade = jogador.y_velocidade - jogador.gravidade * dt 
	end
	  

	-- se ele colidiu com o "teto", seta a posicao y no teto
	if y < 0 then
		jogador.bateu_algo = true
		--y = jogador.chao
		y_velocidade = 0
		y = 5
		
	end
	
		-- se ele colidiu com o "chao", seta a posicao y no teto
    if y > jogador.chao then
		jogador.bateu_algo = true
		y = jogador.chao
		--y = 3
	end
	
  end,
  pos = function () 
  	return x, x+width, y, y+height
  end,
  
  
  -- Testa se passaro bateu em algo
  bateu = function (posx, posy_high, posy_low) 
  	if posx>x and posx<x+width and y + (height/2) > posy_high and y - (height/2)< posy_low then
  		return true
  	else
  		return false
  	end
  end
}
end


function novo_tubo(img, tipo_objeto, i) 
	local x, width, height = frame_width, img:getWidth(), img:getHeight()
	local y = 0
	
	--if i >= 3 and i <= 4 then
	--	x = x + x/2
	--elseif i >= 5 and i <= 6 then
	--	x = x + x
	--end
	
	--Set a altura do tubo
	if tipo_objeto == 1 then
		y = -40
	elseif tipo_objeto >= 2 and tipo_objeto <=4 then
		y = 0
	elseif tipo_objeto > 4 then
		y = jogador.chao - height
	end
	
	return 
	{
		wait_objeto = nil,
		draw = function()
			love.graphics.draw(img, x, y)
		end,
		update = coroutine.wrap ( function (self, dt, index, dis)
			while true do
				x = x + dis
				if (x < 0) then
					if procura_valor_na_lista(tubo_cenario, self) then
						table.remove(tubo_cenario, index)
						jogador.pontos = jogador.pontos + 0.5
					end
				end
				_, _, index, dis = wait(1/1000, self)
			end
		end),
		pos = function ()
			return x+(width/2), y , y + height
		end
	}
end


function wait(temp, objeto)
	objeto.wait_objeto = tempo_atual + temp
	return coroutine.yield()
end



-- Teste de tecla para uma certa acao
function love.keyreleased( key )
	if key == "up" and dificuldade < 5 then
		dificuldade = dificuldade + 1
	elseif key == "down" and dificuldade > 1 then
		dificuldade = dificuldade - 1
	elseif key == "p" then
		pause = not pause
	end
	if key == "space" and pause == true then
		pause = not pause
	end
end


function procura_valor_na_lista(tabela, valor)
	for i, v in ipairs(tabela) do
        if v == valor then
            return true
        end
    end
    return false
end



