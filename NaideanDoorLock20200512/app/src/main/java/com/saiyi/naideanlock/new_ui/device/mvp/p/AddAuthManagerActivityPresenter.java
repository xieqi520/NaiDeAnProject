package com.saiyi.naideanlock.new_ui.device.mvp.p;


import com.saiyi.naideanlock.new_ui.device.mvp.m.AddAuthManagerActivityModel;
import com.saiyi.naideanlock.new_ui.device.mvp.v.AddAuthManagerActivityView;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.ui.mvp.BaseModel;
import com.sandy.guoguo.babylib.ui.mvp.BasePresenter;

import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2018/4/18.
 */

public class AddAuthManagerActivityPresenter extends BasePresenter<AddAuthManagerActivityView> {
    private static final int REQ_GET_USER_INFO = 1;
    private static final int REQ_BIND = 2;
    private static final int REQ_ADD_BIND = 3;

    private AddAuthManagerActivityModel model;

    public AddAuthManagerActivityPresenter(AddAuthManagerActivityView view) {
        this.view = view;
        this.model = new AddAuthManagerActivityModel();
    }

    public void searchUserInfo(String phone,String token) {
        if (model != null) {
            view.showLoading();
            model.searchUserInfo(REQ_GET_USER_INFO, phone,token, this);
        }
    }

    public void bindDevice(String mac, String name, String type, String token){
        if (model != null) {
            view.showLoading();
            model.bindDevice(REQ_BIND, mac,name,type, token, this);
        }
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
            case REQ_GET_USER_INFO:
                view.showUserInfoResult(resp);
                break;

            case REQ_BIND:
                view.showAddDeviceResult(resp);
                break;

            case REQ_ADD_BIND:
                view.showAddBindResult(resp);
                break;
        }
    }
}
