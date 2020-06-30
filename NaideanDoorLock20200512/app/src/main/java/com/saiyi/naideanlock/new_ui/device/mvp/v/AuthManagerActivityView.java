package com.saiyi.naideanlock.new_ui.device.mvp.v;


import com.saiyi.naideanlock.bean.AuthInfo;
import com.saiyi.naideanlock.bean.MdlDevice;
import com.saiyi.naideanlock.bean.MdlHttpRespList;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.ui.mvp.BaseView;

import java.util.List;

/**
 * Created by Administrator on 2018/4/18.
 */

public interface AuthManagerActivityView extends BaseView {
    void showAuthUserListResult(MdlBaseHttpResp<List<AuthInfo>> resp);
    void showRenameAuthUserResult(MdlBaseHttpResp resp);
    void showDelNannyResult(MdlBaseHttpResp resp);
    void showDelNoAdminResult(MdlBaseHttpResp resp);
}
