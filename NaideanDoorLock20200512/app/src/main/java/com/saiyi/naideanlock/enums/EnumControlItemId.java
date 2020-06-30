package com.saiyi.naideanlock.enums;


import android.support.annotation.IntDef;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

public class EnumControlItemId {
    @Retention(RetentionPolicy.SOURCE)
    @IntDef({
            CAMERA, AUTHORIZATION, UNLOCK, ABOUT_SETTING, RECORD, USER
    })
    public @interface _Type {
    }

    public static final int CAMERA = 1 << 1;
    public static final int AUTHORIZATION = 1 << 2;
    public static final int UNLOCK = 1 << 3;
    public static final int ABOUT_SETTING = 1 << 4;
    public static final int RECORD = 1 << 5;
    public static final int USER = 1 << 6;

}
