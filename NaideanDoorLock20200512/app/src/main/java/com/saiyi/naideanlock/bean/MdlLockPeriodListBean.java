package com.saiyi.naideanlock.bean;

import android.os.Parcel;
import android.os.Parcelable;

public class MdlLockPeriodListBean implements Parcelable{

    /**
     * lockPeriod :
     */

    public String lockPeriod;

    protected MdlLockPeriodListBean(Parcel in) {
        lockPeriod = in.readString();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(lockPeriod);
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public static final Creator<MdlLockPeriodListBean> CREATOR = new Creator<MdlLockPeriodListBean>() {
        @Override
        public MdlLockPeriodListBean createFromParcel(Parcel in) {
            return new MdlLockPeriodListBean(in);
        }

        @Override
        public MdlLockPeriodListBean[] newArray(int size) {
            return new MdlLockPeriodListBean[size];
        }
    };
}
