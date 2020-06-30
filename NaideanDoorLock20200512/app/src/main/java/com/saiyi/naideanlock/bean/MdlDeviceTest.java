package com.saiyi.naideanlock.bean;

import com.google.gson.annotations.SerializedName;
import com.saiyi.naideanlock.enums.EnumDeviceAdmin;
import com.saiyi.naideanlock.enums.EnumDeviceLink;
import com.saiyi.naideanlock.enums.EnumSwitch;

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
public class MdlDeviceTest {
    public String createTime;
    public int electricity;
    public String id;

    public int low;

    public String mac;

    public String name;

    public int oneline;
    /**
     * wifi模块密码
     * <p/>暂时用不到的
     */
    //@SerializedName("openPwd")
    //public String pwd;
    /**
     * 防撬报警是否开启 0：关闭 1：开启
     */

    public int prying;
    /**
     * 开锁状态 0：关闭 1：开启
     */

    public int status;
    /**
     * 温度报警 0：关闭 1：开启
     */

    public int temperature;

    public List<String> times;
    /**
     * 锁类型 0：关闭 1：开启
     */

    public int type;
    /**
     * 无人报警 0：关闭 1：开启
     */

    public int unmanned;


    public int userType;//0超级管理员 1普通用户 2保姆

    public String videoId;
    public String videoPwd;
    public String videoUser;
    //@SerializedName("weeks")
    public List<String> weeks;

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

    public int linkType;





    /**
     * 设备密码
     */
    public String openPwd;
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

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    public int getElectricity() {
        return electricity;
    }

    public void setElectricity(int electricity) {
        this.electricity = electricity;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public int getLow() {
        return low;
    }

    public void setLow(int low) {
        this.low = low;
    }

    public String getMac() {
        return mac;
    }

    public void setMac(String mac) {
        this.mac = mac;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getOneline() {
        return oneline;
    }

    public void setOneline(int oneline) {
        this.oneline = oneline;
    }

    public int getPrying() {
        return prying;
    }

    public void setPrying(int prying) {
        this.prying = prying;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public int getTemperature() {
        return temperature;
    }

    public void setTemperature(int temperature) {
        this.temperature = temperature;
    }

    public List<String> getTimes() {
        return times;
    }

    public void setTimes(List<String> times) {
        this.times = times;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public int getUnmanned() {
        return unmanned;
    }

    public void setUnmanned(int unmanned) {
        this.unmanned = unmanned;
    }

    public int getUserType() {
        return userType;
    }

    public void setUserType(int userType) {
        this.userType = userType;
    }

    public String getVideoId() {
        return videoId;
    }

    public void setVideoId(String videoId) {
        this.videoId = videoId;
    }

    public String getVideoPwd() {
        return videoPwd;
    }

    public void setVideoPwd(String videoPwd) {
        this.videoPwd = videoPwd;
    }

    public String getVideoUser() {
        return videoUser;
    }

    public void setVideoUser(String videoUser) {
        this.videoUser = videoUser;
    }

    public List<String> getWeeks() {
        return weeks;
    }

    public void setWeeks(List<String> weeks) {
        this.weeks = weeks;
    }

    public int getLinkType() {
        return linkType;
    }

    public void setLinkType(int linkType) {
        this.linkType = linkType;
    }

    public String getOpenPwd() {
        return openPwd;
    }

    public void setOpenPwd(String openPwd) {
        this.openPwd = openPwd;
    }
}
