package com.saiyi.naideanlock.enums;


import android.support.annotation.IntDef;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

public class EnumCheckCode {
    @Retention(RetentionPolicy.SOURCE)
    @IntDef({
            REGISTER, FIND_PWD, CHANGE_BIND_PHONE
    })
    public @interface _Type {
    }

    public static final int REGISTER = 0;
    public static final int FIND_PWD = 1;
    public static final int CHANGE_BIND_PHONE = 2;

}
