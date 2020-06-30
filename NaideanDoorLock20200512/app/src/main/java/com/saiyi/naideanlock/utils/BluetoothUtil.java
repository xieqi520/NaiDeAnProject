package com.saiyi.naideanlock.utils;

import android.content.Context;
import android.util.Log;

import com.inuker.bluetooth.library.BluetoothClient;
import com.inuker.bluetooth.library.connect.listener.BleConnectStatusListener;
import com.inuker.bluetooth.library.connect.listener.BluetoothStateListener;
import com.inuker.bluetooth.library.connect.options.BleConnectOptions;
import com.inuker.bluetooth.library.connect.response.BleConnectResponse;
import com.inuker.bluetooth.library.connect.response.BleNotifyResponse;
import com.inuker.bluetooth.library.connect.response.BleReadResponse;
import com.inuker.bluetooth.library.connect.response.BleWriteResponse;
import com.inuker.bluetooth.library.model.BleGattProfile;
import com.inuker.bluetooth.library.receiver.listener.BluetoothBondListener;
import com.inuker.bluetooth.library.search.SearchRequest;
import com.inuker.bluetooth.library.search.SearchResult;
import com.inuker.bluetooth.library.search.response.SearchResponse;
import com.saiyi.naideanlock.bean.BleAddressBean;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * 描述：蓝牙
 * 创建作者：ask
 * 创建时间：2017/10/28 12:02
 */

public class BluetoothUtil {

    private static BluetoothUtil instance;

    private static BluetoothClient mClient;//蓝牙的客户端

    private List<BleAddressBean> bleAddressList;//扫描蓝牙地址类

    private ConnectBleListener mConnectBleListener;//蓝牙连接结果回调

    private BleNotifyListener mBleNotifyListener;//蓝牙发送通知结果回调

    private BleWriteListener mBleWriteListener;//蓝牙写入数据结果回调

    private BleReadListener mBleReadListener;//蓝牙读取数据结果回调

    private BleConnectCaseListener mBleConnectCaseListener;//蓝牙连接状态回调

    public BluetoothUtil() {

    }

    public static synchronized BluetoothUtil getInstance(Context context) {
        if (instance == null) {
            instance = new BluetoothUtil();
        }

        if (mClient == null) {
            mClient = new BluetoothClient(context);
        }

        return instance;
    }

    public static synchronized BluetoothClient getBluetoothClient(Context context) {
        if (mClient == null) {
            mClient = new BluetoothClient(context);
        }
        return mClient;
    }


    /**
     * 判断蓝牙是否打开
     *
     * @return
     */
    public boolean isBlueToothOpened() {
        return mClient.isBluetoothOpened();
    }

    /**
     * 打开蓝牙设备
     */
    public void openBlueTooth() {
        mClient.openBluetooth();
    }


    /**
     * 连接蓝牙时的重试次数  连接超时  和发现服务超时设置
     *
     * @return
     */
    public BleConnectOptions getBleConnectOptions() {
        BleConnectOptions options = new BleConnectOptions.Builder()
                .setConnectRetry(3)   // 连接如果失败重试3次
                .setConnectTimeout(30000)   // 连接超时30s
                .setServiceDiscoverRetry(3)  // 发现服务如果失败重试3次
                .setServiceDiscoverTimeout(20000)  // 发现服务超时20s
                .build();
        return options;
    }

    /**
     * 蓝牙扫描设置
     *
     * @return
     */
    public SearchRequest getSearchRequest() {
        SearchRequest request = new SearchRequest.Builder()
                .searchBluetoothLeDevice(3000, 3)    //先扫BLE设备3次，每次3s
                .searchBluetoothClassicDevice(5000) // 再扫经典蓝牙5s
                .searchBluetoothLeDevice(2000)      // 再扫BLE设备2s
                .build();
        return request;
    }

    /**
     * 获取蓝牙扫描结果
     *
     * @return
     */
    public List<BleAddressBean> getSearchResult() {
        if (!isBlueToothOpened()) { //蓝牙没打开 就先打开蓝牙
            openBlueTooth();
        }
        bleAddressList = new ArrayList<>();

        if (mClient == null) {
            return null;
        }

        mClient.search(getSearchRequest(), new SearchResponse() {
            @Override
            public void onSearchStarted() {
                Log.e("ble", "开始扫描蓝牙");
            }

            @Override
            public void onDeviceFounded(SearchResult device) {
                Log.e("ble", "发现设备");
                BleAddressBean addressBean = new BleAddressBean();
                addressBean.setBleMac(device.getAddress());
                addressBean.setBleName(device.getName());

                bleAddressList.add(addressBean);
            }

            @Override
            public void onSearchStopped() {
                Log.e("ble", "停止扫描");
            }

            @Override
            public void onSearchCanceled() {
                Log.e("ble", "扫描取消");
            }
        });

        return bleAddressList;
    }

    /**
     * 连接蓝牙
     *
     * @param mac 连接的蓝牙mac地址
     */
    public void connectBle(String mac) {
        if (mClient != null) {
            mClient.connect(mac, getBleConnectOptions(), new BleConnectResponse() {
                @Override
                public void onResponse(int code, BleGattProfile data) {
                    mConnectBleListener.connectResult(code);
                }
            });
        }
    }

    /**
     * 蓝牙连接结果回调
     */
    public interface ConnectBleListener {
        void connectResult(int code);
    }

    public void setConnectBleListener(ConnectBleListener mConnectBleListener) {
        this.mConnectBleListener = mConnectBleListener;
    }


    /**
     * 停止扫描
     */
    public void stopSearch() {
        if (mClient != null) {
            mClient.stopSearch();
        }
    }

    /**
     * 断开连接
     *
     * @param mac
     */
    public void disconnect(String mac) {
        if (mClient != null) {
            mClient.disconnect(mac);
        }
    }

    /**
     * 设置蓝牙打开状态监听和蓝牙配对监听
     */
    public void setBleListener() {
        if (mClient != null) {
            mClient.registerBluetoothStateListener(mBluetoothStateListener);
            mClient.registerBluetoothBondListener(mBluetoothBondListener);
        }
    }

    /**
     * 设置蓝牙连接状态是否改变监听
     *
     * @param mac 当前连接的蓝牙mac地址
     */
    public void setmBleConnectStatusListener(String mac) {
        if (mClient != null) {
            mClient.registerConnectStatusListener(mac, mBleConnectStatusListener);
        }
    }

    /**
     * 解除蓝牙的监听
     *
     * @param mac
     */
    public void unregisterBluetoothListener(String mac) {
        if (mClient != null) {
            mClient.unregisterBluetoothStateListener(mBluetoothStateListener);
            mClient.unregisterBluetoothBondListener(mBluetoothBondListener);
            mClient.unregisterConnectStatusListener(mac, mBleConnectStatusListener);
        }
    }

    /**
     * 发送蓝牙通知
     *
     * @param mac            蓝牙的mac地址
     * @param serviceUUID    蓝牙的服务UUID
     * @param passagewayUUID 蓝牙的发送通知的UUID
     */
    public void sentNotify(String mac, String serviceUUID, String passagewayUUID) {
        if (mClient == null) {
            return;
        }
        mClient.notify(mac, UUID.fromString(serviceUUID), UUID.fromString(passagewayUUID), new BleNotifyResponse() {
            @Override
            public void onNotify(UUID service, UUID character, byte[] value) {
                mBleNotifyListener.notifyResult(value);
            }

            @Override
            public void onResponse(int code) {
                mBleNotifyListener.notifyError(code);
            }
        });

    }

    /**
     * 蓝牙发送通知回调
     */
    public interface BleNotifyListener {
        void notifyResult(byte[] value);

        void notifyError(int code);
    }

    /**
     * 设置蓝牙发送通知结果回调
     *
     * @param listener
     */
    public void setBleNotifyListener(BleNotifyListener listener) {
        this.mBleNotifyListener = listener;
    }


    /**
     * 蓝牙数据写入
     *
     * @param mac            蓝牙mac地址
     * @param serviceUUID    蓝牙服务UUID
     * @param passagewayUUID 蓝牙通道UUID
     * @param data           需要写入的数据
     */
    public void sentMessage(String mac, String serviceUUID, String passagewayUUID, byte[] data) {
        if (mClient == null) {
            return;
        }
        mClient.write(mac, UUID.fromString(serviceUUID), UUID.fromString(passagewayUUID), data, new BleWriteResponse() {
            @Override
            public void onResponse(int code) {
                mBleWriteListener.writeResult(code);
            }
        });
    }

    /**
     * 蓝牙写入数据回调
     */
    public interface BleWriteListener {
        void writeResult(int code);
    }

    /**
     * 设置蓝牙写入数据结果回调
     *
     * @param bleWriteListener
     */
    public void setBleWriteListener(BleWriteListener bleWriteListener) {
        this.mBleWriteListener = bleWriteListener;
    }

    /**
     * 蓝牙读取数据
     *
     * @param mac            蓝牙mac地址
     * @param serviceUUID    蓝牙服务UUID
     * @param passagewayUUID 蓝牙读通道UUID
     */
    public void readMessage(String mac, String serviceUUID, String passagewayUUID) {
        if (mClient == null) {
            return;
        }
        mClient.read(mac, UUID.fromString(serviceUUID), UUID.fromString(passagewayUUID), new BleReadResponse() {
            @Override
            public void onResponse(int code, byte[] data) {
                mBleReadListener.readResult(code, data);
            }
        });
    }

    /**
     * 蓝牙读取数据结果回调
     */
    public interface BleReadListener {
        void readResult(int code, byte[] value);
    }

    /**
     * 设置蓝牙读取数据结果回调
     *
     * @param bleReadListener
     */
    public void setBleReadListener(BleReadListener bleReadListener) {
        this.mBleReadListener = bleReadListener;
    }

    /**
     * 蓝牙打开监听
     */
    private BluetoothStateListener mBluetoothStateListener = new BluetoothStateListener() {
        @Override
        public void onBluetoothStateChanged(boolean openOrClosed) {
            Log.e("ble", "蓝牙状态：" + openOrClosed);
        }

    };

    /**
     * 蓝牙配对监听
     */
    private BluetoothBondListener mBluetoothBondListener = new BluetoothBondListener() {
        @Override
        public void onBondStateChanged(String mac, int bondState) {
            Log.e("ble", "蓝牙地址：" + mac + "     连接状态：" + bondState);
        }
    };

    /**
     * 蓝牙连接状态变化监听
     */
    private BleConnectStatusListener mBleConnectStatusListener = new BleConnectStatusListener() {

        @Override
        public void onConnectStatusChanged(String mac, int status) {
            mBleConnectCaseListener.connectChangeResult(mac, status);
        }
    };

    /**
     * 蓝牙连接状态回调
     */
    public interface BleConnectCaseListener {
        void connectChangeResult(String mac, int status);
    }

    public void setBleConnectCaseListener(BleConnectCaseListener mBleConnectCaseListener) {
        this.mBleConnectCaseListener = mBleConnectCaseListener;
    }
}
