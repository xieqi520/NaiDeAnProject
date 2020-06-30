package com.saiyi.naideanlock.bean;

import com.google.gson.annotations.SerializedName;

public class MdlUnlockRecord {

    /**
     * number : 17727881181
     * mac : 07:58:2C:16:0B:DE
     * time : 2018-12-10 11:36:34
     * status : 1
     * linkType : 2
     * recordID : 7
     * userName :
     * headPicurl :
     */
    @SerializedName("id")
    public long recordID;

    //@SerializedName("phone")
    public String phone;

    @SerializedName("deviceMac")
    public String mac;

    @SerializedName("createTime")
    public String time;

    @SerializedName("openValue")
    public int status;

    @SerializedName("userType")
    public int linkType;

    //@SerializedName("memoName")
    public String memoName;

    @SerializedName("pic")
    public String headPicurl;
    public String deviceId;
    public String openType;
    public String sceneFingerprints;
    public String scenePwd;
    public String userId;
}
