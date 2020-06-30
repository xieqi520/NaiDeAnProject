package com.hisilicon.hisilink;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.Manifest;
import android.content.pm.PackageManager;
import android.net.wifi.ScanResult;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import android.app.ActionBar;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.view.Menu;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.Toast;

public class MainActivity extends Activity {
	private WiFiAdmin mWiFiAdmin;
	private ListView lvDevices = null;
	private Map<String, String> companyIdMap = null;
	private Map<String, String> deviceTypeMap = null;
    private static final int REQUEST_CODE_ACCESS_COARSE_LOCATION = 1;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		ActionBar actionBar = getActionBar();  
		actionBar.hide();
		mWiFiAdmin = new WiFiAdmin(MainActivity.this);
		if ((!mWiFiAdmin.isWifiEnabled()) || (0 > mWiFiAdmin.getNetWorkId())){
			warningDialog();
		}
		initCompanyIdMap();
		initDeviceTypeMap();
		requestAccessLocationPermission();
	}

	public void requestAccessLocationPermission()
	{
		//��� API level �Ǵ��ڵ��� 23(Android 6.0) ʱ
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
			//�ж��Ƿ����Ȩ��
			if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
				//�ж��Ƿ���Ҫ���û�����Ϊʲô��Ҫ�����Ȩ��
				if (ActivityCompat.shouldShowRequestPermissionRationale(this,Manifest.permission.ACCESS_COARSE_LOCATION)) {
					Toast toast = Toast.makeText(getApplicationContext(), "��Android 6.0��ʼ��Ҫ��λ��Ȩ�޲ſ����������豸", Toast.LENGTH_SHORT);
				}
				//����Ȩ��
				ActivityCompat.requestPermissions(this,new String[]{Manifest.permission.ACCESS_COARSE_LOCATION},REQUEST_CODE_ACCESS_COARSE_LOCATION);
			}
		}
	}

	public void checkAccessLocation()
	{
	    //Android 6.0�汾���ϣ��迪����λ���񣬲��ܻ�ȡɨ����
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M){
			// ��ȡ��λ����״̬
			int locationMode;
			try {
                locationMode = Settings.Secure.getInt(getContentResolver(), Settings.Secure.LOCATION_MODE);
            } catch (Settings.SettingNotFoundException e) {
                e.printStackTrace();
                locationMode = Settings.Secure.LOCATION_MODE_OFF;
            }
			if (locationMode == Settings.Secure.LOCATION_MODE_OFF)
			{
				//�����λ����δ�򿪣�Android�Ի���
				AlertDialog.Builder builder = new AlertDialog.Builder(MainActivity.this);//�����Ի���
				builder.setTitle("Android6.0 ���ϰ汾��򿪶�λ���񣬲���ɨ���豸"); //���ñ���
				builder.setMessage("�Ƿ�ǰ�����ã�"); //��������
				builder.setIcon(android.R.drawable.ic_menu_info_details); //����ͼ��
				builder.setCancelable(false);
				builder.setPositiveButton("��", new DialogInterface.OnClickListener() {
				    @Override
				    public void onClick(DialogInterface dialogInterface, int i) {
				    	startActivity(new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS));
				    }
				});//���ð�ť������ʵ��
				builder.setNegativeButton("��", new DialogInterface.OnClickListener() {
				    @Override
				    public void onClick(DialogInterface dialogInterface, int i) {
				    	finish();
				    }
				});//���ð�ť������ʵ��
				builder.show(); //��ʾ�Ի���
			}
		}
	}
    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        if (requestCode == REQUEST_CODE_ACCESS_COARSE_LOCATION) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                //���������Ȩ������Ĵ���
            } else {
                //�������Ȩ�ޱ��ܾ��Ĵ���
				finish();
            }
        } else {
            super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        }
    }

	public void initCompanyIdMap()
	{	
		//����ID map���ʼ��
		companyIdMap= new HashMap<String, String>();
		companyIdMap.put("001", "��˼");
		companyIdMap.put("002", "��Ϊ");
		companyIdMap.put("003", "hi1131s");
		companyIdMap.put("004", "С��");
		//to be continue
	}
	
	public void initDeviceTypeMap()
	{
		//�豸���� map���ʼ��
		deviceTypeMap= new HashMap<String, String>();
		deviceTypeMap.put("001", "������");
		deviceTypeMap.put("002", "��������");
		deviceTypeMap.put("003", "�˶�DV");
		deviceTypeMap.put("004", "���˻�");
		//to be continue
	}
	
	public void warningDialog(){
		// Android�Ի���
		AlertDialog.Builder builder = new AlertDialog.Builder(MainActivity.this);//�����Ի���
		builder.setTitle("���Wifi����������ͥ����"); //���ñ���
		builder.setMessage("�Ƿ�ǰ�����ã�"); //��������
		builder.setIcon(android.R.drawable.ic_menu_info_details); //����ͼ��
		builder.setCancelable(false);
		builder.setPositiveButton("��", new DialogInterface.OnClickListener() {
		    @Override
		    public void onClick(DialogInterface dialogInterface, int i) {
		    	startActivity(new Intent(Settings.ACTION_WIFI_SETTINGS));
		    }
		});//���ð�ť������ʵ��
		builder.setNegativeButton("��", new DialogInterface.OnClickListener() {
		    @Override
		    public void onClick(DialogInterface dialogInterface, int i) {
		    	finish();
		    }
		});//���ð�ť������ʵ��
		builder.show(); //��ʾ�Ի���
	}
	
	//Ѱ�Ҹ�ʽ��������SSIDҪ����豸���ҵ����ؽ�������豸�������򷵻�null
	//Hisi_XYYYZZZUUUUUUUUUUUU
	public String findDeviceBySsid(String ssid){
		String retStr = null;
		if((ssid.length()>=24) && (ssid.startsWith("Hisi_"))){
			//X����汾�ţ�Ӧ�ý���1��9֮��
			if((ssid.charAt(5) < '1')||(ssid.charAt(5) > '9'))
				return null;
			//YYY����������ID��Ŀǰ002����Ϊ��˼�����������̴�׷�ӡ�
			if (companyIdMap.containsKey(ssid.substring(6, 9))){
				retStr = companyIdMap.get(ssid.substring(6, 9));
			}
			else{
				return null;
			}
			
			//ZZZ�����豸����
			if (deviceTypeMap.containsKey(ssid.substring(9, 12))){
				retStr += deviceTypeMap.get(ssid.substring(9, 12));
			}
			else{
				return null;
			}
			
			//MAC��ַ����λ
			retStr += ssid.substring(20, 24);
		}
		return retStr;
	}
	
	public void onClick_Event(View view) {
		List<ScanResult> mWiFiList;
		final List<String> deviceList = new ArrayList<String>();
		final List<String> ssidList = new ArrayList<String>();
		
		lvDevices = (ListView)findViewById(R.id.deviceslist);

		checkAccessLocation();
		try {
			mWiFiAdmin.startScan();
			Thread.sleep(50);
			mWiFiList = mWiFiAdmin.getWifiList();
			String []str = new String[mWiFiList.size()];
			for(int i = 0; i < mWiFiList.size(); ++i){
				str[i] = findDeviceBySsid(mWiFiList.get(i).SSID);
				if((null != str[i])&&(!deviceList.contains(str[i]))){
					deviceList.add(str[i]);
					ssidList.add(mWiFiList.get(i).SSID);
				}
			}
		} catch (InterruptedException e) {
			e.printStackTrace();
		}

		if(deviceList.size() != 0){
			lvDevices.setAdapter(new ArrayAdapter<String>(this,
	                android.R.layout.simple_list_item_1, deviceList));
			lvDevices.setOnItemClickListener(new OnItemClickListener(){
				public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
	                    long arg3) {
					Intent intent = new Intent(MainActivity.this, DeviceActivity.class);
					Bundle bundle=new Bundle();
					bundle.putString("devicename", deviceList.get(arg2));
					bundle.putString("SSID", ssidList.get(arg2));
					intent.putExtras(bundle);
                    startActivity(intent);
				}
			});
		}

		if(0 == deviceList.size())
		{
			setContentView(R.layout.activity_main);
			Toast toast = Toast.makeText(getApplicationContext(), "û�м������豸����ȷ��", Toast.LENGTH_SHORT);
			toast.show(); 
		}
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}

}
