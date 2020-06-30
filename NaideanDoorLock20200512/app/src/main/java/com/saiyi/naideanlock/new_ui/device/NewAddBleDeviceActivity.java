package com.saiyi.naideanlock.new_ui.device;

import android.bluetooth.BluetoothDevice;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.view.animation.LinearInterpolator;
import android.widget.ImageView;
import android.widget.TextView;

import com.saiyi.naideanlock.R;
import com.saiyi.naideanlock.application.MyApplication;
import com.saiyi.naideanlock.bean.DeviceInfo;
import com.saiyi.naideanlock.bean.MdlDevice;
import com.saiyi.naideanlock.bean.MdlScanNewDevice;
import com.saiyi.naideanlock.enums.BLEDeviceStatus;
import com.saiyi.naideanlock.enums.EnumDeviceAdmin;
import com.saiyi.naideanlock.enums.EnumDeviceLink;
import com.saiyi.naideanlock.new_ui.base.MVPBaseHandleBLEActivity;
import com.saiyi.naideanlock.new_ui.device.mvp.p.AddDeviceActivityPresenter;
import com.saiyi.naideanlock.new_ui.device.mvp.v.AddDeviceActivityView;
import com.saiyi.naideanlock.service.HomeService;
import com.saiyi.naideanlock.utils.MyUtility;
import com.saiyi.naideanlock.utils.SharedPreferencesUtils;
import com.sandy.guoguo.babylib.adapter.recycler.BaseAdapterHelper;
import com.sandy.guoguo.babylib.adapter.recycler.MyRecyclerAdapter;
import com.sandy.guoguo.babylib.adapter.recycler.RecycleViewDivider;
import com.sandy.guoguo.babylib.adapter.recycler.WrapContentLinearLayoutManager;
import com.sandy.guoguo.babylib.constant.BabyHttpConstant;
import com.sandy.guoguo.babylib.dialogs.CommonDialog;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.listener.OnMultiClickListener;
import com.sandy.guoguo.babylib.utils.LogAndToastUtil;
import com.sandy.guoguo.babylib.utils.ResourceUtil;
import com.sandy.guoguo.babylib.utils.eventbus.MdlEventBus;
import com.sandy.guoguo.babylib.widgets.MyRecyclerView;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class  NewAddBleDeviceActivity extends MVPBaseHandleBLEActivity<AddDeviceActivityView, AddDeviceActivityPresenter> implements AddDeviceActivityView {
    private MyRecyclerView<DeviceInfo> mXRecyclerView;
    private MyRecyclerAdapter<DeviceInfo> adapter;
    private List<MdlScanNewDevice> dataList = new ArrayList<>();
    private List<DeviceInfo> mScanAndAddedDevices = new ArrayList<>();
    private List<MdlDevice> mAddedDevices = new ArrayList<>();

    private ImageView ivBgBle;
    private TextView tvNote;
    private int actionIndex;
    private int mPosition = 0;

    @Override
    public void onDestroy() {
        super.onDestroy();
        stopAnim();
        if (mXRecyclerView != null) {
            mXRecyclerView.destroy();
            mXRecyclerView = null;
        }
    }

    /**
     * 旋转动画
     */
    private void startAnim() {
        tvNote.setText(R.string.is_searching);
        Animation circle_anim = AnimationUtils.loadAnimation(this, R.anim.anim_round_rotate);
        LinearInterpolator interpolator = new LinearInterpolator();  //设置匀速旋转，在xml文件中设置会出现卡顿
        circle_anim.setInterpolator(interpolator);
        ivBgBle.startAnimation(circle_anim);  //开始动画
        ivBgBle.setEnabled(false);
    }

    /**
     * 停止动画
     */
    private void stopAnim() {
        tvNote.setText(R.string.note_searching);
        ivBgBle.setEnabled(true);
        ivBgBle.clearAnimation();
    }

    @Override
    protected void timeoutStopScan() {
        stopAnim();
    }

    @Override
    protected void bleSwitchOff() {

    }

    @Override
    protected void scanNewDevice(MdlScanNewDevice mdlScanNewDevice) {
        if (!dataList.contains(mdlScanNewDevice)) {
            dataList.add(mdlScanNewDevice);
            DeviceInfo deviceInfo1;
            boolean isRefresh = false;
            String address = mdlScanNewDevice.device.getAddress();
            if (address == null) return;
            if (address.contains(":")) {
                address = address.replace(":","");
            }
            if (mScanAndAddedDevices.size() == 0) {
                DeviceInfo deviceInfo = new DeviceInfo();
                deviceInfo.setAddress(address);
                deviceInfo.setName(mdlScanNewDevice.device.getName() == null ? "Lock":mdlScanNewDevice.device.getName());
                isRefresh = true;
                mScanAndAddedDevices.add(deviceInfo);
            } else {
                isRefresh = true;
                for (int i = 0; i < mScanAndAddedDevices.size(); i++) {
                    deviceInfo1 = mScanAndAddedDevices.get(i);
                    if (TextUtils.equals(deviceInfo1.getAddress(), address)) {
                        isRefresh = false;
                    }
                }
                if (isRefresh) {
                    DeviceInfo deviceInfo = new DeviceInfo();
                    deviceInfo.setAddress(address);
                    deviceInfo.setName(mdlScanNewDevice.device.getName() == null ? "Lock":mdlScanNewDevice.device.getName());
                    mScanAndAddedDevices.add(deviceInfo);
                }
            }
            if (!isRefresh) {
                return;
            }
            mXRecyclerView.notifyItemInserted(mScanAndAddedDevices, mScanAndAddedDevices.size());
        }
    }

    @Override
    protected void prepareScan() {

    }

    @Override
    public synchronized void onEventBusMessage(MdlEventBus event) {
        super.onEventBusMessage(event);
        switch (event.eventType) {
            case BLEDeviceStatus.STOP_SCAN:
                LogAndToastUtil.cancelWait(this);
                timeoutStopScan();
                break;

        }
    }

    @Override
    protected int getTitleResId() {
        return R.string.device_add;
    }

    @Override
    protected int getLayoutResId() {
        return R.layout.activity_new_add_ble_device;
    }

    @Override
    protected void initViewAndControl() {
        initNav();

        ivBgBle = findView(R.id.ivBgBle);
        ivBgBle.setOnClickListener(new OnMultiClickListener() {
            @Override
            public void OnMultiClick(View view) {
                startAnim();
                startScan();
            }
        });

        mXRecyclerView = findView(R.id.recyclerView);
        mXRecyclerView.fillData(mScanAndAddedDevices);


        LinearLayoutManager layoutManager = new WrapContentLinearLayoutManager(this);
        layoutManager.setOrientation(LinearLayoutManager.VERTICAL);
        mXRecyclerView.setLayoutManager(layoutManager);

        mXRecyclerView.addItemDecoration(new RecycleViewDivider(this, LinearLayoutManager.HORIZONTAL));

        initAdapter();


        mXRecyclerView.setAdapter(adapter);
        mXRecyclerView.setLoadingMoreEnabled(false);
        mXRecyclerView.setPullRefreshEnabled(false);

        //startAnim();
        presenter.getAllDeviceByType(MyApplication.getInstance().deviceLinkType,MyApplication.getInstance().mdlUserInApp.token);
    }


    private void initNav() {
        TextView tvLeft = findView(R.id.toolbarLeft);
        tvNote = findView(R.id.tv_note);
        tvLeft.setVisibility(View.VISIBLE);
        ResourceUtil.setCompoundDrawable(tvLeft, R.drawable.dr_ic_back, 0, 0, 0);
    }


    private void initAdapter() {
        adapter = new MyRecyclerAdapter<DeviceInfo>(this, R.layout._item_activity_new_add_ble_device, mScanAndAddedDevices) {
            @Override
            public void onUpdate(BaseAdapterHelper helper, final DeviceInfo item, final int position) {
                if (item == null) {
                    return;
                }

                helper.setText(R.id.tvName, item.getName());
                helper.setText(R.id.tvAddress, item.getAddress());
                if (item.isAdded()) {
                    helper.setText(R.id.tvAdd,getResources().getString(R.string.connectdevice));
                    helper.setVisible(R.id.tvAdd,View.GONE);
                    helper.setVisible(R.id.tvDel,View.VISIBLE);
                    helper.getView(R.id.tvAdd).setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            DeviceInfo deviceInfo = mScanAndAddedDevices.get(position);
                            MdlDevice mdlDevice;
                            for (int i = 0; i < mAddedDevices.size(); i++) {
                                mdlDevice = mAddedDevices.get(i);
                                if (TextUtils.equals(mdlDevice.mac,deviceInfo.getAddress())) {
                                    //SharedPreferencesUtils.getInstance().putIntger("position",position);
                                    Intent intent = new Intent();
                                    intent.putExtra("device",mdlDevice);
                                    intent.putIntegerArrayListExtra("weeks",(ArrayList<Integer>)mdlDevice.weeks);

                                    NewAddBleDeviceActivity.this.setResult(RESULT_OK,intent);
                                    NewAddBleDeviceActivity.this.finish();

                                    //mScanAndAddedDevices.remove(actionIndex);
                                    //mXRecyclerView.notifyItemRemoved(mScanAndAddedDevices, actionIndex);
                                }
                            }
                        }
                    });
                    helper.getView(R.id.tvDel).setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            clickDelDeviceNotice(position,helper.getView(R.id.tvAdd));
                        }
                    });
                } else {
                    helper.setText(R.id.tvAdd,getResources().getString(R.string.add));
                    helper.setVisible(R.id.tvDel,View.GONE);
                    helper.getView(R.id.tvAdd).setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            mPosition = position;
                            DeviceInfo deviceInfo = mScanAndAddedDevices.get(position);
                            addDevice(mScanAndAddedDevices.get(position));
                        }
                    });
                }
            }
        };

//        adapter.setOnItemClickListener(new MyRecyclerAdapter.OnItemClickListener() {
//            @Override
//            public void onItemClick(RecyclerView.ViewHolder viewHolder, View view, int position) {
//                position--;
//                DeviceInfo deviceInfo = mScanAndAddedDevices.get(position);
//                if (!deviceInfo.isAdded()) {
//                    addDevice(mScanAndAddedDevices.get(position));
//                } else {
//                    clickDelDeviceNotice(position);
//                }
//            }
//        });
    }

    private void delDevice(MdlDevice md) {

        presenter.delDevice(md.id,MyApplication.getInstance().mdlUserInApp.token);
    }

    private void clickDelDeviceNotice(int position,View view) {
        CommonDialog dialog = new CommonDialog(this, getString(R.string.delete), getString(R.string.delete_device_notice), new CommonDialog.ClickListener() {
            @Override
            public void clickConfirm() {
                actionIndex = position;

                DeviceInfo deviceInfo = mScanAndAddedDevices.get(position);
                MdlDevice mdlDevice;
                for (int i = 0; i < mAddedDevices.size(); i++) {
                    mdlDevice = mAddedDevices.get(i);
                    if (TextUtils.equals(mdlDevice.mac,deviceInfo.getAddress())) {
                        if (isOneDeviceConnected && !MyUtility.checkBLEServiceIsNull()) {
                            HomeService.ME.disConnect(mdlDevice.mac);
                        }
                        delDevice(mdlDevice);
                        if(view != null){
                            ((TextView)view).setText(getResources().getString(R.string.connectdevice));
                            view.setVisibility(View.VISIBLE);
                        }
                        //mScanAndAddedDevices.remove(actionIndex);
                        //mXRecyclerView.notifyItemRemoved(mScanAndAddedDevices, actionIndex);
                    }
                }

            }

            @Override
            public void clickCancel() {

            }
        });
        dialog.show();
    }

    private void addDevice(DeviceInfo deviceInfo) {
        /*Map<String, Object> params = new HashMap<>();
        params.put("number", MyApplication.getInstance().mdlUserInApp.phone);
        params.put("mac", bleDevice.getAddress());
        params.put("lockName", bleDevice.getName());
        params.put("isAdmin", EnumDeviceAdmin.NOT_ADMIN);
        params.put("linkType", EnumDeviceLink.BLE);*/
        String address = deviceInfo.getAddress();
        if (address.contains(":")) {
            address = address.replace(":","");
        }
        presenter.bindDevice(address,deviceInfo.getName(), EnumDeviceLink.BLE+"",MyApplication.getInstance().mdlUserInApp.token);
    }

    private void addDevice(BluetoothDevice bleDevice) {
        /*Map<String, Object> params = new HashMap<>();
        params.put("number", MyApplication.getInstance().mdlUserInApp.phone);
        params.put("mac", bleDevice.getAddress());
        params.put("lockName", bleDevice.getName());
        params.put("isAdmin", EnumDeviceAdmin.NOT_ADMIN);
        params.put("linkType", EnumDeviceLink.BLE);*/
        String address = bleDevice.getAddress();
        if (address.contains(":")) {
            address = address.replace(":","");
        }
        presenter.bindDevice(address,bleDevice.getName(), EnumDeviceLink.BLE+"",MyApplication.getInstance().mdlUserInApp.token);
    }

    @Override
    protected AddDeviceActivityPresenter createPresenter() {
        return new AddDeviceActivityPresenter(this);
    }

    @Override
    public void showAddDeviceResult(MdlBaseHttpResp resp) {
        if (resp.code == BabyHttpConstant.R_HTTP_OK) {
            /*if (mPosition >=0 && mPosition < mScanAndAddedDevices.size()) {
                DeviceInfo deviceInfo = mScanAndAddedDevices.get(mPosition);
                deviceInfo.setAdded(true);
                mScanAndAddedDevices.set(mPosition, deviceInfo);
                adapter.notifyDataSetChanged();
            }*/
            dataList.clear();
            mScanAndAddedDevices.clear();
            mAddedDevices.clear();
            presenter.getAllDeviceByType(MyApplication.getInstance().deviceLinkType,MyApplication.getInstance().mdlUserInApp.token);
            //finish();
        }
    }

    @Override
    public void showDeviceListResult(MdlBaseHttpResp<List<MdlDevice>> resp) {

        if (resp.code == BabyHttpConstant.R_HTTP_OK) {
            if (currentPage == 1) {
                dataList.clear();
            }


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
                //startScan();
                if (adapter != null) {
                    adapter.notifyDataSetChanged();
                }

            } else {
                //startScan();
            }

        }
    }

    @Override
    public void showDelDeviceResult(MdlBaseHttpResp resp) {
        if (resp.code == BabyHttpConstant.R_HTTP_OK) {
            /*if (actionIndex >= 0) {
                mScanAndAddedDevices.remove(actionIndex);
                mXRecyclerView.notifyItemRemoved(mScanAndAddedDevices, actionIndex);
            }*/
            if (actionIndex >= 0) {
                if (actionIndex < mAddedDevices.size()) {
                    mAddedDevices.remove(actionIndex);
                }
                DeviceInfo deviceInfo = mScanAndAddedDevices.get(actionIndex);
                deviceInfo.setAdded(false);
                mScanAndAddedDevices.set(actionIndex, deviceInfo);
                adapter.notifyDataSetChanged();
            }
            /*dataList.clear();
            mScanAndAddedDevices.clear();
            mAddedDevices.clear();
            presenter.getAllDeviceByType(MyApplication.getInstance().deviceLinkType,MyApplication.getInstance().mdlUserInApp.token);*/
        }
    }
}
