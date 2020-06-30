package com.saiyi.naideanlock.new_ui.device.mvp.v;


import com.saiyi.naideanlock.bean.MdlHttpRespList;
import com.saiyi.naideanlock.bean.MdlUnlockRecord;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.ui.mvp.BaseView;

/**
 * Created by Administrator on 2018/4/18.
 */

public interface UnlockRecordActivityView extends BaseView {
    void showRecordListResult(MdlBaseHttpResp<MdlHttpRespList<MdlUnlockRecord>> resp);
    void showDelAllRecordResult(MdlBaseHttpResp resp);
}
