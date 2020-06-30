package com.saiyi.naideanlock.ui;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;

import com.saiyi.naideanlock.R;
import com.saiyi.naideanlock.application.MyApplication;
import com.saiyi.naideanlock.base.BaseActivity;
import com.saiyi.naideanlock.config.Config;
import com.saiyi.naideanlock.enums.EnumDeviceLink;
import com.saiyi.naideanlock.new_ui.basis.NewLoginActivity;
import com.saiyi.naideanlock.new_ui.device.NewControlActivity;
import com.saiyi.naideanlock.new_ui.device.NewSelectUnlockingModeActivity;
import com.saiyi.naideanlock.new_ui.user.ProtocolActivity;
import com.saiyi.naideanlock.new_ui.user.mvp.p.UserInfoActivityPresenter;
import com.saiyi.naideanlock.new_ui.user.mvp.v.UserInfoActivityView;
import com.saiyi.naideanlock.ui.mvp.p.LaucherPresenter;
import com.saiyi.naideanlock.ui.mvp.v.LauncherView;
import com.saiyi.naideanlock.utils.DeviceUtils;
import com.saiyi.naideanlock.utils.MD5Util;
import com.saiyi.naideanlock.utils.SharedPreferencesUtils;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.ui.MVPBaseActivity;


/**
 * 启动页面
 */
public class LauncherActivity extends MVPBaseActivity<LauncherView, LaucherPresenter> implements LauncherView {

    private Handler mHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            switch (msg.what) {
                case 0:
                    Intent intent = new Intent(LauncherActivity.this,NewLoginActivity.class);
                    startActivity(intent);
                    break;
                    default:
                        break;
            }
        }
    };

    /*@Override
    protected int getContentView() {
        return R.layout.activity_launcher;
    }

    @Override
    protected void onCreateView(Bundle savedInstanceState) {

    }

    @Override
    protected void initView() {

    }

    @Override
    protected void initData() {
        mHandler.postDelayed(new Runnable() {
            @Override
            public void run() {
                goToPage();
            }
        }, 2000);
    }

    @Override
    protected void topBarSet() {

    }

    @Override
    protected void topBarListener() {

    }

    @Override
    protected void setListener() {

    }*/

    private void goToPage() {
        boolean isLogin = SharedPreferencesUtils.getInstance().getSPFBoolean(Config.IS_LOGIN);
        if (isLogin) {//用户登录过
            //presenter.autoLogin(DeviceUtils.getIMEI(this,));
            if (MyApplication.getInstance().mdlUserInApp != null && MyApplication.getInstance().mdlUserInApp.token != null) {
                mHandler.sendEmptyMessageDelayed(0,1500);
                presenter.autoLogin(DeviceUtils.getIMEI(LauncherActivity.this), MyApplication.getInstance().mdlUserInApp.token);
            } else {
                Intent intent = new Intent(this,NewLoginActivity.class);
                startActivity(intent);
            }
        } else {//用户没登录
//            Intent intent = new Intent(this,NewLoginActivity.class);
            Intent intent = new Intent(this, ProtocolActivity.class);
            startActivity(intent);
        }
        finish();
    }



    /**
     * 调用一下登录接口 登录成功之后在跳转到主页面
     */
    private void login() {
        String username = SharedPreferencesUtils.getInstance().getSPFString(Config.LOGIN_USER_NAME);
        String password = MD5Util.decrypt(SharedPreferencesUtils.getInstance().getSPFString(Config.LOGIN_PASS_WORLD));
        if (TextUtils.isEmpty(username) || TextUtils.isEmpty(password)) {
            return;
        }
    }

    @Override
    public void showAutoLoginResult(MdlBaseHttpResp<Integer> resp) {
        mHandler.removeMessages(0);
        if (resp == null) {
            Intent intent = new Intent(this,NewLoginActivity.class);
            startActivity(intent);
            return;
        }
        if (resp.code == 2003) {
            Intent intent = new Intent(this,NewLoginActivity.class);
            startActivity(intent);
        } else if (resp.code == 1000) {

//

            MyApplication.getInstance().deviceLinkType = EnumDeviceLink.BLE;
            Intent intent = new Intent(this, NewControlActivity.class);
            startActivity(intent);
            finish();
        } else {
            Intent intent = new Intent(this,NewLoginActivity.class);
            startActivity(intent);
        }
    }

    @Override
    protected int getLayoutResId() {
        return R.layout.activity_launcher;
    }

    @Override
    protected void initViewAndControl() {
        mHandler.postDelayed(new Runnable() {
            @Override
            public void run() {
                goToPage();
            }
        }, 2000);
    }

    @Override
    protected LaucherPresenter createPresenter() {
        return new LaucherPresenter(this);
    }
}
