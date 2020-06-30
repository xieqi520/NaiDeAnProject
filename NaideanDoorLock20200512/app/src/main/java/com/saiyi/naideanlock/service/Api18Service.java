package com.saiyi.naideanlock.service;

import android.annotation.TargetApi;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothGatt;
import android.bluetooth.BluetoothGattCallback;
import android.bluetooth.BluetoothGattCharacteristic;
import android.bluetooth.BluetoothGattDescriptor;
import android.bluetooth.BluetoothGattService;
import android.bluetooth.BluetoothManager;
import android.bluetooth.BluetoothProfile;
import android.bluetooth.le.ScanCallback;
import android.bluetooth.le.ScanResult;
import android.bluetooth.le.ScanSettings;
import android.content.Intent;
import android.os.Binder;
import android.os.Build;
import android.os.IBinder;
import android.os.Message;
import android.text.TextUtils;

import com.saiyi.naideanlock.bean.MdlScanNewDevice;
import com.saiyi.naideanlock.constant.PublicConstant;
import com.saiyi.naideanlock.constant.UUIDConstant;
import com.saiyi.naideanlock.enums.BLEDeviceStatus;
import com.saiyi.naideanlock.utils.BLEDeviceCmd;
import com.saiyi.naideanlock.utils.MyUtility;
import com.sandy.guoguo.babylib.utils.DelayHandler;
import com.sandy.guoguo.babylib.utils.LogAndToastUtil;
import com.sandy.guoguo.babylib.utils.Utility;
import com.sandy.guoguo.babylib.utils.eventbus.EventBusManager;
import com.sandy.guoguo.babylib.utils.eventbus.MdlEventBus;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

@TargetApi(Build.VERSION_CODES.LOLLIPOP)
public class Api18Service extends HomeService {
    private BluetoothAdapter mBluetoothAdapter;
    private BluetoothManager mBluetoothManager;

    private BluetoothGatt mBluetoothGatt = null;
    private BluetoothGattCharacteristic mCanWriteDataCharacteristic = null;

    private Object newScanCallback = null;

    public static final String SCAN_NAME_PREFIX = "BT_";

    @Override
    public void onCreate() {
        super.onCreate();
        ME = this;
        init();
//		setForeground();

        LogAndToastUtil.log("service onCreate....");

    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        LogAndToastUtil.log("service onStartCommand....");
        EventBusManager.post(new MdlEventBus(BLEDeviceStatus.REGISTER_OK));

        flags = START_FLAG_REDELIVERY;
        return super.onStartCommand(intent, flags, startId);
    }

    protected void init() {
        mBluetoothManager = (BluetoothManager) getSystemService(BLUETOOTH_SERVICE);
        mBluetoothAdapter = mBluetoothManager.getAdapter();
    }

    @Override
    public void onDestroy() {
        ME = null;
        stopForeground(true);
        destroyGatt();
        super.onDestroy();
    }

    private void destroyGatt(){
        if(mBluetoothGatt != null){
            mBluetoothGatt.disconnect();
            mBluetoothGatt.close();
        }
    }

    private void refreshGatt(BluetoothGatt gatt){
        try{
            Method method = gatt.getClass().getDeclaredMethod("refresh");
            method.invoke(gatt);
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    private final IBinder binder = new LocalBinder();

    public class LocalBinder extends Binder {
        public Api18Service getService() {
            return Api18Service.this;
        }
    }

    @Override
    public IBinder getBinder() {
        return binder;
    }

    private final BluetoothGattCallback mGattCallback = new BluetoothGattCallback() {
        @Override
        public void onConnectionStateChange(BluetoothGatt gatt, int status, int newState) {
            LogAndToastUtil.log("回调onConnectionStateChange->status:%s;newState:%s", status, newState);


            DelayHandler.getInstance().removeMessages(CUSTOM_CONNECT_TIMEOUT_MSG_WHAT);
            if (newState == BluetoothProfile.STATE_CONNECTED) {

                Utility.ThreadSleep(200);
                searchService(gatt);
            } else  {
                LogAndToastUtil.log("连接断开...");
                gatt.close();
                mBluetoothGatt = null;
                EventBusManager.post(new MdlEventBus(BLEDeviceStatus.DISCONNECTED, gatt.getDevice()));

                scanDeviceMacAddress.remove(gatt.getDevice().getAddress());
            }
        }

        @Override
        public void onServicesDiscovered(final BluetoothGatt gatt, int status) {
            LogAndToastUtil.log("回调onServicesDiscovered()->status:%s", status);
            if (status == BluetoothGatt.GATT_SUCCESS) {
                List<BluetoothGattService> list = gatt.getServices();
                for (BluetoothGattService service : list) {
                    LogAndToastUtil.log("-------服务:%s", service.getUuid().toString());
                    for (BluetoothGattCharacteristic charc : service.getCharacteristics()) {
                        LogAndToastUtil.log("-------特征:%s", charc.getUuid().toString());
                    }
                    LogAndToastUtil.log("--------------------------------------------------");
                }
                discoverServiceOk(gatt);
            }
        }

        @Override
        public void onCharacteristicChanged(BluetoothGatt gatt, BluetoothGattCharacteristic characteristic) {
            LogAndToastUtil.log("回调通知onCharacteristicChanged()->uuid:%s;value:%s", characteristic.getUuid().toString(), Utility.byteArray2HexString(characteristic.getValue()));
            handleNotify(gatt, characteristic);

        }

        @Override
        public void onCharacteristicWrite(BluetoothGatt gatt, BluetoothGattCharacteristic characteristic, int status) {
            LogAndToastUtil.log("回调onCharacteristicWrite()->uuid:%s;value:%s", characteristic.getUuid().toString(), Utility.byteArray2HexString(characteristic.getValue()));
        }

        @Override
        public void onCharacteristicRead(BluetoothGatt gatt, BluetoothGattCharacteristic characteristic, int status) {
        }
    };

    private void discoverServiceOk(final BluetoothGatt gatt) {
        DelayHandler.getInstance().post(new Runnable() {
            @Override
            public void run() {
                openBLENotification(gatt);

                Utility.ThreadSleep(300);
                writeData(BLEDeviceCmd.bondDevice());

                EventBusManager.post(new MdlEventBus(BLEDeviceStatus.CONNECTED, gatt.getDevice()));
            }
        });
    }

    private void handleNotify(final BluetoothGatt gatt, final BluetoothGattCharacteristic characteristic) {
        final byte[] data = characteristic.getValue();
        if (MyUtility.byte2Uint8(data[0]) == 0x5A && MyUtility.byte2Uint8(data[1]) == 0xA5){
            DelayHandler.getInstance().post(new Runnable() {
                @Override
                public void run() {
//                    MdlNotifyData notifyData = new MdlNotifyData();
//                    notifyData.data = data;
//                    notifyData.mac = gatt.getDevice().getAddress();
//                    EventBusManager.post(new MdlEventBus(BLEDeviceStatus.DEVICE_NOTIFY_DATA, notifyData));
                    BLEDeviceCmd.handleDevice2AppData(data);
                }
            });
        }
    }


    @Override
    public boolean getProfileState(String mac) {
        String address = covertMac(mac);
        BluetoothDevice mDevice = getBLEObjOnMacAddress(address);
        int connectionState = mBluetoothManager.getConnectionState(mDevice, BluetoothProfile.GATT);
        boolean flag = connectionState == BluetoothProfile.STATE_CONNECTED;
		if (flag)
			LogAndToastUtil.log("getProfileState检测->设备已连接上！->:%s", address);
		else
			LogAndToastUtil.log("getProfileState检测->设备未连接！->:%s", address);
        return flag;
    }

    private void searchService(final BluetoothGatt gatt) {
        new Thread() {
            public void run() {
                gatt.discoverServices();
            }
        }.start();
    }

    @SuppressWarnings("deprecation")
    @Override
    public synchronized void scan(boolean flag) {
        if (flag == isScanning) {
            return;
        }

        isScanning = flag;

        if (flag) {
            Message msg = DelayHandler.getInstance().obtainMessage();
            msg.what = AUTO_STOP_SCAN_MSG_WHAT;
            msg.obj = new Runnable() {
                @Override
                public void run() {
                    stopScanBLEDevice();
                    EventBusManager.post(new MdlEventBus(BLEDeviceStatus.AUTO_STOP_SCAN));
                    isScanning = false;
                }
            };
            DelayHandler.getInstance().sendMessageDelayed(msg, PublicConstant.SCAN_BLE_TIME);

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                if(newScanCallback == null){
                    newScanCallback = new ScanCallback() {
                        @Override
                        public void onScanResult(int callbackType, ScanResult result) {
                            LogAndToastUtil.log("android5.0及以上搜索结果：%s", result.toString());

                            handleSearchResult(result.getDevice(), result.getRssi(), result.getScanRecord().getBytes());
                        }

                        @Override
                        public void onBatchScanResults(List<ScanResult> results) {
                            LogAndToastUtil.log("外围设备->onBatchScanResults:", results.toString());
                        }

                        @Override
                        public void onScanFailed(int errorCode) {
                            LogAndToastUtil.log("外围设备->onScanFailed:", errorCode);
                        }
                    };
                }
                ScanSettings.Builder builder = new  ScanSettings.Builder();
                builder.setScanMode(ScanSettings.SCAN_MODE_LOW_LATENCY);

                mBluetoothAdapter.getBluetoothLeScanner().startScan(null, builder.build(),(ScanCallback) newScanCallback);
            } else {
                mBluetoothAdapter.startLeScan(mLeScanCallback);
            }

            LogAndToastUtil.log("扫描设备...");
        } else {
            DelayHandler.getInstance().removeMessages(AUTO_STOP_SCAN_MSG_WHAT);
            EventBusManager.post(new MdlEventBus(BLEDeviceStatus.STOP_SCAN));
            stopScanBLEDevice();
            LogAndToastUtil.log("停止扫描...");
        }

    }

    @SuppressWarnings("deprecation")
    private void stopScanBLEDevice() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            if(newScanCallback != null){
                mBluetoothAdapter.getBluetoothLeScanner().stopScan((ScanCallback) newScanCallback);
            }
        } else {
            mBluetoothAdapter.stopLeScan(mLeScanCallback);
        }
    }


    private BluetoothAdapter.LeScanCallback mLeScanCallback = new BluetoothAdapter.LeScanCallback() {

        @Override
        public void onLeScan(BluetoothDevice device, int rssi, byte[] scanRecord) {
            handleSearchResult(device, rssi, scanRecord);

        }
    };

    private void handleSearchResult(BluetoothDevice device, int rssi, byte[] scanRecord) {
        LogAndToastUtil.log("外围设备->mac地址:%s;名称:%s", device.getAddress(), device.getName());
        String deviceName = device.getName() == null ? "" : device.getName();
        if (!scanDeviceMacAddress.contains(device.getAddress()) && deviceName.startsWith(SCAN_NAME_PREFIX)) {
            scanDeviceMacAddress.add(device.getAddress());
            EventBusManager.post(new MdlEventBus(BLEDeviceStatus.SCAN_NEW_DEVICE, new MdlScanNewDevice(device, rssi, scanRecord)));
        }
    }

    private String covertMac(String mac) {
        if (mac.contains(":")) return mac;
        StringBuffer stringBuffer = new StringBuffer();
        String part = "";
        for (int i = 0; i < mac.length()/2; i++) {
            if (i != 0) {
                stringBuffer.append(":");
            }
            part = mac.substring(i*2,i*2+2);
            stringBuffer.append(part);
        }
        return stringBuffer.toString();
    }

    @Override
    public boolean connect(final String mac) {
        String address = covertMac(mac);
        if (mBluetoothAdapter == null || TextUtils.isEmpty(address)) {
            return false;
        }

        MyUtility.otherOperationNeedStopScan();

        final BluetoothDevice device = mBluetoothAdapter.getRemoteDevice(address);
        int connectionState = mBluetoothManager.getConnectionState(device, BluetoothProfile.GATT);

        if (device == null) {
            return false;
        }

        if (connectionState == BluetoothProfile.STATE_DISCONNECTED) {
            if (mBluetoothGatt != null  && address.equals(mBluetoothGatt.getDevice().getAddress())) {
                if(mBluetoothGatt.getDevice().equals(device)){
                    if (mBluetoothGatt.connect()) {
                        LogAndToastUtil.log("GATT re-connect success.:%s",device.getAddress());
                        return true;
                    } else {
                        LogAndToastUtil.log("GATT re-connect failed.:%s",device.getAddress());
                        return false;
                    }
                } else {
                    if(mBluetoothManager.getConnectionState(mBluetoothGatt.getDevice(), BluetoothProfile.GATT) == BluetoothProfile.STATE_CONNECTED){
                        mBluetoothGatt.disconnect();
                    }
                    mBluetoothGatt = device.connectGatt(this, false, mGattCallback);
                }
            } else {
                mBluetoothGatt = device.connectGatt(this, false, mGattCallback);
            }

            Message msg = DelayHandler.getInstance().obtainMessage();
            msg.what = CUSTOM_CONNECT_TIMEOUT_MSG_WHAT;
            msg.obj = new Runnable() {
                @Override
                public void run() {
                    EventBusManager.post(new MdlEventBus(BLEDeviceStatus.CUSTOM_CONNECT_TIMEOUT, device));
                }
            };
            DelayHandler.getInstance().sendMessageDelayed(msg, PublicConstant.CUSTOM_CONNECT_TIMEOUT);
        } else {
            LogAndToastUtil.log("Attempt to connect in state: " + connectionState);
            return false;
        }

        return true;
    }


    @Override
    public void disConnect(String mac) {
        String address = covertMac(mac);
        LogAndToastUtil.log("执行断开..");
        final BluetoothDevice device = mBluetoothAdapter.getRemoteDevice(address);
        int connectionState = mBluetoothManager.getConnectionState(device, BluetoothProfile.GATT);

        if (mBluetoothGatt != null) {
            if (connectionState == BluetoothProfile.STATE_CONNECTED) {
                refreshGatt(mBluetoothGatt);
                mBluetoothGatt.disconnect();
            } else {
                EventBusManager.post(new MdlEventBus(BLEDeviceStatus.DISCONNECTED, device));
            }
        } else {
            EventBusManager.post(new MdlEventBus(BLEDeviceStatus.DISCONNECTED, device));
        }
    }


    public void openBLENotification(BluetoothGatt gatt) {
        BluetoothGattService service = gatt.getService(UUIDConstant.SERVICE_UUID);

        BluetoothGattCharacteristic canWriteDataCharacteristic = service.getCharacteristic(UUIDConstant.CAN_WRITE_UUID);

        /* 打开通知*/
        BluetoothGattCharacteristic configCharacteristic = service.getCharacteristic(UUIDConstant.NOTIFY_CHARACTERISTIC_UUID);
        if(configCharacteristic == null){
            LogAndToastUtil.log("特征%s不存在。", UUIDConstant.NOTIFY_CHARACTERISTIC_UUID);
        } else {
            gatt.setCharacteristicNotification(configCharacteristic, true);
            BluetoothGattDescriptor configDescriptor = configCharacteristic.getDescriptor(UUIDConstant.NOTIFY_DESCRIPTOR_UUID);
            if (configDescriptor != null) {
                configDescriptor.setValue(BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE);
                gatt.writeDescriptor(configDescriptor);
                LogAndToastUtil.log("已打开%s，现在可以进行数据传输了。", UUIDConstant.NOTIFY_DESCRIPTOR_UUID);
            } else {
                LogAndToastUtil.log("%s为空", UUIDConstant.NOTIFY_CHARACTERISTIC_UUID);
            }
        }

        mBluetoothGatt = gatt;
        mCanWriteDataCharacteristic = canWriteDataCharacteristic;

        MyUtility.otherOperationNeedStopScan();
    }


    private BluetoothDevice getBLEObjOnMacAddress(String mac) {
        String address = covertMac(mac);
        if(mBluetoothGatt != null && mBluetoothGatt.getDevice().getAddress().equalsIgnoreCase(address)){
            return mBluetoothGatt.getDevice();
        }
        return mBluetoothAdapter.getRemoteDevice(address);
    }

    @Override
    public List<BluetoothDevice> getConnectDevices() {
        ArrayList<BluetoothDevice>  list = new ArrayList<>(mBluetoothManager.getConnectedDevices(BluetoothProfile.GATT));
        if(list.size() > 0){
            Iterator<BluetoothDevice> ite = list.iterator();
            while (ite.hasNext()){
                BluetoothDevice device = ite.next();
                String deviceName = device.getName() == null ? "" : device.getName();
                if(TextUtils.isEmpty(device.getName()) || !deviceName.startsWith(SCAN_NAME_PREFIX)){
                    ite.remove();
                }
            }
        }
        return list;
    }

    @Override
    public void writeData(byte[] data) {
        if (mBluetoothGatt != null && mCanWriteDataCharacteristic != null) {
            mCanWriteDataCharacteristic.setValue(data);
            boolean flag = mBluetoothGatt.writeCharacteristic(mCanWriteDataCharacteristic);
            LogAndToastUtil.log("写的初始化：%s data:%s", flag, Utility.byteArray2HexString(data));
        } else {
            LogAndToastUtil.log("writeData为空");
        }
    }

}
