package com.saiyi.naideanlock.new_ui.device;

import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.os.Message;
import android.provider.Settings;
import android.support.annotation.StringRes;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.Spannable;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.hisilicon.hisilink.WiFiAdmin;
import com.saiyi.naideanlock.R;
import com.saiyi.naideanlock.application.MyApplication;
import com.saiyi.naideanlock.bean.DeviceInfo;
import com.saiyi.naideanlock.bean.MdlControlItem;
import com.saiyi.naideanlock.bean.MdlDevice;
import com.saiyi.naideanlock.bean.MdlScanNewDevice;
import com.saiyi.naideanlock.constant.PublicConstant;
import com.saiyi.naideanlock.enums.BLEDeviceStatus;
import com.saiyi.naideanlock.enums.EnumBLECmd;
import com.saiyi.naideanlock.enums.EnumControlItemId;
import com.saiyi.naideanlock.enums.EnumDeviceAdmin;
import com.saiyi.naideanlock.enums.EnumDeviceLink;
import com.saiyi.naideanlock.enums.EnumSwitch;
import com.saiyi.naideanlock.new_ui.base.MVPBaseHandleBLEActivity;
import com.saiyi.naideanlock.new_ui.device.mvp.p.ControlActivityPresenter;
import com.saiyi.naideanlock.new_ui.device.mvp.v.ControlActivityView;
import com.saiyi.naideanlock.new_ui.user.NewUserInfoActivity;
import com.saiyi.naideanlock.service.HomeService;
import com.saiyi.naideanlock.utils.BLEDeviceCmd;
import com.saiyi.naideanlock.utils.MyUtility;
import com.saiyi.naideanlock.utils.SharedPreferencesUtils;
import com.saiyi.naideanlock.utils.ToastUtil;
import com.saiyi.naideanlock.widget.MyDialog;
import com.sandy.guoguo.babylib.adapter.MyViewAdapter;
import com.sandy.guoguo.babylib.adapter.recycler.BaseAdapterHelper;
import com.sandy.guoguo.babylib.adapter.recycler.MyRecyclerAdapter;
import com.sandy.guoguo.babylib.adapter.recycler.RecycleViewDivider;
import com.sandy.guoguo.babylib.adapter.recycler.WrapContentLinearLayoutManager;
import com.sandy.guoguo.babylib.constant.BabyExtraConstant;
import com.sandy.guoguo.babylib.constant.BabyHttpConstant;
import com.sandy.guoguo.babylib.dialogs.CommonDialog;
import com.sandy.guoguo.babylib.dialogs.CommonInputDialog;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.listener.OnMultiClickListener;
import com.sandy.guoguo.babylib.utils.DelayHandler;
import com.sandy.guoguo.babylib.utils.LogAndToastUtil;
import com.sandy.guoguo.babylib.utils.ResourceUtil;
import com.sandy.guoguo.babylib.utils.Utility;
import com.sandy.guoguo.babylib.utils.eventbus.MdlEventBus;
import com.sandy.guoguo.babylib.widgets.MyGridView;
import com.sandy.guoguo.babylib.widgets.MyRecyclerView;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

public class NewControlActivity extends MVPBaseHandleBLEActivity<ControlActivityView, ControlActivityPresenter> implements ControlActivityView {
    private PopupWindow mPopupWindow;//设备列表弹窗

    private MyRecyclerView<MdlDevice> mXRecyclerView;
    private MyRecyclerAdapter<MdlDevice> adapter;
    private List<MdlDevice> dataList = new ArrayList<>();

    private int actionIndex = -1;
    private TextView tvDeviceName, tvDevicePower, tvDeviceStatus;

    private MdlDevice currentDevice;
    private TextView tvLeft,tvRight;
    private MyGridView gridViewBottom;
    private ImageView ivLockStatus;
    private ArrayList<MdlControlItem> dataListBottom;
    private MyViewAdapter<MdlControlItem> bottomAdapter;

    private static int backCount = 0;
    private static final int BACK_COUNT_RESET_0_WHAT = 0X1225;

    private static final float LOW_POWER_V = 3.0f;
    private boolean isShowLowPower = false;
    private MdlBaseHttpResp<List<MdlDevice>> mdlBaseHttpResp;
    private float mPower = -1;
    private boolean unlocking = false;
    private boolean isUnlocking = true;
    private boolean isVisible = true;

    @Override
    public void onDestroy() {
        super.onDestroy();
        DelayHandler.getInstance().removeMessages(BACK_COUNT_RESET_0_WHAT);
        if (mXRecyclerView != null) {
            mXRecyclerView.destroy();
            mXRecyclerView = null;
        }
        if(handler != null){
            handler.removeCallbacks(null);
            handler = null;
        }
    }

    @Override
    protected int getLayoutResId() {
        return R.layout.activity_new_control;
    }

    @Override
    protected int getTitleResId() {
        return R.string.control_panel;
    }

    private void initNav() {
        tvLeft = findView(R.id.toolbarLeft);
        tvRight = findView(R.id.toolbarRight);
        tvLeft.setVisibility(View.GONE);
        tvRight.setVisibility(View.VISIBLE);
        ResourceUtil.setCompoundDrawable(tvRight, R.drawable.add, 0, 0, 0);
        tvLeft.setOnClickListener(new OnMultiClickListener() {
            @Override
            public void OnMultiClick(View view) {
                //clickShowPopup();
            }
        });
        tvRight.setOnClickListener(new OnMultiClickListener() {
            @Override
            public void OnMultiClick(View view) {
                if(isLocking){
                    LogAndToastUtil.toast("正在开门中...");
                    return;
                }
                go2AddDevice();
            }
        });

    }

    private void clickShowPopup() {
        if (mPopupWindow == null) {
            initPopWindow();
        }
        if (!mPopupWindow.isShowing()) {
            getAllDevice();

            //设置弹窗位置
            mPopupWindow.showAsDropDown(tvLeft, 0, 40);
        } else {
            mPopupWindow.dismiss();
        }
    }

    private void hidePopupWindow() {
        if (mPopupWindow != null && mPopupWindow.isShowing()) {
            mPopupWindow.dismiss();
        }
    }

    private void getAllDevice() {
        //Map<String, Object> params = new HashMap<>();
        //params.put("type", MyApplication.getInstance().deviceLinkType);
//        params.put("number", MyApplication.getInstance().mdlUserInApp.phone);
        presenter.getAllDeviceByType(MyApplication.getInstance().deviceLinkType,MyApplication.getInstance().mdlUserInApp.token);
    }

    @Override
    protected void initViewAndControl() {
        initNav();
        ivLockStatus = findView(R.id.ivLockStatus);
        if (MyApplication.getInstance().deviceLinkType == EnumDeviceLink.BLE) {
            ivLockStatus.setImageResource(R.drawable.ic_ble_lock_switch_off);
        } else {
            ivLockStatus.setImageResource(R.drawable.ic_wifi_lock_switch_off);
        }

        tvDeviceStatus = findView(R.id.tvDeviceStatus);
        showDeviceStatusUI(false);

        tvDeviceName = findView(R.id.tvDeviceName);
        tvDeviceName.setVisibility(View.GONE);
        /*tvDeviceName.setOnClickListener(new OnMultiClickListener() {
            @Override
            public void OnMultiClick(View view) {
                updateDeviceNameDialog();
            }
        });*/
        tvDevicePower = findView(R.id.tvPower);
        tvDevicePower.setVisibility(View.INVISIBLE);

        initBottomView();
    }

    private void initBottomView() {
        dataListBottom = new ArrayList<>();
        gridViewBottom = findView(R.id.gridView);
        resetBottomData();

        bottomAdapter = new MyViewAdapter<>(dataListBottom);
        bottomAdapter.setOnBindingListener(onBindingBottomView);
        gridViewBottom.setAdapter(bottomAdapter);

    }

    private void resetBottomData() {
        dataListBottom.clear();
        MdlControlItem item;
        if (currentDevice == null) {
                gridViewBottom.setNumColumns(3);
                item = new MdlControlItem(EnumControlItemId.CAMERA,false, getString(R.string.rename), R.drawable.dr_ic_rename);
                dataListBottom.add(item);
                item = new MdlControlItem(EnumControlItemId.AUTHORIZATION,false, getString(R.string.administration), R.drawable.dr_ic_set_authorization);
                dataListBottom.add(item);
                item = new MdlControlItem(EnumControlItemId.UNLOCK,false, getString(R.string.open_lock), R.drawable.dr_ic_set_lock);
                dataListBottom.add(item);
            item = new MdlControlItem(EnumControlItemId.ABOUT_SETTING,false, getString(R.string.set), R.drawable.dr_ic_set_setting);
            dataListBottom.add(item);
            item = new MdlControlItem(EnumControlItemId.RECORD,false, getString(R.string.record), R.drawable.dr_ic_set_record);
            dataListBottom.add(item);
        } else if (currentDevice.isAdmin == EnumDeviceAdmin.NANNY) {
            gridViewBottom.setNumColumns(2);
            item = new MdlControlItem(EnumControlItemId.CAMERA, true/*currentDevice.linkType == EnumDeviceLink.WIFI*/, getString(R.string.rename), R.drawable.dr_ic_rename);
            dataListBottom.add(item);
            item = new MdlControlItem(EnumControlItemId.ABOUT_SETTING,true, getString(R.string.set), R.drawable.dr_ic_set_setting);
            dataListBottom.add(item);
            item = new MdlControlItem(EnumControlItemId.UNLOCK, getString(R.string.open_lock), R.drawable.dr_ic_set_lock);
            dataListBottom.add(item);
        } else {
            gridViewBottom.setNumColumns(3);
            item = new MdlControlItem(EnumControlItemId.CAMERA, true/*currentDevice.linkType == EnumDeviceLink.WIFI*/, getString(R.string.rename), R.drawable.dr_ic_rename);
            dataListBottom.add(item);
//            item = new MdlControlItem(EnumControlItemId.AUTHORIZATION, currentDevice.isAdmin == EnumDeviceAdmin.IS_ADMIN, getString(R.string.administration), R.drawable.dr_ic_set_authorization);
            item = new MdlControlItem(EnumControlItemId.AUTHORIZATION, currentDevice.isAdmin == EnumDeviceAdmin.IS_ADMIN, getString(R.string.administration), R.drawable.dr_ic_set_authorization);
            dataListBottom.add(item);

            @StringRes int lockStrId = currentDevice.linkType == EnumDeviceLink.WIFI ? R.string.open_remote_lock : R.string.open_lock;
            item = new MdlControlItem(EnumControlItemId.UNLOCK, getString(lockStrId), R.drawable.dr_ic_set_lock);
            dataListBottom.add(item);

            item = new MdlControlItem(EnumControlItemId.ABOUT_SETTING, true, getString(R.string.set), R.drawable.dr_ic_set_setting);
            dataListBottom.add(item);
            item = new MdlControlItem(EnumControlItemId.RECORD, getString(R.string.record), R.drawable.dr_ic_set_record);
            dataListBottom.add(item);
        }
        item = new MdlControlItem(EnumControlItemId.USER, true, getString(R.string.information), R.drawable.dr_ic_set_user);
        dataListBottom.add(item);
    }

    private MyViewAdapter.OnBindingListener<MdlControlItem> onBindingBottomView = new MyViewAdapter.OnBindingListener<MdlControlItem>() {

        @Override
        public View OnBinding(int index, MdlControlItem item, View convertView) {
            if (convertView == null) {
                convertView = getLayoutInflater().inflate(R.layout._item_activity_new_control_grid_view, null);
            }
            TextView tvItemName = convertView.findViewById(R.id.stvName);
            tvItemName.setText(item.name);
            tvItemName.setEnabled(item.enable);
            ResourceUtil.setCompoundDrawable(tvItemName, 0, item.iconRes, 0, 0);
            tvItemName.setOnClickListener(new ClickBottomListener(item));
            return convertView;
        }
    };


    private MyDialog myDialog = null;

    @Override
    public void showDeviceListResultMore(MdlBaseHttpResp<List<MdlDevice>> resp) {
        List<DeviceInfo> mScanAndAddedDevices = new ArrayList<>();
        List<MdlDevice> mAddedDevices = new ArrayList<>();
        if (resp.code == BabyHttpConstant.R_HTTP_OK) {
            if (currentPage == 1) {
                dataList.clear();
            }
            mAddedDevices.clear();
            mScanAndAddedDevices.clear();
            boolean haveData = resp.data != null && resp.data.size() > 0;
            if (haveData) {
                List<MdlDevice> list = resp.data;
                mAddedDevices.addAll(list);
                int length = list.size();
                MdlDevice mdlDevice;
                DeviceInfo deviceInfo;
                for (int i = 0; i < length; i++) {
                    mdlDevice = list.get(i);
                    if (mdlDevice != null) {
                        deviceInfo = new DeviceInfo();
                        deviceInfo.setName(mdlDevice.lockName);
                        deviceInfo.setAddress(mdlDevice.mac);
                        deviceInfo.setAdded(true);
                        mScanAndAddedDevices.add(deviceInfo);
                    }
                }
                if (adapter != null) {
                    adapter.notifyDataSetChanged();
                }
            } else {
                ToastUtil.toastShort(NewControlActivity.this, "没有连接对应的设备");
                return;
            }
        }
        //通过接口查询对应的设备信息， 弹出对应要连接的设备， 点击连接进行连接操作， 然后在将对应的设备开门业务
        View view = LayoutInflater.from(NewControlActivity.this).inflate(R.layout.dialog_dervice_list, null);
        myDialog = new MyDialog(NewControlActivity.this, 0, 0, view, R.style.MyDialog, 0);
        RecyclerView listDialog = view.findViewById(R.id.listview_dialog);
        listDialog.setHasFixedSize(true);
        listDialog.setLayoutManager(new LinearLayoutManager(NewControlActivity.this));
        MyRecyclerAdapter adapter = new MyRecyclerAdapter<DeviceInfo>(this, R.layout._item_activity_new_add_ble_device, mScanAndAddedDevices) {
            @Override
            public void onUpdate(BaseAdapterHelper helper, final DeviceInfo item, final int position) {
                if (item == null) {
                    return;
                }
                helper.setText(R.id.tvName, item.getName());
                helper.setText(R.id.tvAddress, item.getAddress());
                if (item.isAdded()) {
                    helper.setText(R.id.tvAdd,getResources().getString(R.string.connectdevice));
                    helper.setVisible(R.id.tvDel,View.GONE);
                    helper.getView(R.id.tvAdd).setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            //connect 连接操作
                            isUnlocking = false;
                            MdlDevice device = mAddedDevices.get(position);
                            if (device == null) {
                                return;
                            }
                            SharedPreferencesUtils.getInstance().putBoolean(BabyExtraConstant.EXTRA_ISOPENDEVICE,true);
                            SharedPreferencesUtils.getInstance().putString(BabyExtraConstant.EXTRA_MAC,device.mac);
                            if (device.linkType == EnumDeviceLink.BLE) {
                                if (device.mac.equals(currentDevice.mac)) {
                                    HomeService.ME.disConnect(currentDevice.mac);
                                    showCurrentDevice(device);
                                    startScan();
                                } else {
                                    HomeService.ME.disConnect(currentDevice.mac);
                                    showCurrentDevice(device);
                                    startScan();
                                }
                            } else {
                                showCurrentDevice(device);
                            }
                        }
                    });
                }
            }
        };

        listDialog.setAdapter(adapter);
        myDialog.show();
    }



    private class ClickBottomListener extends OnMultiClickListener {
        private MdlControlItem item;

        public ClickBottomListener(MdlControlItem item) {
            this.item = item;
        }

        @Override
        public void OnMultiClick(View view) {
            Class<?> targetCls = null;
            if (item.targetId == EnumControlItemId.USER) {
                targetCls = NewUserInfoActivity.class;
            } else {
                /*if (currentDevice == null) {
                    LogAndToastUtil.toast("请选择设备");
                    return;
                }*/
                switch (item.targetId) {
                    case EnumControlItemId.CAMERA://拍照相关 重命名
                        //targetCls = NewPhotoActivity.class;
                        updateDeviceNameDialog();
                        return;
                    case EnumControlItemId.AUTHORIZATION://授权管理
                        targetCls = NewAuthManagerActivity.class;
                        break;
                    case EnumControlItemId.UNLOCK://远程开锁
                        //密码输入错误过多限制
                        long limitTime = SharedPreferencesUtils.getInstance().getSPFLong(BabyExtraConstant.EXTRA_LIMITTIME);
                        if(System.currentTimeMillis() -limitTime <= 0){
                            LogAndToastUtil.toast("密码输入错误过多限制");
                            return;
                        }
                        //查询出对应的设备
                        if(isLocking){ //正在开门中...
                            LogAndToastUtil.toast("正在开门中...");
                            return;
                        }
                        presenter.getAllDeviceByTypeMore(MyApplication.getInstance().deviceLinkType,MyApplication.getInstance().mdlUserInApp.token);
//                        if (!isUnlocking) {
//                            isUnlocking = true;
//                        }
//                        if (currentDevice.isAdmin == EnumDeviceAdmin.NANNY) {
//                            if (!nannyCheckUnlockTimeAndWeekPeriod()) {
//                                LogAndToastUtil.toast("非授权时段不能开锁");
//                                if (!MyUtility.checkBLEServiceIsNull() && isOneDeviceConnected) {
//                                    HomeService.ME.disConnect(currentDevice.mac);
//                                }
//                                return;
//                            }
//                        }
//
//                        if (currentDevice.linkType == EnumDeviceLink.BLE) {
//                            if (MyUtility.checkBLEServiceIsNull()) {
//                                return;
//                            }
//                            if (!isOneDeviceConnected) {
//                                LogAndToastUtil.toast("设备未连接!!!");
//                                startScan();
//                                return;
//                            }
//                        }
//                        checkUnlock();
                        break;
                    case EnumControlItemId.ABOUT_SETTING://设置
                        targetCls = NewSettingActivity.class;
                        break;
                    case EnumControlItemId.RECORD://开锁记录
                        targetCls = NewUnlockRecordActivity.class;
                        break;
                    default:
                        break;
                }
            }

            if (targetCls == null) {
                return;
            }
            Intent intent = new Intent(NewControlActivity.this, targetCls);
            intent.putExtra(BabyExtraConstant.EXTRA_ITEM, currentDevice);
            startActivityForResult(intent, PublicConstant.REQ_ITEM);
        }
    }

    private void checkUnlock() {
        if (TextUtils.isEmpty(currentDevice.pwd)) {
            LogAndToastUtil.toast("请先设置开锁密码");
            return;
        }
//        if (!isUnlocking) return;
        if (currentDevice.isAdmin == EnumDeviceAdmin.IS_ADMIN) {
            unlock();
        } else {
            unlocking  = true;
            unlock();
        }
    }

    private boolean isLocking = false;
    int inputTimes = 0;
    private void unlock() {
        if (currentDevice.isAdmin == EnumDeviceAdmin.NANNY) {
            if (!nannyCheckUnlockTimeAndWeekPeriod()) {
                LogAndToastUtil.toast("非授权时段不能开锁");
                if (!MyUtility.checkBLEServiceIsNull() && isOneDeviceConnected) {
                    HomeService.ME.disConnect(currentDevice.mac);
                }
                return;
            }
        }
        CommonInputDialog dialog = new CommonInputDialog(NewControlActivity.this, getString(R.string.input_device_pwd), getString(R.string.input_device_pwd), new CommonInputDialog.ClickListener() {
            @Override
            public void clickConfirm(String content) {
                inputTimes ++;
                if (mPower > 0 && mPower < 4.2) {
                    tvDevicePower.setText(getResources().getString(R.string.lowcapacity_dontunlock));
                    LogAndToastUtil.toast(getResources().getString(R.string.lowcapacity_dontunlock));
                    return;
                }
                Utility.toggleSoftKeyboard(NewControlActivity.this);

                if (content.equals(currentDevice.pwd)) {
                    inputTimes = 0 ;
                    if (currentDevice.linkType == EnumDeviceLink.BLE) {
                        clickOpenBLELock();
                    } else {
                        Intent intent = new Intent(NewControlActivity.this, NewRemoteUnlockActivity.class);
                        intent.putExtra(BabyExtraConstant.EXTRA_ITEM, currentDevice);
                        startActivityForResult(intent, PublicConstant.REQ_ITEM);
                    }
                } else {
                    LogAndToastUtil.toast("密码输入错误!!!");
                    HomeService.ME.disConnect(currentDevice.mac);
                    if(inputTimes%5 ==0){
                        int limitTime = inputTimes / 5;
                        long limitValue =  60 * limitTime * 1000 + System.currentTimeMillis();
                        SharedPreferencesUtils.getInstance().putLong(BabyExtraConstant.EXTRA_LIMITTIME,limitValue);
                    }
                }
            }

            @Override
            public void clickCancel() {
                //取消则断开对应的蓝牙设备
                HomeService.ME.disConnect(currentDevice.mac);
            }
        }, true);

        dialog.show();
    }

    /**
     * 当前用户身份是“保姆”时，对允许开锁时段和星期的校验
     */
    private boolean nannyCheckUnlockTimeAndWeekPeriod() {
        Calendar calendar = Calendar.getInstance();
        boolean flag = false;
//        int today = calendar.get(Calendar.DAY_OF_WEEK)-1;
//        if (today == 0) {
//            today = 7;
//        }
        int today = calendar.get(Calendar.DAY_OF_WEEK);
        if (currentDevice.weeks.contains(today)) {
            flag = true;
        }
        /*//for (MdlLockTimeListBean bean : currentDevice.lockTimeList) {
            if (String.valueOf(today).equals(currentDevice.weeks) || "8".equals(currentDevice.weeks)) {
                flag = true;
                //break;
            }
        //}*/
        if (!flag) {
            return false;
        }
        List<String> lockPeriodListBeans = currentDevice.times;
        int nowMinuteAndSecond = calendar.get(Calendar.HOUR_OF_DAY) * 60 + calendar.get(Calendar.MINUTE);
        flag = false;

        int[] period;
        for (String bean : lockPeriodListBeans) {
            period = new int[4];
            if (TextUtils.isEmpty(bean)) {
                continue;
            }
            String[] periodArr = bean.split("[:-]");
            int len = periodArr.length;
            len = len > 4 ? 4 : len;
            for (int i = 0; i < len; i++) {
                period[i] = Integer.parseInt(periodArr[i]);
            }
            if (period[0] * 60 + period[1] <= nowMinuteAndSecond && nowMinuteAndSecond <= period[2] * 60 + period[3]) {
                flag = true;
                return flag;
            }
        }

        return flag;
    }

    private void clickOpenBLELock() {
        if (MyUtility.checkBLEServiceIsNull()) {
            return;
        }
        if (isOneDeviceConnected) {
            HomeService.ME.writeData(BLEDeviceCmd.unlock());
        } else {
            LogAndToastUtil.toast("设备未连接!!!");
            startScan();
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode != RESULT_OK) {
            return;
        }
        switch (requestCode) {
            case PublicConstant.REQ_ITEM:
                currentDevice = data.getParcelableExtra(BabyExtraConstant.EXTRA_ITEM);
                break;
            case PublicConstant.REQ_ADDDEVICE:
                isUnlocking = false;
                MdlDevice device = data.getParcelableExtra("device");
                List<Integer> weeks = data.getIntegerArrayListExtra("weeks");
                if (device == null) return;
                if (weeks != null) {
                    device.weeks = weeks;
                }
                //currentDevice = device;
                SharedPreferencesUtils.getInstance().putString(BabyExtraConstant.EXTRA_MAC,device.mac);
                if (device.linkType == EnumDeviceLink.BLE) {
                    boolean flag = false;
                    if (!MyUtility.checkBLEServiceIsNull()) {
                        flag = HomeService.ME.getProfileState(device.mac);
                    }
                    if (flag) {
                        showCurrentDevice(device);
                        return;
                    }
                    if (currentDevice == null) {
                        showCurrentDevice(device);
                        startScan();
                        return;
                    }
                    if (device.mac.equals(currentDevice.mac)) {
                        showCurrentDevice(device);
                        if (isOneDeviceConnected) {
                            LogAndToastUtil.log("--------相同的设备，且已经连接上了------");
                        } else {
                            startScan();
                        }
                    } else {
                        if (MyUtility.checkBLEServiceIsNull()) {
                            return;
                        }
                        //if (isOneDeviceConnected) {
                            HomeService.ME.disConnect(currentDevice.mac);
                        //}
                        showCurrentDevice(device);
                        startScan();
                    }
                } else {
                    showCurrentDevice(device);
                }
                break;
        }

    }


    private void showDeviceStatusUI(boolean isLocked) {
        String str = isLocked ? "锁已打开" : "锁已关闭";
        Spannable spannable = Utility.getCommon2LinesSpan(str + "\n", getString(R.string.add_device), R.dimen.font_14, R.dimen.font_14, R.color.brown_1, R.color.gray3);
        tvDeviceStatus.setText(spannable);
    }

    private void updateDeviceNameDialog() {
//        String oldName = Utility.getEditTextStr(tvDeviceName);
//        if (TextUtils.isEmpty(oldName)) {
//            return;
//        }
        presenter.getAllDeviceByTypeRename(MyApplication.getInstance().deviceLinkType,MyApplication.getInstance().mdlUserInApp.token);

    }

    @Override
    public void showDeviceListResultRename(MdlBaseHttpResp<List<MdlDevice>> resp) {
        List<DeviceInfo> mScanAndAddedDevices = new ArrayList<>();
        List<MdlDevice> mAddedDevices = new ArrayList<>();
        if (resp.code == BabyHttpConstant.R_HTTP_OK) {
            if (currentPage == 1) {
                dataList.clear();
            }
            mAddedDevices.clear();
            mScanAndAddedDevices.clear();
            boolean haveData = resp.data != null && resp.data.size() > 0;
            if (haveData) {
                List<MdlDevice> list = resp.data;
                mAddedDevices.addAll(list);
                int length = list.size();
                MdlDevice mdlDevice;
                DeviceInfo deviceInfo;
                for (int i = 0; i < length; i++) {
                    mdlDevice = list.get(i);
                    if (mdlDevice != null) {
                        deviceInfo = new DeviceInfo();
                        deviceInfo.setName(mdlDevice.lockName);
                        deviceInfo.setAddress(mdlDevice.mac);
                        deviceInfo.setAdded(true);
                        mScanAndAddedDevices.add(deviceInfo);
                    }
                }
                if (adapter != null) {
                    adapter.notifyDataSetChanged();
                }
            } else {
                ToastUtil.toastShort(NewControlActivity.this, "没有连接对应的设备");
                return;
            }
        }
        //通过接口查询对应的设备信息， 弹出对应要连接的设备， 点击连接进行连接操作， 然后在将对应的设备开门业务
        View view = LayoutInflater.from(NewControlActivity.this).inflate(R.layout.dialog_dervice_list, null);
        MyDialog myDialogRename = new MyDialog(NewControlActivity.this, 0, 0, view, R.style.MyDialog, 0);
        RecyclerView listDialog = view.findViewById(R.id.listview_dialog);
        listDialog.setHasFixedSize(true);
        listDialog.setLayoutManager(new LinearLayoutManager(NewControlActivity.this));
        MyRecyclerAdapter adapter = new MyRecyclerAdapter<DeviceInfo>(this, R.layout._item_activity_new_add_ble_device, mScanAndAddedDevices) {
            @Override
            public void onUpdate(BaseAdapterHelper helper, final DeviceInfo item, final int position) {
                if (item == null) {
                    return;
                }
                helper.setText(R.id.tvName, item.getName());
                helper.setText(R.id.tvAddress, item.getAddress());
                if (item.isAdded()) {
                    helper.setText(R.id.tvAdd,"重命名");
                    helper.setVisible(R.id.tvDel,View.GONE);
                    helper.getView(R.id.tvAdd).setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            CommonInputDialog dialog = new CommonInputDialog(NewControlActivity.this, getString(R.string.rename_device),
                                    getString(R.string.input_device_name), new CommonInputDialog.ClickListener() {
                                @Override
                                public void clickConfirm(String content) {
//                                    handleUpdateDeviceName(content);
                                    myDialogRename.dismiss();
                                    presenter.updateDeviceName(mAddedDevices.get(position).id,content,MyApplication.getInstance().mdlUserInApp.token);
                                    setDeviceName(content);
                                    Utility.toggleSoftKeyboard(NewControlActivity.this);
                                }

                                @Override
                                public void clickCancel() {
                                }
                            });
                            dialog.show();
                        }
                    });
                }
            }
        };

        listDialog.setAdapter(adapter);
        myDialogRename.show();
    }

    private void handleUpdateDeviceName(String name) {
        //Map<String, Object> params = new HashMap<>();
        //params.put("name", name);
        //params.put("id", currentDevice.mac);
//        params.put("linkType", MyApplication.getInstance().deviceLinkType);
        presenter.updateDeviceName(currentDevice.id,name,MyApplication.getInstance().mdlUserInApp.token);
        setDeviceName(name);
    }

    /**
     * 弹出显示设备列表和添加设备的弹窗
     */
    private void initPopWindow() {
        //获取手机屏幕宽 用来设置弹窗宽度
        DisplayMetrics dm = Utility.getDisplayScreenSize(this);
        //填充弹窗视图
        LayoutInflater inflater = (LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View view = inflater.inflate(R.layout.popup_device_show, null);
        mPopupWindow = new PopupWindow(view, dm.widthPixels - 40, dm.heightPixels / 2);
        //设置获取焦点
        mPopupWindow.setFocusable(true);
        //设置弹窗外部可点击
        mPopupWindow.setOutsideTouchable(true);

        view.findViewById(R.id.ivAddDevice).setOnClickListener(new OnMultiClickListener() {
            @Override
            public void OnMultiClick(View view) {
                go2AddDevice();
                hidePopupWindow();
            }
        });


        initRecyclerView(view);
    }

    private void go2AddDevice() {
//        if (MyApplication.getInstance().deviceLinkType == EnumDeviceLink.BLE) {
//            if (isOneDeviceConnected && currentDevice != null) {
//                HomeService.ME.disConnect(currentDevice.mac);
//            }
//            startActivityForResult(new Intent(NewControlActivity.this, NewAddBleDeviceActivity.class),PublicConstant.REQ_ADDDEVICE);
//        } else {
//            WiFiAdmin mWiFiAdmin = new WiFiAdmin(this);
//            if (mWiFiAdmin.isWifiConnect()) {
//                startActivity(new Intent(NewControlActivity.this, NewWifiCurrentWifiActivity.class));
//            } else {
//                startActivity(new Intent(Settings.ACTION_WIFI_SETTINGS));
//            }
//        }

        startActivity(new Intent(NewControlActivity.this, NewSelectUnlockingModeActivity.class));
    }

    private void initRecyclerView(View view) {
        mXRecyclerView = view.findViewById(R.id.recyclerView);
        mXRecyclerView.fillData(dataList);

        LinearLayoutManager layoutManager = new WrapContentLinearLayoutManager(this);
        layoutManager.setOrientation(LinearLayoutManager.VERTICAL);
        mXRecyclerView.setLayoutManager(layoutManager);
        mXRecyclerView.addItemDecoration(new RecycleViewDivider(this, LinearLayoutManager.HORIZONTAL));

        initAdapter();
//        mXRecyclerView.setLoadingListener(new XRecyclerView.LoadingListener() {
//            @Override
//            public void onRefresh() {
//                loadRefresh();
//            }
//
//            @Override
//            public void onLoadMore() {
//                loadMore();
//            }
//        });
        mXRecyclerView.setAdapter(adapter);
        mXRecyclerView.setLoadingMoreEnabled(false);
        mXRecyclerView.setPullRefreshEnabled(false);
    }

    private void initAdapter() {
        adapter = new MyRecyclerAdapter<MdlDevice>(this, R.layout._item_popup_device_show, dataList) {
            @Override
            public void onUpdate(BaseAdapterHelper helper, final MdlDevice item, final int position) {
                if (item == null) {
                    return;
                }

                helper.setText(R.id.tvName, item.lockName);

                helper.setVisible(R.id.ivDel, item.isAdmin == EnumDeviceAdmin.IS_ADMIN);
                helper.setOnClickListener(R.id.ivDel, new OnMultiClickListener() {
                    @Override
                    public void OnMultiClick(View view) {
                        clickDelDeviceNotice(position);
                    }
                });
            }
        };
        adapter.setOnItemClickListener(new MyRecyclerAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(RecyclerView.ViewHolder viewHolder, View view, int position) {
                position--;

                MdlDevice device = dataList.get(position);
                if (device.linkType == EnumDeviceLink.BLE) {
                    boolean flag = false;
                    if (!MyUtility.checkBLEServiceIsNull()) {
                        flag = HomeService.ME.getProfileState(device.mac);
                    }
                    if (flag) {
                        showCurrentDevice(position);
                        return;
                    }
                    if (currentDevice == null) {
                        showCurrentDevice(position);
                        startScan();
                        return;
                    }
                    if (device.mac.equals(currentDevice.mac)) {
                        showCurrentDevice(position);
                        if (isOneDeviceConnected) {
                            LogAndToastUtil.log("--------相同的设备，且已经连接上了------");
                        } else {
                            startScan();
                        }
                    } else {
                        if (MyUtility.checkBLEServiceIsNull()) {
                            return;
                        }
                        if (isOneDeviceConnected) {
                            HomeService.ME.disConnect(currentDevice.mac);
                        }
                        showCurrentDevice(position);
                        startScan();
                    }
                } else {
                    showCurrentDevice(position);
                }
            }
        });
    }

    private void showCurrentDevice(int position) {
        currentDevice = dataList.get(position);
        setDeviceName(currentDevice.lockName);
        //todo 要处理显示电量
        double capacity = currentDevice.electricity < 0 ? 0:currentDevice.electricity > 100 ? 100 : currentDevice.electricity ;
        //tvDevicePower.setText(getResources().getString(R.string.devcapacity)+capacity+"V");

        resetBottomData();
        bottomAdapter.notifyDataSetChanged();

        hidePopupWindow();
    }
    private void showCurrentDevice(MdlDevice mdlDevice) {
        currentDevice = mdlDevice;
        setDeviceName(currentDevice.lockName);
        //todo 要处理显示电量
        double capacity = currentDevice.electricity < 0 ? 0:currentDevice.electricity > 100 ? 100 : currentDevice.electricity ;
        //tvDevicePower.setText(getResources().getString(R.string.devcapacity)+capacity+"V");
        resetBottomData();
        bottomAdapter.notifyDataSetChanged();
    }

    private void setDeviceName(String name) {
        if (TextUtils.isEmpty(name)) {
            tvDeviceName.setVisibility(View.GONE);
        } else {
            if (tvDeviceName.getVisibility() != View.VISIBLE) {
                tvDeviceName.setVisibility(View.VISIBLE);
            }
            tvDeviceName.setText(name);
        }
    }

    private void clickDelDeviceNotice(int position) {
        CommonDialog dialog = new CommonDialog(this, getString(R.string.delete), getString(R.string.delete_device_notice), new CommonDialog.ClickListener() {
            @Override
            public void clickConfirm() {
                actionIndex = position;

                MdlDevice md = dataList.get(position);
                if (isOneDeviceConnected && !MyUtility.checkBLEServiceIsNull()) {
                    HomeService.ME.disConnect(md.mac);
                }
                delDevice(md);
            }

            @Override
            public void clickCancel() {

            }
        });
        dialog.show();
    }

    private void delDevice(MdlDevice md) {
        if (currentDevice != null && currentDevice.mac.equals(md.mac)) {
            currentDevice = null;
            resetBottomData();
        }

        //Map<String, Object> params = new HashMap<>();
        //params.put("id", md.mac);
//        params.put("isAdmin", md.isAdmin);
//        params.put("linkType", MyApplication.getInstance().deviceLinkType);
//        params.put("number", MyApplication.getInstance().mdlUserInApp.phone);
        presenter.delDevice(md.id,MyApplication.getInstance().mdlUserInApp.token);
    }

    private void addUnlockRecord2Remote() {
        if (currentDevice == null) {
            return;
        }
        /*Map<String, Object> params = new HashMap<>();
        params.put("deviceId", currentDevice.mac);
        params.put("scenePwd", currentDevice.pwd);//y190604
        params.put("userType", currentDevice.isAdmin);
        params.put("sceneFingerprints", "");
        params.put("openValue", EnumSwitch.ON);
        params.put("openType", MyApplication.getInstance().deviceLinkType);*/
//        params.put("number", MyApplication.getInstance().mdlUserInApp.phone);
        //String id,String openType,int openValue,String sceneFingerprints,String scenePwd,int userType,String token
        presenter.addUnlockRecord(currentDevice.id,MyApplication.getInstance().UNLOCK_APP,EnumSwitch.ON,"",
                currentDevice.pwd,currentDevice.isAdmin,MyApplication.getInstance().mdlUserInApp.token);
    }

    @Override
    protected ControlActivityPresenter createPresenter() {
        return new ControlActivityPresenter(this);
    }

    @Override
    public void showDeviceListResult(MdlBaseHttpResp<List<MdlDevice>> resp) {
        if (resp.code == BabyHttpConstant.R_HTTP_OK) {
            if (currentPage == 1) {
                dataList.clear();
            }
            boolean haveData = resp.data != null && resp.data.size() > 0;
            if (haveData) {
                dataList.addAll(resp.data);
                if (!unlocking) {
                    if (mPopupWindow == null || !mPopupWindow.isShowing()) {
                        int length = dataList.size();
                        String lastAddress = SharedPreferencesUtils.getInstance().getSPFString(BabyExtraConstant.EXTRA_MAC);//上一次开门的地址
                        MdlDevice mdlDevice;
                        for (int i = 0; i < length; i++) {
                            mdlDevice = dataList.get(i);
                            if(!TextUtils.isEmpty(mdlDevice.mac)){
                                showCurrentDevice(i);
                            }
                            if (TextUtils.equals(lastAddress, mdlDevice.mac)) { //显示之前address
                                showCurrentDevice(i);
                                break;
                            }
                        }
                        return;
                    }
                } else {
                    unlocking = false;
                    int lenght = dataList.size();
                    MdlDevice mdlDevice;
                    for (int i = 0; i < lenght; i++) {
                        mdlDevice = dataList.get(i);
                        if (mdlDevice != null && TextUtils.equals(mdlDevice.mac,currentDevice.mac)) {
                            currentDevice = mdlDevice;
                            unlock();
                            return;
                        }
                    }
                    LogAndToastUtil.toast(getResources().getString(R.string.nolicenseunlock));
                    return;
                }
            } else {
                currentDevice = null;
                tvDeviceName.setVisibility(View.INVISIBLE);
                initBottomView();
            }
            if (mXRecyclerView != null) {
                mXRecyclerView.loadMoreComplete();
                mXRecyclerView.refreshComplete();
            }
            if (adapter != null) {
                adapter.notifyDataSetChanged();
            }
        }
    }

    @Override
    public void showDelDeviceResult(MdlBaseHttpResp resp) {
        if (resp.code == BabyHttpConstant.R_HTTP_OK) {
            if (actionIndex >= 0) {
                dataList.remove(actionIndex);
                mXRecyclerView.notifyItemRemoved(dataList, actionIndex);
            }
        }
    }

    @Override
    public void showUpdateDeviceNameResult(MdlBaseHttpResp resp) {
        if (resp.code == BabyHttpConstant.R_HTTP_OK) {
            currentDevice.lockName = Utility.getEditTextStr(tvDeviceName);
        } else {
            setDeviceName(currentDevice.lockName);
        }
    }

    @Override
    public void showAddUnlockRecordResult(MdlBaseHttpResp resp) {

    }

    @Override
    protected void timeoutStopScan() {
        LogAndToastUtil.cancelWait(this);
    }

    @Override
    protected void bleSwitchOff() {

    }

    @Override
    protected void onPause() {
        super.onPause();
        isVisible = false;
    }

    @Override
    protected void onResume() {
        super.onResume();
        isVisible = true;
        getAllDevice();
    }

    @Override
    protected void scanNewDevice(MdlScanNewDevice mdlScanNewDevice) {
        if (currentDevice != null && mdlScanNewDevice.device.getAddress().replace(":","").equals(currentDevice.mac)) {
            if (!isVisible) return;
            LogAndToastUtil.cancelWait(this);

            Utility.ThreadSleep(150);
            if (!isOneDeviceConnected) {
                mHandler.sendEmptyMessageDelayed(0,4000);
                LogAndToastUtil.showWait(this, R.string.connecting);
            }
            HomeService.ME.connect(mdlScanNewDevice.device.getAddress());
        }
    }

    Handler mHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            switch (msg.what) {
                case 0:
                    if (isOneDeviceConnected) {
                        LogAndToastUtil.cancelWait(NewControlActivity.this);
                    }
                    break;
                    default:
                        break;
            }

        }
    };

    @Override
    protected void prepareScan() {
        LogAndToastUtil.showWait(this, R.string.scanning);
    }
    public static final int SCAN_NEW_DEVICE = 0XE0; //224
    public static final int CONNECTED = 0XE1; //225
    public static final int DISCONNECTED = 0XE2;//226
    public static final int REGISTER_OK = 0XE3; //227
    public static final int AUTO_STOP_SCAN = 0XE4; //228
    public static final int NOTIFY = 0XE5; //229
    public static final int CUSTOM_CONNECT_TIMEOUT = 0XE6; //230
    public static final int STOP_SCAN = 0XE7; //231
    public static final int BONDED = 0X30;  //48
    public static final int SET_PWD = 0X31; //49
    public static final int GET_POWER = 0X32; //50
    public static final int UNLOCK = 0X33; //51
    public static final int RESET_PWD = 0X34; //52
    public static final int DEVICE_ACTIVE_REPORT_POWER = 0X35; //53
    public static final int DEVICE_ACTIVE_REPORT_LOCK_STATUS = 0X36;//54
    private  Handler handler = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            if(msg.what == 0){
                isLocking = false; //没有正在开门
            }
        }
    };

    @Override
    public synchronized void onEventBusMessage(MdlEventBus event) {super.onEventBusMessage(event);
        LogAndToastUtil.log("jerry"+"the event bus message the type is" + event.eventType,event);
        switch (event.eventType) {
            case BLEDeviceStatus.CONNECTED: {
                LogAndToastUtil.cancelWait(this);
                isOneDeviceConnected = true;
//                LogAndToastUtil.toast(R.string.connected);
                hidePopupWindow();
                if(myDialog != null){
                    myDialog.dismiss();
                    myDialog = null;
                }
                checkUnlock();
                SharedPreferencesUtils.getInstance().putBoolean(BabyExtraConstant.EXTRA_ISOPENDEVICE,true);
                break;
            }
            case BLEDeviceStatus.DISCONNECTED:
            case BLEDeviceStatus.CUSTOM_CONNECT_TIMEOUT:
                LogAndToastUtil.cancelWait(this);
                isOneDeviceConnected = false;
//                LogAndToastUtil.toast(R.string.disconnected);
                tvDevicePower.setText(getResources().getString(R.string.disconnectdev));
                if (MyApplication.getInstance().deviceLinkType == EnumDeviceLink.BLE) {
                    ivLockStatus.setImageResource(R.drawable.ic_ble_lock_switch_off);
                } else {
                    ivLockStatus.setImageResource(R.drawable.ic_wifi_lock_switch_off);
                }
                showDeviceStatusUI(false);
                tvDevicePower.setVisibility(View.INVISIBLE);
                if(myDialog != null){
                    myDialog.dismiss();
                    myDialog = null;
                }
                break;
            case EnumBLECmd.UNLOCK: {
                if (MyApplication.getInstance().deviceLinkType == EnumDeviceLink.BLE) {
                    ivLockStatus.setImageResource(R.drawable.ic_ble_lock_switch_on);
                } else {
                    ivLockStatus.setImageResource(R.drawable.ic_wifi_lock_switch_on);
                }
                showDeviceStatusUI(true);
                addUnlockRecord2Remote();
                //正在开门中
                isLocking = true;
                handler.sendEmptyMessageDelayed(0,20000);
                break;
            }
            case EnumBLECmd.GET_POWER:
            case EnumBLECmd.DEVICE_ACTIVE_REPORT_POWER: {
                byte[] data = (byte[]) event.data;
                float powerV = Utility.byte2Uint(data[0]) * 0.1f;
                mPower = powerV;
                if (powerV < 4.2) {
                    tvDevicePower.setText(getResources().getString(R.string.lowcapacity_dontunlock));
                } else if (powerV < 4.5) {
                    tvDevicePower.setText(getResources().getString(R.string.lowcapacity_plschangebattery));
                } else {
                    tvDevicePower.setText(Utility.myFormat("设备电量 %.1fV", powerV));
                }
                tvDevicePower.setVisibility(View.VISIBLE);
                checkLowPower(powerV);
                break;
            }

            case EnumBLECmd.BONDED: {
                if (!MyUtility.checkBLEServiceIsNull()) {
//                    LogAndToastUtil.log("BLEDeviceCmd.getPower()------------");
                    HomeService.ME.writeData(BLEDeviceCmd.getPower());
                }
                break;
            }

            /*
             * 根据这个得到的貌似是错误的状态
             * 回调通知onCharacteristicChanged()->uuid:0000ff01-0000-1000-8000-00805f9b34fb;value: 0x5A 0xA5 0x33 0x01 0x01 0xCC
             * 回调通知onCharacteristicChanged()->uuid:0000ff01-0000-1000-8000-00805f9b34fb;value: 0x5A 0xA5 0x36 0x01 0x00 0xC8
             */
            case EnumBLECmd.DEVICE_ACTIVE_REPORT_LOCK_STATUS: {
//                byte[] data = (byte[]) event.data;
//                if (data[0] == Byte.parseByte(EnumSwitch.OFF)) {
//                    if (MyApplication.getInstance().deviceLinkType == EnumDeviceLink.BLE) {
//                        ivLockStatus.setImageResource(R.drawable.ic_ble_lock_switch_off);
//                    } else {
//                        ivLockStatus.setImageResource(R.drawable.ic_wifi_lock_switch_off);
//                    }
//                    showDeviceStatusUI(false);
//                } else {
//                    if (MyApplication.getInstance().deviceLinkType == EnumDeviceLink.BLE) {
//                        ivLockStatus.setImageResource(R.drawable.ic_ble_lock_switch_on);
//                    } else {
//                        ivLockStatus.setImageResource(R.drawable.ic_wifi_lock_switch_on);
//                    }
//                    showDeviceStatusUI(true);
//                }
                break;
            }
        }
    }

    private void checkLowPower(float v) {
        if (!isShowLowPower && v < LOW_POWER_V) {
            isShowLowPower = true;
            LogAndToastUtil.toast("电量低");
        }
    }

    //重写方法，为了是在当前activity不扫描ble设备
    @Override
    protected void permissionOK() {

    }

    @Override
    protected void handleBackKey() {
        if (backCount == 0) {
            LogAndToastUtil.toast(R.string.click_again_go_desktop);
            backCount++;

            Message msg = DelayHandler.getInstance().obtainMessage();
            msg.what = BACK_COUNT_RESET_0_WHAT;
            msg.obj = new Runnable() {
                @Override
                public void run() {
                    backCount = 0;
                }
            };
            DelayHandler.getInstance().sendMessageDelayed(msg, 2 * 1000);
        } else if (backCount >= 1) {
            DelayHandler.getInstance().removeMessages(BACK_COUNT_RESET_0_WHAT);

            // 回到桌面
            //Utility.goToDesktop(this);
            finish();
            backCount = 0;
        }

    }


}
