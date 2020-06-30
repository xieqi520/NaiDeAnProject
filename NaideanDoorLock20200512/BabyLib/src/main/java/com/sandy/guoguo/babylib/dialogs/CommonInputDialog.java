package com.sandy.guoguo.babylib.dialogs;

import android.content.Context;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v7.app.AlertDialog;
import android.text.InputType;
import android.text.TextUtils;
import android.view.View;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.TextView;

import com.sandy.guoguo.babylib.R;
import com.sandy.guoguo.babylib.utils.LogAndToastUtil;
import com.sandy.guoguo.babylib.utils.Utility;


/**
 * Created by Administrator on 2017/7/30.
 * 注意：此dialog的布局的EditText对长度限制为5
 */

public class CommonInputDialog extends AlertDialog implements View.OnClickListener {
    private ClickListener listener;
    private EditText etName;
    private String title;
    private String hintMsg;
    private boolean isPwdET;


    public CommonInputDialog(@NonNull Context context, String title, String hintMsg, ClickListener listener) {
        this(context, title, hintMsg, listener, false);
    }

    public CommonInputDialog(@NonNull Context context, String title, String hintMsg, ClickListener listener, boolean isPwdET) {
        super(context, R.style.dialog);
        this.title = title;
        this.hintMsg = hintMsg;
        this.listener = listener;
        this.isPwdET = isPwdET;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().clearFlags(WindowManager.LayoutParams.FLAG_ALT_FOCUSABLE_IM);
        setContentView(R.layout.dialog_input_common);

        initViewAndControl();
    }

    private void initViewAndControl() {
        TextView tvTitle = findViewById(R.id.tvTitle);
        tvTitle.setText(title);
        etName = findViewById(R.id.etName);
        if (!TextUtils.isEmpty(hintMsg)) {
            etName.setHint(hintMsg);
        }
        if (isPwdET) {
            etName.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD);
        }

        findViewById(R.id.tv_cancel).setOnClickListener(this);
        findViewById(R.id.tv_confirm).setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        int i = v.getId();
        if (i == R.id.tv_cancel) {
            listener.clickCancel();

        } else if (i == R.id.tv_confirm) {
            String name = Utility.getEditTextStr(etName);
            if (TextUtils.isEmpty(name)) {
                LogAndToastUtil.toast(R.string.content_can_not_null);
                return;
            }
            listener.clickConfirm(name);

        }
        dismiss();
    }

    public interface ClickListener {
        void clickConfirm(String content);

        void clickCancel();
    }
}
