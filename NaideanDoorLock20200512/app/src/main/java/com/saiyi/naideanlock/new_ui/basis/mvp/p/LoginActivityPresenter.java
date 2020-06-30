package com.saiyi.naideanlock.new_ui.basis.mvp.p;


import com.saiyi.naideanlock.new_ui.basis.mvp.m.LoginActivityModel;
import com.saiyi.naideanlock.new_ui.basis.mvp.v.LoginActivityView;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.ui.mvp.BaseModel;
import com.sandy.guoguo.babylib.ui.mvp.BasePresenter;

import java.util.Map;

/**
 * Created by Administrator on 2018/4/18.
 */

public class LoginActivityPresenter extends BasePresenter<LoginActivityView> {
    private LoginActivityModel model;

    public LoginActivityPresenter(LoginActivityView view) {
        this.view = view;
        this.model = new LoginActivityModel();
    }

    public void login(String phone,String password){
        if(model != null){
            view.showLoading();
            model.login(0, phone,password, this);
        }
    }

    public void login1(String phone,String password, String phoneBrand,String phoneId,String phoneModel,String phoneSystem){
        if(model != null){
            view.showLoading();
            model.login1(0, phone,password, phoneBrand,phoneId,phoneModel,phoneSystem,this);
        }
    }

    @Override
    protected BaseModel getMode() {
        return model;
    }

    @Override
    protected void responseSuccess(int code, MdlBaseHttpResp resp) {
        view.showLoginResult(resp);
    }
}
