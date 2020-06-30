package com.sandy.guoguo.babylib.utils;

import android.content.Context;
import android.content.SharedPreferences;

import com.sandy.guoguo.babylib.constant.BabyPublicConstant;
import com.sandy.guoguo.babylib.entity.MdlUser;
import com.sandy.guoguo.babylib.ui.BaseApp;

public class BaseSPUtil {
    private static final String SP_ACCOUNT = "_ACCOUNT";
    private static final String SP_PWD = "_PWD";
    private static final String SP_API_TOKEN = "_TOKEN";
    private static final String SP_USER = "_USER";

    private static final SharedPreferences sp;

    static {
        sp = BaseApp.ME.getSharedPreferences(BabyPublicConstant.APP_NAME, Context.MODE_PRIVATE);
    }


    public static String getAccountFromSP() {
        return sp.getString(SP_ACCOUNT, "");
    }

    public static void saveAccount2SP(String account) {
        SharedPreferences.Editor editor = sp.edit();
        editor.putString(SP_ACCOUNT, account);
        editor.apply();
    }
    public static String getTokenFromSP() {
        return sp.getString(SP_API_TOKEN, "");
    }

    public static void saveToken2SP(String token) {
        SharedPreferences.Editor editor = sp.edit();
        editor.putString(SP_API_TOKEN, token);
        editor.apply();
    }

    public static String getPwdFromSP() {
        return sp.getString(SP_PWD, "");
    }

    public static void savePwd2SP(String account) {
        SharedPreferences.Editor editor = sp.edit();
        editor.putString(SP_PWD, account);
        editor.apply();
    }

    public static MdlUser getUserFromSP() {
        String json = sp.getString(SP_USER, "");
        return JsonUtil.fromJson(json, MdlUser.class);
    }

    public static void saveUser2SP(MdlUser mdlUser) {
        SharedPreferences.Editor editor = sp.edit();
        editor.putString(SP_USER, JsonUtil.createJson(mdlUser));
        editor.apply();
    }
}
