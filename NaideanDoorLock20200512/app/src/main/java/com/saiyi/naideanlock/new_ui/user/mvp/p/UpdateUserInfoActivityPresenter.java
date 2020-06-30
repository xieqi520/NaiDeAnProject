package com.saiyi.naideanlock.new_ui.user.mvp.p;


import com.saiyi.naideanlock.new_ui.user.mvp.m.UpdateUserInfoActivityModel;
import com.saiyi.naideanlock.new_ui.user.mvp.v.UpdateUserInfoActivityView;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.ui.mvp.BaseModel;
import com.sandy.guoguo.babylib.ui.mvp.BasePresenter;

import java.io.File;
import java.util.Map;

/**
 * Created by Administrator on 2018/4/18.
 */

public class UpdateUserInfoActivityPresenter extends BasePresenter<UpdateUserInfoActivityView> {
    private static final int REQ_UPDATE_INFO = 1;
    private static final int REQ_UPLOAD_PIC = 2;
    private static final int REQ_GET_USER_INFO = 3;

    private UpdateUserInfoActivityModel model;

    public UpdateUserInfoActivityPresenter(UpdateUserInfoActivityView view) {
        this.view = view;
        this.model = new UpdateUserInfoActivityModel();
    }

    public void updateUserInfo(String nickName,String pic,String token) {
        if (model != null) {
            view.showLoading();
            model.updateUserInfo(REQ_UPDATE_INFO, nickName, pic, token,this);
        }
    }

    public void getUserInfo(String phone,String token) {
        if (model != null) {
            model.getUserInfo(REQ_GET_USER_INFO, phone, token,this);
        }
    }

    public void uploadHeadPic(File file) {
        if (model != null) {
            view.showLoading();
            model.uploadHeadPic(REQ_UPLOAD_PIC, file, this);
        }
    }


    @Override
    protected BaseModel getMode() {
        return model;
    }

    @Override
    protected void responseSuccess(int code, MdlBaseHttpResp resp) {
        switch (code) {
            case REQ_UPDATE_INFO:
                view.showUpdateInfoResult(resp);
                break;
            case REQ_GET_USER_INFO:
                view.showGetUserInfoResult(resp);
                break;
            case REQ_UPLOAD_PIC:
                view.showUploadPicResult(resp);
                break;
        }
    }
}
