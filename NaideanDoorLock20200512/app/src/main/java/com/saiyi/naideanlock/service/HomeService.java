package com.saiyi.naideanlock.service;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.bluetooth.BluetoothDevice;
import android.content.Intent;
import android.os.IBinder;
import android.support.v4.app.NotificationCompat;

import com.saiyi.naideanlock.R;
import com.sandy.guoguo.babylib.utils.DelayHandler;

import java.util.HashSet;
import java.util.List;

public abstract class HomeService extends Service {
    public static HomeService ME = null;
    public HashSet<String> scanDeviceMacAddress;

    public static final int AUTO_STOP_SCAN_MSG_WHAT = 0X15011501;
    protected static final int CUSTOM_CONNECT_TIMEOUT_MSG_WHAT = 0X031801;

    private static final String CHANNEL_ID = "2019";

    public boolean isScanning = false;


    public void clearScanCache(){
        scanDeviceMacAddress.clear();
    }

    @Override
    public void onCreate() {
        super.onCreate();

        scanDeviceMacAddress = new HashSet<>();
        setForeground();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        DelayHandler.getInstance().removeMessages(CUSTOM_CONNECT_TIMEOUT_MSG_WHAT);
        DelayHandler.getInstance().removeMessages(AUTO_STOP_SCAN_MSG_WHAT);
        stopForeground(true);
    }


	protected void setForeground() {
        Notification notification = new NotificationCompat.Builder(this, CHANNEL_ID)
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentTitle(getString(R.string.app_name))
                .setContentText(getString(R.string.app_name))
                .build();

        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            String name = "chan name";
            String description = "chan description";
            int importance = NotificationManager.IMPORTANCE_DEFAULT;

            NotificationChannel channel = new NotificationChannel(CHANNEL_ID, name, importance);
            channel.setDescription(description);

            NotificationManager manager = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
            manager.createNotificationChannel(channel);
        }

        startForeground(R.mipmap.ic_launcher, notification);
	}

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        scanDeviceMacAddress.clear();
        return super.onStartCommand(intent, flags, startId);
    }

    public abstract IBinder getBinder();

    /**
     * 得到连接状态
     */
    public abstract boolean getProfileState(String address);


    /**
     * 连接设备
     */
    public abstract boolean connect(String address);

    /**
     * 断开设备
     */
    public abstract void disConnect(String address);

    /**
     * 得到已连接的蓝牙设备
     */
    public abstract List<BluetoothDevice> getConnectDevices();

    /**
     * 扫描设备
     */
    public abstract void scan(boolean flag);

    /**
     * 写入数据
     */
    public abstract void writeData(byte[] data);


    @Override
    public IBinder onBind(Intent intent) {
        return getBinder();
    }

}
