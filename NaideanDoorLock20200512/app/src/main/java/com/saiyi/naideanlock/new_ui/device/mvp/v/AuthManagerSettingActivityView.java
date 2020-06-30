package com.saiyi.naideanlock.new_ui.device.mvp.v;


import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.ui.mvp.BaseView;

/**
 * Created by Administrator on 2018/4/18.
 */

public interface AuthManagerSettingActivityView extends BaseView {
    void showSetNannyResult(MdlBaseHttpResp resp);
    void showSetNoAdminResult(MdlBaseHttpResp resp);
    void showSetResult(MdlBaseHttpResp resp);
}
