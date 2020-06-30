package com.saiyi.naideanlock.new_ui.device;

import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.saiyi.naideanlock.R;
import com.sandy.guoguo.babylib.constant.BabyExtraConstant;
import com.sandy.guoguo.babylib.ui.BaseActivity;
import com.sandy.guoguo.babylib.utils.ResourceUtil;

public class NewPhotoDetailActivity extends BaseActivity {
    @Override
    protected int getTitleResId() {
        return R.string.about_photo;
    }

    @Override
    protected int getLayoutResId() {
        return R.layout.activity_new_photo_detail;
    }

    @Override
    protected void initViewAndControl() {
        initNav();

        String url = getIntent().getStringExtra(BabyExtraConstant.EXTRA_ITEM);
        ImageView ivPic = findView(R.id.ivPic);
        showRemoteGoodsImage(url, ivPic);
    }

    private void initNav() {
        TextView tvLeft = findView(R.id.toolbarLeft);
        tvLeft.setVisibility(View.VISIBLE);
        ResourceUtil.setCompoundDrawable(tvLeft, R.drawable.dr_ic_back, 0, 0, 0);
    }
}
