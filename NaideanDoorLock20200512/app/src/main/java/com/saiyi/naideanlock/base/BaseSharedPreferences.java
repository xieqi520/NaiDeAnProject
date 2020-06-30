package com.saiyi.naideanlock.base;

import android.content.Context;
import android.content.SharedPreferences;

import com.saiyi.naideanlock.application.MyApplication;
import com.saiyi.naideanlock.config.Config;


/**
 * 描述：本地保存基类
 * 创建作者：Fanjianchang
 * 创建时间：2017/9/20 15:00
 */

public class BaseSharedPreferences {

    private static BaseSharedPreferences instance;

    private SharedPreferences spf;

    private SharedPreferences.Editor mEditor;

    public BaseSharedPreferences() {
        spf = MyApplication.getInstance().getAppContext().getSharedPreferences(Config.SPF_FILE_NAME, Context.MODE_PRIVATE);
        mEditor = spf.edit();
    }

    public static synchronized BaseSharedPreferences getInstance() {
        if (instance == null) {
            instance = new BaseSharedPreferences();
        }
        return instance;
    }

    /**
     * 保存字符串
     *
     * @param key
     * @param value
     */
    public void putString(String key, String value) {
        mEditor.putString(key, value);
        mEditor.commit();
    }

    /**
     * 保存整型
     *
     * @param key
     * @param value
     */
    public void putIntger(String key, int value) {
        mEditor.putInt(key, value);
        mEditor.commit();
    }

    /**
     * 保存浮点型
     *
     * @param key
     * @param value
     */
    public void putFolat(String key, float value) {
        mEditor.putFloat(key, value);
        mEditor.commit();
    }

    /**
     * 保存长整型
     *
     * @param key
     * @param value
     */
    public void putLong(String key, long value) {
        mEditor.putLong(key, value);
        mEditor.commit();
    }

    /**
     * 保存boolean类型
     *
     * @param key
     * @param value
     */
    public void putBoolean(String key, boolean value) {
        mEditor.putBoolean(key, value);
        mEditor.commit();
    }

    /**
     * 获取字符串
     *
     * @param key
     * @return
     */
    public String getString(String key) {
        return spf.getString(key, null);
    }

    /**
     * 用默认值
     * @param key
     * @param defValue
     * @return
     */
    public String getString(String key,String defValue) {
        return spf.getString(key, defValue);
    }

    /**
     * 获取整型
     *
     * @param key
     * @return
     */
    public Integer getInteger(String key) {
        return spf.getInt(key, 0);
    }

    /**
     * 获取浮点型
     *
     * @param key
     * @return
     */
    public Float getFloat(String key) {
        return spf.getFloat(key, 0);
    }

    /**
     * 获取长整型
     *
     * @param key
     * @return
     */
    public Long getLong(String key) {
        return spf.getLong(key, 0);
    }

    /**
     * 获取boolean类型
     *
     * @param key
     * @return
     */
    public boolean getBoolean(String key) {
        return spf.getBoolean(key, false);
    }

    /**
     * 删除某一个值
     *
     * @param key
     */
    public void remove(String key) {
        mEditor.remove(key);
        mEditor.commit();
    }

    /**
     * 清除所有的值
     */
    public void clear() {
        mEditor.clear();
        mEditor.commit();
    }
}
