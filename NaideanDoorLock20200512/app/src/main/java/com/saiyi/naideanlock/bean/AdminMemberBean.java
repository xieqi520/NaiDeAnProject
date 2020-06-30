package com.saiyi.naideanlock.bean;

/**
 * 描述：授权成员
 * 创建作者：ask
 * 创建时间：2017/10/10 14:48
 */

public class AdminMemberBean {
    /**
     * 头像获取地址
     */
    private String url;
    /**
     * 成员名称
     */
    private String name;

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return "AdminMemberBean{" +
                "url='" + url + '\'' +
                ", name='" + name + '\'' +
                '}';
    }
}
