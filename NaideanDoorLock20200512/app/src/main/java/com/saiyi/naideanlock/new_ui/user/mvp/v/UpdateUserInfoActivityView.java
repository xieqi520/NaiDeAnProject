package com.saiyi.naideanlock.new_ui.user.mvp.v;


import com.saiyi.naideanlock.bean.UserInfo;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.ui.mvp.BaseView;

/**
 * Created by Administrator on 2018/4/18.
 */

public interface UpdateUserInfoActivityView extends BaseView {
    void showUpdateInfoResult(MdlBaseHttpResp resp);
    void showGetUserInfoResult(MdlBaseHttpResp<UserInfo> resp);
    void showUploadPicResult(MdlBaseHttpResp<String> resp);
}
