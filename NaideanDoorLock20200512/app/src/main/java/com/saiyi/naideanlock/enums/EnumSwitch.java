package com.saiyi.naideanlock.enums;


import android.support.annotation.IntDef;
import android.support.annotation.StringDef;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

public class EnumSwitch {
    @Retention(RetentionPolicy.SOURCE)
    @IntDef({
            ON, OFF
    })
    public @interface _Status {
    }

    public static final int ON = 1;
    public static final int OFF = 0;

}
