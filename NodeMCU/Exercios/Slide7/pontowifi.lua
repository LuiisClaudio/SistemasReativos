-- Conexao/criação da rede Wifi
wifi.setmode(wifi.SOFTAP)
wifi.ap.config({ssid="",pwd=""})
wifi.ap.setip({ip="192.168.0.20",netmask="255.255.255.0",gateway="192.168.0.20"})
print(wifi.ap.getip())