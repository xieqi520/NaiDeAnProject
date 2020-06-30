package com.saiyi.naideanlock.enums;


import android.support.annotation.IntDef;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

public class EnumDeviceLink {
    @Retention(RetentionPolicy.SOURCE)
    @IntDef({
            WIFI, BLE
    })
    public @interface _Type {
    }

    public static final int WIFI = 1;
    public static final int BLE = 2;

}
