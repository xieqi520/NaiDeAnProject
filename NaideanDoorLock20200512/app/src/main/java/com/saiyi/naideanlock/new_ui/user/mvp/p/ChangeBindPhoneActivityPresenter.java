package com.saiyi.naideanlock.new_ui.user.mvp.p;


import com.saiyi.naideanlock.new_ui.user.mvp.m.ChangeBindPhoneActivityModel;
import com.saiyi.naideanlock.new_ui.user.mvp.v.ChangeBindPhoneActivityView;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.ui.mvp.BaseModel;
import com.sandy.guoguo.babylib.ui.mvp.BasePresenter;

import java.util.Map;

/**
 * Created by Administrator on 2018/4/18.
 */

public class ChangeBindPhoneActivityPresenter extends BasePresenter<ChangeBindPhoneActivityView> {
    private static final int CHECK_PHONE = 1;
    private static final int UPDATE_PHONE = 2;
    private static final int REQ_GET_CHECK_CODE = 3;

    private ChangeBindPhoneActivityModel model;

    public ChangeBindPhoneActivityPresenter(ChangeBindPhoneActivityView view) {
        this.view = view;
        this.model = new ChangeBindPhoneActivityModel();
    }

    public void checkPhone(Map map,String token) {
        if (model != null) {
            view.showLoading();
            model.checkPhone(CHECK_PHONE, map, token,this);
        }
    }
    public void updatePhone(Map map,String token) {
        if (model != null) {
            view.showLoading();
            model.updatePhone(UPDATE_PHONE, map, token,this);
        }
    }
    public void getCheckCode(String phone) {
        if (model != null) {
            view.showLoading();
            model.getCheckCode(REQ_GET_CHECK_CODE, phone, this);
        }
    }


    @Override
    protected BaseModel getMode() {
        return model;
    }

    @Override
    protected void responseSuccess(int code, MdlBaseHttpResp resp) {
        switch (code) {
            case CHECK_PHONE:
                view.showCheckPhoneResult(resp);
                break;

            case UPDATE_PHONE:
                view.showUpdatePhoneResult(resp);
                break;

            case REQ_GET_CHECK_CODE:
                view.showCheckCodeResult(resp);
                break;

        }
    }
}
