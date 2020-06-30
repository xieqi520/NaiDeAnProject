package me.iwf.photopicker.utils;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.support.v4.app.Fragment;
import android.support.v4.content.FileProvider;

import java.io.File;

/**
 * Created by Administrator on 2017/6/16.
 * -解决 Android N 上 报错：android.os.FileUriExposedException
 */

public class MyFileProviderUtil {
    /**
     * 适配android 7.0，大于等于7.0时，通过fileprovider给uri
     * @param context
     * @param file
     * @return
     */
    public static Uri getUriForFile(Context context, File file) {
        if (context == null || file == null) {
            throw new NullPointerException();
        }
        Uri uri;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            uri = FileProvider.getUriForFile(context.getApplicationContext(), context.getPackageName()+".fileprovider", file);
        } else {
            uri = Uri.fromFile(file);
        }
        return uri;
    }
    public static Uri getUriForFile(Object context, String path) {
        File file = new File(path);
        if (context == null) {
            throw new NullPointerException();
        }
        if (context instanceof Fragment) {
            return getUriForFile(((Fragment) context).getContext(), file);
        } else if (context instanceof Activity) {
            return getUriForFile((Activity) context, file);
        } else if (context instanceof Context){
            return getUriForFile((Context) context, file);
        }else {
            throw new IllegalArgumentException("非法上下文对象裁剪图片");
        }
    }


    /**
     * 调取图片时，intent适配android 7.0
     * @param it
     * @return
     */
    public static Intent fitAPI24(Intent it){
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.N){
            it.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
        }
        return it;
    }

}

