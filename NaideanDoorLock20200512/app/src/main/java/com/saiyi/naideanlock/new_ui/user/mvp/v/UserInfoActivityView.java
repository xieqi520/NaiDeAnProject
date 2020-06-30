package com.saiyi.naideanlock.new_ui.user.mvp.v;


import com.saiyi.naideanlock.bean.MdlHttpRespList;
import com.saiyi.naideanlock.bean.MdlVersion;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.entity.MdlUser;
import com.sandy.guoguo.babylib.ui.mvp.BaseView;

/**
 * Created by Administrator on 2018/4/18.
 */

public interface UserInfoActivityView extends BaseView {
    void showUserInfoResult(MdlBaseHttpResp<MdlUser> resp);
    void showAppVersionResult(MdlBaseHttpResp<MdlHttpRespList<MdlVersion>> resp);
}
