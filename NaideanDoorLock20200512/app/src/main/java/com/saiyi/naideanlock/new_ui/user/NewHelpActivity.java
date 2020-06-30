package com.saiyi.naideanlock.new_ui.user;

import android.view.View;
import android.widget.TextView;

import com.saiyi.naideanlock.R;
import com.sandy.guoguo.babylib.ui.BaseActivity;
import com.sandy.guoguo.babylib.utils.ResourceUtil;

public class NewHelpActivity extends BaseActivity {
    @Override
    protected int getTitleResId() {
        return R.string.help;
    }

    @Override
    protected int getLayoutResId() {
        return R.layout.activity_new_help;
    }

    @Override
    protected void initViewAndControl() {
        initNav();

    }

    private void initNav() {
        TextView tvLeft = findView(R.id.toolbarLeft);
        tvLeft.setVisibility(View.VISIBLE);
        ResourceUtil.setCompoundDrawable(tvLeft, R.drawable.dr_ic_back, 0, 0, 0);
    }
}
