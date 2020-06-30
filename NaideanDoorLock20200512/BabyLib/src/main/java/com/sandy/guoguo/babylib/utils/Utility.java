package com.sandy.guoguo.babylib.utils;


import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.Paint;
import android.os.Build;
import android.support.annotation.ColorRes;
import android.support.annotation.DimenRes;
import android.support.annotation.StringRes;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.TextUtils;
import android.text.style.AbsoluteSizeSpan;
import android.text.style.ForegroundColorSpan;
import android.util.DisplayMetrics;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.webkit.WebSettings;
import android.widget.TextView;

import com.sandy.guoguo.babylib.R;
import com.sandy.guoguo.babylib.constant.BabyHttpConstant;
import com.sandy.guoguo.babylib.constant.BabyPublicConstant;
import com.sandy.guoguo.babylib.enums.EnumEventBus;
import com.sandy.guoguo.babylib.ui.BaseApp;
import com.sandy.guoguo.babylib.utils.eventbus.EventBusManager;
import com.sandy.guoguo.babylib.utils.eventbus.MdlEventBus;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;
import java.util.Set;

public class Utility {
    public static byte int2byte(int num) {
        short v = (short) num;
        return (byte) (v & 0xFF);
    }

    public static int byte2Uint(byte num) {
        return num & 0xFF;
    }


    /**
     * 跳转到桌面
     */
    public static void goToDesktop(Context context) {
        Intent intent = new Intent(Intent.ACTION_MAIN);
        intent.addCategory(Intent.CATEGORY_HOME);
        intent.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
        context.startActivity(intent);
    }


    /**
     * 线程休眠
     *
     * @param ms 单位：毫秒
     */
    public static void ThreadSleep(long ms) {
        try {
            Thread.sleep(ms);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    public static String byteArray2HexString(byte[] data) {
        StringBuilder sb = new StringBuilder();
        for (byte b : data) {
            sb.append(String.format(" 0x%02X", b));
        }

        return sb.toString();
    }

    /**
     * 获取进程号对应的进程名
     *
     * @return 进程名
     */
    public static String getProcessName() {
        BufferedReader reader = null;
        try {
            int pid = android.os.Process.myPid();
            reader = new BufferedReader(new FileReader("/proc/" + pid + "/cmdline"));
            String processName = reader.readLine();
            if (!TextUtils.isEmpty(processName)) {
                processName = processName.trim();
            }
            return processName;
        } catch (Throwable throwable) {
            throwable.printStackTrace();
        } finally {
            try {
                if (reader != null) {
                    reader.close();
                }
            } catch (IOException exception) {
                exception.printStackTrace();
            }
        }
        return null;
    }

    public static String getRunInfo() {

        try {
            PackageManager manager = BaseApp.ME.getPackageManager();
            PackageInfo info = manager.getPackageInfo(BaseApp.ME.getPackageName(), 0);

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss SSS", Locale.getDefault());

            StringBuilder sb = new StringBuilder();
            sb.append(String.format("Android版本: %s\r\n", Build.VERSION.RELEASE));
            sb.append(String.format("设备型号: %s\r\n", Build.MODEL));
            sb.append(String.format("%s版本: %s\r\n", BabyPublicConstant.APP_NAME, info.versionName));
            sb.append(String.format("Android系统制作 %s\r\n", Build.BRAND));
            sb.append(String.format("时间: %s\r\n", sdf.format(new Date())));

            return sb.toString();
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
            return "";
        }
    }

    public static String getUserAgent() {
        String userAgent = "";
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
            try {
                userAgent = WebSettings.getDefaultUserAgent(BaseApp.ME);
            } catch (Exception e) {
                userAgent = System.getProperty("http.agent");
            }
        } else {
            userAgent = System.getProperty("http.agent");
        }
        StringBuffer sb = new StringBuffer();
        for (int i = 0, length = userAgent.length(); i < length; i++) {
            char c = userAgent.charAt(i);
            if (c <= '\u001f' || c >= '\u007f') {
                sb.append(String.format("\\u%04x", (int) c));
            } else {
                sb.append(c);
            }
        }
        return sb.toString();
    }


    public static Spannable getCommon2LinesSpan(String _1_line, String _2_line, @DimenRes int _1_fontSizeId, @DimenRes int _2_fontSizeId) {
        int len1 = _1_line.length();
        int len2 = len1 + _2_line.length();

        Spannable span = new SpannableString(_1_line + _2_line);
        span.setSpan(new AbsoluteSizeSpan(ResourceUtil.getDimension(_1_fontSizeId)), 0, len1, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        span.setSpan(new AbsoluteSizeSpan(ResourceUtil.getDimension(_2_fontSizeId)), len1, len2, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);

        span.setSpan(new ForegroundColorSpan(ResourceUtil.getColor(R.color.black)), 0, len1, Spannable.SPAN_INCLUSIVE_INCLUSIVE);
        span.setSpan(new ForegroundColorSpan(ResourceUtil.getColor(R.color.gray)), len1, len2, Spannable.SPAN_INCLUSIVE_INCLUSIVE);
        return span;
    }

    public static Spannable getCustomSpan(String content, @DimenRes int fontSize) {
        Spannable span = new SpannableString(content);
        int len1 = content.length();
        span.setSpan(new AbsoluteSizeSpan(ResourceUtil.getDimension(fontSize)), 0, len1, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);

        return span;
    }

    public static Spannable getCustomSpan(@StringRes int resId, @DimenRes int fontSize) {
        String content = BaseApp.ME.getString(resId);
        return getCustomSpan(content, fontSize);
    }

    public static Spannable getCommon2LinesSpan(String _1_line, String _2_line) {
        return getCommon2LinesSpan(_1_line, _2_line, R.dimen.font_16, R.dimen.font_12);
    }

    public static Spannable getCommon2LinesSpan(String _1_line, String _2_line, @ColorRes int colorId) {
        return getCommon2LinesSpan(_1_line, _2_line, R.dimen.font_16, R.dimen.font_12, colorId, colorId);
    }

    public static Spannable getCommon2LinesSpan(String _1_line, String _2_line, @DimenRes int _1_fontSizeId, @DimenRes int _2_fontSizeId, @ColorRes int _1_colorId, @ColorRes int _2_colorId) {
        int len1 = _1_line.length();
        int len2 = len1 + _2_line.length();

        Spannable span = new SpannableString(_1_line + _2_line);
        span.setSpan(new AbsoluteSizeSpan(ResourceUtil.getDimension(_1_fontSizeId)), 0, len1, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        span.setSpan(new AbsoluteSizeSpan(ResourceUtil.getDimension(_2_fontSizeId)), len1, len2, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);

        span.setSpan(new ForegroundColorSpan(ResourceUtil.getColor(_1_colorId)), 0, len1, Spannable.SPAN_INCLUSIVE_INCLUSIVE);
        span.setSpan(new ForegroundColorSpan(ResourceUtil.getColor(_2_colorId)), len1, len2, Spannable.SPAN_INCLUSIVE_INCLUSIVE);
        return span;
    }

    public static String getEditTextStr(TextView editText) {
        if (editText == null) {
            throw new NullPointerException("--骚年，先别忙获取内容，你的EditText为null--");
        }
        return editText.getText().toString().trim();
    }

    public static DisplayMetrics getDisplayScreenSize(Activity context) {
        DisplayMetrics dm = new DisplayMetrics();
        context.getWindowManager().getDefaultDisplay().getMetrics(dm);
        return dm;
    }

    public static void recycleBitmap(Bitmap bmp) {
        if (bmp != null && !bmp.isRecycled()) {
            bmp.recycle();
            bmp = null;
        }
    }

    public static String getPhotoPath() {
        String imagePath = Utility.getDatePath(BaseApp.ME.dirPhoto);
        String fileName = new SimpleDateFormat("dd_HHmmssSSS", Locale.getDefault()).format(new Date()) + ".jpg";
        imagePath = imagePath + "/" + fileName; // 相片储存的绝对路径

        return imagePath;
    }

    private static String getDatePath(String basePath) {
        if (basePath == null) {
            return null;
        }
        String path = basePath;
        if (basePath.endsWith("/") == false) {
            basePath += "/";
        }
        Calendar calendar = Calendar.getInstance();
        path = String.format(Locale.US, "%s%d/%02d", basePath, calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH) + 1);
        File file = new File(path);
        if (!file.exists()) {
            file.mkdirs();
        }
        return path;
    }

    public static String getRemotePicUrlFromServer(String url) {
        return BabyHttpConstant.BASE_IMAGE_URL + url;
    }

    public static String appendSet(Set<Long> set) {
        if (set == null || set.isEmpty()) {
            return "";
        }
        StringBuilder sb = new StringBuilder();
        for (long id : set) {
            sb.append(id).append(",");
        }
        sb.deleteCharAt(sb.length() - 1);

        return sb.toString();
    }

    public static void stopApp() {
        try {
//            android.os.Process.killProcess(android.os.Process.myPid());
//            System.exit(0);
            EventBusManager.post(new MdlEventBus(EnumEventBus.LOGOUT_OK));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void needLogin(Activity activity) {
       BaseSPUtil.saveToken2SP("");

        BaseApp.ME.mdlUserInApp = null;
        Intent intent = new Intent(activity, BaseApp.ME.loginActivityCls);
        activity.startActivity(intent);
        stopApp();
    }

    public static String myFormat(String format, Object... args) {
        return String.format(Locale.getDefault(), format, args);
    }

    public static String getTargetYesterday(Calendar calendar) {
        calendar.add(Calendar.DATE, -1);
        String s = myFormat("%d-%02d-%02d", calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH) + 1, calendar.get(Calendar.DAY_OF_MONTH));
        return s;
    }

    public static String getTargetToday(Calendar calendar) {
        String s = myFormat("%d-%02d-%02d", calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH) + 1, calendar.get(Calendar.DAY_OF_MONTH));
        return s;
    }

    public static String getTargetNextDay(Calendar calendar) {
        calendar.add(Calendar.DATE, +1);
        String s = myFormat("%d-%02d-%02d", calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH) + 1, calendar.get(Calendar.DAY_OF_MONTH));
        return s;
    }

    public static String getTargetYesterday() {
        return getTargetYesterday(Calendar.getInstance());
    }

    public static String getYMD(long mills) {
        return new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault()).format(new Date(mills));
    }

    public static String getYMDHM(long mills) {
        return new SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.getDefault()).format(new Date(mills));
    }

    public static String getYMDHMS(long mills) {
        return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new Date(mills));
    }

    /**
     * 设置下划线
     */
    public static void setUnderline(TextView tvTest) {
        tvTest.getPaint().setFlags(Paint.UNDERLINE_TEXT_FLAG); //下划线
        tvTest.getPaint().setAntiAlias(true);//抗锯齿
    }

    /**
     * 设置中划线
     */
    public static void setStrikethrough(TextView tvTest) {
        tvTest.getPaint().setFlags(Paint.STRIKE_THRU_TEXT_FLAG | Paint.ANTI_ALIAS_FLAG);
    }

    public static void hideSoftKeyboard(Activity activity) {
        InputMethodManager imm = (InputMethodManager) activity.getSystemService(Context.INPUT_METHOD_SERVICE);
        View view = activity.getCurrentFocus();
        if (imm != null && imm.isActive() && view != null) {
            if (view.getWindowToken() != null) {
                imm.hideSoftInputFromWindow(view.getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);
            }
        }
    }

    /**
     * 输入法状态发生逆转
     * 如果使用上面的hideSoftKeyboard();需要正确获取得到焦点的组件，这里用这个方便一点
     */
    public static void toggleSoftKeyboard(Context context) {
        InputMethodManager imm = (InputMethodManager) context.getSystemService(Context.INPUT_METHOD_SERVICE);
        imm.toggleSoftInput(0, InputMethodManager.HIDE_NOT_ALWAYS);
    }

    /**
     * MD5加密
     *
     * @param str     内容
     * @throws Exception
     */
    public static String Md5(String str){
        MessageDigest md = null;
        try {
            md = MessageDigest.getInstance("MD5");
            md.update(str.getBytes("UTF-8"));
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        if(md == null){
            throw new IllegalArgumentException("创建MD5失败----------");
        }
        byte[] result = md.digest();
        StringBuffer sb = new StringBuffer(32);
        for (int i = 0; i < result.length; i++) {
            int val = result[i] & 0xff;
            if (val <= 0xf) {
                sb.append("0");
            }
            sb.append(Integer.toHexString(val));
        }
        return sb.toString().toLowerCase();
    }

    public static String getVersionInfo() {
        try {
            PackageManager pm = BaseApp.ME.getPackageManager();
            PackageInfo info = pm.getPackageInfo(BaseApp.ME.getPackageName(), 0);
            return info.versionName;
        } catch (Exception e) {
            e.printStackTrace();
            return "版本号未知";
        }
    }
}
