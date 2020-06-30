package com.sandy.guoguo.babylib.utils;

import android.text.TextUtils;

import java.util.regex.Pattern;

/**
 * Created by Administrator on 2018/6/11.
 */

public class RegexUtil {
    /**
     * 正则表达式：验证手机号
     */
    public static final String REGEX_MOBILE = "^1\\d{10}$";

    /**
     * 正则表达式：验证邮箱
     */
    public static final String REGEX_EMAIL = "^([a-z0-9A-Z]+[-|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}$";

    /**
     * 正则表达式：验证金额
     */
    public static final String REGEX_MONEY = "^[\\d.]+$";

    /**
     * 校验手机号
     *
     * @param mobile
     * @return 校验通过返回true，否则返回false
     */
    public static boolean isMobile(String mobile) {
        return Pattern.matches(REGEX_MOBILE, mobile);
    }

    /**
     * 校验邮箱
     *
     * @param email
     * @return 校验通过返回true，否则返回false
     */
    public static boolean isEmail(String email) {
        return Pattern.matches(REGEX_EMAIL, email);
    }

    /**
     * 校验密码
     *
     * @param pwd
     * @return 校验通过返回true，否则返回false
     */
    public static boolean isPwd(String pwd) {
        return !TextUtils.isEmpty(pwd) && pwd.length() >= 6;
    }

    public static boolean isMoney(String money) {
        return Pattern.matches(REGEX_MONEY, money);
    }
}
