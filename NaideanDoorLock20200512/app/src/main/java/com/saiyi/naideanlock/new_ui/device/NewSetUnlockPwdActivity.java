package com.saiyi.naideanlock.new_ui.device;

import android.content.Intent;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.saiyi.naideanlock.R;
import com.saiyi.naideanlock.application.MyApplication;
import com.saiyi.naideanlock.bean.MdlDevice;
import com.saiyi.naideanlock.config.Config;
import com.saiyi.naideanlock.new_ui.device.mvp.p.SetUnlockPwdActivityPresenter;
import com.saiyi.naideanlock.new_ui.device.mvp.v.SetUnlockPwdActivityView;
import com.saiyi.naideanlock.utils.SPUtil;
import com.sandy.guoguo.babylib.constant.BabyExtraConstant;
import com.sandy.guoguo.babylib.constant.BabyHttpConstant;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.listener.OnMultiClickListener;
import com.sandy.guoguo.babylib.ui.MVPBaseActivity;
import com.sandy.guoguo.babylib.utils.LogAndToastUtil;
import com.sandy.guoguo.babylib.utils.RegexUtil;
import com.sandy.guoguo.babylib.utils.ResourceUtil;
import com.sandy.guoguo.babylib.utils.Utility;

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

public class NewSetUnlockPwdActivity extends MVPBaseActivity<SetUnlockPwdActivityView, SetUnlockPwdActivityPresenter> implements SetUnlockPwdActivityView {
    private EditText etPhone, etCheckCode, etPwd, etConfirmPwd;
    private MdlDevice mdlDevice;
    private Button btnGetCode;

    private Disposable disposable;

    private static int MAX_COUNT_DOWN_TIME = Config.CHECK_CODE_MAX_COUNT_DOWN_TIME;

    @Override
    protected int getLayoutResId() {
        return R.layout.activity_new_set_unlock_pwd;
    }

    @Override
    protected int getTitleResId() {
        return R.string.unlocking_set;
    }

    @Override
    protected void initViewAndControl() {
        initNav();
        etPhone = findView(R.id.etPhone);
        etPhone.setText(MyApplication.getInstance().mdlUserInApp.phone);
        etCheckCode = findView(R.id.et_forget_code);

        etPwd = findView(R.id.etPwd);

        etConfirmPwd = findView(R.id.etConfirmPwd);

        mdlDevice = getIntent().getParcelableExtra(BabyExtraConstant.EXTRA_ITEM);

        findView(R.id.btnConfirm).setOnClickListener(new OnMultiClickListener() {
            @Override
            public void OnMultiClick(View view) {
                clickConfirm();
            }
        });

        btnGetCode = findView(R.id.btnGetCode);
        btnGetCode.setOnClickListener(new OnMultiClickListener() {
            @Override
            public void OnMultiClick(View view) {
                getCheckCode();
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

    private void resetCheckCodeBtn() {
        btnGetCode.setText(R.string.verification_code);
        btnGetCode.setEnabled(true);
    }

    private void clickConfirm() {
        stopCountDown();
        sendNewPwd2Remote();
    }


    private void initNav() {
        TextView tvLeft = findView(R.id.toolbarLeft);
        tvLeft.setVisibility(View.VISIBLE);
        ResourceUtil.setCompoundDrawable(tvLeft, R.drawable.dr_ic_back, 0, 0, 0);

    }

    @Override
    protected SetUnlockPwdActivityPresenter createPresenter() {
        return new SetUnlockPwdActivityPresenter(this);
    }


    private void sendNewPwd2Remote() {

        String phone = Utility.getEditTextStr(etPhone);
        String pwd = Utility.getEditTextStr(etPwd);
        String confirmPwd = Utility.getEditTextStr(etConfirmPwd);
        if(!RegexUtil.isMobile(phone)) {
            LogAndToastUtil.toast("请输入正确的手机号");
            return;
        }
        String phoneCheckCode = Utility.getEditTextStr(etCheckCode);
        if(TextUtils.isEmpty(phoneCheckCode)){
            LogAndToastUtil.toast("验证码不能为空");
            return;
        }
        if (!RegexUtil.isPwd(pwd) || !RegexUtil.isPwd(confirmPwd)) {
            LogAndToastUtil.toast("密码不能低于6位");
            return;
        }
//        if (!TextUtils.equals(oldPwd, mdlDevice.pwd)) {
//            LogAndToastUtil.toast("旧密码输入错误");
//            return;
//        }
        if (!TextUtils.equals(pwd, confirmPwd)) {
            LogAndToastUtil.toast("两次输入密码不一致");
            return;
        }


        //Map<String, Object> params = new HashMap<>();
//        params.put("bindingID", mdlDevice.bindingID);
        //params.put("code", phoneCheckCode);
        //params.put("id", mdlDevice.mac);
        //params.put("openPwd", pwd);
        presenter.setUnlockPwd(mdlDevice.id,phoneCheckCode,pwd,MyApplication.getInstance().mdlUserInApp.token);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        stopCountDown();
    }

    @Override
    public void showSetUnlockPwdResult(MdlBaseHttpResp resp) {
        if (resp.code == BabyHttpConstant.R_HTTP_OK) {


            String pwd = Utility.getEditTextStr(etPwd);
            mdlDevice.pwd = pwd;
            //mdlDevice.lockPwd = pwd;

            Intent intent = new Intent();
            intent.putExtra(BabyExtraConstant.EXTRA_ITEM, mdlDevice);
            setResult(RESULT_OK, intent);
            finish();
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
