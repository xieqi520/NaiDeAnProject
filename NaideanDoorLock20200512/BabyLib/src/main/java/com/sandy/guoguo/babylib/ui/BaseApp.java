package com.sandy.guoguo.babylib.ui;

import android.app.Application;
import android.os.Environment;
import android.text.TextUtils;

import com.sandy.guoguo.babylib.constant.BabyPublicConstant;
import com.sandy.guoguo.babylib.entity.MdlUser;
import com.sandy.guoguo.babylib.http.HttpManager;
import com.sandy.guoguo.babylib.utils.BaseSPUtil;
import com.sandy.guoguo.babylib.utils.LogAndToastUtil;
import com.sandy.guoguo.babylib.utils.NetWorkChangReceiver;
import com.sandy.guoguo.babylib.utils.Utility;

import java.io.File;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.Locale;

public abstract class BaseApp extends Application {
    public static BaseApp ME;

    public String dirPhoto;

    public MdlUser mdlUserInApp;

    private NetWorkChangReceiver netWorkChangReceiver;


    public Class loginActivityCls,tabActivityCls;

    @Override
    public void onCreate() {
        super.onCreate();

        long startTime = System.currentTimeMillis();

        //使用多进程时，只初始化一次
        LogAndToastUtil.log("============BaseApp进程:%s  进程2:%s", getPackageName(), Utility.getProcessName());
        if (TextUtils.equals(getPackageName(), Utility.getProcessName())) {
            ME = this;

            mdlUserInApp = BaseSPUtil.getUserFromSP();

            prepareSD();

            initDB();
            initRetrofit();
            initZXingDisplayOpinion();
            forGlobalException();
            registerNetWorkReceiver();
        }
        LogAndToastUtil.log("============进程--启动:%s", System.currentTimeMillis()-startTime);
    }



    private void registerNetWorkReceiver(){
        netWorkChangReceiver = new NetWorkChangReceiver();
//        IntentFilter filter = new IntentFilter();
//        filter.addAction(ConnectivityManager.CONNECTIVITY_ACTION);
////        filter.addAction(WifiManager.WIFI_STATE_CHANGED_ACTION);
////        filter.addAction(WifiManager.NETWORK_STATE_CHANGED_ACTION);
//        registerReceiver(netWorkChangReceiver, filter);
        netWorkChangReceiver.registerThis(this);
    }

    private void unregisterNetWorkReceiver(){
        if(netWorkChangReceiver != null){
            netWorkChangReceiver.unregisterThis(this);
            netWorkChangReceiver = null;
        }
    }



    private void initDB() {
//        DBManager.getInstance().initDBManager(this);
    }

    private void initZXingDisplayOpinion() {
//        ZXingLibrary.initDisplayOpinion(this);
    }

    private void initRetrofit() {
        HttpManager.getInstance().init();
    }

    private void forGlobalException() {
        Thread.setDefaultUncaughtExceptionHandler(new Thread.UncaughtExceptionHandler() {// 给主线程设置处理运行时异常的handler
            private int errCount = 0;

            @Override
            public void uncaughtException(Thread thread, final Throwable ex) {
                if (errCount > 0) {
                    stop();
                    return;
                }
                errCount++;
                ex.printStackTrace();
                StringWriter sw = new StringWriter();
                PrintWriter pw = new PrintWriter(sw);
                ex.printStackTrace(pw);
                pw.close();
                StringBuilder sb = new StringBuilder();
                sb.append(Utility.getRunInfo());
                sb.append(sw.toString());
                // CallParameter<Integer> call = new
                // CallParameter<Integer>(null) {
                // @Override
                // public void onComplete(Integer result, Exception exception) {
                // if (exception != null) {
                // MyApp.log("写远程日志出�? \r\n%s", exception);
                // }
                // stop();
                // }
                // };
                try {
                    String from = "";
                    StackTraceElement[] arr = ex.getStackTrace();
                    for (StackTraceElement item : arr) {
                        String className = item.getClassName();
                        if (className.indexOf("mvp") != -1) {
                            int i = className.lastIndexOf(".");
                            if (i != -1) {
                                className = className.substring(i + 1);
                            }
                            from = String.format(Locale.US, "%s:%d %s.%s", item.getFileName(), item.getLineNumber(), className, item.getMethodName());
                            break;
                        }
                    }
                    String title = ex.getClass().getSimpleName() + ": " + ex.getMessage();

                    // RemoteThread.WriteLog(call, from, title, sb.toString());//
                    // 写入远程日志

                    LogAndToastUtil.log("%s异常 结束: \r\n%s", BabyPublicConstant.APP_NAME, sb.toString());

                    stop();
                } catch (Exception e) {
                    LogAndToastUtil.log("异常结束处理出错: \r\n%s", e);
                }
            }
        });
    }


    private void stop() {
        try {
            android.os.Process.killProcess(android.os.Process.myPid());
            System.exit(0);
        } catch (Exception e) {
        }
    }

    private void prepareSD() {
        if (Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED)) {
            String sdCardPath = Environment.getExternalStorageDirectory().toString();
            String basePath = BabyPublicConstant.APP_NAME;
            basePath = sdCardPath + "/" + basePath;
            basePath = basePath.replace("//", "/");
            if (basePath.endsWith("/")) {
                basePath = basePath.substring(0, basePath.length() - 1);
            }
            dirPhoto = basePath + "/photo";
            File dir = new File(dirPhoto);
            if (!dir.exists()) {
                dir.mkdirs();
            }
        }
    }

    @Override
    public void onTerminate() {
        super.onTerminate();
        ME = null;
        LogAndToastUtil.clearToast();
        unregisterNetWorkReceiver();
    }
}
