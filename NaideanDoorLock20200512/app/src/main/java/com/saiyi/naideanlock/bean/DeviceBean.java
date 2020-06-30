package com.saiyi.naideanlock.bean;

/**
 * 描述：
 * 创建作者：ask
 * 创建时间：2017/11/16 11:45
 */

public class DeviceBean {
    /**
     * 设备名
     */
    private String deviceName;

    public String getDeviceName() {
        return deviceName;
    }

    public void setDeviceName(String deviceName) {
        this.deviceName = deviceName;
    }

    @Override
    public String toString() {
        return "DeviceBean{" +
                "deviceName='" + deviceName + '\'' +
                '}';
    }
}
