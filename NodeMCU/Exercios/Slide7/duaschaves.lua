led1 = 3
led2 = 6
sw1 = 1
sw2 = 2
but1 = 0
but2 = 0
timerstate=1
ledstate = false
agilidade = 1.0;
aux_sw1 = 0;
aux_sw2 = 0;
pin_state = false

quantum = 1000

local meusleds = {led1, led2}

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

gpio.mode(sw1,gpio.INT,gpio.PULLUP)
gpio.mode(sw2,gpio.INT,gpio.PULLUP)




--callback da interrupção
local function newpincb (level, timestamp)
    --checa se os botoes foram pressionados
    if pin_state then
        gpio.write(led1, gpio.LOW);     
        return
    end

    ledstate =  not ledstate
    if ledstate then  
        gpio.write(led1, gpio.HIGH);
    else
    gpio.write(led1, gpio.LOW);
    end
end

    --acelera callback
local function agilidadeupcb()
    aux_sw1 = tmr.now();
    if (aux_sw1 - aux_sw2 < quantum) then
        pin_state = true
    end

    agilidade = agilidade * 2.0;
    tempo:stop();
    tempo:register(quantum/agilidade, tmr.ALARM_AUTO, newpincb );
    tempo:start();
end

    --desacelera callback/
local function agilidadedowncb()
    aux_sw2 = tmr.now();
    if (aux_sw1 - aux_sw2 < quantum) then
        pin_state = true
    end

    agilidade = agilidade / 2.0;
    tempo:stop();
    tempo:register(quantum/agilidade, tmr.ALARM_AUTO, newpincb );
    tempo:start();
end

--registrar tratamento para botão
gpio.trig(sw1, "down", agilidadeupcb)
gpio.trig(sw2, "down", agilidadedowncb)

tempo = tmr.create()
tempo:register(quantum/agilidade, tmr.ALARM_AUTO, newpincb );
tempo:start()