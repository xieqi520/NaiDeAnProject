package com.saiyi.naideanlock.new_ui.basis.mvp.v;


import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.ui.mvp.BaseView;

/**
 * Created by Administrator on 2018/4/18.
 */

public interface FindPwdActivityView extends BaseView {
    void showFindResult(MdlBaseHttpResp resp);
    void showCheckCodeResult(MdlBaseHttpResp resp);
}
