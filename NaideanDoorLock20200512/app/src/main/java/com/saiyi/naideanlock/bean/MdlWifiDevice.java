package com.saiyi.naideanlock.bean;

import android.os.Parcel;
import android.os.Parcelable;

public class MdlWifiDevice implements Parcelable{
    public int cameraType;
    public String strMac;
    public String strName;
    public String strDeviceID;
    public String strIpAddr;
    public int port;

    public MdlWifiDevice() {
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof MdlWifiDevice)) return false;

        MdlWifiDevice that = (MdlWifiDevice) o;

        return strDeviceID != null ? strDeviceID.equals(that.strDeviceID) : that.strDeviceID == null;
    }

    @Override
    public int hashCode() {
        return strDeviceID != null ? strDeviceID.hashCode() : 0;
    }

    protected MdlWifiDevice(Parcel in) {
        cameraType = in.readInt();
        strMac = in.readString();
        strName = in.readString();
        strDeviceID = in.readString();
        strIpAddr = in.readString();
        port = in.readInt();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeInt(cameraType);
        dest.writeString(strMac);
        dest.writeString(strName);
        dest.writeString(strDeviceID);
        dest.writeString(strIpAddr);
        dest.writeInt(port);
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public static final Creator<MdlWifiDevice> CREATOR = new Creator<MdlWifiDevice>() {
        @Override
        public MdlWifiDevice createFromParcel(Parcel in) {
            return new MdlWifiDevice(in);
        }

        @Override
        public MdlWifiDevice[] newArray(int size) {
            return new MdlWifiDevice[size];
        }
    };

    @Override
    public String toString() {
        return "MdlWifiDevice{" +
                "cameraType=" + cameraType +
                ", strMac='" + strMac + '\'' +
                ", strName='" + strName + '\'' +
                ", strDeviceID='" + strDeviceID + '\'' +
                ", strIpAddr='" + strIpAddr + '\'' +
                ", port=" + port +
                '}';
    }
}
