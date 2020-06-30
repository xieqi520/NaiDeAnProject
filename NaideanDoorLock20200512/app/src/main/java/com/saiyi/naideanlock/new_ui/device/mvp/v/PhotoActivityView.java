package com.saiyi.naideanlock.new_ui.device.mvp.v;


import com.saiyi.naideanlock.bean.MdlHttpRespList;
import com.saiyi.naideanlock.bean.MdlPhoto;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.ui.mvp.BaseView;

/**
 * Created by Administrator on 2018/4/18.
 */

public interface PhotoActivityView extends BaseView {
    void showPhotoListResult(MdlBaseHttpResp<MdlHttpRespList<MdlPhoto>> resp);
}
