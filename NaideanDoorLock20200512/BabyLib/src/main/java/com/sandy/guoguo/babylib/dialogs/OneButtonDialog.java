package com.sandy.guoguo.babylib.dialogs;

import android.content.Context;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v7.app.AlertDialog;
import android.text.TextUtils;
import android.view.View;
import android.widget.TextView;

import com.sandy.guoguo.babylib.R;


/**
 * Created by Administrator on 2017/7/30.
 */

public class OneButtonDialog extends AlertDialog implements View.OnClickListener {
    private ClickListener listener;
    private String msg;


    public OneButtonDialog(@NonNull Context context, String msg, ClickListener listener) {
        super(context, R.style.dialog);
        this.msg = msg;
        this.listener = listener;
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.dialog_one_button);

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

        findViewById(R.id.tvClose).setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        int i = v.getId();
        if (i == R.id.tvClose) {
            listener.clickConfirm();

        }
        dismiss();
    }

    public interface ClickListener {
        void clickConfirm();
    }
}
