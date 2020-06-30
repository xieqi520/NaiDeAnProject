package com.saiyi.naideanlock.new_ui.device.mvp.p;


import com.saiyi.naideanlock.new_ui.device.mvp.m.UnlockRecordActivityModel;
import com.saiyi.naideanlock.new_ui.device.mvp.v.UnlockRecordActivityView;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.ui.mvp.BaseModel;
import com.sandy.guoguo.babylib.ui.mvp.BasePresenter;

import java.util.Map;

/**
 * Created by Administrator on 2018/4/18.
 */

public class UnlockRecordActivityPresenter extends BasePresenter<UnlockRecordActivityView> {
    private static final int REQ_GET_LIST = 1;
    private static final int REQ_DEL = 2;

    private UnlockRecordActivityModel model;

    public UnlockRecordActivityPresenter(UnlockRecordActivityView view) {
        this.view = view;
        this.model = new UnlockRecordActivityModel();
    }

    public void getUnlockRecord(String id,int page,int size, String token) {
        if (model != null) {
            view.showLoading();
            model.getUnlockRecord(REQ_GET_LIST, id,page,size,token, this);
        }
    }

    public void deleteAllUnlockRecord(String id,String token) {
        if (model != null) {
            view.showLoading();
            model.deleteAllUnlockRecord(REQ_DEL, id,token, this);
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
                view.showRecordListResult(resp);
                break;
            case REQ_DEL:
                view.showDelAllRecordResult(resp);
                break;
        }
    }
}
