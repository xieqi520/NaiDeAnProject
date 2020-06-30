package com.saiyi.naideanlock.utils;

import android.annotation.TargetApi;
import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.support.v4.app.Fragment;

import com.saiyi.naideanlock.R;
import com.saiyi.naideanlock.constant.PublicConstant;
import com.saiyi.naideanlock.service.HomeService;
import com.sandy.guoguo.babylib.utils.LogAndToastUtil;

public class MyUtility {
    public static boolean checkBLEServiceIsNull() {
        return HomeService.ME == null;
    }
    public static void otherOperationNeedStopScan() {
        if (!checkBLEServiceIsNull()) {
            if (HomeService.ME.isScanning) {
                HomeService.ME.scan(false);
            }
        }
    }

    public static byte int2UInt8(int num) {
        short v = (short) num;
        return (byte) (v & 0xFF);
    }

    public static int byte2Uint8(byte num) {
        return num & 0xFF;
    }

    public static byte getCrc(byte[] data) {
        byte res = data[0];
        int len = data.length;
        for (int i = 1; i < len; i++) {
            res ^= data[i];
        }
        return res;
    }

    public static String byteArray2HexString(byte[] data) {
        StringBuilder sb = new StringBuilder();
        for (byte b : data) {
            sb.append(String.format(" 0x%02X", b));
        }

        return sb.toString();
    }

    public static boolean checkIsSupportBLE(Object context) {
        BluetoothAdapter mBluetoothAdapter = null;
        if (context instanceof Fragment) {
            mBluetoothAdapter = getBluetoothAdapter(((Fragment) context).getContext());
        } else {
            mBluetoothAdapter = getBluetoothAdapter((Activity) context);
        }
        if (mBluetoothAdapter == null) {
            LogAndToastUtil.toast(R.string.can_not_support);
            return false;
        } else {
            if (!mBluetoothAdapter.isEnabled()) {
                Intent enableIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
                if (context instanceof Fragment) {
                    ((Fragment) context).startActivityForResult(enableIntent, PublicConstant.REQUEST_ENABLE_BT);
                } else {
                    ((Activity) context).startActivityForResult(enableIntent, PublicConstant.REQUEST_ENABLE_BT);
                }
                return false;
            }
        }
        return true;
    }

    public static BluetoothAdapter getBluetoothAdapter(Context context) {
        BluetoothAdapter mBluetoothAdapter = null;
        int currentapiVersion = Build.VERSION.SDK_INT;
        if (currentapiVersion < Build.VERSION_CODES.JELLY_BEAN_MR2) {// 小于android4.3以下
            LogAndToastUtil.toast(R.string.can_not_support);
            return null;
        } else if (currentapiVersion >= Build.VERSION_CODES.JELLY_BEAN_MR2) {// 大于android4.2
            mBluetoothAdapter = getBluetoothAdapter_api18(context);
        }
        return mBluetoothAdapter;
    }

    @TargetApi(Build.VERSION_CODES.JELLY_BEAN_MR2)
    private static BluetoothAdapter getBluetoothAdapter_api18(Context context) {
        BluetoothManager bluetoothManager = (BluetoothManager) context.getSystemService(Context.BLUETOOTH_SERVICE);
        if (!context.getPackageManager().hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE)) {
            LogAndToastUtil.toast(R.string.can_not_support);
            return null;
        }

        return bluetoothManager.getAdapter();
    }
}
