package com.saiyi.naideanlock.new_ui.device.mvp.p;


import com.saiyi.naideanlock.new_ui.device.mvp.m.SettingActivityModel;
import com.saiyi.naideanlock.new_ui.device.mvp.v.SettingActivityView;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.ui.mvp.BaseModel;
import com.sandy.guoguo.babylib.ui.mvp.BasePresenter;

import java.util.Map;

/**
 * Created by Administrator on 2018/4/18.
 */

public class SettingActivityPresenter extends BasePresenter<SettingActivityView> {
    private static final int REQ_SET_UNMANNED_MODE = 1;
    private static final int REQ_SET_TAMPER_ALERT = 2;
    private static final int REQ_SET_LOW_POWER = 3;

    private SettingActivityModel model;

    public SettingActivityPresenter(SettingActivityView view) {
        this.view = view;
        this.model = new SettingActivityModel();
    }

    public void setUnmannedMode(Map map) {
        if (model != null) {
            view.showLoading();
            model.setUnmannedMode(REQ_SET_UNMANNED_MODE, map, this);
        }
    }

    public void setTamperAlert(Map map) {
        if (model != null) {
            view.showLoading();
            model.setTamperAlert(REQ_SET_TAMPER_ALERT, map, this);
        }
    }

    public void setLowPower(Map map) {
        if (model != null) {
            view.showLoading();
            model.setLowPower(REQ_SET_LOW_POWER, map, this);
        }
    }
    public void updateAlarm(String id,int low,String token) {
        if (model != null) {
            view.showLoading();
            model.updateAlarm(REQ_SET_LOW_POWER, id,low,token, this);
        }
    }

    @Override
    protected BaseModel getMode() {
        return model;
    }

    @Override
    protected void responseSuccess(int code, MdlBaseHttpResp resp) {
        switch (code) {
            case REQ_SET_UNMANNED_MODE:
                view.showSetUnmannedModeResult(resp);
                break;
            case REQ_SET_TAMPER_ALERT:
                view.showSetTamperAlertResult(resp);
                break;
            case REQ_SET_LOW_POWER:
                view.showSetLowPowerResult(resp);
                break;
        }
    }
}
