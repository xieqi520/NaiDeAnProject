package com.saiyi.naideanlock.bean;

/**
 * 描述：
 * 创建作者：ask
 * 创建时间：2017/10/27 15:09
 */

public class PhotoBean {
    /**
     * 头像地址
     */
    private String url;
    /**
     * 日期
     */
    private String data;
    /**
     * 时间
     */
    private String time;

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    @Override
    public String toString() {
        return "PhotoBean{" +
                "url='" + url + '\'' +
                ", data='" + data + '\'' +
                ", time='" + time + '\'' +
                '}';
    }
}
