package com.sandy.guoguo.babylib.utils.permission;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.os.Build;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.Fragment;
import android.support.v4.content.ContextCompat;

/**
 * Created by haozo on 2017/9/26.
 */

public class PermissionUtil {
    public static final int PERMISSION_ACCESS_COARSE_LOCATION_REQ_CODE = 100;


    @TargetApi(Build.VERSION_CODES.M)
    public static void checkPermission(Object context, int reqCode, String... permissions) {

        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            //6.0以下
            reqPermissionSuccess(context, reqCode);
            return;
        }
        boolean granted = hasPermission(context, permissions);//检查权限
        if (granted) {
            reqPermissionSuccess(context, reqCode);
        } else {
            if (context instanceof Fragment) {
                ((Fragment) context).requestPermissions(permissions, reqCode);
            } else if(context instanceof Activity){
                ((Activity) context).requestPermissions(permissions, reqCode);
            } else {
                throw new IllegalArgumentException("非法上下文对象获取权限信息");
            }
        }
    }

    private static void reqPermissionFail(Object context, int reqCode) {
        if (context instanceof MyPermissionResultListener) {
            ((MyPermissionResultListener) context).permissionFail(reqCode);
        } else {
            throw new IllegalArgumentException("非法上下文对象获取权限信息");
        }
    }

    private static void reqPermissionSuccess(Object context, int reqCode) {
        if (context instanceof MyPermissionResultListener) {
            ((MyPermissionResultListener) context).permissionSuccess(reqCode);
        } else {
            throw new IllegalArgumentException("非法上下文对象获取权限信息");
        }
    }

    private static boolean hasPermission(Object context, String... permissions) {
        for (String permission : permissions) {
            Activity activity;
            if (context instanceof Fragment) {
                activity = ((Fragment) context).getActivity();
            } else if(context instanceof Activity){
                activity = (Activity) context;
            } else{
                throw new IllegalArgumentException("非法上下文对象hasPermission");
            }
            int granted = ContextCompat.checkSelfPermission(activity, permission);
            if (granted == PackageManager.PERMISSION_DENIED) {
                return false;
            }
        }

        return true;
    }

    public static void onRequestPermissionsResult(Fragment context, int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        handlePermissionsResult(context, requestCode, permissions, grantResults);
    }


    public static void onRequestPermissionsResult(Activity context, int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        handlePermissionsResult(context, requestCode, permissions, grantResults);
    }

    private static void handlePermissionsResult(Object context, int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        boolean permissionGranted = true;
        int index = 0;

        for (int grant : grantResults) {
            if (grant == PackageManager.PERMISSION_DENIED) {
                permissionGranted = false;
                break;
            }
            index++;
        }
        if (permissionGranted) {
            //获得权限
            reqPermissionSuccess(context, requestCode);
        } else {
            //权限被用户拒绝
            Activity activity;

            if (context instanceof Fragment) {
                activity = ((Fragment) context).getActivity();
            } else {
                activity = (Activity) context;
            }

            /*shouldShowRequestPermissionRationale
                返回false有两种情况:
                    1，第一次申请权限
                    2，拒绝，并勾选了"不再提醒"
                返回true:
                    拒绝，没有勾选"不再提醒"
            * */
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                if (ActivityCompat.shouldShowRequestPermissionRationale(activity, permissions[index])) {
                    activity.requestPermissions(new String[]{permissions[index]}, requestCode);
                } else {
                    reqPermissionFail(context, requestCode);
                }
            }
        }
    }
}
