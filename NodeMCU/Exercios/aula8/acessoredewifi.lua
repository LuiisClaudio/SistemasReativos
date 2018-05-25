wificonf = {
  ssid = "",
  pwd = "",
  save = false
}

wifi.sta.config(wificonf)
print("modo: ".. wifi.setmode(wifi.STATION))
print("IP = "..wifi.sta.getip())
