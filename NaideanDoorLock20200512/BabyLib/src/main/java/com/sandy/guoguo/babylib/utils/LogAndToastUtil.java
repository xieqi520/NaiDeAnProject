package com.sandy.guoguo.babylib.utils;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.support.annotation.StringRes;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import com.sandy.guoguo.babylib.R;
import com.sandy.guoguo.babylib.constant.BabyPublicConstant;
import com.sandy.guoguo.babylib.ui.BaseApp;

import java.util.HashMap;
import java.util.Stack;

public class LogAndToastUtil {
    // 等待加载进度条对话框的 集合
    private static HashMap<Class<?>, Stack<ProgressDialog>> dicWait;

    /**
     * 弹出提示 使用静态成员变量保证toast不延时
     */
    private static Toast toast;

    public static void toast(@StringRes int resId, Object... args) {
        toastShowLengthTime(ResourceUtil.getString(resId), Toast.LENGTH_SHORT, args);
    }

    public static void toast(String s, Object... args) {

        toastShowLengthTime(s, Toast.LENGTH_SHORT, args);
    }

    private static void toastShowLengthTime(String s, int duration, Object... args) {
        if (args != null && args.length > 0) {
            s = String.format(s, args);
        }

        if (toast == null) {
            toast = Toast.makeText(BaseApp.ME, "", duration);
            toast.setGravity(Gravity.CENTER, 0, 0);
        }

        toast.setText(s);
        toast.show();
    }

    public static void toastCustomView(LayoutInflater inflater, int width, String msg) {
        if (toast == null) {
            toast = Toast.makeText(BaseApp.ME, "", Toast.LENGTH_SHORT);
            toast.setGravity(Gravity.CENTER, 0, 0);
        }
        View view = inflater.inflate(R.layout.dialog_alert, null);
        TextView tvMsg = view.findViewById(R.id.tvMsg);
        tvMsg.setWidth(width);
        tvMsg.setHeight(width);
        tvMsg.setText(msg);
        toast.setView(view);
        toast.show();
    }

    public static void clearToast() {
        if (toast != null) {
            toast.cancel();
            toast = null;
        }

    }


    /**
     * 打印日志
     */
    public static void log(String s, Object... args) {
        if (!BabyPublicConstant.isDebug) {
            return;
        }
        if (args != null && args.length > 0) {
            s = String.format(s, args);
        }

        Log.i("--LP--", s);
    }

    public static ProgressDialog showWait(Context context, String message) {
        return showWait(context, message, true);
    }
    public static ProgressDialog showWait(Context context, @StringRes int resId) {
        return showWait(context, ResourceUtil.getString(resId));
    }

    public static ProgressDialog showWaitNoCanceledOutside(Context context, String message) {
        return showWait(context, message, false);
    }

    public static ProgressDialog showWait(Context context, String message, boolean canceledOutside) {

        ProgressDialog pd = new ProgressDialog(context);
        pd.setProgressStyle(ProgressDialog.STYLE_SPINNER);
        pd.setCanceledOnTouchOutside(canceledOutside);
        pd.setMessage(message);
        pd.setIndeterminate(true);
        pd.setCancelable(true);
        pd.show();

        if (dicWait == null) {
            dicWait = new HashMap<>();
        }
        Stack<ProgressDialog> stack = dicWait.get(context.getClass());
        if (stack == null) {
            stack = new Stack<>();
            dicWait.put(context.getClass(), stack);
        }
        stack.push(pd);
        return pd;
    }

    public static void clearWait(Context context) {
        if (context == null) {
            dicWait.clear();
        } else {
            Stack<ProgressDialog> stack = dicWait.get(context.getClass());
            if (stack != null) {
                stack.clear();
            }
            dicWait.remove(context.getClass());
        }
    }

    public static void cancelWaitOnUi(Activity activity) {
        activity.runOnUiThread(new CancelWaitRunnable(activity));
    }

    /**
     * CancelWait 辅助类
     */
    static class CancelWaitRunnable implements Runnable {
        private Context c;

        public CancelWaitRunnable(Context c) {
            this.c = c;
        }

        public void run() {
            cancelWait(c);
        }
    }

    public static void cancelWait(Context context) {
        try {
            if (context == null) {
                return;
            }
            Stack<ProgressDialog> stack = dicWait.get(context.getClass());
            if (stack != null && stack.size() > 0) {
                ProgressDialog pd = stack.pop();
                if (pd.isShowing()) {
                    pd.cancel();
                }
                if (stack.size() == 0) {
                    dicWait.remove(context.getClass());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
