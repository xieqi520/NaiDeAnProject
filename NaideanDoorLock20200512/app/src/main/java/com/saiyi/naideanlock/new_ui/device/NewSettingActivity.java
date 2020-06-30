package com.saiyi.naideanlock.new_ui.device;

import android.content.Intent;
import android.view.View;
import android.widget.TextView;

import com.saiyi.naideanlock.R;
import com.saiyi.naideanlock.application.MyApplication;
import com.saiyi.naideanlock.bean.MdlDevice;
import com.saiyi.naideanlock.constant.PublicConstant;
import com.saiyi.naideanlock.enums.EnumDeviceAdmin;
import com.saiyi.naideanlock.enums.EnumDeviceLink;
import com.saiyi.naideanlock.enums.EnumSwitch;
import com.saiyi.naideanlock.new_ui.device.mvp.p.SettingActivityPresenter;
import com.saiyi.naideanlock.new_ui.device.mvp.v.SettingActivityView;
import com.sandy.guoguo.babylib.constant.BabyExtraConstant;
import com.sandy.guoguo.babylib.constant.BabyHttpConstant;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.listener.OnMultiClickListener;
import com.sandy.guoguo.babylib.ui.MVPBaseActivity;
import com.sandy.guoguo.babylib.utils.LogAndToastUtil;
import com.sandy.guoguo.babylib.utils.ResourceUtil;

import java.util.HashMap;
import java.util.Map;

/**
 * 相关设置页面
 */
public class NewSettingActivity extends MVPBaseActivity<SettingActivityView, SettingActivityPresenter> implements SettingActivityView {


    private MdlDevice mdlDevice;
    private TextView setting_unmanned_mode_cb;//无人模式报警
    private TextView setting_tamper_cb;//防撬报警
    private TextView setting_no_power_cb;//低电提醒

    private void initNav() {
        TextView tvLeft = findView(R.id.toolbarLeft);
        tvLeft.setVisibility(View.VISIBLE);
        ResourceUtil.setCompoundDrawable(tvLeft, R.drawable.dr_ic_back, 0, 0, 0);
    }

    @Override
    protected void initViewAndControl() {
        initNav();

        //无人模式报警
        setting_unmanned_mode_cb = findView(R.id.setting_unmanned_mode_cb);
        //防撬报警
        setting_tamper_cb = findView(R.id.setting_tamper_cb);
        //低电提醒
        setting_no_power_cb = findView(R.id.setting_no_power_cb);

        mdlDevice = getIntent().getParcelableExtra(BabyExtraConstant.EXTRA_ITEM);

        setting_unmanned_mode_cb.setSelected(EnumSwitch.ON == mdlDevice.no);
        setting_tamper_cb.setSelected(EnumSwitch.ON == mdlDevice.prying);
        setting_no_power_cb.setSelected(EnumSwitch.ON == mdlDevice.low);


        setting_unmanned_mode_cb.setOnClickListener(new SwitchClickListener());
        setting_tamper_cb.setOnClickListener(new SwitchClickListener());
        setting_no_power_cb.setOnClickListener(new SwitchClickListener());

        TextView tvResetNetwork = findView(R.id.tvResetNetwork);
        tvResetNetwork.setOnClickListener(new OnMultiClickListener() {
            @Override
            public void OnMultiClick(View view) {
                LogAndToastUtil.toast("重新配网------");
            }
        });

        if(mdlDevice.linkType == EnumDeviceLink.BLE){
            tvResetNetwork.setVisibility(View.GONE);
            setting_unmanned_mode_cb.setVisibility(View.GONE);
            setting_tamper_cb.setVisibility(View.GONE);
        }
        if(mdlDevice.isAdmin == EnumDeviceAdmin.NANNY){
            setting_no_power_cb.setVisibility(View.GONE);
        }

        findView(R.id.setting_unlocking_set_tv).setOnClickListener(new OnMultiClickListener() {
            @Override
            public void OnMultiClick(View view) {
                Intent intent = new Intent(NewSettingActivity.this, NewSetUnlockPwdActivity.class);
                intent.putExtra(BabyExtraConstant.EXTRA_ITEM, mdlDevice);
                startActivityForResult(intent, PublicConstant.REQ_ITEM);
            }
        });

    }


    private class SwitchClickListener extends OnMultiClickListener {


        @Override
        public void OnMultiClick(View view) {
            Map<String, Object> params = new HashMap<>();
//            params.put("linkType", MyApplication.getInstance().deviceLinkType);
//            params.put("number", MyApplication.getInstance().mdlUserInApp.phone);
            params.put("id", mdlDevice.mac);

            switch (view.getId()) {
                case R.id.setting_unmanned_mode_cb://无人模式报警
                    params.put("unmanned", view.isSelected() ? 0 : 1);
                    presenter.setUnmannedMode(params);
                    break;
                case R.id.setting_tamper_cb://防撬报警
                    params.put("prying", view.isSelected() ? 0 : 1);
                    presenter.setTamperAlert(params);
                    break;
                case R.id.setting_no_power_cb://低电提醒
                    //params.put("low", view.isSelected() ? 0 : 1);
                    presenter.updateAlarm(mdlDevice.id,view.isSelected() ? 0 : 1,MyApplication.getInstance().mdlUserInApp.token);
                    break;
                default:
                    break;
            }
        }
    }


    @Override
    public void showSetUnmannedModeResult(MdlBaseHttpResp resp) {
        if (resp.code == BabyHttpConstant.R_HTTP_OK) {
            setting_unmanned_mode_cb.setSelected(!setting_unmanned_mode_cb.isSelected());
            mdlDevice.no = setting_unmanned_mode_cb.isSelected() ? EnumSwitch.ON : EnumSwitch.OFF;
        }
    }

    @Override
    public void showSetTamperAlertResult(MdlBaseHttpResp resp) {
        if (resp.code == BabyHttpConstant.R_HTTP_OK) {
            setting_tamper_cb.setSelected(!setting_tamper_cb.isSelected());
            mdlDevice.prying = setting_tamper_cb.isSelected() ? EnumSwitch.ON : EnumSwitch.OFF;
        }
    }

    @Override
    public void showSetLowPowerResult(MdlBaseHttpResp resp) {
        if (resp.code == BabyHttpConstant.R_HTTP_OK) {
            setting_no_power_cb.setSelected(!setting_no_power_cb.isSelected());
            mdlDevice.low = setting_no_power_cb.isSelected() ? EnumSwitch.ON : EnumSwitch.OFF;
        }
    }

    @Override
    protected int getLayoutResId() {
        return R.layout.activity_new_setting;
    }


    @Override
    protected int getTitleResId() {
        return R.string.about_setting;
    }

    @Override
    protected SettingActivityPresenter createPresenter() {
        return new SettingActivityPresenter(this);
    }

    @Override
    protected void handleBackKey() {
        Intent intent = new Intent();
        intent.putExtra(BabyExtraConstant.EXTRA_ITEM, mdlDevice);
        setResult(RESULT_OK, intent);

        super.handleBackKey();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode != RESULT_OK) {
            return;
        }
        switch (requestCode) {
            case PublicConstant.REQ_ITEM:
                mdlDevice = data.getParcelableExtra(BabyExtraConstant.EXTRA_ITEM);
                break;
        }
    }
}
