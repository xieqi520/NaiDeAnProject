package com.saiyi.naideanlock.enums;

import android.support.annotation.IntDef;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

public class EnumBLECmd {
    @Retention(RetentionPolicy.SOURCE)
    @IntDef({
            BONDED, SET_PWD, GET_POWER, UNLOCK, RESET_PWD, DEVICE_ACTIVE_REPORT_POWER, DEVICE_ACTIVE_REPORT_LOCK_STATUS
    })
    public @interface _Flag {
    }

    public static final int BONDED = 0X30;
    public static final int SET_PWD = 0X31;
    public static final int GET_POWER = 0X32;
    public static final int UNLOCK = 0X33;
    public static final int RESET_PWD = 0X34;
    public static final int DEVICE_ACTIVE_REPORT_POWER = 0X35;
    public static final int DEVICE_ACTIVE_REPORT_LOCK_STATUS = 0X36;
}
