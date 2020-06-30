package com.saiyi.naideanlock.new_ui.basis.mvp.p;


import com.saiyi.naideanlock.new_ui.basis.mvp.m.RegisterActivityModel;
import com.saiyi.naideanlock.new_ui.basis.mvp.v.RegisterActivityView;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.ui.mvp.BaseModel;
import com.sandy.guoguo.babylib.ui.mvp.BasePresenter;

import java.util.Map;

/**
 * Created by Administrator on 2018/4/18.
 */

public class RegisterActivityPresenter extends BasePresenter<RegisterActivityView> {
    private static final int REQ_REGISTER = 1;
    private static final int REQ_GET_PHONE_CHECK_CODE = 2;

    private RegisterActivityModel model;

    public RegisterActivityPresenter(RegisterActivityView view) {
        this.view = view;
        this.model = new RegisterActivityModel();
    }

    public void register(String phone,String password,String phoneCode){
        if(model != null){
            view.showLoading();
            model.register(REQ_REGISTER, phone,password,phoneCode, this);
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
            case REQ_REGISTER:
                view.showRegisterResult(resp);
                break;
            case REQ_GET_PHONE_CHECK_CODE:
                view.showCheckCodeResult(resp);
                break;
        }
    }
}
