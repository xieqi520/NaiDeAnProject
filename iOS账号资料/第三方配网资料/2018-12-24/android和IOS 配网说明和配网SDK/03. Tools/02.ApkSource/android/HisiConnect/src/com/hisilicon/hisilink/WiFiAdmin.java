package com.hisilicon.hisilink;

import java.util.List;
import java.util.Locale;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.wifi.ScanResult;
import android.net.wifi.WifiConfiguration;
import android.net.wifi.WifiConfiguration.KeyMgmt;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.util.Log;

public class WiFiAdmin {
    static final int SECURITY_NONE = 0;  
    static final int SECURITY_WEP = 1;  
    static final int SECURITY_PSK = 2;  
    static final int SECURITY_EAP = 3; 
    static final int SECURITY_ERR = 4; 
	//����һ��WifiManager����
	private WifiManager mWifiManager;
	//����һ��WifiInfo����
	private WifiInfo mWifiInfo;
	//ɨ��������������б�
    private List<ScanResult> mWifiList;
    private List<WifiConfiguration> mWifiConfigurations;
    private ConnectivityManager mConnectivityManager;
    private static final String TAG = "WifiAdmin";
    public WiFiAdmin(Context context){
        //ȡ��WifiManager����
        mWifiManager=(WifiManager) context.getSystemService(Context.WIFI_SERVICE);
        //ȡ��WifiInfo����  
        mWifiInfo=mWifiManager.getConnectionInfo();
        //�õ����úõ���������  
        mWifiConfigurations=mWifiManager.getConfiguredNetworks();
        mConnectivityManager = (ConnectivityManager)context.getSystemService(Context.CONNECTIVITY_SERVICE);
    }
    
    public void startScan(){
        mWifiManager.startScan();
        //�õ�ɨ����
        mWifiList=mWifiManager.getScanResults();
    }
    
    public boolean isWifiEnabled(){
    	return mWifiManager.isWifiEnabled();
    }
    
    //�õ������б�  
    public List<ScanResult> getWifiList(){  
        return mWifiList;
    }
    
    //�õ��ֻ�������wifi��SSID
    public String getWifiSSID(){
    	mWifiInfo=mWifiManager.getConnectionInfo();
    	String str = (mWifiInfo==null)?"NULL":mWifiInfo.getSSID();
    	//ȥ��ssidǰ���˫����
        str = str.substring(1,str.length()-1);
        return str;
    }
    
    //�õ��ֻ�������wifi��ip��ַ
    public int getWifiIPAdress(){
    	mWifiInfo=mWifiManager.getConnectionInfo();
        return (mWifiInfo==null)?0:mWifiInfo.getIpAddress();
    }

    //�õ��ֻ�������wifi��Ĭ������
    public String getWifiGWAdress(){
    	mWifiInfo=mWifiManager.getConnectionInfo();
    	int ipAddress = (mWifiInfo==null) ? 0 : mWifiInfo.getIpAddress();
        return String.format(Locale.getDefault(), "%d.%d.%d.1",
                (ipAddress & 0xff), (ipAddress >> 8 & 0xff),
                (ipAddress >> 16 & 0xff));
    }

    //�õ�������wifi�ļ��ܷ�ʽ
    public int getSecurity() {
    	for (WifiConfiguration mWifiConfiguration : mWifiConfigurations) {
    		//��ǰ���ӵ�SSID
    		String mCurrentSSID = getWifiSSID();
    		
    		//���ù���SSID
            String mConfigSSid = mWifiConfiguration.SSID;
            //ȥ��ssidǰ���˫����
            mConfigSSid = mConfigSSid.substring(1,mConfigSSid.length()-1);
            
          //�Ƚ�networkId����ֹ�������籣����ͬ��SSID
            if (mCurrentSSID.equals(mConfigSSid)&&mWifiInfo.getNetworkId()==mWifiConfiguration.networkId) {
                if (mWifiConfiguration.allowedKeyManagement.get(KeyMgmt.WPA_PSK)) {
                    return SECURITY_PSK;  
                }
                if (mWifiConfiguration.allowedKeyManagement.get(KeyMgmt.WPA_EAP) || mWifiConfiguration.allowedKeyManagement.get(KeyMgmt.IEEE8021X)) {  
                    return SECURITY_EAP;  
                }
                return (mWifiConfiguration.wepKeys[0] != null) ? SECURITY_WEP : SECURITY_NONE;  
            }
    	}
    	//error: ����SSID�б���δ�ҵ���ǰ����
		return SECURITY_ERR;
    }
    
    //���һ�����粢����  
    public void addNetWork(WifiConfiguration configuration){  
        int wcgId=mWifiManager.addNetwork(configuration);  
        mWifiManager.enableNetwork(wcgId, true);
        mWifiManager.reconnect();
        //mWifiManager.saveConfiguration();
    }
    //��������  
    public void reconnect(){  
    	mWifiManager.reconnect();
    }
    //enable ����
    public void enableNetWork(int wcgId){
        mWifiManager.enableNetwork(wcgId, true);
    }

    public boolean isWifiConnected()
    {
        boolean flag = false;
        if (null != mConnectivityManager) {
            NetworkInfo nif = mConnectivityManager.getActiveNetworkInfo();
            if (null != nif && nif.isConnected()) {
                if (nif.getState() == NetworkInfo.State.CONNECTED) {
                    flag = true;
                }
            }
        }
        return flag;
    }
    
    //�õ����ӵ�ID  
    public int getNetWorkId(){  
        return (mWifiInfo==null)?-1:mWifiInfo.getNetworkId();  
    }
    
    //�Ͽ�ָ��ID������  
    public void disConnectionWifi(int netId){
        mWifiManager.disableNetwork(netId);
        mWifiManager.disconnect();
    }

    private WifiConfiguration IsExsits(String SSID) {
        List<WifiConfiguration> existingConfigs = mWifiManager.getConfiguredNetworks();
        if (existingConfigs == null)
            return null;
        for (WifiConfiguration existingConfig : existingConfigs) {
            if (existingConfig.SSID!=null && existingConfig.SSID.equals("\"" + SSID + "\"")) {
                return existingConfig;
            }
        }
        return null;
    }

    //�Ͽ���ɾ��ָ��ID������  
    public void forgetWifi(String SSID){
        WifiConfiguration tempConfig = this.IsExsits(SSID);
        if (tempConfig != null) {
        	Log.d(TAG,"tempConfig.networkId="+tempConfig.networkId);
            mWifiManager.removeNetwork(tempConfig.networkId);
            //mWifiManager.saveConfiguration();
        }
    }

    //����SSID ���� ���ܷ�ʽ��������
    public WifiConfiguration createWifiInfo(String SSID, String Password, int Type){
    	WifiConfiguration config = new WifiConfiguration();
    	config.allowedAuthAlgorithms.clear();
        config.allowedGroupCiphers.clear();
        config.allowedKeyManagement.clear();
        config.allowedPairwiseCiphers.clear();
        config.allowedProtocols.clear();
        config.SSID = "\"" + SSID + "\"";

        if(Type == 1) //WIFICIPHER_NOPASS
        {
        	config.hiddenSSID = true;
        	config.allowedKeyManagement.set(WifiConfiguration.KeyMgmt.NONE);
        }

        if(Type == 2) //WIFICIPHER_WEP
        {
        	config.hiddenSSID = true;
        	config.wepKeys[0]= "\""+Password+"\"";
        	config.allowedAuthAlgorithms.set(WifiConfiguration.AuthAlgorithm.SHARED);
        	config.allowedGroupCiphers.set(WifiConfiguration.GroupCipher.CCMP);
        	config.allowedGroupCiphers.set(WifiConfiguration.GroupCipher.TKIP);
        	config.allowedGroupCiphers.set(WifiConfiguration.GroupCipher.WEP40);
        	config.allowedGroupCiphers.set(WifiConfiguration.GroupCipher.WEP104);
        	config.allowedKeyManagement.set(WifiConfiguration.KeyMgmt.NONE);
        	config.wepTxKeyIndex = 0;
        }
        if(Type == 3) //WIFICIPHER_WPA
        {
        	config.preSharedKey = "\""+Password+"\"";     
        	config.hiddenSSID = true;       
        	config.allowedAuthAlgorithms.set(WifiConfiguration.AuthAlgorithm.OPEN);
        	config.allowedGroupCiphers.set(WifiConfiguration.GroupCipher.TKIP);
        	config.allowedKeyManagement.set(WifiConfiguration.KeyMgmt.WPA_PSK);
        	config.allowedPairwiseCiphers.set(WifiConfiguration.PairwiseCipher.TKIP);
        	config.allowedGroupCiphers.set(WifiConfiguration.GroupCipher.CCMP);
        	config.allowedPairwiseCiphers.set(WifiConfiguration.PairwiseCipher.CCMP);
        	config.status = WifiConfiguration.Status.ENABLED;
        }
        return config;
    }     
}
