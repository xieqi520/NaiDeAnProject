package com.saiyi.naideanlock.new_ui.device;

import android.content.Intent;
import android.provider.Settings;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.saiyi.naideanlock.R;
import com.saiyi.naideanlock.application.MyApplication;
import com.saiyi.naideanlock.bean.MdlDevice;
import com.saiyi.naideanlock.bean.MdlWifiDevice;
import com.saiyi.naideanlock.bean.MdlWifiTransfer;
import com.saiyi.naideanlock.constant.ExtraConstant;
import com.saiyi.naideanlock.enums.EnumDeviceAdmin;
import com.saiyi.naideanlock.enums.EnumDeviceLink;
import com.saiyi.naideanlock.new_ui.device.mvp.p.AddDeviceActivityPresenter;
import com.saiyi.naideanlock.new_ui.device.mvp.v.AddDeviceActivityView;
import com.sandy.guoguo.babylib.constant.BabyHttpConstant;
import com.sandy.guoguo.babylib.dialogs.CommonDialog;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.enums.EnumEventBus;
import com.sandy.guoguo.babylib.listener.OnMultiClickListener;
import com.sandy.guoguo.babylib.ui.MVPBaseActivity;
import com.sandy.guoguo.babylib.utils.DelayHandler;
import com.sandy.guoguo.babylib.utils.JsonUtil;
import com.sandy.guoguo.babylib.utils.LogAndToastUtil;
import com.sandy.guoguo.babylib.utils.NetworkStatusCheckUtil;
import com.sandy.guoguo.babylib.utils.ResourceUtil;
import com.sandy.guoguo.babylib.utils.eventbus.MdlEventBus;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.net.Socket;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import object.p2pipcam.nativecaller.BridgeService;
import object.p2pipcam.nativecaller.NativeCaller;

/**
 * 当前连接的Ap（设备）
 */
public class NewWifiCurrentAPActivity extends MVPBaseActivity<AddDeviceActivityView, AddDeviceActivityPresenter> implements AddDeviceActivityView {
    private static final int REQ_SET_CONNECT_WIFI = 0226;


//    private WiFiAdmin mWiFiAdmin;

    private Button btnConfirm;
    private TextView tvConnectNotice;

    private String wifiName, wifiPwd;

    private String targetTestId;
    private boolean searchDeviceOk = false;
    private MdlWifiDevice wifiDevice;


    @Override
    protected int getLayoutResId() {
        return R.layout.activity_new_wifi_current_ap;
    }

    @Override
    protected void initViewAndControl() {
        initNav();

        wifiName = getIntent().getStringExtra(ExtraConstant.EXTRA_WIFI_NAME);
        wifiPwd = getIntent().getStringExtra(ExtraConstant.EXTRA_WIFI_PWD);

        tvConnectNotice = findView(R.id.tvConnectNotice);

        btnConfirm = findView(R.id.btnConfirm);
        btnConfirm.setOnClickListener(new OnMultiClickListener() {
            @Override
            public void OnMultiClick(View view) {
                clickAction();
            }
        });

//        currDevBean = MyApplication.getInstance().getCurrdev();
//        mWiFiAdmin = new WiFiAdmin(NewWifiCurrentAPActivity.this);

        initWifiService();
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

    private void clickAction() {
        if(wifiDevice != null && searchDeviceOk){
            addDevice2Remote(wifiDevice);
        } else {
            Map<String, Object> map = new HashMap<>();
            map.put("pro", "set_wifi");
            map.put("cmd", 114);
            map.put("user", "admin");
            map.put("pwd", "");
            map.put("wifissid", wifiName);
            map.put("wifipwd", wifiPwd);

            startClient("192.168.43.1", 11111, JsonUtil.createJson(map));
        }
    }

    public Socket socket;

    public void startClient(final String address, final int port, final String strMsg) {
        if (socket == null) {
            new Thread(new Runnable() {
                @Override
                public void run() {
                    try {
                        LogAndToastUtil.log("启动客户端  address:%s port:%d", address, port);
                        socket = new Socket(address, port);
                        LogAndToastUtil.log("客户端连接成功");
                        socket.getOutputStream().write(strMsg.getBytes());
                        socket.getOutputStream().flush();

                        PrintWriter pw = new PrintWriter(socket.getOutputStream());
                        InputStream inputStream = socket.getInputStream();

                        byte[] buffer = new byte[1024];
                        int len;
                        while ((len = inputStream.read(buffer)) != -1) {
                            String data = new String(buffer, 0, len);
//                            12-12 15:03:08.486: I/tcp(30284): 收到服务器的数据---------------------------------------------:{
//                            	12-12 15:03:08.486: I/tcp(30284): 	"did":	"IKB-000000-MMEEC"
//                            	12-12 15:03:08.486: I/tcp(30284): }


                            LogAndToastUtil.log("收到服务器的数据---------------------------------------------:%s 长度:%s", data, data.length());
                            // EventBus.getDefault().post(new MessageClient(data));
                            if (data != null && data.length() > 1) {
                                String testDid = data.substring(data.lastIndexOf("\"") - 16, data.lastIndexOf("\""));
                                LogAndToastUtil.log("testDid:%s 长度:%s", testDid, testDid.length());

                                DelayHandler.getInstance().post(new Runnable() {
                                    @Override
                                    public void run() {
                                        wlanSearchCamera(testDid);
                                    }
                                });
                            }

                        }
                        LogAndToastUtil.log("客户端断开连接");
                        pw.close();

                    } catch (Exception EE) {
                        EE.printStackTrace();
                        LogAndToastUtil.log("客户端无法连接服务器");

                    } finally {
                        try {
                            if (socket != null) {
                                socket.close();
                            }
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                        socket = null;
                    }
                }
            }).start();
        }

    }

    private void wlanSearchCamera(String testId) {
        targetTestId = testId;
        startScan();
    }

    private void startScan() {
//        LogAndToastUtil.showWait(this, R.string.scanning);
        /**
         * 局域网搜索
         * **/
        new Thread() {
            @Override
            public void run() {
                NativeCaller.StartSearch();

                try {
                    Thread.sleep(30000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                NativeCaller.StopSearch();
                super.run();
            }
        }.start();
    }

    @Override
    public void onEventBusMessage(MdlEventBus event) {
        super.onEventBusMessage(event);
        switch (event.eventType) {
            case EnumEventBus.FIND_WIFI_DEVICE: {
                wifiDevice = (MdlWifiDevice) event.data;
                LogAndToastUtil.log("搜索结果 wifiDevice:%s", wifiDevice.toString());

                if (searchDeviceOk) {
                    return;
                }

                if (TextUtils.equals(wifiDevice.strDeviceID, targetTestId)) {

                    searchDeviceOk = true;
                    NativeCaller.StopSearch();

                    CommonDialog dialog = new CommonDialog(this, "重新设置网络", "您可能需要重新连接网络", new CommonDialog.ClickListener() {
                        @Override
                        public void clickConfirm() {
                            startActivityForResult(new Intent(Settings.ACTION_WIFI_SETTINGS), REQ_SET_CONNECT_WIFI);
                        }

                        @Override
                        public void clickCancel() {

                        }
                    });
                    dialog.show();

                }

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
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == REQ_SET_CONNECT_WIFI) {

            if (NetworkStatusCheckUtil.checkStatus(this)) {
                if (wifiDevice != null)
                    addDevice2Remote(wifiDevice);
            } else {
                LogAndToastUtil.toast("当前网络不可用");
            }


        }
    }

    private void addDevice2Remote(MdlWifiDevice wifiDevice) {

        Map<String, Object> params = new HashMap<>();
        //params.put("number", MyApplication.getInstance().mdlUserInApp.phone);

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

        presenter.bindDevice(wifiDevice.strMac,wifiDevice.strName, EnumDeviceLink.WIFI+"",MyApplication.getInstance().mdlUserInApp.token);
    }

    private void initNav() {
        TextView tvLeft = findView(R.id.toolbarLeft);
        tvLeft.setVisibility(View.VISIBLE);
        ResourceUtil.setCompoundDrawable(tvLeft, R.drawable.dr_ic_back, 0, 0, 0);
    }

    @Override
    protected int getTitleResId() {
        return R.string.ap_connect;
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
