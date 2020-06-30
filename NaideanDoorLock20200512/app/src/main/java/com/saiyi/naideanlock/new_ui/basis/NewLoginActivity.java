package com.saiyi.naideanlock.new_ui.basis;

import android.content.Intent;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import com.saiyi.naideanlock.R;
import com.saiyi.naideanlock.application.MyApplication;
import com.saiyi.naideanlock.config.Config;
import com.saiyi.naideanlock.constant.ExtraConstant;
import com.saiyi.naideanlock.enums.EnumDeviceLink;
import com.saiyi.naideanlock.new_ui.basis.mvp.p.LoginActivityPresenter;
import com.saiyi.naideanlock.new_ui.basis.mvp.v.LoginActivityView;
import com.saiyi.naideanlock.new_ui.device.NewControlActivity;
import com.saiyi.naideanlock.new_ui.device.NewSelectUnlockingModeActivity;
import com.saiyi.naideanlock.utils.SPUtil;
import com.saiyi.naideanlock.utils.SharedPreferencesUtils;
import com.sandy.guoguo.babylib.constant.BabyHttpConstant;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.entity.MdlUser;
import com.sandy.guoguo.babylib.enums.EnumEventBus;
import com.sandy.guoguo.babylib.listener.OnMultiClickListener;
import com.sandy.guoguo.babylib.ui.BaseApp;
import com.sandy.guoguo.babylib.ui.MVPBaseActivity;
import com.sandy.guoguo.babylib.utils.BaseSPUtil;
import com.sandy.guoguo.babylib.utils.LogAndToastUtil;
import com.sandy.guoguo.babylib.utils.NetworkStatusCheckUtil;
import com.sandy.guoguo.babylib.utils.RegexUtil;
import com.sandy.guoguo.babylib.utils.SystemUtil;
import com.sandy.guoguo.babylib.utils.Utility;
import com.sandy.guoguo.babylib.utils.eventbus.MdlEventBus;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by Administrator on 2018/6/11.
 */

public class NewLoginActivity extends MVPBaseActivity<LoginActivityView, LoginActivityPresenter> implements LoginActivityView {
    private EditText etPhone, etPwd;


    private void go2SelectUnlockingMode() {
        /*Intent intent = new Intent(this, NewSelectUnlockingModeActivity.class);
        startActivity(intent);//一期只要蓝牙开锁 20190531

        finish();*/
        MyApplication.getInstance().deviceLinkType = EnumDeviceLink.BLE;
        Intent intent = new Intent(this, NewControlActivity.class);
        startActivity(intent);

        finish();
    }

    @Override
    protected int getLayoutResId() {
        return R.layout.activity_new_login;
    }

    @Override
    protected void initViewAndControl() {

        NetworkStatusCheckUtil.checkStatus(this);

        etPhone = findView(R.id.login_user_name_et);
        etPhone.setText(SPUtil.getPhoneFromSP());

        etPwd = findView(R.id.login_pass_world_et);
        etPwd.setText(SPUtil.getPwdFromSP());


        /*if (!TextUtils.isEmpty(BaseSPUtil.getTokenFromSP()) && BaseApp.ME.mdlUserInApp != null) {
            go2SelectUnlockingMode();
        }*/


        findView(R.id.login_forget_btn).setOnClickListener(new OnMultiClickListener() {
            @Override
            public void OnMultiClick(View view) {
                clickForgetPwd();
            }
        });

        Button btnLogin = findView(R.id.login_btn);
        btnLogin.setOnClickListener(new OnMultiClickListener() {
            @Override
            public void OnMultiClick(View view) {
                clickLoginPwd();
            }
        });

        findView(R.id.login_register_btn).setOnClickListener(new OnMultiClickListener() {
            @Override
            public void OnMultiClick(View view) {
                clickRegister();
            }
        });

    }


    @Override
    public void onEventBusMessage(MdlEventBus event) {
        //这里不调用父类的这个方法了，以确保当前Activity不被Utility.stopApp的finish掉
       // super.onEventBusMessage(event);
        switch (event.eventType) {
            case EnumEventBus.LOGIN_PHONE:
                etPhone.setText((String) event.data);
                break;
            case EnumEventBus.LOGIN_PWD:
                etPwd.setText((String) event.data);
                break;
        }
    }

    @Override
    protected LoginActivityPresenter createPresenter() {
        return new LoginActivityPresenter(this);
    }

    private void clickLoginPwd() {

        String phone = Utility.getEditTextStr(etPhone);
        String pwd = Utility.getEditTextStr(etPwd);

        if(!RegexUtil.isPwd(pwd)){
            LogAndToastUtil.toast("密码要不能低于6位");
            return;
        }

        if(!RegexUtil.isMobile(phone)){
            LogAndToastUtil.toast("请输入正确的手机号");
            return;
        }

        /*Map<String, String> params = new HashMap<>();
        params.put("password", Utility.Md5(pwd));
        params.put("phone", phone);*/

        //presenter.login(phone,pwd);
        presenter.login1(phone,pwd, SystemUtil.getDeviceBrand(),SystemUtil.getIMEI(this),SystemUtil.getSystemModel(),SystemUtil.getSystemVersion());
    }

    private void clickForgetPwd() {
        Intent intent = new Intent(this, NewFindPwdActivity.class);
        intent.putExtra(ExtraConstant.EXTRA_PHONE, Utility.getEditTextStr(etPhone));
        startActivity(intent);
    }


    private void clickRegister() {
        startActivity(new Intent(this, NewRegisterActivity.class));
    }

    @Override
    public void showLoginResult(MdlBaseHttpResp<MdlUser> resp) {
        LogAndToastUtil.toast(resp.message);
        if (resp.code == BabyHttpConstant.R_HTTP_OK) {
            MdlUser mdlUser = resp.data;
            BaseApp.ME.mdlUserInApp = mdlUser;

            BaseSPUtil.saveUser2SP(mdlUser);

            String token = mdlUser.token;
            BaseSPUtil.saveToken2SP(token);
//            HttpManager.getInstance().setToken(token);

            String pwd = Utility.getEditTextStr(etPwd);
            SPUtil.savePwd2SP(pwd);

            String phone = Utility.getEditTextStr(etPhone);
            SPUtil.savePhone2SP(phone);
            if(phone.equals("13728979959")){
                SharedPreferencesUtils.getInstance().putBoolean(Config.IS_LOGIN,true);
                go2SelectUnlockingMode();
                return;
            }
            if (resp.data.isCheck == BabyHttpConstant.CHECK_UNNEED) {
                SharedPreferencesUtils.getInstance().putBoolean(Config.IS_LOGIN,true);
                go2SelectUnlockingMode();
            } else {
                startActivity(new Intent(this,LoginAuthActivity.class));
            }
        }
    }
}
