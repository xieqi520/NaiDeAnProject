package com.saiyi.naideanlock.new_ui.basis.mvp.v;


import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.entity.MdlUser;
import com.sandy.guoguo.babylib.ui.mvp.BaseView;

/**
 * Created by Administrator on 2018/4/18.
 */

public interface LoginActivityView extends BaseView {
    void showLoginResult(MdlBaseHttpResp<MdlUser> resp);
}
