package com.saiyi.naideanlock.new_ui.device;

import android.content.Intent;
import android.text.TextUtils;
import android.view.View;
import android.widget.TextView;

import com.saiyi.naideanlock.R;
import com.saiyi.naideanlock.application.MyApplication;
import com.saiyi.naideanlock.bean.MdlDevice;
import com.saiyi.naideanlock.new_ui.device.mvp.p.RemoteUnlockActivityPresenter;
import com.saiyi.naideanlock.new_ui.device.mvp.v.RemoteUnlockActivityView;
import com.sandy.guoguo.babylib.constant.BabyExtraConstant;
import com.sandy.guoguo.babylib.constant.BabyHttpConstant;
import com.sandy.guoguo.babylib.dialogs.CommonInputDialog;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.listener.OnMultiClickListener;
import com.sandy.guoguo.babylib.ui.MVPBaseActivity;
import com.sandy.guoguo.babylib.utils.ResourceUtil;
import com.sandy.guoguo.babylib.utils.Utility;

import java.util.HashMap;
import java.util.Map;

public class NewRemoteUnlockActivity extends MVPBaseActivity<RemoteUnlockActivityView, RemoteUnlockActivityPresenter> implements RemoteUnlockActivityView {
    private MdlDevice mdlDevice;
    private TextView tvDeviceName;

    @Override
    protected int getTitleResId() {
        return R.string.remote_unlocking;
    }

    @Override
    protected RemoteUnlockActivityPresenter createPresenter() {
        return new RemoteUnlockActivityPresenter(this);
    }

    @Override
    protected int getLayoutResId() {
        return R.layout.activity_new_remote_unlock;
    }

    @Override
    protected void initViewAndControl() {
        initNav();

        mdlDevice = getIntent().getParcelableExtra(BabyExtraConstant.EXTRA_ITEM);

        tvDeviceName = findView(R.id.tvDeviceName);
        tvDeviceName.setText(mdlDevice.lockName);
        tvDeviceName.setOnClickListener(new OnMultiClickListener() {
            @Override
            public void OnMultiClick(View view) {
                updateDeviceNameDialog();
            }
        });

        findView(R.id.tvOpenCamera).setOnClickListener(new OnMultiClickListener() {
            @Override
            public void OnMultiClick(View view) {
                clickOpenCamera();
            }
        });

    }

    private void clickOpenCamera() {
        Intent intent = new Intent(this, NewWifiCameraActivity.class);
        intent.putExtra(BabyExtraConstant.EXTRA_ITEM, mdlDevice);
        startActivity(intent);
    }

    private void updateDeviceNameDialog() {
        String oldName = Utility.getEditTextStr(tvDeviceName);
        if (TextUtils.isEmpty(oldName)) {
            return;
        }

        CommonInputDialog dialog = new CommonInputDialog(this, getString(R.string.rename_device), getString(R.string.input_device_name), new CommonInputDialog.ClickListener() {
            @Override
            public void clickConfirm(String content) {
                handleUpdateDeviceName(content);
                Utility.toggleSoftKeyboard(NewRemoteUnlockActivity.this);
            }

            @Override
            public void clickCancel() {
            }
        });

        dialog.show();
    }

    private void handleUpdateDeviceName(String name) {
        //Map<String, Object> params = new HashMap<>();
        //params.put("name", name);
        //params.put("id", mdlDevice.mac);
//        params.put("linkType", MyApplication.getInstance().deviceLinkType);
        presenter.updateDeviceName(mdlDevice.mac,name,MyApplication.getInstance().mdlUserInApp.token);

        tvDeviceName.setText(name);
    }


    private void initNav() {
        TextView tvLeft = findView(R.id.toolbarLeft);
        tvLeft.setVisibility(View.VISIBLE);
        ResourceUtil.setCompoundDrawable(tvLeft, R.drawable.dr_ic_back, 0, 0, 0);
    }

    @Override
    public void showUpdateDeviceNameResult(MdlBaseHttpResp resp) {
        if (resp.code == BabyHttpConstant.R_HTTP_OK) {
            mdlDevice.lockName = Utility.getEditTextStr(tvDeviceName);
        } else {
            tvDeviceName.setText(mdlDevice.lockName);
        }
    }
}
