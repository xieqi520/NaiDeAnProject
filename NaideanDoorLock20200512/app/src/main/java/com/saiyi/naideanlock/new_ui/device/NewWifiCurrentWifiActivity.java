package com.saiyi.naideanlock.new_ui.device;

import android.content.Intent;
import android.provider.Settings;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.hisilicon.hisilink.WiFiAdmin;
import com.saiyi.naideanlock.R;
import com.saiyi.naideanlock.constant.ExtraConstant;
import com.sandy.guoguo.babylib.dialogs.CommonDialog;
import com.sandy.guoguo.babylib.listener.OnMultiClickListener;
import com.sandy.guoguo.babylib.ui.BaseActivity;
import com.sandy.guoguo.babylib.utils.LogAndToastUtil;
import com.sandy.guoguo.babylib.utils.ResourceUtil;
import com.sandy.guoguo.babylib.utils.Utility;

/**
 * 当前连接的wifi
 */
public class NewWifiCurrentWifiActivity extends BaseActivity {
    private static final int REQ_SET_CONNECT_AP = 0225;

    private EditText etWifiName,etWifiPwd;

    private WiFiAdmin mWiFiAdmin;

    public static final String WIFI_SSID_PREFIX = "IKB";

    @Override
    protected int getLayoutResId() {
        return R.layout.activity_new_wifi_current_wifi;
    }

    @Override
    protected void initViewAndControl() {
        initNav();

        etWifiPwd = findView(R.id.etWifiPwd);
        etWifiName = findView(R.id.etWifiName);

        Button btnConfirm = findView(R.id.btnConfirm);
        btnConfirm.setOnClickListener(new OnMultiClickListener() {
            @Override
            public void OnMultiClick(View view) {
                clickAction();
            }
        });

//        currDevBean = MyApplication.getInstance().getCurrdev();
        mWiFiAdmin = new WiFiAdmin(NewWifiCurrentWifiActivity.this);

        etWifiName.setText(mWiFiAdmin.getWifiSSID());
        etWifiName.setEnabled(false);
    }

    private void clickAction() {
        String wifiName = Utility.getEditTextStr(etWifiName);
        String wifiPw = Utility.getEditTextStr(etWifiPwd);
        if (TextUtils.isEmpty(wifiName)) {
            LogAndToastUtil.toast("wifi名不能为空");
            return;
        }

        if (TextUtils.isEmpty(wifiPw)) {
            LogAndToastUtil.toast("wifi密码不能为空");
            return;
        }

        CommonDialog dialog = new CommonDialog(this, "请连接设备热点", "您可以在'设置'中连接以IKB开头的设备热点", new CommonDialog.ClickListener() {
            @Override
            public void clickConfirm() {
                startActivityForResult(new Intent(Settings.ACTION_WIFI_SETTINGS), REQ_SET_CONNECT_AP);
            }

            @Override
            public void clickCancel() {

            }
        });
        dialog.show();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if(requestCode == REQ_SET_CONNECT_AP){
            String apName = mWiFiAdmin.getWifiSSID();
            LogAndToastUtil.log("================当前wifi名称：%s", apName);
            if(!apName.startsWith(WIFI_SSID_PREFIX)){
                LogAndToastUtil.toast("请连接正确的热点");
            } else {
                String wifiName = Utility.getEditTextStr(etWifiName);
                String wifiPwd = Utility.getEditTextStr(etWifiPwd);

                Intent intent = new Intent(this, NewWifiCurrentAPActivity.class);
                intent.putExtra(ExtraConstant.EXTRA_WIFI_NAME, wifiName);
                intent.putExtra(ExtraConstant.EXTRA_WIFI_PWD, wifiPwd);
                startActivity(intent);
                finish();
            }
        }
    }

    private void initNav() {
        TextView tvLeft = findView(R.id.toolbarLeft);
        tvLeft.setVisibility(View.VISIBLE);
        ResourceUtil.setCompoundDrawable(tvLeft, R.drawable.dr_ic_back, 0, 0, 0);
    }

    @Override
    protected int getTitleResId() {
        return R.string.wifi_connect;
    }


}
