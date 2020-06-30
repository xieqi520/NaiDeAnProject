package com.saiyi.naideanlock.utils;

import android.text.TextUtils;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 描述：字符工具类
 * 创建作者：ask
 * 创建时间：2017/11/1 10:21
 */

public class CharacterUtil {

    /**
     * 判断字符是否是电话号码
     *
     * @param phoneNumber
     * @return
     */
    public static boolean isPhoneNumber(String phoneNumber) {
        if (TextUtils.isEmpty(phoneNumber)) {
            return false;
        }
        Pattern p = Pattern.compile("^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$");
        Matcher m = p.matcher(phoneNumber);   //此处参数为String的字符串
        if (m.matches()) {
            return true;
        }
        return false;
    }

    /**
     * 判断字符是否由数字和字母组成
     *
     * @param s
     * @return
     */
    public static boolean is(String s) {
        return s != null && s.matches("[A-Za-z0-9]+");
    }
}
