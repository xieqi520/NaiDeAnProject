package com.saiyi.naideanlock.utils;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;

/**
 * 描述：获取app版本
 * 创建作者：ask
 * 创建时间：2017/11/16 14:42
 */

public class VersionCodeUtils {

    private static VersionCodeUtils instance;
    private Context context;

    public VersionCodeUtils(Context context) {
        this.context = context;
    }

    public static synchronized VersionCodeUtils getInstance(Context context) {
        if (instance == null) {
            instance = new VersionCodeUtils(context);
        }
        return instance;
    }

    /**
     * get App versionCode
     *
     * @return
     */
    public String getVersionCode() {
        PackageManager packageManager = context.getPackageManager();
        PackageInfo packageInfo;
        String versionCode = "";
        try {
            packageInfo = packageManager.getPackageInfo(context.getPackageName(), 0);
            versionCode = packageInfo.versionCode + "";
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        return versionCode;
    }

    /**
     * get App versionName
     *
     * @return
     */
    public String getVersionName() {
        PackageManager packageManager = context.getPackageManager();
        PackageInfo packageInfo;
        String versionName = "";
        try {
            packageInfo = packageManager.getPackageInfo(context.getPackageName(), 0);
            versionName = packageInfo.versionName;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        return versionName;
    }
}
