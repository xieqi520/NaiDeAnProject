package com.saiyi.naideanlock.new_ui.device.mvp.p;


import com.saiyi.naideanlock.new_ui.device.mvp.m.AddAuthManagerActivityModel;
import com.saiyi.naideanlock.new_ui.device.mvp.m.AuthSettingActivityModel;
import com.saiyi.naideanlock.new_ui.device.mvp.v.AddAuthManagerActivityView;
import com.saiyi.naideanlock.new_ui.device.mvp.v.AuthSettingActivityView;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.ui.mvp.BaseModel;
import com.sandy.guoguo.babylib.ui.mvp.BasePresenter;

import java.util.List;

/**
 * Created by Administrator on 2018/4/18.
 */

public class AuthSettingActivityPresenter extends BasePresenter<AuthSettingActivityView> {
    private static final int REQ_GET_USER_INFO = 1;
    private static final int REQ_BIND = 2;
    private static final int REQ_ADD_BIND = 3;

    private AuthSettingActivityModel model;

    public AuthSettingActivityPresenter(AuthSettingActivityView view) {
        this.view = view;
        this.model = new AuthSettingActivityModel();
    }



    public void addBind(String mac, String memoName, List<String> times, String userId, String userType, List<Integer> week, String token){
        if (model != null) {
            view.showLoading();
            model.addBinding(REQ_ADD_BIND, mac, memoName, times, userId,userType, week, token,this);
        }
    }

    @Override
    protected BaseModel getMode() {
        return model;
    }

    @Override
    protected void responseSuccess(int code, MdlBaseHttpResp resp) {
        switch (code) {
            case REQ_ADD_BIND:
                view.showAddBindResult(resp);
                break;
        }
    }
}
