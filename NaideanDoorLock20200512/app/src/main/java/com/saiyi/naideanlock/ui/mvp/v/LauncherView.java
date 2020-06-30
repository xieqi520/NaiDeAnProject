package com.saiyi.naideanlock.ui.mvp.v;


import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.ui.mvp.BaseView;

/**
 * Created by Administrator on 2018/4/18.
 */

public interface LauncherView extends BaseView {
    void showAutoLoginResult(MdlBaseHttpResp<Integer> resp);
}
