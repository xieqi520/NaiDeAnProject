package com.saiyi.naideanlock.bean;

/**
 * 描述：开锁记录
 * 创建作者：Fanjianchang
 * 创建时间：2017/10/10 15:58
 */

public class UnlockingBean {
    /**
     * 头像地址
     */
    private String url;

    /**
     * 开锁信息
     */
    private String information;

    /**
     * 开锁方式头像地址
     */
    private String styleUrl;
    /**
     * 开锁日期
     */
    private String date;
    /**
     * 开锁时间
     */
    private String time;

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getInformation() {
        return information;
    }

    public void setInformation(String information) {
        this.information = information;
    }

    public String getStyleUrl() {
        return styleUrl;
    }

    public void setStyleUrl(String styleUrl) {
        this.styleUrl = styleUrl;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    @Override
    public String toString() {
        return "UnlockingBean{" +
                "url='" + url + '\'' +
                ", information='" + information + '\'' +
                ", styleUrl='" + styleUrl + '\'' +
                ", date='" + date + '\'' +
                ", time='" + time + '\'' +
                '}';
    }
}
