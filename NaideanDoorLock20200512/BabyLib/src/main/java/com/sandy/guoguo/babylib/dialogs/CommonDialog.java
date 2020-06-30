package com.sandy.guoguo.babylib.dialogs;

import android.content.Context;
import android.os.Bundle;
import android.support.annotation.ColorRes;
import android.support.annotation.NonNull;
import android.support.v7.app.AlertDialog;
import android.text.TextUtils;
import android.view.View;
import android.widget.TextView;

import com.sandy.guoguo.babylib.R;
import com.sandy.guoguo.babylib.utils.ResourceUtil;


/**
 * Created by Administrator on 2017/7/30.
 */

public class CommonDialog extends AlertDialog implements View.OnClickListener {
    private ClickListener listener;
    private String title;
    private String msg;

    @ColorRes
    private int btnColor;


    public CommonDialog(@NonNull Context context, String title, String msg, ClickListener listener) {
        this(context, title, msg,R.color.del_color, listener);
    }
    public CommonDialog(@NonNull Context context, String title, String msg, @ColorRes int btnColor, ClickListener listener) {
        super(context, R.style.dialog);
        this.title = title;
        this.msg = msg;
        this.btnColor = btnColor;
        this.listener = listener;
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.dialog_common);

        initViewAndControl();
    }

    private void initViewAndControl() {
        TextView tvTitle = findViewById(R.id.tvTitle);
        if (TextUtils.isEmpty(title)) {
            tvTitle.setVisibility(View.GONE);
        } else {
            tvTitle.setVisibility(View.VISIBLE);
            tvTitle.setText(title);
        }

        TextView tvMsg = findViewById(R.id.tvMsg);
        if (TextUtils.isEmpty(msg)) {
            tvMsg.setVisibility(View.GONE);
        } else {
            tvMsg.setVisibility(View.VISIBLE);
            tvMsg.setText(msg);
        }

        findViewById(R.id.tv_cancel).setOnClickListener(this);
        TextView tvConfirm = findViewById(R.id.tv_confirm);
        if(btnColor != 0){
            tvConfirm.setTextColor(ResourceUtil.getColor(btnColor));
        }
        tvConfirm.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        int i = v.getId();
        if (i == R.id.tv_cancel) {
            listener.clickCancel();

        } else if (i == R.id.tv_confirm) {
            listener.clickConfirm();

        }
        dismiss();
    }

    public interface ClickListener {
        void clickConfirm();

        void clickCancel();
    }
}
