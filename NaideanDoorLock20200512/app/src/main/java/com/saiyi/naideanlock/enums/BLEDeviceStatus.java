package com.saiyi.naideanlock.enums;


import android.support.annotation.IntDef;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

public class BLEDeviceStatus {
	@Retention(RetentionPolicy.SOURCE)
	@IntDef({SCAN_NEW_DEVICE, CONNECTED, DISCONNECTED, REGISTER_OK, AUTO_STOP_SCAN, NOTIFY, CUSTOM_CONNECT_TIMEOUT, STOP_SCAN})
	public @interface DeviceStatus{}

	public static final int SCAN_NEW_DEVICE = 0XE0; //224
	public static final int CONNECTED = 0XE1; //225
	public static final int DISCONNECTED = 0XE2;//226
	public static final int REGISTER_OK = 0XE3; //227
	public static final int AUTO_STOP_SCAN = 0XE4; //228
	public static final int NOTIFY = 0XE5; //229
	public static final int CUSTOM_CONNECT_TIMEOUT = 0XE6; //230
	public static final int STOP_SCAN = 0XE7; //231

	public static final int DEVICE_NOTIFY_DATA = 0XE8;

}
