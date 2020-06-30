package com.saiyi.naideanlock.new_ui.device;

import android.Manifest;
import android.content.Intent;
import android.os.Build;
import android.provider.Settings;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.TextView;

import com.jcodecraeer.xrecyclerview.XRecyclerView;
import com.saiyi.naideanlock.R;
import com.saiyi.naideanlock.application.MyApplication;
import com.saiyi.naideanlock.bean.MdlDevice;
import com.saiyi.naideanlock.bean.MdlWifiDevice;
import com.saiyi.naideanlock.bean.MdlWifiTransfer;
import com.saiyi.naideanlock.enums.EnumDeviceAdmin;
import com.saiyi.naideanlock.enums.EnumDeviceLink;
import com.saiyi.naideanlock.new_ui.device.mvp.p.AddDeviceActivityPresenter;
import com.saiyi.naideanlock.new_ui.device.mvp.v.AddDeviceActivityView;
import com.sandy.guoguo.babylib.adapter.recycler.BaseAdapterHelper;
import com.sandy.guoguo.babylib.adapter.recycler.MyRecyclerAdapter;
import com.sandy.guoguo.babylib.adapter.recycler.WrapContentLinearLayoutManager;
import com.sandy.guoguo.babylib.constant.BabyHttpConstant;
import com.sandy.guoguo.babylib.dialogs.CommonDialog;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.enums.EnumEventBus;
import com.sandy.guoguo.babylib.listener.OnMultiClickListener;
import com.sandy.guoguo.babylib.ui.MVPBaseActivity;
import com.sandy.guoguo.babylib.utils.LogAndToastUtil;
import com.sandy.guoguo.babylib.utils.ResourceUtil;
import com.sandy.guoguo.babylib.utils.eventbus.MdlEventBus;
import com.sandy.guoguo.babylib.utils.permission.PermissionUtil;
import com.sandy.guoguo.babylib.widgets.MyRecyclerView;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import object.p2pipcam.nativecaller.BridgeService;
import object.p2pipcam.nativecaller.NativeCaller;

/**
 * AP（设备）列表
 * <p> 可能用不上了，只是我没有删除
 */
public class NewWifiAPListActivity extends MVPBaseActivity<AddDeviceActivityView, AddDeviceActivityPresenter> implements AddDeviceActivityView {
    private MyRecyclerView<MdlWifiDevice> mXRecyclerView;
    private MyRecyclerAdapter<MdlWifiDevice> adapter;
    private List<MdlWifiDevice> dataList = new ArrayList<>();

    private TextView tvEmpty;

    private static final String WIFI_SSID_PREFIX = "IKB";

    @Override
    protected int getLayoutResId() {
        return R.layout.activity_new_wifi_ap_list;
    }

    private void initNav() {
        TextView tvLeft = findView(R.id.toolbarLeft);
        tvLeft.setVisibility(View.VISIBLE);
        ResourceUtil.setCompoundDrawable(tvLeft, R.drawable.dr_ic_back, 0, 0, 0);
    }

    @Override
    protected void initViewAndControl() {
        initNav();


        mXRecyclerView = findView(R.id.recyclerView);
        mXRecyclerView.fillData(dataList);


        LinearLayoutManager layoutManager = new WrapContentLinearLayoutManager(this);
        layoutManager.setOrientation(LinearLayoutManager.VERTICAL);
        mXRecyclerView.setLayoutManager(layoutManager);

//        mXRecyclerView.addItemDecoration(new RecycleViewDivider(this, LinearLayoutManager.HORIZONTAL));

        initAdapter();

        mXRecyclerView.setLoadingListener(new XRecyclerView.LoadingListener() {
            @Override
            public void onRefresh() {
                loadRefresh();
            }

            @Override
            public void onLoadMore() {
//                loadMore();
            }
        });
        mXRecyclerView.setAdapter(adapter);
        mXRecyclerView.setLoadingMoreEnabled(false);

        tvEmpty = findView(R.id.tvEmpty);
        tvEmpty.setOnClickListener(new OnMultiClickListener() {
            @Override
            public void OnMultiClick(View view) {
                loadRefresh();
            }
        });

        resetRecyclerView(false);

        initWifiService();

        requestAccessLocationPermission();
    }

    private void initWifiService() {
//        BridgeService.setSHIXCOMMONInterface(this);

        Intent intent = new Intent();
        intent.setClass(this, BridgeService.class);
        startService(intent);


        new Thread(new Runnable() {
            @Override
            public void run() {
                try {

                    /**
                     * 以下是初始化SDK的方法，启动我的SDK 先调用
                     * **/
                    NativeCaller.PPPPInitial("");
                    NativeCaller.PPPPNetworkDetect();
                    NativeCaller.Init();
                } catch (Exception e) {

                }
            }
        }).start();
    }


    private void loadRefresh() {
        currentPage = 1;
        dataList.clear();

        adapter.notifyDataSetChanged();

        startScan();
    }

    private void initAdapter() {
        adapter = new MyRecyclerAdapter<MdlWifiDevice>(this, R.layout._item_activity_new_wifi_list, dataList) {


            @Override
            public void onUpdate(BaseAdapterHelper helper, final MdlWifiDevice item, final int position) {
                if (item == null) {
                    return;
                }
//                ImageView ivPic = helper.getView(R.id.ivPic);
//                showRemoteGoodsImage(item.picture, ivPic);

                helper.setText(R.id.tvName, item.strDeviceID);


            }
        };

        adapter.setOnItemClickListener(new MyRecyclerAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(RecyclerView.ViewHolder viewHolder, View view, int position) {
                position--;
                clickDetail(position);
            }
        });
    }

    private void clickDetail(int position) {
//        Intent intent = new Intent();
//        intent.putExtra(BabyExtraConstant.EXTRA_ITEM, dataList.get(position));
//        setResult(RESULT_OK, intent);
//        finish();

        MdlWifiDevice wifiDevice = dataList.get(position);

        Map<String, Object> params = new HashMap<>();
        params.put("number", MyApplication.getInstance().mdlUserInApp.phone);

        /*
        目前此摄像头模块strMac总为：0:0:0:0:0:0，但业务需求，此字段必须唯一。
        因此，先用模块的strDeviceID代替
        */
//        params.put("mac", wifiDevice.strMac);
        /*params.put("mac", wifiDevice.strDeviceID);


        params.put("lockName", wifiDevice.strName);
        params.put("isAdmin", EnumDeviceAdmin.NOT_ADMIN);
        params.put("linkType", EnumDeviceLink.WIFI);
        params.put("uid", wifiDevice.strDeviceID);*/

        presenter.bindDevice(wifiDevice.strDeviceID,wifiDevice.strName, EnumDeviceLink.WIFI+"",MyApplication.getInstance().mdlUserInApp.token);
    }

    private void resetRecyclerView(boolean haveData) {
        if (haveData) {
            mXRecyclerView.setVisibility(View.VISIBLE);
            tvEmpty.setVisibility(View.GONE);
        } else {
            mXRecyclerView.setVisibility(View.GONE);
            tvEmpty.setVisibility(View.VISIBLE);
        }
    }

    public void requestAccessLocationPermission() {
        PermissionUtil.checkPermission(this, PermissionUtil.PERMISSION_ACCESS_COARSE_LOCATION_REQ_CODE, Manifest.permission.ACCESS_COARSE_LOCATION);
    }

    public void checkAccessGPSLocation() {
        //Android 6.0版本以上，需开启定位服务，才能获取扫描结果
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            // 获取定位服务状态
            int locationMode;
            try {
                locationMode = Settings.Secure.getInt(getContentResolver(), Settings.Secure.LOCATION_MODE);
            } catch (Settings.SettingNotFoundException e) {
                e.printStackTrace();
                locationMode = Settings.Secure.LOCATION_MODE_OFF;
            }
            if (locationMode == Settings.Secure.LOCATION_MODE_OFF) {
                CommonDialog commonDialog = new CommonDialog(this, "Android6.0 以上版本需打开定位服务，才能扫描设备", "是否前往设置？", new CommonDialog.ClickListener() {
                    @Override
                    public void clickConfirm() {
                        startActivity(new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS));
                    }

                    @Override
                    public void clickCancel() {

                    }
                });
                commonDialog.show();
            }
        }
    }

    @Override
    public void permissionSuccess(int permissionReqCode) {
        super.permissionSuccess(permissionReqCode);

        LogAndToastUtil.log("----permissionSuccess---");

        checkAccessGPSLocation();
        startScan();
    }

    private void startScan() {
        LogAndToastUtil.showWait(this, R.string.scanning);
        /**
         * 局域网搜索
         * **/
        new Thread() {
            @Override
            public void run() {
                NativeCaller.StartSearch();

                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                NativeCaller.StopSearch();
                super.run();
            }
        }.start();
    }

    @Override
    protected int getTitleResId() {
        return R.string.wifi_list;
    }


    @Override
    protected void onDestroy() {
        super.onDestroy();
        Intent intent = new Intent();
        intent.setClass(this, BridgeService.class);
        stopService(intent);
    }

    @Override
    protected AddDeviceActivityPresenter createPresenter() {
        return new AddDeviceActivityPresenter(this);
    }

    @Override
    public void onEventBusMessage(MdlEventBus event) {
        super.onEventBusMessage(event);
        switch (event.eventType) {
            case EnumEventBus.FIND_WIFI_DEVICE: {
                MdlWifiDevice wifiDevice = (MdlWifiDevice) event.data;
                LogAndToastUtil.log("搜索结果 wifiDevice:%s", wifiDevice.toString());

                LogAndToastUtil.cancelWait(NewWifiAPListActivity.this);

                if (wifiDevice.strDeviceID.startsWith(WIFI_SSID_PREFIX)) {
                    if (!dataList.contains(wifiDevice)) {
                        dataList.add(wifiDevice);
                    }
                }

                resetRecyclerView(!dataList.isEmpty());
                adapter.notifyDataSetChanged();
                break;
            }
            case EnumEventBus.WIFI_DEVICE_DATA_TRANS: {
                MdlWifiTransfer transfer = (MdlWifiTransfer) event.data;
                LogAndToastUtil.log("透传回调 wifiDevice:%s", transfer.toString());
                break;
            }
        }
    }


    @Override
    public void showAddDeviceResult(MdlBaseHttpResp resp) {
        if (resp.code == BabyHttpConstant.R_HTTP_OK) {
            finish();
        }
    }

    @Override
    public void showDeviceListResult(MdlBaseHttpResp<List<MdlDevice>> resp) {

    }

    @Override
    public void showDelDeviceResult(MdlBaseHttpResp resp) {

    }
}
