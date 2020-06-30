package com.sandy.guoguo.babylib.utils;

/**
 * 创建者     YGP
 * 创建时间   2019/7/11
 * 描述       ${TODO}
 * <p/>
 * 更新者     $Author$
 * 更新时间   $Date$
 * 更新描述   ${TODO}
 */

import android.content.Context;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.text.TextUtils;

import java.net.NetworkInterface;
import java.net.SocketException;
import java.util.Locale;

/**
 * 系统工具类
 * Created by zhuwentao on 2016-07-18.
 */
public class SystemUtil {

    /**
     * 获取当前手机系统语言。
     *
     * @return 返回当前系统语言。例如：当前设置的是“中文-中国”，则返回“zh-CN”
     */
    public static String getSystemLanguage() {
        return Locale.getDefault().getLanguage();
    }

    /**
     * 获取当前系统上的语言列表(Locale列表)
     *
     * @return  语言列表
     */
    public static Locale[] getSystemLanguageList() {
        return Locale.getAvailableLocales();
    }

    /**
     * 获取当前手机系统版本号
     *
     * @return  系统版本号
     */
    public static String getSystemVersion() {
        return Build.VERSION.RELEASE;
    }

    /**
     * 获取手机型号
     *
     * @return  手机型号
     */
    public static String getSystemModel() {
        return Build.MODEL;
    }

    /**
     * 获取手机厂商
     *
     * @return  手机厂商
     */
    public static String getDeviceBrand() {
        return Build.BRAND;
    }

    /**
     * 获取手机IMEI(需要“android.permission.READ_PHONE_STATE”权限)
     *
     * @return  手机IMEI
     */
    /*public static String getIMEI(Context ctx) {
        TelephonyManager tm = (TelephonyManager) ctx.getSystemService(Activity.TELEPHONY_SERVICE);
        if (tm != null) {
            return tm.getDeviceId();
        }
        return null;
    }*/

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
        String SerialNumber = Build.SERIAL;
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
