package com.sandy.guoguo.babylib.utils;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkInfo;
import android.os.Build;
import android.support.annotation.RequiresApi;

public class NetworkStatusCheckUtil {

    public static boolean checkStatus(Context context) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP) {
            return checkStateApiLow23(context);
        } else {
            return checkStateApi23orNew(context);
        }
    }

    /**
     * API版本23以下时调用此方法进行检测
     * <p>因为API23后getNetworkInfo(int networkType)方法被弃用
     *
     * @param context
     */
    private static boolean checkStateApiLow23(Context context) {
        //步骤1：通过Context.getSystemService(Context.CONNECTIVITY_SERVICE)获得ConnectivityManager对象
        ConnectivityManager connMgr = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);

        //步骤2：获取ConnectivityManager对象对应的NetworkInfo对象
        //NetworkInfo对象包含网络连接的所有信息
        //步骤3：根据需要取出网络连接信息
        //获取WIFI连接的信息
        NetworkInfo networkInfo = connMgr.getNetworkInfo(ConnectivityManager.TYPE_WIFI);
        Boolean isWifiConn = networkInfo.isConnected();

        //获取移动数据连接的信息
        networkInfo = connMgr.getNetworkInfo(ConnectivityManager.TYPE_MOBILE);
        Boolean isMobileConn = networkInfo.isConnected();
        LogAndToastUtil.log("API level < 23 网络情况:Wifi是否连接:%s 移动数据是否连接:%s", isWifiConn, isMobileConn);
        return isMobileConn || isWifiConn;
    }


    /**
     * API 23及以上时调用此方法进行网络的检测
     * <p>getAllNetworks() 在API 21后开始使用
     *
     * @param context
     */

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    private static boolean checkStateApi23orNew(Context context) {
        //获得ConnectivityManager对象
        ConnectivityManager connMgr = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);

        //获取所有网络连接的信息
        Network[] networks = connMgr.getAllNetworks();
        if (networks == null) {
            LogAndToastUtil.log("API level >= 23 网络情况:%s", "null");
            return false;
        }
        //用于存放网络连接信息
        StringBuilder sb = new StringBuilder();
        //通过循环将网络信息逐个取出来
        boolean isConnected = false;
        for (int i = 0; i < networks.length; i++) {
            //获取ConnectivityManager对象对应的NetworkInfo对象
            NetworkInfo networkInfo = connMgr.getNetworkInfo(networks[i]);
            isConnected = networkInfo.isConnected();
            sb.append(networkInfo.getTypeName() + " connect is " + isConnected);
        }
        LogAndToastUtil.log("API level >= 23 网络情况:%s", sb.toString());
        return isConnected;
    }

}
