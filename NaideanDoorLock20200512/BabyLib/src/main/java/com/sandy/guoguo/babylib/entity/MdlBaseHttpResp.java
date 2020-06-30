package com.sandy.guoguo.babylib.entity;

import com.google.gson.annotations.SerializedName;

/**
 * Created by Administrator on 2018/6/6.
 */

public class MdlBaseHttpResp<T> {
    public int code;
    public String message;
    public int totalItems;

    public T data;
    public boolean success;

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    @Override
    public String toString() {
        return "MdlBaseHttpResp{" +
                "code=" + code +
                ", message='" + message + '\'' +
                ", totalItems=" + totalItems +
                ", data=" + data +
                '}';
    }
}
