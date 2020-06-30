package com.saiyi.naideanlock.bean;

import android.os.Parcel;
import android.os.Parcelable;

public class MdlLockTimeListBean implements Parcelable {

    /**
     * id : 77
     * lockTime : 8
     */

    public int id;
    public String lockTime;

    protected MdlLockTimeListBean(Parcel in) {
        id = in.readInt();
        lockTime = in.readString();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeInt(id);
        dest.writeString(lockTime);
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public static final Creator<MdlLockTimeListBean> CREATOR = new Creator<MdlLockTimeListBean>() {
        @Override
        public MdlLockTimeListBean createFromParcel(Parcel in) {
            return new MdlLockTimeListBean(in);
        }

        @Override
        public MdlLockTimeListBean[] newArray(int size) {
            return new MdlLockTimeListBean[size];
        }
    };
}
