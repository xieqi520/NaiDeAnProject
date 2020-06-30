package com.sandy.guoguo.babylib.enums;

import android.support.annotation.StringDef;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

public class EnumQrCode {
    @Retention(RetentionPolicy.SOURCE)
    @StringDef({
            QR_TYPE_NO_LIMIT,QR_TYPE_WEB_LOGIN, QR_TYPE_TEAM_DETAIL
    })
    public @interface QrCodeType {
    }

    public static final String QR_TYPE_NO_LIMIT = "0";

    public static final String QR_TYPE_WEB_LOGIN = "1";
    public static final String QR_TYPE_TEAM_DETAIL = "2";

}
