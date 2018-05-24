cont = 0
IP = nil
    wificonf = {
      -- verificar ssid e senha
      ssid = "AndroidAP",
      pwd = "asdf1234",
      save = false
    }
    
    wifi.sta.config(wificonf)
    print("modo: ".. wifi.setmode(wifi.STATION))
