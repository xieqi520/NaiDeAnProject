package com.saiyi.naideanlock.utils;

import android.app.Activity;
import android.content.Context;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.view.WindowManager;

import java.net.NetworkInterface;
import java.net.SocketException;

/**
 * 描述：获取手机宽高 做适配用
 * 创建作者：ask
 * 创建时间：2017/9/20 14:47
 */

public class DeviceUtils {
    private static int screenWidth = -1;
    private static int screenHeight = -1;

    /**
     * 获取屏幕分辨率宽度
     */
    public static int getScreenWidth(Activity context) {
        if (screenWidth == -1) {
            DisplayMetrics dm = new DisplayMetrics();
            WindowManager wm = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
            wm.getDefaultDisplay().getMetrics(dm);
            screenWidth = dm.widthPixels;
        }
        return screenWidth;
    }

    /**
     * 获取屏幕分辨率宽度
     */
    public static int getScreenHeight(Context context) {
        if (screenHeight == -1) {
            DisplayMetrics dm = new DisplayMetrics();
            WindowManager wm = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
            wm.getDefaultDisplay().getMetrics(dm);
            screenHeight = dm.heightPixels;
        }
        return screenHeight;
    }


    public static String getIMEI(Context context) {
        /**
         * 门口分机大平板获取不到imei
         */
		/*try {
			 TelephonyManager telephonyManager = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
			 String imei = telephonyManager.getDeviceId();
			 if (!StringUtils.isEmpty(imei)) {
				 return imei;
			 }
		} catch (Exception e) {
			// TODO: handle exception
		}*/
		/*try {
			 String android_id = Settings.System.getString(context.getContentResolver(), Settings.System.ANDROID_ID);
			 if (!StringUtils.isEmpty(android_id)) {
				 return android_id;
			 }
		} catch (Exception e) {
			// TODO: handle exception
		}*/
        String SerialNumber = android.os.Build.SERIAL;
        if (!TextUtils.isEmpty(SerialNumber)) {
            return SerialNumber;
        }
        return getLocalMacAddressFromWifiInfo(context);
    }

    /**
     * 获取mac地址 然后去掉:(冒号)
     * @param context
     * @return
     */
    public static String getLocalMacAddressFromWifiInfo(Context context){
        int version = Build.VERSION.SDK_INT;
        if (version < 23) {
            try {
                WifiManager wifi = (WifiManager) context.getSystemService(Context.WIFI_SERVICE);
                WifiInfo info = wifi.getConnectionInfo();
                String mac = info.getMacAddress(); // 获取mac地址 然后分割成数据
                if (!TextUtils.isEmpty(mac)) {
                    String[] macArr = mac.split(":");
                    String res = "";
                    for (String part : macArr) {
                        res += part;
                    }
                    return res;
                }
            } catch (Exception e) {
                // TODO: handle exception
            }
            return "";
        } else {
            String macAddress = null;
            StringBuffer buf = new StringBuffer();
            NetworkInterface networkInterface = null;
            try {
                networkInterface = NetworkInterface.getByName("wlan0");
                if (networkInterface == null) {
                    return "020000000002";
                }
                byte[] addr = networkInterface.getHardwareAddress();
                for (byte b : addr) {
                    buf.append(String.format("%02X:", b));
                }
                if (buf.length() > 0) {
                    buf.deleteCharAt(buf.length() - 1);
                }
                macAddress = buf.toString();
                if (!TextUtils.isEmpty(macAddress)) {
                    String[] macArr = macAddress.split(":");
                    String res = "";
                    for (String part : macArr) {
                        res += part;
                    }
                    return res;
                } else {
                    return "020000000002";
                }
            } catch (SocketException e) {
                e.printStackTrace();
                return "020000000002";
            }
        }
    }
}
