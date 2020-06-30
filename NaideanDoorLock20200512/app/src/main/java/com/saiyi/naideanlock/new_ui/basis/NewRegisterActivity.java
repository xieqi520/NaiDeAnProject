package com.saiyi.naideanlock.new_ui.basis;

import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import com.saiyi.naideanlock.R;
import com.saiyi.naideanlock.config.Config;
import com.saiyi.naideanlock.enums.EnumCheckCode;
import com.saiyi.naideanlock.new_ui.basis.mvp.p.RegisterActivityPresenter;
import com.saiyi.naideanlock.new_ui.basis.mvp.v.RegisterActivityView;
import com.saiyi.naideanlock.utils.SPUtil;
import com.sandy.guoguo.babylib.constant.BabyHttpConstant;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.enums.EnumEventBus;
import com.sandy.guoguo.babylib.listener.OnMultiClickListener;
import com.sandy.guoguo.babylib.ui.MVPBaseActivity;
import com.sandy.guoguo.babylib.utils.LogAndToastUtil;
import com.sandy.guoguo.babylib.utils.RegexUtil;
import com.sandy.guoguo.babylib.utils.Utility;
import com.sandy.guoguo.babylib.utils.eventbus.EventBusManager;
import com.sandy.guoguo.babylib.utils.eventbus.MdlEventBus;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import io.reactivex.Observable;
import io.reactivex.Observer;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.Disposable;
import io.reactivex.functions.Function;
import io.reactivex.schedulers.Schedulers;

/**
 * Created by Administrator on 2018/6/11.
 */

public class NewRegisterActivity extends MVPBaseActivity<RegisterActivityView, RegisterActivityPresenter> implements RegisterActivityView {
    private EditText etPhone, etPwd,etCheckCode,etConfirmPwd;
    private Button btnGetCode;

    private Disposable disposable;

    private static int MAX_COUNT_DOWN_TIME = Config.CHECK_CODE_MAX_COUNT_DOWN_TIME;

    @Override
    protected int getLayoutResId() {
        return R.layout.activity_register;
    }

    @Override
    protected void initViewAndControl() {
        etPhone = findView(R.id.register_user_name_et);

        etCheckCode = findView(R.id.register_verification_code_et);

        etPwd = findView(R.id.register_one_pass_et);

        etConfirmPwd = findView(R.id.register_two_pass_et);

        btnGetCode = findView(R.id.register_get_code_btn);
        btnGetCode.setOnClickListener(new OnMultiClickListener() {
            @Override
            public void OnMultiClick(View view) {
                getCheckCode();
            }
        });

        Button btnRegister = findView(R.id.register_btn);
        btnRegister.setOnClickListener(new OnMultiClickListener() {
            @Override
            public void OnMultiClick(View view) {
                clickRegister();
            }
        });

    }


    @Override
    protected RegisterActivityPresenter createPresenter() {
        return new RegisterActivityPresenter(this);
    }

    private void getCheckCode(){
        String phone = Utility.getEditTextStr(etPhone);
        if(!RegexUtil.isMobile(phone)){
            LogAndToastUtil.toast("请输入正确的手机号");
            return;
        }
        presenter.getCheckCode(phone);
    }

    private void startCountDown() {
        Observable.interval(0, 1, TimeUnit.SECONDS)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .map(new Function<Long, Integer>() {
                    @Override
                    public Integer apply(Long aLong) throws Exception {
                        return MAX_COUNT_DOWN_TIME - aLong.intValue();
                    }
                })
                .take(MAX_COUNT_DOWN_TIME + 1)
                .subscribe(new Observer<Integer>() {
                    @Override
                    public void onSubscribe(Disposable d) {
                        disposable = d;
                        btnGetCode.setEnabled(false);
                    }

                    @Override
                    public void onNext(Integer i) {
                        btnGetCode.setText(getString(R.string.count_down, i));
                    }

                    @Override
                    public void onError(Throwable e) {
                        btnGetCode.setEnabled(true);
                    }

                    @Override
                    public void onComplete() {
                        resetCheckCodeBtn();
                    }
                });
    }

    private void stopCountDown(){
        if (disposable != null && !disposable.isDisposed()) {
            disposable.dispose();
            disposable = null;
        }
        resetCheckCodeBtn();
    }

    private void resetCheckCodeBtn(){
        btnGetCode.setText(R.string.verification_code);
        btnGetCode.setEnabled(true);
    }

    private void clickRegister(){
        stopCountDown();

        String pwd = Utility.getEditTextStr(etPwd);
        String confirmPwd = Utility.getEditTextStr(etConfirmPwd);
        if(!RegexUtil.isPwd(pwd) || !RegexUtil.isPwd(confirmPwd)){
            LogAndToastUtil.toast("密码要不能低于6位");
            return;
        }
        if(!TextUtils.equals(pwd, confirmPwd)){
            LogAndToastUtil.toast("两次输入密码不一致");
            return;
        }
        String phone = Utility.getEditTextStr(etPhone);
        if(!RegexUtil.isMobile(phone)){
            LogAndToastUtil.toast("请输入正确的手机号");
            return;
        }
        String phoneCheckCode = Utility.getEditTextStr(etCheckCode);
        if(TextUtils.isEmpty(phoneCheckCode)){
            LogAndToastUtil.toast("验证码不能为空");
            return;
        }

        /*Map<String, Object> params = new HashMap<>();
        params.put("code", phoneCheckCode);
        params.put("password", Utility.Md5(pwd));
        params.put("passwords", Utility.Md5(confirmPwd));
        params.put("number", phone);*/
        presenter.register(phone,pwd,phoneCheckCode);
    }

    private void back2Login(){
        finish();
    }



    @Override
    protected void onDestroy() {
        super.onDestroy();
        stopCountDown();
    }

    @Override
    public void showRegisterResult(MdlBaseHttpResp resp) {
        if(resp.code == BabyHttpConstant.R_HTTP_OK){
            DisplayMetrics dm = Utility.getDisplayScreenSize(this);
            LogAndToastUtil.toastCustomView(getLayoutInflater(), (int) (dm.widthPixels*0.4f), resp.message);

            String phone = Utility.getEditTextStr(etPhone);
            EventBusManager.post(new MdlEventBus(EnumEventBus.LOGIN_PHONE, phone));

            SPUtil.savePhone2SP(phone);
            back2Login();
        }
    }

    @Override
    public void showCheckCodeResult(MdlBaseHttpResp resp) {
        LogAndToastUtil.toast(resp.message);
        if(resp.code == BabyHttpConstant.R_HTTP_OK){
            String phone = Utility.getEditTextStr(etPhone);
            SPUtil.savePhone2SP(phone);

            startCountDown();
        }
    }
}
