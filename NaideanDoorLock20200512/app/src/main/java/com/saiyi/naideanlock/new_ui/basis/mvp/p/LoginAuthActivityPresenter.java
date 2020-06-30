package com.saiyi.naideanlock.new_ui.basis.mvp.p;


import com.saiyi.naideanlock.new_ui.basis.mvp.m.LoginAuthActivityModel;
import com.saiyi.naideanlock.new_ui.basis.mvp.v.LoginAuthActivityView;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.ui.mvp.BaseModel;
import com.sandy.guoguo.babylib.ui.mvp.BasePresenter;

/**
 * Created by Administrator on 2018/4/18.
 */

public class LoginAuthActivityPresenter extends BasePresenter<LoginAuthActivityView> {
    private static final int REQ_CHECKLOGIN = 1;
    private static final int REQ_GET_PHONE_CHECK_CODE = 2;

    private LoginAuthActivityModel model;

    public LoginAuthActivityPresenter(LoginAuthActivityView view) {
        this.view = view;
        this.model = new LoginAuthActivityModel();
    }

    public void checkLogin(String phoneCode,String token){
        if(model != null){
            view.showLoading();
            model.checkLogin(REQ_CHECKLOGIN,phoneCode, token,this);
        }
    }

    public void getCheckCode(String phone){
        if(model != null){
            view.showLoading();
            model.getCheckCode(REQ_GET_PHONE_CHECK_CODE, phone, this);
        }
    }



    @Override
    protected BaseModel getMode() {
        return model;
    }

    @Override
    protected void responseSuccess(int code, MdlBaseHttpResp resp) {
        switch (code){
            case REQ_CHECKLOGIN:
                view.showLoginResult(resp);
                break;
            case REQ_GET_PHONE_CHECK_CODE:
                view.showCheckCodeResult(resp);
                break;
        }
    }
}
