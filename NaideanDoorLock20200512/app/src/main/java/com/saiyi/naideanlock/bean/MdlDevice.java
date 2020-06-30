package com.saiyi.naideanlock.bean;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.SerializedName;
import com.saiyi.naideanlock.application.MyApplication;
import com.saiyi.naideanlock.enums.EnumDeviceAdmin;
import com.saiyi.naideanlock.enums.EnumDeviceLink;
import com.saiyi.naideanlock.enums.EnumSwitch;

import java.util.List;

public class MdlDevice implements Parcelable{

    public String createTime;
    public int electricity;
    public String id;
    /**
     * 低电报警是否开启 0：关闭 1：开启
     */
    @EnumSwitch._Status
    public int low = EnumSwitch.OFF;

    public String mac;
    /**
     * 设备名称
     */
    @SerializedName("name")
    public String lockName;

    public int oneline = 0;
    /**
     * wifi模块密码
     * <p/>暂时用不到的
     */
    //@SerializedName("openPwd")
    //public String pwd;
    /**
     * 防撬报警是否开启 0：关闭 1：开启
     */
    @EnumSwitch._Status
    public int prying = EnumSwitch.OFF;
    /**
     * 开锁状态 0：关闭 1：开启
     */
    @EnumSwitch._Status
    public int status = EnumSwitch.OFF;
    /**
     * 温度报警 0：关闭 1：开启
     */
    @EnumSwitch._Status
    public int temperature = EnumSwitch.OFF;

    public List<String> times;
    /**
     * 锁类型 0：关闭 1：开启
     */
    @EnumDeviceLink._Type
    @SerializedName("type")
    public int linkType = EnumDeviceLink.BLE;
    /**
     * 无人报警 0：关闭 1：开启
     */
    @EnumSwitch._Status
    @SerializedName("unmanned")
    public int no = EnumSwitch.OFF;

    @EnumDeviceAdmin._Type
    @SerializedName("userType")
    public int isAdmin;//0超级管理员 1普通用户 2保姆

    public String videoId;
    public String videoPwd;
    public String videoUser;
    //@SerializedName("weeks")
    public List<Integer> weeks;

    //public int weeks;

    //public long bindingID;



    /**
     * 手机号
     */
    //public String number = MyApplication.getInstance().mdlUserInApp.phone;



    /**
     * wifi模块唯一标识
     * <p/>暂时用不到的
     */
    //public String uid;



    /**
     * 权限
     */
    //public String jurisdiction;

    /**
     * 授权用户名称
     */
    //public String remark;

    /**
     * 远程开锁密码
     */
    //public String pwd;

    /**
     * 无人模式是否开启 0 ：关闭 1：开启
     */
    //@EnumSwitch._Status
    //public int no = EnumSwitch.OFF;





    //public String appNumber;

    //@EnumDeviceLink._Type
    //public int linkType = EnumDeviceLink.BLE;





    /**
     * 设备密码
     */
    @SerializedName("openPwd")
    public String pwd;
    //public String lockPwd;

    //public String userName;

    //@SerializedName("headPicurl")
    //public String headPicture;

    //public List<MdlLockTimeListBean> lockTimeList;

    /*这里本来可以只用1个list的，但后台的同事，在设备列表和授权用户列表用了不同的key；
       导致我只能这样去接收
     */
    //public List<MdlLockPeriodListBean> lockPeriodList;
    //public List<MdlLockPeriodListBean> periodList;


    protected MdlDevice(Parcel in) {
        createTime = in.readString();
        electricity = in.readInt();
        id = in.readString();
        low = in.readInt();
        mac = in.readString();
        lockName = in.readString();
        oneline = in.readInt();
        prying = in.readInt();
        status = in.readInt();
        temperature = in.readInt();
        times = in.createStringArrayList();
        no = in.readInt();
        isAdmin = in.readInt();
        videoId = in.readString();
        videoPwd = in.readString();
        videoUser = in.readString();
        linkType = in.readInt();
        pwd = in.readString();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(createTime);
        dest.writeInt(electricity);
        dest.writeString(id);
        dest.writeInt(low);
        dest.writeString(mac);
        dest.writeString(lockName);
        dest.writeInt(oneline);
        dest.writeInt(prying);
        dest.writeInt(status);
        dest.writeInt(temperature);
        dest.writeStringList(times);
        dest.writeInt(no);
        dest.writeInt(isAdmin);
        dest.writeString(videoId);
        dest.writeString(videoPwd);
        dest.writeString(videoUser);
        dest.writeInt(linkType);
        dest.writeString(pwd);
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public static final Creator<MdlDevice> CREATOR = new Creator<MdlDevice>() {
        @Override
        public MdlDevice createFromParcel(Parcel in) {
            return new MdlDevice(in);
        }

        @Override
        public MdlDevice[] newArray(int size) {
            return new MdlDevice[size];
        }
    };
}
