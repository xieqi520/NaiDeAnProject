package com.saiyi.naideanlock.new_ui.base;

import android.Manifest;
import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.Nullable;

import com.saiyi.naideanlock.R;
import com.saiyi.naideanlock.application.MyApplication;
import com.saiyi.naideanlock.bean.MdlScanNewDevice;
import com.saiyi.naideanlock.constant.PublicConstant;
import com.saiyi.naideanlock.enums.BLEDeviceStatus;
import com.saiyi.naideanlock.enums.EnumDeviceLink;
import com.saiyi.naideanlock.service.Api18Service;
import com.saiyi.naideanlock.service.HomeService;
import com.saiyi.naideanlock.utils.MyUtility;
import com.sandy.guoguo.babylib.ui.MVPBaseActivity;
import com.sandy.guoguo.babylib.ui.mvp.BasePresenter;
import com.sandy.guoguo.babylib.ui.mvp.BaseView;
import com.sandy.guoguo.babylib.utils.LogAndToastUtil;
import com.sandy.guoguo.babylib.utils.eventbus.MdlEventBus;
import com.sandy.guoguo.babylib.utils.permission.PermissionUtil;

public abstract class MVPBaseHandleBLEActivity<MVP_V extends BaseView, MVP_P extends BasePresenter<MVP_V>> extends MVPBaseActivity<MVP_V, MVP_P> {
    protected boolean isServiceOk, isPermissionOk, isOneDeviceConnected;

    private BLESwitchBroadCastReceiver mBroadCastReceiver;

    protected void initAboutBLE() {
        initBroadcast();
        openService();
        checkPermission();
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        if (MyApplication.getInstance().deviceLinkType == EnumDeviceLink.BLE) {
            if (MyUtility.checkIsSupportBLE(this)) {
                initAboutBLE();
            }
        }
    }


    private void initBroadcast() {
        mBroadCastReceiver = new BLESwitchBroadCastReceiver();
        IntentFilter filter = new IntentFilter();
        filter.addAction(BluetoothAdapter.ACTION_STATE_CHANGED);
        registerReceiver(mBroadCastReceiver, filter);
    }

    private void destroyBroadcast() {
        if (mBroadCastReceiver != null) {
            unregisterReceiver(mBroadCastReceiver);
            mBroadCastReceiver = null;
        }
    }

    private class BLESwitchBroadCastReceiver extends BroadcastReceiver {

        @Override
        public void onReceive(Context context, Intent intent) {
            int bluetoothState = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, -1);

            if (!MyUtility.checkBLEServiceIsNull()) {
                HomeService.ME.stopSelf();
            }

            if (bluetoothState == BluetoothAdapter.STATE_ON) {
                openService();
            } else if (bluetoothState == BluetoothAdapter.STATE_OFF) {
                LogAndToastUtil.toast(context.getString(R.string.close_ble_notice));
                bleSwitchOff();
            }

        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        destroyBroadcast();
    }

    private void openService() {
        int currentApiVersion = Build.VERSION.SDK_INT;
        Intent serviceIntent = new Intent();
        if (currentApiVersion < Build.VERSION_CODES.JELLY_BEAN_MR2) {// 小于android4.3以下
            LogAndToastUtil.toast(getString(R.string.can_not_support));
            finish();
        } else if (currentApiVersion >= Build.VERSION_CODES.JELLY_BEAN_MR2) {// 大于android4.3
            serviceIntent.setClass(this, Api18Service.class);
        }

        startService(serviceIntent);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Activity.RESULT_OK) {
            switch (requestCode) {
                case PublicConstant.REQUEST_ENABLE_BT:
                    initAboutBLE();
                    break;

                default:
                    break;
            }
        }
    }


    private void checkPermission() {
        PermissionUtil.checkPermission(this, PermissionUtil.PERMISSION_ACCESS_COARSE_LOCATION_REQ_CODE, Manifest.permission.ACCESS_COARSE_LOCATION);
//        PermissionUtil.checkPermission(this, PermissionUtil.PERMISSION_ACCESS_COARSE_LOCATION_REQ_CODE, Manifest.permission.ACCESS_FINE_LOCATION);
    }

    @Override
    public void permissionSuccess(int permissionReqCode) {
        super.permissionSuccess(permissionReqCode);
        isPermissionOk = true;
        permissionOK();
    }

    protected void permissionOK() {
        startScan();
    }

    @Override
    public void permissionFail(int permissionReqCode) {
        super.permissionFail(permissionReqCode);

        LogAndToastUtil.toast(R.string.refuse_location_permission);
    }

    protected void startScan() {
        if (isPermissionOk && isServiceOk && !MyUtility.checkBLEServiceIsNull() && !HomeService.ME.isScanning) {
            prepareScan();
            HomeService.ME.clearScanCache();
            HomeService.ME.scan(true);
        }
        LogAndToastUtil.log("搜索前，isPermissionOk:%s isServiceOk:%s HomeService.ME != null:%s", isPermissionOk, isServiceOk, HomeService.ME != null);
    }

    @Override
    public synchronized void onEventBusMessage(MdlEventBus event) {
        super.onEventBusMessage(event);
        switch (event.eventType) {
            case BLEDeviceStatus.REGISTER_OK:
                isServiceOk = true;
                LogAndToastUtil.log("服务启动，到这里没有...");
//                startScan();
                break;

            case BLEDeviceStatus.AUTO_STOP_SCAN:
                LogAndToastUtil.log("-----------AUTO_STOP_SCAN...");
                timeoutStopScan();
                break;


            case BLEDeviceStatus.SCAN_NEW_DEVICE:
                MdlScanNewDevice newDevice = (MdlScanNewDevice) event.data;
                LogAndToastUtil.log("搜到数据：%s", this.getClass().getName());

                scanNewDevice(newDevice);

                break;
        }
    }


    /**自动停止扫描*/
    protected abstract void timeoutStopScan();

    /**手机的蓝牙关闭*/
    protected abstract void bleSwitchOff();

    /**搜到新设备*/
    protected abstract void scanNewDevice(MdlScanNewDevice mdlScanNewDevice);

    /**准备进行搜索*/
    protected abstract void prepareScan();
}
