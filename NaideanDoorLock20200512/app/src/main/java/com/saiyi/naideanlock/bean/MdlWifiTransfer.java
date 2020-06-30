package com.saiyi.naideanlock.bean;

public class MdlWifiTransfer {
    public String did;
    public String buffer;
    public int cmd;

    @Override
    public String toString() {
        return "MdlWifiTransfer{" +
                "did='" + did + '\'' +
                ", buffer='" + buffer + '\'' +
                ", cmd=" + cmd +
                '}';
    }
}
