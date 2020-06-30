package com.sandy.guoguo.babylib.listener;

import okhttp3.ResponseBody;

/**
 * Created by Administrator on 2018/4/17.
 */

public interface OnLoadHttpDataListener<T> {
    void onSuccess(int code, ResponseBody data);
    void onSuccess(int code, T data);
    void onFailure(int code, Throwable e);
}
