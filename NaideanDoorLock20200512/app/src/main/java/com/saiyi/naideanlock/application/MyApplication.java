package com.saiyi.naideanlock.application;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;

import com.lib.zxing.activity.ZXingLibrary;
import com.saiyi.naideanlock.enums.EnumDeviceLink;
import com.saiyi.naideanlock.new_ui.basis.NewLoginActivity;
import com.saiyi.naideanlock.ui.LauncherActivity;
import com.sandy.guoguo.babylib.ui.BaseApp;

import java.util.ArrayList;
import java.util.List;


/**
 * 描述：
 * 创建作者：Fanjianchang
 * 创建时间：2017/9/20 14:00
 */

public class MyApplication extends BaseApp {

    private static MyApplication instance;

    private Context context;

    public static List<Activity> activitiesList;

    public boolean isDebug = false;

    public int deviceLinkType = EnumDeviceLink.BLE;
    public final String UNLOCK_APP = "0";

    /**
     * 获取application对象
     *
     * @return
     */
    public static MyApplication getInstance() {
        return instance;
    }

    @Override
    public void onCreate() {
        super.onCreate();
        instance = this;

        /*
         * 为什么要做这个赋值呢？哈哈 BabyLib的Utility.needLogin()看看就明白了
         */
        loginActivityCls = NewLoginActivity.class;

        activitiesList = new ArrayList<>();
        context = this.getApplicationContext();

        ZXingLibrary.initDisplayOpinion(this);

//        initOkhttp();

//        if (BuildConfig.IS_DEBUG) {
//            isDebug = true;
//        } else {
//            isDebug = false;
//        }
//
//        if (isDebug) { //如果是debug模式就把错误信息打印保存在本地
//            CrashHandler crashHandler = CrashHandler.getInstance();
//            crashHandler.init(getApplicationContext());
//        }
//
//        if (!isDebug) {//如果不是debug模式 就重启app
//            Thread.setDefaultUncaughtExceptionHandler(restartHandler);
//        }
    }

    /**
     * 初始化OkHttpUtils
     */
    private void initOkhttp() {
//        HttpsUtils.SSLParams params = HttpsUtils.getSslSocketFactory(null, null, null);
//        OkHttpClient okHttpClient = new OkHttpClient.Builder()
//                .sslSocketFactory(params.sSLSocketFactory, params.trustManager)//允许使用https
//                .connectTimeout(10000L, TimeUnit.MILLISECONDS)
//                .readTimeout(10000L, TimeUnit.MILLISECONDS)
//                //其他配置
//                .build();
//        OkHttpUtils.initClient(okHttpClient);
    }

    /**
     * 获取app的上下文
     *
     * @return
     */
    public Context getAppContext() {
        return context;
    }

    /**
     * 加入activity
     *
     * @param activity
     */
    public void addActivityToList(Activity activity) {
        if (!activitiesList.contains(activity)) {
            activitiesList.add(activity);
        }
    }

    /**
     * 移除activity
     *
     * @param activity
     */
    public void removeActiviyFromList(Activity activity) {
        if (activitiesList.contains(activity)) {
            activitiesList.remove(activity);
        }
    }

    /**
     * 程序退出
     */
    public void clearActivity() {
        for (Activity activity : activitiesList) {
            if (activity != null) {
                activity.finish();
            }
        }
    }


    // 创建服务用于捕获崩溃异常
    private Thread.UncaughtExceptionHandler restartHandler = new Thread.UncaughtExceptionHandler() {
        public void uncaughtException(Thread thread, Throwable ex) {
            restartApp();//发生崩溃异常时,重启应用
        }
    };

    /**
     * 重启app
     */
    public void restartApp() {
        Intent intent = new Intent(instance, LauncherActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        instance.startActivity(intent);
        clearActivity();
        android.os.Process.killProcess(android.os.Process.myPid());  //结束进程之前可以把你程序的注销或者退出代码放在这段代码之前
    }

    public void setIsDebug(boolean isDebug) {
        this.isDebug = isDebug;
    }
}
