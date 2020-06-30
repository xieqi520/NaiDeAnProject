package com.saiyi.naideanlock.bean;

import android.bluetooth.BluetoothDevice;
import android.os.Parcel;
import android.os.Parcelable;

import java.util.Arrays;

/**
 * Created by Liu on 2018/3/16.
 */

public class MdlScanNewDevice implements Parcelable {
    public BluetoothDevice device;
    public int rssi;
    public byte[] scanResult;

    public MdlScanNewDevice(){}

    public MdlScanNewDevice(BluetoothDevice device, int rssi, byte[] scanResult) {
        this.device = device;
        this.rssi = rssi;
        this.scanResult = scanResult;
    }

    protected MdlScanNewDevice(Parcel in) {
        device = in.readParcelable(BluetoothDevice.class.getClassLoader());
        rssi = in.readInt();
        scanResult = in.createByteArray();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeParcelable(device, flags);
        dest.writeInt(rssi);
        dest.writeByteArray(scanResult);
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public static final Creator<MdlScanNewDevice> CREATOR = new Creator<MdlScanNewDevice>() {
        @Override
        public MdlScanNewDevice createFromParcel(Parcel in) {
            return new MdlScanNewDevice(in);
        }

        @Override
        public MdlScanNewDevice[] newArray(int size) {
            return new MdlScanNewDevice[size];
        }
    };

    @Override
    public String toString() {
        return "MdlScanNewDevice{" +
                "device=" + device +
                ", rssi=" + rssi +
                ", scanResult=" + Arrays.toString(scanResult) +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        MdlScanNewDevice that = (MdlScanNewDevice) o;

        return device != null ? device.equals(that.device) : that.device == null;
    }

    @Override
    public int hashCode() {
        return device != null ? device.hashCode() : 0;
    }
}
