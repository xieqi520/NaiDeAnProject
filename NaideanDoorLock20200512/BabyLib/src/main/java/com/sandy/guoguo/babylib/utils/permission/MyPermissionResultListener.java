package com.sandy.guoguo.babylib.utils.permission;

/**
 * Created by haozo on 2017/9/26.
 */

public interface MyPermissionResultListener {
    void permissionSuccess(int permissionReqCode);
    void permissionFail(int permissionReqCode);
}
