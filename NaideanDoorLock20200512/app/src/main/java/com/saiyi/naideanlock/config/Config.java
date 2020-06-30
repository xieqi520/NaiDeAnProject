package com.saiyi.naideanlock.config;

/**
 * 描述：
 * 创建作者：Fanjianchang
 * 创建时间：2017/9/20 15:09
 */

public class Config {

    /**
     * 用来保存输出日志的文件路径
     */
    public final static String FILE_PATH = "/sdcard/NaideanFil/";

    /**
     * 用来保存输出日志的文件名
     */
    public final static String FILE_NAME = "log.txt";

    /**
     * SharedPreferences本地保存的文件名
     */
    public final static String SPF_FILE_NAME = "sharedPreferences";

    /**
     * 是否登录过
     */
    public final static String IS_LOGIN = "is_login";

    /**
     * 登录用户名
     */
    public static String LOGIN_USER_NAME = "login_user_name";

    /**
     * 登录密码
     */
    public static String LOGIN_PASS_WORLD = "login_pass_world";

    public static final int CHECK_CODE_MAX_COUNT_DOWN_TIME = 60;

}
