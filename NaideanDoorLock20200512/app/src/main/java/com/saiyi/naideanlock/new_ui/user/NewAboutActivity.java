package com.saiyi.naideanlock.new_ui.user;

import android.view.View;
import android.widget.TextView;

import com.saiyi.naideanlock.R;
import com.sandy.guoguo.babylib.ui.BaseActivity;
import com.sandy.guoguo.babylib.utils.ResourceUtil;
import com.sandy.guoguo.babylib.utils.Utility;

public class NewAboutActivity extends BaseActivity {
    @Override
    protected int getTitleResId() {
        return R.string.about_us;
    }

    @Override
    protected int getLayoutResId() {
        return R.layout.activity_new_about;
    }

    @Override
    protected void initViewAndControl() {
        initNav();

        TextView tvVersion = findView(R.id.tvVersion);
        tvVersion.setText(Utility.myFormat("V%s \n 耐得安", Utility.getVersionInfo()));
    }

    private void initNav() {
        TextView tvLeft = findView(R.id.toolbarLeft);
        tvLeft.setVisibility(View.VISIBLE);
        ResourceUtil.setCompoundDrawable(tvLeft, R.drawable.dr_ic_back, 0, 0, 0);
    }
}
