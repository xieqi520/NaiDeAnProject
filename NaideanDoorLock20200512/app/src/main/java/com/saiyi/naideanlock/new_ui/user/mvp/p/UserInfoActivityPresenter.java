package com.saiyi.naideanlock.new_ui.user.mvp.p;


import com.saiyi.naideanlock.new_ui.user.mvp.m.UserInfoActivityModel;
import com.saiyi.naideanlock.new_ui.user.mvp.v.UserInfoActivityView;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.ui.mvp.BaseModel;
import com.sandy.guoguo.babylib.ui.mvp.BasePresenter;

import java.util.Map;

/**
 * Created by Administrator on 2018/4/18.
 */

public class UserInfoActivityPresenter extends BasePresenter<UserInfoActivityView> {
    private static final int REQ_GET_USER_INFO = 1;
    private static final int REQ_GET_APP_VERSION = 2;

    private UserInfoActivityModel model;

    public UserInfoActivityPresenter(UserInfoActivityView view) {
        this.view = view;
        this.model = new UserInfoActivityModel();
    }

    public void getUserInfo(String phone,String token) {
        if (model != null) {
            view.showLoading();
            model.getUserInfo(REQ_GET_USER_INFO, phone,token, this);
        }
    }
    public void getAppVersionInfo(Map map) {
        if (model != null) {
            view.showLoading();
            model.getVersionInfo(REQ_GET_APP_VERSION, map, this);
        }
    }


    @Override
    protected BaseModel getMode() {
        return model;
    }

    @Override
    protected void responseSuccess(int code, MdlBaseHttpResp resp) {
        switch (code) {
            case REQ_GET_USER_INFO:
                view.showUserInfoResult(resp);
                break;

            case REQ_GET_APP_VERSION:
                view.showAppVersionResult(resp);
                break;

        }
    }
}
