package com.saiyi.naideanlock.bean;

import java.io.Serializable;

/**
 * 描述：扫描蓝牙实体类
 * 创建作者：ask
 * 创建时间：2017/10/26 17:16
 */

public class BleAddressBean implements Serializable {
    /**
     * 蓝牙mac地址
     */
    private String bleMac;

    /**
     * 蓝牙名称
     */
    private String bleName;

    public String getBleMac() {
        return bleMac;
    }

    public void setBleMac(String bleMac) {
        this.bleMac = bleMac;
    }

    public String getBleName() {
        return bleName;
    }

    public void setBleName(String bleName) {
        this.bleName = bleName;
    }

    @Override
    public String toString() {
        return "BleAddressBean{" +
                "bleMac='" + bleMac + '\'' +
                ", bleName='" + bleName + '\'' +
                '}';
    }
}
