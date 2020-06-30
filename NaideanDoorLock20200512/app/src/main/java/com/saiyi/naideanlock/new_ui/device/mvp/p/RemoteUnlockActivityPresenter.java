package com.saiyi.naideanlock.new_ui.device.mvp.p;


import com.saiyi.naideanlock.new_ui.device.mvp.m.RemoteUnlockActivityModel;
import com.saiyi.naideanlock.new_ui.device.mvp.v.RemoteUnlockActivityView;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.ui.mvp.BaseModel;
import com.sandy.guoguo.babylib.ui.mvp.BasePresenter;

import java.util.Map;

/**
 * Created by Administrator on 2018/4/18.
 */

public class RemoteUnlockActivityPresenter extends BasePresenter<RemoteUnlockActivityView> {
    private static final int REQ_UPDATE_NAME = 3;

    private RemoteUnlockActivityModel model;

    public RemoteUnlockActivityPresenter(RemoteUnlockActivityView view) {
        this.view = view;
        this.model = new RemoteUnlockActivityModel();
    }

    public void updateDeviceName(String id,String name,String token) {
        if (model != null) {
            view.showLoading();
            model.updateDeviceName(REQ_UPDATE_NAME, id,name,token, this);
        }
    }



    @Override
    protected BaseModel getMode() {
        return model;
    }

    @Override
    protected void responseSuccess(int code, MdlBaseHttpResp resp) {
        switch (code) {
            case REQ_UPDATE_NAME:
                view.showUpdateDeviceNameResult(resp);
                break;
        }
    }
}
