cont = 0
IP = nil
    wificonf = {
      -- verificar ssid e senha
      ssid = "Wire",
      pwd = "934ceara",
      save = false
    }
    
    wifi.sta.config(wificonf)
    print("modo: ".. wifi.setmode(wifi.STATION))
