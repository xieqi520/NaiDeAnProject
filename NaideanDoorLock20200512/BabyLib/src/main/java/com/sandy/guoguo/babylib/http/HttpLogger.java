package com.sandy.guoguo.babylib.http;


import com.sandy.guoguo.babylib.utils.LogAndToastUtil;

import okhttp3.logging.HttpLoggingInterceptor;

public class HttpLogger implements HttpLoggingInterceptor.Logger{
    @Override
    public void log(String message) {
        LogAndToastUtil.log("--OKHttp--message:%s", message);
    }
}
