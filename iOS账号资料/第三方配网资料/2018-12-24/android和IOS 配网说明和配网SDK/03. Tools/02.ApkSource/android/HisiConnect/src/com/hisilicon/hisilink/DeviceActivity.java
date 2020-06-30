package com.hisilicon.hisilink;

import java.io.IOException;
import java.io.OutputStream;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.Socket;
import java.net.UnknownHostException;
import java.util.Timer;
import java.util.TimerTask;
import com.hisilicon.hisilinkapi.HisiLibApi;
import android.net.wifi.WifiConfiguration;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.app.ActionBar;
import android.app.Activity;
import android.text.method.HideReturnsTransformationMethod;
import android.text.method.PasswordTransformationMethod;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.EditText;
import android.widget.TextView;

public class DeviceActivity extends Activity {
	private static final String TAG = "DeviceActivity";
	//handler ��Ϣ
    private static final int MSG_ONLINE_RECEIVED = 0;
    private static final int MSG_MULTICAST_TIMEOUT = 1;
    private static final int MSG_AP_RECEIVED_ACK = 2;
    private static final int MSG_CONNECTED_APMODE = 3;
    private static final int MSG_APMODE_TIMEOUT = 4;
    //������Ϣ���շ�ʽ
    private static final int ONLINE_MSG_BY_UDP = 0;
    private static final int ONLINE_MSG_BY_TCP = 1;
    private static final int ONLINE_PORT_BY_UDP = 1131;
    private static final int ONLINE_PORT_BY_TCP = 0x3516;
    //��ʱʱ��
    private static final int TIMER_MULTICAST_TIMEOUT = 60000;//45s
    private static final int TIMER_APMODE_TIMEOUT = 60000;//120s
    private int counterTime = 0;
    private long buttonPressTime = -1;
    private long APModeStartTime = -1;
    private WiFiAdmin mWiFiAdmin = null;
	private MessageSend mMessageSend = null;
	private int udpPort = 0;
	private String strName = null;
	private String SSID = null;
	private String onlineMessage = null;
	private int homeWifiID = -1;

	private Socket TCPSocket = null;
	private OutputStream outputStream=null;

	private boolean isBroadcastListening = true;
	private TextView errorHint = null;
	private Timer multicastTimer = null;
	private Timer APModeTimer = null;
	private Button buttonConnectAP = null;
	private Button buttonConnectMulti = null;
	private OnlineReciever onlineReciever = null;
	private EditText textPass;

    static {
        System.loadLibrary("HisiLink");
    }

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_device);
		ActionBar actionBar = getActionBar();
		//actionBar.setIcon(new ColorDrawable(getResources().getColor(android.R.color.transparent)));

		//���MainActivity���ݹ������豸��
		Bundle bundle = this.getIntent().getExtras();
		strName = bundle.getString("devicename");
        if (null != strName)
		    actionBar.setTitle(strName);
		SSID = bundle.getString("SSID");
		//������Ϣ
		constructOnlineMessage();
		TextView textSSID = (TextView)findViewById(R.id.textSSID);
		errorHint = (TextView)findViewById(R.id.errorhint);
		textPass = (EditText)findViewById(R.id.inputPass);
		buttonConnectAP = (Button)findViewById(R.id.connect_ap);
		buttonConnectMulti = (Button)findViewById(R.id.connect_multi);
		CheckBox checkBoxPassword = (CheckBox)findViewById(R.id.checkPassword);
		checkBoxPassword.setOnCheckedChangeListener(new OnCheckedChangeListener() {
			@Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if(isChecked){
                    //���ѡ�У���ʾ����      
                	textPass.setTransformationMethod(HideReturnsTransformationMethod.getInstance());
                	textPass.setSelection(textPass.getText().length());
                }else{
                    //������������
                	textPass.setTransformationMethod(PasswordTransformationMethod.getInstance());
                	textPass.setSelection(textPass.getText().length());
                }
            }
        });
		//ȡ���ֻ�������WiFi��SSID
		mWiFiAdmin = new WiFiAdmin(DeviceActivity.this);
		textSSID.setText(mWiFiAdmin.getWifiSSID());
	}

	@Override
	public void onDestroy() {
		if ((null != mWiFiAdmin)&&(null != SSID))
			mWiFiAdmin.forgetWifi(SSID);
		Log.d(TAG, "onDestroy");
		super.onDestroy();
	}

	public void onClick_Event_AP(View view){
		buttonConnectAP.setText("��������");
		buttonConnectAP.setClickable(false);
		buttonConnectMulti.setClickable(false);
		TCPSocket = null;
		APModeStartTime = System.currentTimeMillis();
		APModeTimer=new Timer();
		TimerTask APModetimeoutTask =new TimerTask() {
	        @Override
	        public void run() {
	            Message msg = handler.obtainMessage();
	            msg.what = MSG_APMODE_TIMEOUT;
	            handler.sendMessage(msg);
	        }
	    };
		//����һ��75s�Ķ�ʱ������ʱ�����û�
		APModeTimer.schedule(APModetimeoutTask, TIMER_APMODE_TIMEOUT);

		//TBD:����ֵ�쳣ʱ�Ĵ���
		HisiLibApi.setNetworkInfo(mWiFiAdmin.getSecurity(), ONLINE_PORT_BY_UDP, ONLINE_MSG_BY_UDP,
				mWiFiAdmin.getWifiIPAdress(), mWiFiAdmin.getWifiSSID(), textPass.getText().toString(),
				this.strName);
		//�����豸AP������Ϣ
		WifiConfiguration mWifiConfig = new WifiConfiguration();
		mWifiConfig = constructWifiConfig(SSID);

		//����·����AP ID������Ҫ����
		homeWifiID = mWiFiAdmin.getNetWorkId();
		//�Ͽ�·����AP�������豸AP
		mWiFiAdmin.disConnectionWifi(homeWifiID);
		mWiFiAdmin.addNetWork(mWifiConfig);

		//����TCP����
		TCPConnectThread connectThread = new TCPConnectThread();
		Log.d(TAG, "connectThread start");
		connectThread.start();
	}
	
	public void onClick_Event_Multi(View view){
		buttonConnectMulti.setText("��������");
		buttonConnectMulti.setClickable(false);
		buttonConnectAP.setClickable(false);
		buttonPressTime = System.currentTimeMillis();
		//�ٴε��ʱ������·���ʾ��Ϣ
		errorHint.setText("");
		//����һ��45s�Ķ�ʱ������ʱ��ʾ������Ϣ��
		multicastTimer=new Timer();
		TimerTask timeoutTask =new TimerTask() {
	        @Override
	        public void run() {
	            Message msg = handler.obtainMessage();
	            msg.what = MSG_MULTICAST_TIMEOUT;
	            handler.sendMessage(msg);
	        }
	    };
		multicastTimer.schedule(timeoutTask, TIMER_MULTICAST_TIMEOUT);

		//TBD:����ֵ�쳣ʱ�Ĵ���
		HisiLibApi.setNetworkInfo(mWiFiAdmin.getSecurity(), ONLINE_PORT_BY_TCP, ONLINE_MSG_BY_TCP,
				mWiFiAdmin.getWifiIPAdress(), mWiFiAdmin.getWifiSSID(), textPass.getText().toString(),
				this.strName);

		//�����߳�����������Ϣ
		recieveOnlineMessage();
		//���ͱ���
		sendMessage();
	}
	
	public void constructOnlineMessage(){
		byte []onlineMessageArray = new byte[13];
		onlineMessageArray[0] = 'o';
		onlineMessageArray[1] = 'n';
		onlineMessageArray[2] = 'l';
		onlineMessageArray[3] = 'i';
		onlineMessageArray[4] = 'n';
		onlineMessageArray[5] = 'e';
		onlineMessageArray[6] = ':';
		int []macArray = new int[6];
		char []ssidArray = SSID.toCharArray();
		for(int i = 0; i < 6; ++i){
			macArray[i] = charToInt(ssidArray[12+2*i])*16+charToInt(ssidArray[12+2*i+1]);
		}
		for(int i = 0; i <6; ++i)
		{
			onlineMessageArray[7+i] = (byte)macArray[i];
		}
		onlineMessage = new String(onlineMessageArray,0,13);
	}
	
	public int sendMessage(){
		//�����̷߳����鲥��Ϣ
		mMessageSend = new MessageSend(DeviceActivity.this);
		mMessageSend.multiCastThread();
		return 0;
	}
	
	public void recieveOnlineMessage(){
		onlineReciever = new OnlineReciever(new OnlineReciever.onOnlineRecievedListener() {
	        @Override
	        public void onOnlineReceived(String message) {
	        	if(onlineMessage.equals(message))
	        	{
	                Message msg = handler.obtainMessage();
	                msg.what = MSG_ONLINE_RECEIVED;
	                handler.sendMessage(msg);
	        	}
	        }
	    });
		onlineReciever.start();
	}
	
	public int charToInt(char input){
		int ret;
		if('A' <= input){
			ret = input - 'A' + 10;
		}else{
			ret = input -'0';
		}
		return ret;
	}
	private final Handler handler = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);

            switch(msg.what){
            case MSG_ONLINE_RECEIVED:
                long onlineRecieveTime = System.currentTimeMillis();
                long castTime = onlineRecieveTime -buttonPressTime;
            	//ֹͣ����������Ϣ
            	onlineReciever.stop();
            	//ֹͣ�㲥
            	mMessageSend.stopMultiCast();
            	multicastTimer.cancel();
            	buttonConnectMulti.setText("���ӳɹ�");
            	errorHint.setText("��ϲ�����Կ��ֵ���ˣ�ˣ�\n"+"��ʱ"+castTime+"ms!\n"+"������ȫ��99.9%���û���\n"+"buttonPressTime="+buttonPressTime+" onlineRecieveTime="+ onlineRecieveTime);
            	break;
            case MSG_MULTICAST_TIMEOUT:
            	//ֹͣ����������Ϣ
            	onlineReciever.stop();
            	//ֹͣ�㲥
            	mMessageSend.stopMultiCast();
            	buttonConnectMulti.setText("�鲥ģʽ����");
            	buttonConnectMulti.setClickable(true);
            	buttonConnectAP.setClickable(true);
            	errorHint.setText("����ʧ�ܣ���ȷ���������ݣ�\n"+"1. �ֻ��ѹ�������WiFi��\n"+"2. �����������ȷ��\n"+"3. ����·����������2.4Gģʽ�¡�\n"+"�����Ժ���Ȼʧ�ܣ��볢�Ե��APģʽ����");
            	break;
            	//AP�յ�������Ϣ
            case MSG_AP_RECEIVED_ACK:
            	Log.d(TAG,"MSG_AP_RECEIVED_ACK recieved");
            	//���¹���·����AP
            	connectHomeAP();
            	udpPort = msg.arg1;
        		//����UDP����
        		BroadcastListenThread broadcastListenThread = new BroadcastListenThread();
        		broadcastListenThread.start();
            	break;
            case MSG_CONNECTED_APMODE:
            	APModeTimer.cancel();
            	long connectedTime = System.currentTimeMillis();
                long castTime2 = connectedTime-APModeStartTime;
            	buttonConnectAP.setText("���ӳɹ�");
            	errorHint.setText("��ϲ�����Կ��ֵ���ˣ�ˣ�\n"+"��ʱ"+castTime2+"ms!\n"+"������ȫ��99.9%���û���\n"+"APModeStartTime="+APModeStartTime+" connectedTime="+connectedTime);
            	break;
            case MSG_APMODE_TIMEOUT:
            	//���¹���·����AP
        		if ((null != mWiFiAdmin)&&(null != SSID))
        			mWiFiAdmin.forgetWifi(SSID);
            	connectHomeAP();
            	buttonConnectAP.setText("APģʽ����");
            	buttonConnectAP.setClickable(true);
            	buttonConnectMulti.setClickable(true);
            	errorHint.setText("����ʧ�ܣ���ȷ���������ݣ������ԣ�\n"+"1. �ֻ��ѹ�������WiFi��\n"+"2. �����������ȷ��\n"+"3. ����·����������2.4Gģʽ�¡�");
            	break;
            default:
            	break;
            }
        }
	};

	public void connectHomeAP(){
		
		//�Ͽ��豸AP������·����AP
		Log.d(TAG,"connect home wifi");
		mWiFiAdmin.enableNetWork(homeWifiID);
		//ȷ��wifi�Ѿ�������
		while(!mWiFiAdmin.isWifiConnected())
		{
			try {
				Thread.sleep(100);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
	}
	class BroadcastListenThread extends Thread{
		public void run(){
			while(isBroadcastListening){
				try {
			        // �������շ����׽���,���ƶ��˿ں�
			        DatagramSocket getSocket = new DatagramSocket(udpPort);
			        // ȷ�����ݱ����ܵ����ݵ������С  
			        byte[] buf = new byte[1024];  
			        // �����������͵����ݱ������ݽ��洢��buf��  
			        DatagramPacket getPacket = new DatagramPacket(buf, buf.length);  
			        // ͨ���׽��ֽ�������  
			        getSocket.receive(getPacket);  
			        // �������ͷ����ݵ���Ϣ
			        String getMes = new String(buf, 0, getPacket.getLength());
		        	if(getMes.equals(onlineMessage))
		        	{
		        		Log.d(TAG,"onlineMessage recieved ");
		        		isBroadcastListening = false;
		                Message msg = handler.obtainMessage();
		                msg.what = MSG_CONNECTED_APMODE;
		                handler.sendMessage(msg);
		        	}
		        	if (!getSocket.isClosed())
		        		getSocket.close();
				} 
				catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
	}


	
	class TCPConnectThread extends Thread{

		public TCPConnectThread()
		{
		}
		
		public void run(){
			byte []buffer = HisiLibApi.getMessageToSend();
			//ȷ��WiFi�Ѿ�������
			while(!mWiFiAdmin.isWifiConnected())
			{
				try {
					counterTime++;
					if (counterTime >= 20)
					{
						mWiFiAdmin.reconnect();
						counterTime = 0;
					}
					Thread.sleep(100);
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
			}
			Log.d(TAG,"Wifi connected");
			if (0 == connect()){
				sendMessage(buffer);
			}
		}
	}
	
	public int connect(){
		try {
			//����Ѿ��������ˣ��Ͳ���ִ�����ӳ���
			if (null == TCPSocket) {
				//��InetAddress������ȡip��ַ
				String wifiGWAdress = mWiFiAdmin.getWifiGWAdress();
				InetAddress ipAddress = InetAddress.getByName(wifiGWAdress);
				TCPSocket = new Socket(ipAddress, 5000);
				outputStream = TCPSocket.getOutputStream();
				TCPSocket.getInputStream();
			}
			if (null == TCPSocket){
                Log.e(TAG, "connet fail. socket == null");
                return -1;
			}
			return 0;
		} catch (UnknownHostException e1) {
			Log.e(TAG,"UnknownHostException error");
			e1.printStackTrace();
        	return -1;
		} catch (IOException e1) {
			Log.e(TAG,"IOException error");
			e1.printStackTrace();
			return -1;
		}
	}

	public void sendMessage(byte []buffer){
        try {
            if(TCPSocket==null || !TCPSocket.isConnected()){
                Log.d(TAG, "SOCKET ERROR");
                return;
            }

		    outputStream.write(buffer);
			outputStream.flush();
			outputStream.close();
			outputStream = null;
            if(TCPSocket!=null && !TCPSocket.isClosed()){
            	TCPSocket.close();
            	TCPSocket=null;
            }
			//ȷ��wifi�Ѿ�ȥ����
			while(mWiFiAdmin.isWifiConnected())
			{
				try {
					Thread.sleep(50);
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
			}
			mWiFiAdmin.forgetWifi(SSID);
			Log.d(TAG,"Wifi disconnect");

			Message msg = handler.obtainMessage();
		    msg.what = MSG_AP_RECEIVED_ACK;
		    msg.arg1 = ONLINE_PORT_BY_UDP;//udp port
		    handler.sendMessage(msg);
        } catch (IOException e) {
            e.printStackTrace();
        }
	}
	
	public WifiConfiguration constructWifiConfig(String ssid){
		String passwordString;

		passwordString = HisiLibApi.getPassword(ssid);
		
		WifiConfiguration mWifiConfig;
		mWifiConfig = mWiFiAdmin.createWifiInfo(ssid, passwordString, 3);
		return mWifiConfig;
	}
}
