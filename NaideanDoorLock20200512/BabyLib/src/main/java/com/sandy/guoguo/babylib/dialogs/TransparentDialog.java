package com.sandy.guoguo.babylib.dialogs;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v7.app.AlertDialog;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.widget.TextView;

import com.sandy.guoguo.babylib.R;
import com.sandy.guoguo.babylib.utils.Utility;


/**
 * Created by Administrator on 2017/7/30.
 */

public class TransparentDialog extends AlertDialog {
    private String msg;


    public TransparentDialog(@NonNull Context context, String msg) {
        super(context, R.style.transparentDialog);
        this.msg = msg;
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Window window = this.getWindow();
        window.setGravity(Gravity.CENTER);
        DisplayMetrics dm = Utility.getDisplayScreenSize((Activity) getContext());
        window.setLayout(dm.widthPixels / 3, dm.widthPixels / 3);
        setContentView(R.layout.dialog_transparent);

        initViewAndControl();
    }

    private void initViewAndControl() {
        TextView tvMsg = findViewById(R.id.tvMsg);
        if (TextUtils.isEmpty(msg)) {
            tvMsg.setVisibility(View.GONE);
        } else {
            tvMsg.setVisibility(View.VISIBLE);
            tvMsg.setText(msg);
        }

    }
}
