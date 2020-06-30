package com.saiyi.naideanlock.new_ui.device.mvp.p;

import com.saiyi.naideanlock.new_ui.device.mvp.m.AddDeviceActivityModel;
import com.saiyi.naideanlock.new_ui.device.mvp.v.AddDeviceActivityView;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.ui.mvp.BaseModel;
import com.sandy.guoguo.babylib.ui.mvp.BasePresenter;

import java.util.Map;

import okhttp3.RequestBody;

/**
 * Created by Administrator on 2018/4/18.
 */

public class AddDeviceActivityPresenter extends BasePresenter<AddDeviceActivityView> {
    private static final int REQ_BIND = 1;
    private static final int REQ_GET_LIST = 2;
    private static final int REQ_DEL = 3;

    private AddDeviceActivityModel model;

    public AddDeviceActivityPresenter(AddDeviceActivityView view) {
        this.view = view;
        this.model = new AddDeviceActivityModel();
    }

    public void bindDevice(String mac, String name, String type, String token){
        if(model != null){
            view.showLoading();
            model.bindDevice(REQ_BIND, mac,name,type, token, this);
        }
    }

    public void getAllDeviceByType(int type,String token) {
        if (model != null) {
            view.showLoading();
            model.getAllDeviceByType(REQ_GET_LIST, type,token, this);
        }
    }

    public void delDevice(String id,String token) {
        if (model != null) {
            view.showLoading();
            model.delDevice(REQ_DEL, id,token, this);
        }
    }

    @Override
    protected BaseModel getMode() {
        return model;
    }

    @Override
    protected void responseSuccess(int code, MdlBaseHttpResp resp) {
        switch (code){
            case REQ_BIND:
                view.showAddDeviceResult(resp);
                break;
            case REQ_GET_LIST:
                view.showDeviceListResult(resp);
                break;
            case REQ_DEL:
                view.showDelDeviceResult(resp);
                break;
        }
    }
}
