package com.saiyi.naideanlock.new_ui.device;

import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.saiyi.naideanlock.R;
import com.saiyi.naideanlock.new_ui.device.mvp.p.AddAuthManagerActivityPresenter;
import com.saiyi.naideanlock.new_ui.device.mvp.p.AuthSettingActivityPresenter;
import com.saiyi.naideanlock.new_ui.device.mvp.v.AddAuthManagerActivityView;
import com.saiyi.naideanlock.new_ui.device.mvp.v.AuthSettingActivityView;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.entity.MdlUser;
import com.sandy.guoguo.babylib.ui.MVPBaseActivity;
import com.sandy.guoguo.babylib.utils.ResourceUtil;

/**
 * 创建者     YGP
 * 创建时间   2019/6/11
 * 描述       ${TODO}
 * <p/>
 * 更新者     $Author$
 * 更新时间   $Date$
 * 更新描述   ${TODO}
 */
public class AuthSettingActivity extends MVPBaseActivity<AuthSettingActivityView, AuthSettingActivityPresenter> implements AuthSettingActivityView{
    private LinearLayout llGenearlManager,llNanny;
    private ImageView ivGeneralmanagerSel,ivNannySel;
    private TextView tvRight;

    @Override
    protected int getLayoutResId() {
        return R.layout.activity_auth_setting;
    }

    @Override
    protected int getTitleResId() {
        return R.string.setting;
    }

    @Override
    protected void initViewAndControl() {
        TextView tvLeft = findView(R.id.toolbarLeft);
        tvLeft.setVisibility(View.VISIBLE);
        ResourceUtil.setCompoundDrawable(tvLeft, R.drawable.dr_ic_back, 0, 0, 0);
        tvRight = findView(R.id.toolbarRight);
        tvRight.setVisibility(View.VISIBLE);
        tvRight.setText(R.string.sure);
        llGenearlManager = findView(R.id.ll_general_manager);
        llNanny = findView(R.id.ll_nanny);
        ivGeneralmanagerSel = findView(R.id.iv_generalmanager_sel);
        ivNannySel = findView(R.id.iv_nanny_sel);
        llGenearlManager.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ivGeneralmanagerSel.setImageResource(R.drawable.ic_check_c);
                ivNannySel.setImageResource(R.drawable.ic_check_n);

            }
        });

        llNanny.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ivGeneralmanagerSel.setImageResource(R.drawable.ic_check_n);
                ivNannySel.setImageResource(R.drawable.ic_check_c);
            }
        });
    }

    @Override
    protected AuthSettingActivityPresenter createPresenter() {
        return new AuthSettingActivityPresenter(this);
    }

    @Override
    public void showAddBindResult(MdlBaseHttpResp resp) {

    }
}
