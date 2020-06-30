package com.saiyi.naideanlock.new_ui.device.mvp.v;


import com.saiyi.naideanlock.bean.MdlDevice;
import com.saiyi.naideanlock.bean.MdlHttpRespList;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.ui.mvp.BaseView;

import java.util.List;

/**
 * Created by Administrator on 2018/4/18.
 */

public interface ControlActivityView extends BaseView {
    void showDeviceListResult(MdlBaseHttpResp<List<MdlDevice>> resp);
    void showDeviceListResultMore(MdlBaseHttpResp<List<MdlDevice>> resp);
    void showDeviceListResultRename(MdlBaseHttpResp<List<MdlDevice>> resp);
    void showDelDeviceResult(MdlBaseHttpResp resp);
    void showUpdateDeviceNameResult(MdlBaseHttpResp resp);
    void showAddUnlockRecordResult(MdlBaseHttpResp resp);
}
