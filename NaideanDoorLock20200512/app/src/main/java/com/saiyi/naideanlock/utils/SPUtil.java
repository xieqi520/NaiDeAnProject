package com.saiyi.naideanlock.utils;

import android.content.Context;
import android.content.SharedPreferences;

import com.sandy.guoguo.babylib.constant.BabyPublicConstant;
import com.sandy.guoguo.babylib.ui.BaseApp;


public class SPUtil {
    private static final String SP_PHONE = "PHONE";
    private static final String SP_EMAIL = "EMAIL";
    private static final String SP_PWD = "PWD";

    private static final SharedPreferences sp;
    static {
        sp = BaseApp.ME.getSharedPreferences(BabyPublicConstant.APP_NAME, Context.MODE_PRIVATE);
    }

    public static String getPhoneFromSP(){
        return sp.getString(SP_PHONE, "");
    }
    public static void savePhone2SP(String account){
        SharedPreferences.Editor editor = sp.edit();
        editor.putString(SP_PHONE, account);
        editor.apply();
    }
    public static String getEmailFromSP(){
        return sp.getString(SP_EMAIL, "");
    }
    public static void saveEmail2SP(String account){
        SharedPreferences.Editor editor = sp.edit();
        editor.putString(SP_EMAIL, account);
        editor.apply();
    }
    public static String getPwdFromSP(){
        return sp.getString(SP_PWD, "");
    }
    public static void savePwd2SP(String account){
        SharedPreferences.Editor editor = sp.edit();
        editor.putString(SP_PWD, account);
        editor.apply();
    }

}
