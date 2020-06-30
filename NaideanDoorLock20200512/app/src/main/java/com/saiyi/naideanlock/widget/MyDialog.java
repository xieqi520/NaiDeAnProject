package com.saiyi.naideanlock.widget;

import android.app.Dialog;
import android.content.Context;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;

public class MyDialog extends Dialog {
    private static int default_width = 160; //默认宽度
    private static int default_height = 200;//默认高度

    public MyDialog(Context context, View layout, int style) {
        this(context, default_width, default_height, layout, style);
    }

    public MyDialog(Context context, int width, int height, View layout, int style) {
        super(context, style);
        setContentView(layout);
        Window window = getWindow();
        WindowManager.LayoutParams params = window.getAttributes();
        params.width=WindowManager.LayoutParams.MATCH_PARENT;
        params.gravity = Gravity.CENTER;
        setCanceledOnTouchOutside(false);
        window.setAttributes(params);
    }
    public MyDialog(Context context, int width, int height, View layout, int style, int flag) {
        super(context, style);
        setContentView(layout);
        Window window = getWindow();
        WindowManager.LayoutParams params = window.getAttributes();
        params.width=WindowManager.LayoutParams.WRAP_CONTENT;
        params.gravity = Gravity.CENTER;
        setCanceledOnTouchOutside(false);
        window.setAttributes(params);
    }
    public MyDialog(Context context, View layout, int style, int type) {
        super(context, style);
        setContentView(layout);
        Window window = getWindow();
        WindowManager.LayoutParams params = window.getAttributes();
        params.width=WindowManager.LayoutParams.MATCH_PARENT;
        params.gravity = Gravity.BOTTOM;
        setCanceledOnTouchOutside(true);
        window.setAttributes(params);

    }
}
