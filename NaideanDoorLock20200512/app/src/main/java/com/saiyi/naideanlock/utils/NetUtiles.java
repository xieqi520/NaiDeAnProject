package com.saiyi.naideanlock.utils;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.telephony.TelephonyManager;

/**
 * 描述：手机网络工具类
 * 创建作者：ask
 * 创建时间：2017/9/20 14:52
 */

public class NetUtiles {

    /**
     * 定义网络类型的枚举分类
     * 这里把一些一些2G,2.5G,2.7G等等按照快慢又做了一个分类,仅供参考
     */
    public static enum NetType {
        WIRED_FAST, WIFI_FAST, MOBILE_FAST, MOBILE_MIDDLE, MOBILE_SLOW, NONE,
    }

    /**
     * 是否网络在线
     *
     * @return
     */
    public static boolean $online(Context context) {
        ConnectivityManager manager = (ConnectivityManager) context
                .getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo networkInfo = manager.getActiveNetworkInfo();
        if (networkInfo != null) {
            return networkInfo.isAvailable();
        }
        return false;
    }

    /**
     * 当期的网络类型
     *
     * @return
     */
    public static NetType $type(Context context) {
        ConnectivityManager manager = (ConnectivityManager) context
                .getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo info = manager.getActiveNetworkInfo();

        if (info == null || !info.isConnected()) {
            return NetType.NONE;
        }

        int type = info.getType();
        int subType = info.getSubtype();


        if (type == ConnectivityManager.TYPE_ETHERNET) {
            return NetType.WIRED_FAST;
        }

        if (type == ConnectivityManager.TYPE_WIFI) {
            return NetType.WIFI_FAST;
        }

        if (type == ConnectivityManager.TYPE_MOBILE) {
            switch (subType) {
                case TelephonyManager.NETWORK_TYPE_GPRS:
                case TelephonyManager.NETWORK_TYPE_EDGE:
                case TelephonyManager.NETWORK_TYPE_CDMA:
                case TelephonyManager.NETWORK_TYPE_1xRTT:
                case TelephonyManager.NETWORK_TYPE_IDEN:
                    return NetType.MOBILE_SLOW; // 2G

                case TelephonyManager.NETWORK_TYPE_UMTS:
                case TelephonyManager.NETWORK_TYPE_EVDO_0:
                case TelephonyManager.NETWORK_TYPE_EVDO_A:
                case TelephonyManager.NETWORK_TYPE_HSDPA:
                case TelephonyManager.NETWORK_TYPE_HSUPA:
                case TelephonyManager.NETWORK_TYPE_HSPA:
                case TelephonyManager.NETWORK_TYPE_EVDO_B:
                case TelephonyManager.NETWORK_TYPE_EHRPD:
                case TelephonyManager.NETWORK_TYPE_HSPAP:
                    return NetType.MOBILE_MIDDLE;// 3G

                case TelephonyManager.NETWORK_TYPE_LTE:
                    return NetType.MOBILE_FAST; // 4G
            }
        }

        return NetType.NONE;
    }


    /**
     * 获取wifi名
     *
     * @param context 运行环境
     * @return 返回当前连接wifi名
     */
    public static String getSSID(Context context) {
        //获取系统服务  得到wifi管理对象
        final WifiManager wifiMgr = (WifiManager) context.getSystemService(Context.WIFI_SERVICE);
        if (wifiMgr != null) {
            //通过wifi管理对象获取wifi连接信息实体类
            final WifiInfo info = wifiMgr.getConnectionInfo();
            //获取当前连接的wifi名称
            String wifiName = info != null ? info.getSSID() : null;
            //正则表达式替换
            if (wifiName != null && Build.VERSION.SDK_INT >= 17 && wifiName.startsWith("\"") && wifiName.endsWith("\""))
                wifiName = wifiName.replaceAll("^\"|\"$", "");
            return wifiName;
        }
        return "";
    }

    /**
     * 获取网络连接类型
     *
     * @param context 运行环境
     * @return none、wifi和gprs
     */
    public static String getNetConnType(Context context) {
        final ConnectivityManager connManager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        if (null == connManager) {
            return "none";
        } else {
            NetworkInfo info = null;
            info = connManager.getNetworkInfo(1);
            NetworkInfo.State mobileState;
            if (null != info) {
                mobileState = info.getState();
                if (NetworkInfo.State.CONNECTED == mobileState) {
                    return "wifi";
                }
            }
            info = connManager.getNetworkInfo(0);
            if (null != info) {
                mobileState = info.getState();
                if (NetworkInfo.State.CONNECTED == mobileState) {
                    return "gprs";
                }
            }
            return "none";
        }
    }

    /**
     * 判断网络是否能用
     *
     * @param ctx 运行环境
     * @return false表示不能用，true表示能用
     */
    public static boolean networkUsable(Context ctx) {
        String connType = getNetConnType(ctx);
        return !connType.equals("none");
    }

    /**
     * 判断wifi是否连接
     *
     * @param context 运行环境
     * @return true表示连接，false表示未连接
     */
    public static boolean isWifiConnected(Context context) {
        if (context != null) {
            ConnectivityManager mConnectivityManager = (ConnectivityManager) context.getSystemService("connectivity");
            NetworkInfo mWiFiNetworkInfo = mConnectivityManager.getNetworkInfo(1);
            if (mWiFiNetworkInfo != null) {
                return mWiFiNetworkInfo.isAvailable();
            }
        }
        return false;
    }
}
