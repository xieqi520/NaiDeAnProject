package com.sandy.guoguo.babylib.utils;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkInfo;

public class NetWorkChangReceiver extends BroadcastReceiver {

    public void registerThis(Context hostContext) {
        IntentFilter filter = new IntentFilter();
        filter.addAction(ConnectivityManager.CONNECTIVITY_ACTION);
//        filter.addAction(WifiManager.WIFI_STATE_CHANGED_ACTION);
//        filter.addAction(WifiManager.NETWORK_STATE_CHANGED_ACTION);
        hostContext.registerReceiver(this, filter);
    }

    public void unregisterThis(Context hostContext){
        hostContext.unregisterReceiver(this);
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        LogAndToastUtil.log("网络变化:%s", intent.getAction());

        StringBuilder sb = new StringBuilder();
        boolean flag = false;

        //检测API是不是小于23，因为到了API23之后getNetworkInfo(int networkType)方法被弃用
        if (android.os.Build.VERSION.SDK_INT < android.os.Build.VERSION_CODES.LOLLIPOP) {
            LogAndToastUtil.log("API level < 23");

            //获得ConnectivityManager对象
            ConnectivityManager connMgr = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);

            //获取ConnectivityManager对象对应的NetworkInfo对象
            //获取WIFI连接的信息
            NetworkInfo wifiNetworkInfo = connMgr.getNetworkInfo(ConnectivityManager.TYPE_WIFI);
            //获取移动数据连接的信息
            NetworkInfo dataNetworkInfo = connMgr.getNetworkInfo(ConnectivityManager.TYPE_MOBILE);


            sb.append((wifiNetworkInfo != null && wifiNetworkInfo.isConnected()) ? "WIFI已连接" : "WIFI已断开");
            sb.append((dataNetworkInfo != null && dataNetworkInfo.isConnected()) ? "移动数据已连接" : "移动数据已断开");

            flag = (wifiNetworkInfo != null && wifiNetworkInfo.isConnected()) || (dataNetworkInfo != null && dataNetworkInfo.isConnected());
        } else {
            LogAndToastUtil.log("API level >= 23");


            //获得ConnectivityManager对象
            ConnectivityManager connMgr = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);

            //获取所有网络连接的信息
            Network[] networks = connMgr.getAllNetworks();

            try {
                //通过循环将网络信息逐个取出来
                for (Network network : networks) {
                    //获取ConnectivityManager对象对应的NetworkInfo对象
                    if (network == null) {
                        continue;
                    }
                    NetworkInfo networkInfo = connMgr.getNetworkInfo(network);
                    if (networkInfo != null) {
                        sb.append(networkInfo.getSubtypeName()).append(" ").append(networkInfo.getTypeName()).append(" connect is ").append(networkInfo.isConnected()).append("\n");
                        flag |= networkInfo.isConnected();
                    }
                }
            } catch (Exception e) {
                LogAndToastUtil.log("又是这个错误---------------");
                e.printStackTrace();
            }
            LogAndToastUtil.log("网络情况:%s", sb.toString());
        }

        LogAndToastUtil.log("网络isConnected:%s", flag);
    }
}
