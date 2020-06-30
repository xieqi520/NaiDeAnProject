package com.sandy.guoguo.babylib.entity;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.SerializedName;

public class MdlUser implements Parcelable,Cloneable {
    /**
     * 手机号
     */
    public String phone;

    public String token;
    public String createTime;
    @SerializedName("id")
    public String userID;

    public int isCheck;
    /**
     * userID : 8
     * number : 17727881181
     * userName :
     * headPicurl :
     */
    /*@SerializedName("id")
    public long userID;*/
    @SerializedName("nickName")
    public String userName;
    @SerializedName("pic")
    public String headPicture;

    public MdlUser() {
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getHeadPicture() {
        return headPicture;
    }

    public void setHeadPicture(String headPicture) {
        this.headPicture = headPicture;
    }

    protected MdlUser(Parcel in) {
        phone = in.readString();
        token = in.readString();
        userID = in.readString();
        userName = in.readString();
        headPicture = in.readString();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(phone);
        dest.writeString(token);
        dest.writeString(userID);
        dest.writeString(userName);
        dest.writeString(headPicture);
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public static final Creator<MdlUser> CREATOR = new Creator<MdlUser>() {
        @Override
        public MdlUser createFromParcel(Parcel in) {
            return new MdlUser(in);
        }

        @Override
        public MdlUser[] newArray(int size) {
            return new MdlUser[size];
        }
    };

    @Override
    public Object clone(){
        MdlUser mdlUser = null;
        try {
            mdlUser = (MdlUser) super.clone();
        } catch (CloneNotSupportedException e) {
            e.printStackTrace();
        }
        return mdlUser;
    }

    @Override
    public String toString() {
        return "MdlUser{" +
                "phone='" + phone + '\'' +
                ", token='" + token + '\'' +
                ", userID=" + userID +
                ", userName='" + userName + '\'' +
                ", headPicture='" + headPicture + '\'' +
                '}';
    }
}
