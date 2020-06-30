package com.saiyi.naideanlock.bean;

import android.os.Parcel;
import android.os.Parcelable;

import java.util.List;

/**
 * 创建者     YGP
 * 创建时间   2019/6/5
 * 描述       ${TODO}
 * <p/>
 * 更新者     $Author$
 * 更新时间   $Date$
 * 更新描述   ${TODO}
 */
public class AuthInfo implements Parcelable {
    private String createTime;
    private String deviceId;
    private String grantUserId;
    private String id;
    private String memoName;
    private String openPwd;
    private String phone;
    private String pic;
    private String userId;
    private List<String> times;
    private int userType;
    private List<String> weeks;

    protected AuthInfo(Parcel in) {
        createTime = in.readString();
        deviceId = in.readString();
        grantUserId = in.readString();
        id = in.readString();
        memoName = in.readString();
        openPwd = in.readString();
        phone = in.readString();
        pic = in.readString();
        userId = in.readString();
        times = in.createStringArrayList();
        userType = in.readInt();
        weeks = in.createStringArrayList();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(createTime);
        dest.writeString(deviceId);
        dest.writeString(grantUserId);
        dest.writeString(id);
        dest.writeString(memoName);
        dest.writeString(openPwd);
        dest.writeString(phone);
        dest.writeString(pic);
        dest.writeString(userId);
        dest.writeStringList(times);
        dest.writeInt(userType);
        dest.writeStringList(weeks);
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public static final Creator<AuthInfo> CREATOR = new Creator<AuthInfo>() {
        @Override
        public AuthInfo createFromParcel(Parcel in) {
            return new AuthInfo(in);
        }

        @Override
        public AuthInfo[] newArray(int size) {
            return new AuthInfo[size];
        }
    };

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    public String getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId;
    }

    public String getGrantUserId() {
        return grantUserId;
    }

    public void setGrantUserId(String grantUserId) {
        this.grantUserId = grantUserId;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getMemoName() {
        return memoName;
    }

    public void setMemoName(String memoName) {
        this.memoName = memoName;
    }

    public String getOpenPwd() {
        return openPwd;
    }

    public void setOpenPwd(String openPwd) {
        this.openPwd = openPwd;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPic() {
        return pic;
    }

    public void setPic(String pic) {
        this.pic = pic;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public List<String> getTimes() {
        return times;
    }

    public void setTimes(List<String> times) {
        this.times = times;
    }

    public int getUserType() {
        return userType;
    }

    public void setUserType(int userType) {
        this.userType = userType;
    }

    public List<String> getWeeks() {
        return weeks;
    }

    public void setWeeks(List<String> weeks) {
        this.weeks = weeks;
    }
}
