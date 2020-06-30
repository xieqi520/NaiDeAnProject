配网支持二维码配网和Hilink配网

二维码格式为{"ssid":"zmg1994","password":"123456"}
Hilink 请参照海思提供的demo和SDK     

注意：
HisiLibApi.setNetworkInfo(2, ONLINE_PORT_BY_TCP, ONLINE_MSG_BY_TCP,
						97392812, mConnectedSsid, Password,
						"1688");

注意最后一个参数 必须填入 "1688" ,否则设备无法识别配网