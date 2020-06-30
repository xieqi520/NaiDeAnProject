package com.saiyi.naideanlock.new_ui.device.mvp.p;

import com.saiyi.naideanlock.new_ui.device.mvp.m.SetUnlockPwdActivityModel;
import com.saiyi.naideanlock.new_ui.device.mvp.v.SetUnlockPwdActivityView;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.ui.mvp.BaseModel;
import com.sandy.guoguo.babylib.ui.mvp.BasePresenter;

import java.util.Map;

/**
 * Created by Administrator on 2018/4/18.
 */

public class SetUnlockPwdActivityPresenter extends BasePresenter<SetUnlockPwdActivityView> {
    private static final int REQ_SET_PWD = 1;
    private static final int REQ_GET_PHONE_CHECK_CODE = 2;

    private SetUnlockPwdActivityModel model;

    public SetUnlockPwdActivityPresenter(SetUnlockPwdActivityView view) {
        this.view = view;
        this.model = new SetUnlockPwdActivityModel();
    }

    public void setUnlockPwd(String id,String phoneCode,String openPwd,String token){
        if(model != null){
            view.showLoading();
            model.setUnlockPwd(REQ_SET_PWD, id,phoneCode,openPwd,token, this);
        }
    }

    public void getCheckCode(String phone){
        if(model != null){
            view.showLoading();
            model.getCheckCode(REQ_GET_PHONE_CHECK_CODE, phone, this);
        }
    }

    @Override
    protected BaseModel getMode() {
        return model;
    }

    @Override
    protected void responseSuccess(int code, MdlBaseHttpResp resp) {
        switch (code){
            case REQ_SET_PWD:
                view.showSetUnlockPwdResult(resp);
                break;
            case REQ_GET_PHONE_CHECK_CODE:
                view.showCheckCodeResult(resp);
                break;
        }
    }
}
