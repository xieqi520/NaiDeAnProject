package com.saiyi.naideanlock.bean;

/**
 * 描述：登录实体类
 * 创建作者：ask
 * 创建时间：2017/10/30 16:41
 */

public class LoginBean {
    public static int LOGIN_SUCCESS = 1;//登录成功
    public static int LOGIN_FAIL = 2;//登录失败
    public static int LOGIN_PASS_WRONG = 3;//密码错误

    private int result;

    public int getResult() {
        return result;
    }

    public void setResult(int result) {
        this.result = result;
    }
}
