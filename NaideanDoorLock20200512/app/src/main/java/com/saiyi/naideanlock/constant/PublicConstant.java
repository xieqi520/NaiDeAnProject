package com.saiyi.naideanlock.constant;

import com.sandy.guoguo.babylib.utils.Utility;

public class PublicConstant {
    public static final int REQ_ITEM = 0X1205;
    public static final int REQ_ADDDEVICE = 0X1206;
    public static final int REQ_PHONE = 0X1210;

    /**
     * 扫描设备用时
     */
    public static final int SCAN_BLE_TIME = 8 * 1000;

    /**
     * 用户自定义连接超时的时间
     */
    public static final int CUSTOM_CONNECT_TIMEOUT = 25 * 1000;

    public static final int REQUEST_ENABLE_BT = 0x01;

    //    public static final String DEVICE_DEFAULT_PWD = "123456";
    private static final byte b = Utility.int2byte(0xFF);
    public static final byte[] DEVICE_DEFAULT_PWD = {b, b, b, b, b, b, b, b};

}
