package com.saiyi.naideanlock.constant;

import java.util.UUID;

public class UUIDConstant {
	// 服务的UUID
	public static final UUID SERVICE_UUID = UUID.fromString("0000ff00-0000-1000-8000-00805f9b34fb");

	// 数据传输 特征的UUID
	public static final UUID CAN_WRITE_UUID = UUID.fromString("0000ff01-0000-1000-8000-00805f9b34fb");

	//通知 特征的UUID
	public static final UUID NOTIFY_CHARACTERISTIC_UUID = CAN_WRITE_UUID;

	// 通知 描述符的UUID
	public static final UUID NOTIFY_DESCRIPTOR_UUID = UUID.fromString("00002902-0000-1000-8000-00805f9b34fb");

}
