package com.saiyi.naideanlock.ui.mvp.p;


import com.saiyi.naideanlock.ui.mvp.m.LauncherModel;
import com.saiyi.naideanlock.ui.mvp.v.LauncherView;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.ui.mvp.BaseModel;
import com.sandy.guoguo.babylib.ui.mvp.BasePresenter;

/**
 * Created by Administrator on 2018/4/18.
 */

public class LaucherPresenter extends BasePresenter<LauncherView> {
    private static final int REQ_AUTO_LOGIN = 1;

    private LauncherModel model;

    public LaucherPresenter(LauncherView view) {
        this.view = view;
        this.model = new LauncherModel();
    }

    public void autoLogin(String phoneId,String token) {
        if (model != null) {
            view.showLoading();
            model.autoLogin(REQ_AUTO_LOGIN, phoneId,token, this);
        }
    }

    @Override
    protected BaseModel getMode() {
        return model;
    }

    @Override
    protected void responseSuccess(int code, MdlBaseHttpResp resp) {
        switch (code) {
            case REQ_AUTO_LOGIN:
                view.showAutoLoginResult(resp);
                break;

        }
    }

    @Override
    public void onFailure(int code, Throwable e) {
        super.onFailure(code, e);
        switch (code) {
            case REQ_AUTO_LOGIN:
                view.showAutoLoginResult(null);
                break;

        }
    }
}
