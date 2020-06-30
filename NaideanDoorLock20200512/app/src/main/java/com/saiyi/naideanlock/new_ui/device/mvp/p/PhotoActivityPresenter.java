package com.saiyi.naideanlock.new_ui.device.mvp.p;


import com.saiyi.naideanlock.new_ui.device.mvp.m.PhotoActivityModel;
import com.saiyi.naideanlock.new_ui.device.mvp.v.PhotoActivityView;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.ui.mvp.BaseModel;
import com.sandy.guoguo.babylib.ui.mvp.BasePresenter;

import java.util.Map;

/**
 * Created by Administrator on 2018/4/18.
 */

public class PhotoActivityPresenter extends BasePresenter<PhotoActivityView> {
    private static final int REQ_GET_LIST = 1;

    private PhotoActivityModel model;

    public PhotoActivityPresenter(PhotoActivityView view) {
        this.view = view;
        this.model = new PhotoActivityModel();
    }

    public void getPhotoList(Map map) {
        if (model != null) {
            view.showLoading();
            model.getPhotoList(REQ_GET_LIST, map, this);
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
                view.showPhotoListResult(resp);
                break;
        }
    }
}
