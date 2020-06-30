package com.saiyi.naideanlock.bean;

/**
 * 描述：联系人列表
 * 创建作者：ask
 * 创建时间：2017/10/10 15:21
 */

public class AddMemberBean {
    /**
     * 头像地址
     */
    private String url;

    /**
     * 联系人名字
     */
    private String name;

    /**
     * 是否已经添加为管理员
     */
    private boolean isShared;

    /**
     * 是否选中添加为分享用户
     */
    private boolean isChoosed;

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

    public boolean isShared() {
        return isShared;
    }

    public void setShared(boolean shared) {
        isShared = shared;
    }

    public boolean isChoosed() {
        return isChoosed;
    }

    public void setChoosed(boolean choosed) {
        isChoosed = choosed;
    }

    @Override
    public String toString() {
        return "AddMemberBean{" +
                "url='" + url + '\'' +
                ", name='" + name + '\'' +
                ", isShared=" + isShared +
                ", isChoosed=" + isChoosed +
                '}';
    }
}
