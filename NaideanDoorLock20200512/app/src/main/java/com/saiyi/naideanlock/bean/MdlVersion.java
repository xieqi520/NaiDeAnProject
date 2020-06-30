package com.saiyi.naideanlock.bean;

import com.google.gson.annotations.SerializedName;

public class MdlVersion {
    @SerializedName("enumber")
    public int versionCode;
    @SerializedName("ename")
    public String versionName;
    @SerializedName("packageURL")
    public String packageUrl;
}
