package com.saiyi.naideanlock.utils;


import com.saiyi.naideanlock.base.BaseSharedPreferences;

/**
 * 描述：SharedPreferences保存本地工具类
 * 创建作者：ask
 * 创建时间：2017/9/20 14:57
 */

public class SharedPreferencesUtils {

    private static SharedPreferencesUtils instance;

    public static synchronized SharedPreferencesUtils getInstance() {
        if (instance == null) {
            instance = new SharedPreferencesUtils();
        }
        return instance;
    }

    public void putString(String key, String value) {
        BaseSharedPreferences.getInstance().putString(key, value);
    }

    public void putIntger(String key, int value) {
        BaseSharedPreferences.getInstance().putIntger(key, value);
    }

    public void putFolat(String key, float value) {
        BaseSharedPreferences.getInstance().putFolat(key, value);
    }

    public void putLong(String key, long value) {
        BaseSharedPreferences.getInstance().putLong(key, value);
    }

    public void putBoolean(String key, boolean value) {
        BaseSharedPreferences.getInstance().putBoolean(key, value);
    }

    public String getSPFString(String key,String value) {
        return BaseSharedPreferences.getInstance().getString(key,value);
    }
    public String getSPFString(String key) {
        return BaseSharedPreferences.getInstance().getString(key);
    }

    public Integer getSPFIntger(String key) {
        return BaseSharedPreferences.getInstance().getInteger(key);
    }

    public float getSPFFolat(String key) {
        return BaseSharedPreferences.getInstance().getFloat(key);
    }

    public long getSPFLong(String key) {
        return BaseSharedPreferences.getInstance().getLong(key);
    }

    public boolean getSPFBoolean(String key) {
        return BaseSharedPreferences.getInstance().getBoolean(key);
    }

    public void remove(String key) {
        BaseSharedPreferences.getInstance().remove(key);
    }

    public void clear() {
        BaseSharedPreferences.getInstance().clear();
    }
}
