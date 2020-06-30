package com.saiyi.naideanlock.new_ui.basis;

import android.content.Intent;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import com.saiyi.naideanlock.R;
import com.saiyi.naideanlock.application.MyApplication;
import com.saiyi.naideanlock.enums.EnumDeviceLink;
import com.saiyi.naideanlock.new_ui.basis.mvp.p.LoginAuthActivityPresenter;
import com.saiyi.naideanlock.new_ui.basis.mvp.v.LoginAuthActivityView;
import com.saiyi.naideanlock.new_ui.device.NewControlActivity;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.ui.MVPBaseActivity;
import com.sandy.guoguo.babylib.utils.LogAndToastUtil;
import com.sandy.guoguo.babylib.utils.RegexUtil;
import com.sandy.guoguo.babylib.utils.Utility;

/**
 * 创建者     YGP
 * 创建时间   2019/7/11
 * 描述       ${TODO}
 * <p/>
 * 更新者     $Author$
 * 更新时间   $Date$
 * 更新描述   ${TODO}
 */
public class LoginAuthActivity extends MVPBaseActivity<LoginAuthActivityView, LoginAuthActivityPresenter> implements LoginAuthActivityView {

    private EditText etPhone;
    private EditText etCode;
    private Button btnLogin;
    private Button btnGetCode;

    @Override
    protected int getLayoutResId() {
        return R.layout.activity_loginauth;
    }

    @Override
    protected void initViewAndControl() {
        etPhone = findView(R.id.loginauth_user_name_et);
        etCode = findView(R.id.loginauth_verification_code_et);
        btnLogin = findView(R.id.loginauth_btn);
        btnGetCode = findView(R.id.loginauth_get_code_btn);
        etPhone.setText(MyApplication.getInstance().mdlUserInApp.phone);
        btnGetCode.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(!RegexUtil.isMobile(etPhone.getText().toString())){
                    LogAndToastUtil.toast("请输入正确的手机号");
                    return;
                }
                getCheckCode();
            }
        });

        btnLogin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(!RegexUtil.isMobile(etPhone.getText().toString())){
                    LogAndToastUtil.toast("请输入正确的手机号");
                    return;
                }
                if (TextUtils.isEmpty(etCode.getText().toString())) {
                    LogAndToastUtil.toast("请输入验证码");
                    return;
                }
                presenter.checkLogin(etCode.getText().toString(), MyApplication.getInstance().mdlUserInApp.token);
            }
        });
    }

    private void getCheckCode(){
        String phone = Utility.getEditTextStr(etPhone);
        if(!RegexUtil.isMobile(phone)){
            LogAndToastUtil.toast("请输入正确的手机号");
            return;
        }
        presenter.getCheckCode(phone);
    }

    @Override
    protected LoginAuthActivityPresenter createPresenter() {
        return new LoginAuthActivityPresenter(LoginAuthActivity.this);
    }

    @Override
    public void showLoginResult(MdlBaseHttpResp resp) {
        if (resp.code == 1000) {
            MyApplication.getInstance().deviceLinkType = EnumDeviceLink.BLE;
            Intent intent = new Intent(this, NewControlActivity.class);
            startActivity(intent);

            finish();
        }
    }

    @Override
    public void showCheckCodeResult(MdlBaseHttpResp resp) {

    }
}
