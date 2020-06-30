package com.saiyi.naideanlock.utils;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.os.Build;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;

/**
 * 描述：权限申请
 * 创建作者：ask
 * 创建时间：2017/11/2 8:43
 */

public class PermissionHelpUtil {

    private static PermissionHelpUtil instance;

    private Activity context;

    public PermissionHelpUtil(Activity context) {
        this.context = context;

    }

    public static synchronized PermissionHelpUtil getInstance(Activity context) {
        if (instance == null) {
            instance = new PermissionHelpUtil(context);
        }
        return instance;
    }

    /**
     * 判断当前是否是android 6.0系统
     *
     * @return true 6.0 false 6.0以下
     */
    public boolean isSystemM() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            return true;
        }
        return false;
    }

    /**
     * 手机通讯录的读写权限
     */
    public void contacts() {
        if (isSystemM()) {
            if (ContextCompat.checkSelfPermission(context, Manifest.permission.READ_CONTACTS) != PackageManager.PERMISSION_GRANTED) {
                ActivityCompat.requestPermissions(context, new String[]{Manifest.permission.READ_CONTACTS}, 0);//申请权限
                ActivityCompat.requestPermissions(context, new String[]{Manifest.permission.WRITE_CONTACTS}, 0);//申请权限
            }
        }
    }

    /**
     * 位置权限
     */
    public void location() {
        if (isSystemM())
            if (ContextCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                //申请位置权限
                ActivityCompat.requestPermissions(context, new String[]{Manifest.permission.ACCESS_FINE_LOCATION}, 0);
            }
    }

}
