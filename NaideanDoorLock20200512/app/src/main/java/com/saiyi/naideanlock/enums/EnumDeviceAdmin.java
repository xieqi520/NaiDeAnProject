package com.saiyi.naideanlock.enums;


import android.support.annotation.IntDef;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

public class EnumDeviceAdmin {
    @Retention(RetentionPolicy.SOURCE)
    @IntDef({
            NOT_ADMIN, IS_ADMIN, NANNY
    })
    public @interface _Type {
    }

    public static final int NOT_ADMIN = 1;
    public static final int IS_ADMIN = 0;
    /**保姆*/
    public static final int NANNY = 2;

}
