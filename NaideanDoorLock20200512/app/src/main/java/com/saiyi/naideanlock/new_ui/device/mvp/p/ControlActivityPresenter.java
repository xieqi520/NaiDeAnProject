package com.saiyi.naideanlock.new_ui.device.mvp.p;


import com.saiyi.naideanlock.new_ui.device.mvp.m.ControlActivityModel;
import com.saiyi.naideanlock.new_ui.device.mvp.v.ControlActivityView;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.ui.mvp.BaseModel;
import com.sandy.guoguo.babylib.ui.mvp.BasePresenter;

import java.util.Map;

/**
 * Created by Administrator on 2018/4/18.
 */

public class ControlActivityPresenter extends BasePresenter<ControlActivityView> {
    private static final int REQ_GET_LIST = 1;
    private static final int REQ_DEL = 2;
    private static final int REQ_UPDATE_NAME = 3;
    private static final int REQ_ADD_UNLOCK_RECORD = 4;
    private static final int REQ_GET_LIST_MORE = 5;
    private static final int REQ_GET_LIST_RENAME = 6;

    private ControlActivityModel model;

    public ControlActivityPresenter(ControlActivityView view) {
        this.view = view;
        this.model = new ControlActivityModel();
    }

    public void getAllDeviceByType(int type,String token) {
        if (model != null) {
            view.showLoading();
            model.getAllDeviceByType(REQ_GET_LIST, type,token, this);
        }
    }
    public void getAllDeviceByTypeMore(int type,String token) {
        if (model != null) {
            view.showLoading();
            model.getAllDeviceByType(REQ_GET_LIST_MORE, type,token, this);
        }
    }
    public void getAllDeviceByTypeRename(int type,String token) {
        if (model != null) {
            view.showLoading();
            model.getAllDeviceByType(REQ_GET_LIST_RENAME, type,token, this);
        }
    }

    public void delDeviceBinding(String id,String token) {
        if (model != null) {
            view.showLoading();
            //model.delDeviceBinding(REQ_DEL, id,token, this);
        }
    }

    public void delDevice(String id,String token) {
        if (model != null) {
            view.showLoading();
            model.delDevice(REQ_DEL, id,token, this);
        }
    }

    public void updateDeviceName(String id,String name,String token) {
        if (model != null) {
            view.showLoading();
            model.updateDeviceName(REQ_UPDATE_NAME, id,name, token,this);
        }
    }
    public void addUnlockRecord(String id,String openType,int openValue,String sceneFingerprints,String scenePwd,int userType,String token) {
        if (model != null) {
            view.showLoading();
            model.addUnlockRecord(REQ_ADD_UNLOCK_RECORD, id,openType,openValue,sceneFingerprints,scenePwd,userType,token, this);
        }
    }


    @Override
    protected BaseModel getMode() {
        return model;
    }

    @Override
    protected void responseSuccess(int code, MdlBaseHttpResp resp) {
        switch (code) {
            case REQ_GET_LIST:
                view.showDeviceListResult(resp);
                break;
            case REQ_DEL:
                view.showDelDeviceResult(resp);
                break;
            case REQ_UPDATE_NAME:
                view.showUpdateDeviceNameResult(resp);
                break;
            case REQ_ADD_UNLOCK_RECORD:
                view.showAddUnlockRecordResult(resp);
                break;
            case REQ_GET_LIST_MORE:
                view.showDeviceListResultMore(resp);
                break;
            case REQ_GET_LIST_RENAME:
                view.showDeviceListResultRename(resp);
                break;
        }
    }
}
