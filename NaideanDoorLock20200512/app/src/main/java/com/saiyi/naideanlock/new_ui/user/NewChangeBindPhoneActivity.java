package com.saiyi.naideanlock.new_ui.user;

import android.content.Intent;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.saiyi.naideanlock.R;
import com.saiyi.naideanlock.application.MyApplication;
import com.saiyi.naideanlock.config.Config;
import com.saiyi.naideanlock.constant.ExtraConstant;
import com.saiyi.naideanlock.enums.EnumCheckCode;
import com.saiyi.naideanlock.new_ui.user.mvp.p.ChangeBindPhoneActivityPresenter;
import com.saiyi.naideanlock.new_ui.user.mvp.v.ChangeBindPhoneActivityView;
import com.saiyi.naideanlock.utils.SPUtil;
import com.sandy.guoguo.babylib.constant.BabyExtraConstant;
import com.sandy.guoguo.babylib.constant.BabyHttpConstant;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.entity.MdlUser;
import com.sandy.guoguo.babylib.listener.OnMultiClickListener;
import com.sandy.guoguo.babylib.ui.MVPBaseActivity;
import com.sandy.guoguo.babylib.utils.BaseSPUtil;
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

public class NewChangeBindPhoneActivity extends MVPBaseActivity<ChangeBindPhoneActivityView, ChangeBindPhoneActivityPresenter> implements ChangeBindPhoneActivityView {
    private EditText etPhone, etPwd, etCheckCode;
    private TextView tvGetCode;

    private Disposable disposable;

    private static int MAX_COUNT_DOWN_TIME = Config.CHECK_CODE_MAX_COUNT_DOWN_TIME;
    private Button btnConfirm;

    private boolean isCheckPhone = true;

    @Override
    protected int getLayoutResId() {
        return R.layout.activity_new_change_bind_phone;
    }

    @Override
    protected int getTitleResId() {
        return R.string.change_phone_number;
    }

    @Override
    protected void initViewAndControl() {
        initNav();
        etPhone = findView(R.id.etPhone);
        etPhone.setText(SPUtil.getPhoneFromSP());

        String phoneFromIntent = getIntent().getStringExtra(ExtraConstant.EXTRA_PHONE);
        if (!TextUtils.isEmpty(phoneFromIntent)) {
            etPhone.setText(phoneFromIntent);
        }

        etCheckCode = findView(R.id.etCheckCode);

        etPwd = findView(R.id.etPwd);


        tvGetCode = findView(R.id.tvGetCode);
        tvGetCode.setOnClickListener(new OnMultiClickListener() {
            @Override
            public void OnMultiClick(View view) {
                getCheckCode();
            }
        });
        btnConfirm = findView(R.id.btnConfirm);
        btnConfirm.setOnClickListener(new OnMultiClickListener() {
            @Override
            public void OnMultiClick(View view) {
                if (isCheckPhone) {
                    clickCheck();
                } else {
                    clickUpdate();
                }
            }
        });

    }

    private void initNav() {
        TextView tvLeft = findView(R.id.toolbarLeft);
        tvLeft.setVisibility(View.VISIBLE);
        ResourceUtil.setCompoundDrawable(tvLeft, R.drawable.dr_ic_back, 0, 0, 0);

    }

    @Override
    protected ChangeBindPhoneActivityPresenter createPresenter() {
        return new ChangeBindPhoneActivityPresenter(this);
    }

    private void getCheckCode() {
        String phone = Utility.getEditTextStr(etPhone);
        if (!RegexUtil.isMobile(phone)) {
            LogAndToastUtil.toast("请输入正确的手机号");
            return;
        }
        /*Map<String, Object> params = new HashMap<>();
        params.put("number", phone);
        params.put("type", EnumCheckCode.CHANGE_BIND_PHONE);*/
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
                        tvGetCode.setEnabled(false);
                    }

                    @Override
                    public void onNext(Integer i) {
                        tvGetCode.setText(getString(R.string.count_down, i));
                    }

                    @Override
                    public void onError(Throwable e) {
                        tvGetCode.setEnabled(true);
                    }

                    @Override
                    public void onComplete() {
                        resetCheckCodeBtn();
                    }
                });
    }

    private void stopCountDown() {
        if (disposable != null && !disposable.isDisposed()) {
            disposable.dispose();
            disposable = null;
        }
        resetCheckCodeBtn();
    }

    private void resetCheckCodeBtn() {
        tvGetCode.setText(R.string.verification_code);
        tvGetCode.setEnabled(true);
    }

    private void clickCheck() {
        stopCountDown();

        String pwd = Utility.getEditTextStr(etPwd);
        if (!RegexUtil.isPwd(pwd)) {
            LogAndToastUtil.toast("密码不能低于6位");
            return;
        }

        String phone = Utility.getEditTextStr(etPhone);
        if (!RegexUtil.isMobile(phone)) {
            LogAndToastUtil.toast("请输入正确的手机号");
            return;
        }
        String phoneCheckCode = Utility.getEditTextStr(etCheckCode);
        if (TextUtils.isEmpty(phoneCheckCode)) {
            LogAndToastUtil.toast("验证码不能为空");
            return;
        }

        Map<String, String> params = new HashMap<>();
        params.put("code", phoneCheckCode);
        params.put("password", pwd);
        params.put("phone", phone);
        presenter.checkPhone(params,BaseSPUtil.getUserFromSP().token);
    }

    private void clickUpdate() {
        stopCountDown();

        String pwd = Utility.getEditTextStr(etPwd);
        if (!RegexUtil.isPwd(pwd)) {
            LogAndToastUtil.toast("密码不能低于6位");
            return;
        }

        String phone = Utility.getEditTextStr(etPhone);
        if (!RegexUtil.isMobile(phone)) {
            LogAndToastUtil.toast("请输入正确的手机号");
            return;
        }
        String phoneCheckCode = Utility.getEditTextStr(etCheckCode);
        if (TextUtils.isEmpty(phoneCheckCode)) {
            LogAndToastUtil.toast("验证码不能为空");
            return;
        }

        Map<String, String> params = new HashMap<>();
        params.put("code", phoneCheckCode);
        params.put("phone", phone);
        presenter.updatePhone(params,BaseSPUtil.getUserFromSP().token);
    }


    @Override
    protected void onDestroy() {
        super.onDestroy();
        stopCountDown();
    }


    @Override
    public void showCheckCodeResult(MdlBaseHttpResp resp) {
        if (resp.code == BabyHttpConstant.R_HTTP_OK) {

            startCountDown();
        }
    }

    @Override
    public void showCheckPhoneResult(MdlBaseHttpResp resp) {
        if (resp.code == BabyHttpConstant.R_HTTP_OK) {
            isCheckPhone = false;
            etPhone.setText("");
            etPhone.setHint(R.string.input_new_phone);
            etPhone.setEnabled(true);
            etCheckCode.setText("");
            etPwd.setVisibility(View.GONE);
            btnConfirm.setText(R.string.confirm);
        }
    }

    @Override
    public void showUpdatePhoneResult(MdlBaseHttpResp resp) {
        if (resp.code == BabyHttpConstant.R_HTTP_OK) {

            handleBackKey();
        }
    }

    @Override
    protected void handleBackKey() {
        MdlUser mdlUser = new MdlUser();
        mdlUser.phone = Utility.getEditTextStr(etPhone);

        SPUtil.savePhone2SP(mdlUser.phone);

        Intent intent = new Intent();
        intent.putExtra(BabyExtraConstant.EXTRA_ITEM, mdlUser);
        setResult(RESULT_OK, intent);

        super.handleBackKey();
    }
}
