package com.saiyi.naideanlock.utils;

import android.content.Context;
import android.view.Gravity;
import android.widget.Toast;

/**
 * 描述：Toast提示工具类
 * 创建作者：ask
 * 创建时间：2017/10/31 15:19
 */

public class ToastUtil {

    public ToastUtil() {

    }

    /**
     * 短时间显示提示信息
     *
     * @param context 上下文
     * @param message 提示信息
     */
    public static void toastShort(Context context, String message) {
        showToast(context, message, Toast.LENGTH_SHORT);
    }

    /**
     * 短时间提示信息
     *
     * @param context   上下文
     * @param resources 提示信息资源索引
     */
    public static void toastShort(Context context, int resources) {
        showToast(context, context.getString(resources), Toast.LENGTH_SHORT);
    }

    /**
     * 长时间提示信息
     *
     * @param context 上下文
     * @param message 提示信息
     */
    public static void toastLong(Context context, String message) {
        showToast(context, message, Toast.LENGTH_LONG);
    }

    /**
     * 长时间提示信息
     *
     * @param context   上下文
     * @param resources 提示信息索引
     */
    public static void toastLong(Context context, int resources) {
        showToast(context, context.getString(resources), Toast.LENGTH_LONG);
    }

    /**
     * 短时间中部提示语
     *
     * @param context 上下文
     * @param message 提示信息
     */
    public static void toastShortCenter(Context context, String message) {
        toastGravity(context, message, Toast.LENGTH_SHORT, Gravity.CENTER);
    }

    /**
     * 短时间中部提示语
     *
     * @param context   上下文
     * @param resources 提示信息索引
     */
    public static void toastShortCenter(Context context, int resources) {
        toastGravity(context, context.getString(resources), Toast.LENGTH_SHORT, Gravity.CENTER);
    }

    /**
     * 长时间中部提示语
     *
     * @param context 上下文
     * @param message 提示信息
     */
    public static void toastLongCenter(Context context, String message) {
        toastGravity(context, message, Toast.LENGTH_LONG, Gravity.CENTER);
    }


    /**
     * 长时间中部提示语
     *
     * @param context
     * @param resources
     */
    public static void toastLongCenter(Context context, int resources) {
        toastGravity(context, context.getString(resources), Toast.LENGTH_LONG, Gravity.CENTER);
    }

    private static void toastGravity(Context context, String message, int duration, int gravity) {
        Toast toast = Toast.makeText(context, message, duration);
        toast.setGravity(gravity, 0, 0);
        toast.show();
    }

    private static void showToast(Context context, String message, int duration) {
        Toast toast = Toast.makeText(context, message, duration);
        toast.show();
    }
}
