package com.saiyi.naideanlock.utils;

import android.text.format.DateFormat;
import android.util.Log;

import com.saiyi.naideanlock.application.MyApplication;
import com.saiyi.naideanlock.config.Config;

/**
 * 描述：日志输出辅助类  设置是否将日志输出保存到本地文件夹
 * 创建作者：ask
 * 创建时间：2017/10/31 15:39
 */

public class LogUtil {

    /**
     * 设置时间的格式
     */
    private static final String INFORMAT = "yyyy-MM-dd HH:mm:ss";

    public LogUtil() {

    }


    /**
     * 错误日志
     *
     * @param tag
     * @param message
     */
    public static void e(String tag, String message) {
        if (MyApplication.getInstance().isDebug) {
            Log.e(tag, message);
            write(tag, message);
        }
        Log.e(tag, message);
    }

    public static void v(String tag, String message) {
        if (MyApplication.getInstance().isDebug) {
            Log.v(tag, message);
            write(tag, message);
        }
        Log.v(tag, message);
    }

    public static void d(String tag, String message) {
        if (MyApplication.getInstance().isDebug) {
            Log.d(tag, message);
            write(tag, message);
        }
        Log.d(tag, message);
    }

    public static void i(String tag, String message) {
        if (MyApplication.getInstance().isDebug) {
            Log.i(tag, message);
            write(tag, message);
        }
        Log.i(tag, message);
    }

    public static void w(String tag, String message) {
        if (MyApplication.getInstance().isDebug) {
            Log.w(tag, message);
            write(tag, message);
        }
        Log.w(tag, message);
    }

    /**
     * 用于把日志内容写入制定的文件
     *
     * @param @param tag 标识
     * @param @param msg 要输出的内容
     * @return void 返回类型
     * @throws
     */
    private static void write(String tag, String msg) {
        String log = DateFormat.format(INFORMAT, System.currentTimeMillis())
                + "  "
                + tag
                + "  "
                + msg
                + "\n";
        FileUtil.writeTxtToFile(log,Config.FILE_PATH , Config.FILE_NAME);
    }

}
