package com.hisilicon.hisilinkapi;

public class HisiLibApi {
	//��network��Ϣ���ø�hisi_lib_api
	static public native int setNetworkInfo(int security, int port, int onlineProtocal, int ipAdress, String ssid, String password, String deviceName);
	//��ȡ���ͱ���
	static public native byte []getMessageToSend();
	//��ȡ�豸AP����
	static public native String getPassword(String ssid);
	//�鲥ģʽ���ķ������
	static public native int startMulticast();
	//ֹͣ�鲥����
	static public native int stopMulticast();
}