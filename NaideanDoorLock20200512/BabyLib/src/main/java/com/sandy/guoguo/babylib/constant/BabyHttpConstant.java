package com.sandy.guoguo.babylib.constant;

/**
 * Created by Liu on 2018/3/16.
 */

public class BabyHttpConstant {


    //public static final String BASE_URL = "http://123.207.96.62:8080/";
    //public static final String BASE_URL = "http://58.250.30.13:13703/";
    public static final String BASE_URL = "http://123.207.96.62/";//:80
    //public static final String BASE_IMAGE_URL = "http://123.207.96.62:8080/";
    //public static final String BASE_IMAGE_URL = "http://58.250.30.13:13703/";
    public static final String BASE_IMAGE_URL = "http://123.207.96.62/";
    /**请求成功*/
    public static final int R_HTTP_OK = 1000;
    /**服务器返回无数据*/
    public static final int R_RESPONSE_NO_DATA = 2;

    /**每页显示的数量*/
    public static final int PER_PAGE_SIZE = 10;

    /**Token过期*/
    public static final int R_TOKEN_EXPIRE = 101;

    public static final int R_HTTP_NO_NEW_MSG = 3001;

    public static final int CHECK_UNNEED = 0;

    public static final int CHECK_NEED = 1;
}
