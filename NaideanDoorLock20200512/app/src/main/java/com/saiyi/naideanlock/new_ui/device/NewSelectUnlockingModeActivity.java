package com.saiyi.naideanlock.new_ui.device;

import android.content.Intent;
import android.provider.Settings;
import android.view.View;
import android.widget.TextView;

import com.hisilicon.hisilink.WiFiAdmin;
import com.saiyi.naideanlock.R;
import com.saiyi.naideanlock.application.MyApplication;
import com.saiyi.naideanlock.constant.PublicConstant;
import com.saiyi.naideanlock.enums.EnumDeviceLink;
import com.saiyi.naideanlock.service.HomeService;
import com.sandy.guoguo.babylib.listener.OnMultiClickListener;
import com.sandy.guoguo.babylib.ui.BaseActivity;
import com.sandy.guoguo.babylib.utils.ResourceUtil;

public class NewSelectUnlockingModeActivity extends BaseActivity {
    @Override
    protected int getTitleResId() {
        return R.string.select_unlocking_mode;
    }

    @Override
    protected int getLayoutResId() {
        return R.layout.activity_select_unlocking_mode;
    }

    private void initNav() {
        TextView tvLeft = findView(R.id.toolbarLeft);
        tvLeft.setVisibility(View.VISIBLE);
        ResourceUtil.setCompoundDrawable(tvLeft, R.drawable.dr_ic_back, 0, 0, 0);

    }

    @Override
    protected void initViewAndControl() {
        initNav();

        findView(R.id.tvWifi).setOnClickListener(new OnMultiClickListener() {
            @Override
            public void OnMultiClick(View view) {
                MyApplication.getInstance().deviceLinkType = EnumDeviceLink.WIFI;
                go2Control();
            }
        });
        findView(R.id.tvBle).setOnClickListener(new OnMultiClickListener() {
            @Override
            public void OnMultiClick(View view) {
                MyApplication.getInstance().deviceLinkType = EnumDeviceLink.BLE;
                go2Control();
            }
        });
    }

    private void go2Control(){

        if (MyApplication.getInstance().deviceLinkType == EnumDeviceLink.BLE) {

            startActivityForResult(new Intent(this, NewAddBleDeviceActivity.class), PublicConstant.REQ_ADDDEVICE);
        } else {
            WiFiAdmin mWiFiAdmin = new WiFiAdmin(this);
            if (mWiFiAdmin.isWifiConnect()) {
                startActivity(new Intent(this, NewWifiCurrentWifiActivity.class));
            } else {
                startActivity(new Intent(Settings.ACTION_WIFI_SETTINGS));
            }
        }

//        Intent intent = new Intent(this, NewControlActivity.class);
//        startActivity(intent);
//
//        finish();
    }
}
