package com.saiyi.naideanlock.new_ui.basis.mvp.p;

import com.saiyi.naideanlock.new_ui.basis.mvp.m.FindPwdActivityModel;
import com.saiyi.naideanlock.new_ui.basis.mvp.v.FindPwdActivityView;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.ui.mvp.BaseModel;
import com.sandy.guoguo.babylib.ui.mvp.BasePresenter;

import java.util.Map;

/**
 * Created by Administrator on 2018/4/18.
 */

public class FindPwdActivityPresenter extends BasePresenter<FindPwdActivityView> {
    private static final int REQ_FIND_PWD = 1;
    private static final int REQ_GET_CHECK_CODE = 2;

    private FindPwdActivityModel model;

    public FindPwdActivityPresenter(FindPwdActivityView view) {
        this.view = view;
        this.model = new FindPwdActivityModel();
    }

    public void findPwd(String phone,String password,String phoneCode){
        if(model != null){
            view.showLoading();
            model.findPwd(REQ_FIND_PWD, phone,password,phoneCode, this);
        }
    }
    public void getCheckCode(String phone){
        if(model != null){
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
        switch (code){
            case REQ_FIND_PWD:
                view.showFindResult(resp);
                break;
            case REQ_GET_CHECK_CODE:
                view.showCheckCodeResult(resp);
                break;
        }
    }
}
