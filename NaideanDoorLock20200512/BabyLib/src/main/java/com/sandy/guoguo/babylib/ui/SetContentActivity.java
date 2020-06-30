package com.sandy.guoguo.babylib.ui;

import android.content.Intent;
import android.text.TextUtils;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import com.sandy.guoguo.babylib.R;
import com.sandy.guoguo.babylib.constant.BabyExtraConstant;
import com.sandy.guoguo.babylib.listener.OnMultiClickListener;
import com.sandy.guoguo.babylib.utils.LogAndToastUtil;
import com.sandy.guoguo.babylib.utils.ResourceUtil;
import com.sandy.guoguo.babylib.utils.Utility;


public class SetContentActivity extends BaseActivity {


    private EditText etName;
    private int position;

    @Override
    protected int getLayoutResId() {
        return R.layout.activity_set_content;
    }


    @Override
    protected void initViewAndControl() {
        String title = getIntent().getStringExtra(BabyExtraConstant.EXTRA_TITLE);
        initNav(title);

        String label = getIntent().getStringExtra(BabyExtraConstant.EXTRA_LABEL);
        TextView tvLabel = findView(R.id.tvLabel);
        tvLabel.setText(label);

        String content = getIntent().getStringExtra(BabyExtraConstant.EXTRA_CONTENT);

        position = getIntent().getIntExtra(BabyExtraConstant.EXTRA_HANDLE_POSITION, -1);

        etName = findView(R.id.etName);
        if (!TextUtils.isEmpty(content)) {
            etName.setText(content);
            etName.setSelection(content.length());
        }
    }

    private void initNav(String title) {
        TextView tvLeft = findView(R.id.toolbarLeft);
        tvLeft.setVisibility(View.VISIBLE);
        ResourceUtil.setCompoundDrawable(tvLeft, R.drawable.dr_ic_back, 0, 0, 0);

        TextView tvRight = findView(R.id.toolbarRight);
        tvRight.setVisibility(View.VISIBLE);
        tvRight.setText(R.string.complete);
        tvRight.setOnClickListener(new OnMultiClickListener() {
            @Override
            public void OnMultiClick(View view) {
                clickRight();
            }
        });

        setTitleStr(title);
    }


    private void clickRight() {
        String content = Utility.getEditTextStr(etName);
        if (TextUtils.isEmpty(content)) {
            LogAndToastUtil.toast(R.string.content_can_not_null);
            return;
        }
        Intent intent = new Intent();
        intent.putExtra(BabyExtraConstant.EXTRA_CONTENT, content);
        intent.putExtra(BabyExtraConstant.EXTRA_HANDLE_POSITION, position);
        setResult(RESULT_OK, intent);

        finish();
    }
}
