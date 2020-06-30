package com.saiyi.naideanlock.new_ui.user.mvp.v;


import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.ui.mvp.BaseView;

/**
 * Created by Administrator on 2018/4/18.
 */

public interface ChangeBindPhoneActivityView extends BaseView {
    void showCheckPhoneResult(MdlBaseHttpResp resp);
    void showUpdatePhoneResult(MdlBaseHttpResp resp);
    void showCheckCodeResult(MdlBaseHttpResp resp);
}
