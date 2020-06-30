package object.p2pipcam.nativecaller;


import android.app.Service;
import android.content.Intent;
import android.os.Binder;
import android.os.IBinder;
import android.util.Log;

import com.saiyi.naideanlock.bean.MdlWifiDevice;
import com.saiyi.naideanlock.bean.MdlWifiTransfer;
import com.sandy.guoguo.babylib.enums.EnumEventBus;
import com.sandy.guoguo.babylib.utils.eventbus.EventBusManager;
import com.sandy.guoguo.babylib.utils.eventbus.MdlEventBus;

public class BridgeService extends Service {
    private String TAG = BridgeService.class.getSimpleName();


    @Override
    public IBinder onBind(Intent intent) {
        Log.d("tag", "SHIXCONNET BridgeService onBind()");
        return new ControllerBinder();
    }

    /**
     *
     * **/
    class ControllerBinder extends Binder {
        public BridgeService getBridgeService() {
            return BridgeService.this;
        }
    }

    @Override
    public void onCreate() {
        super.onCreate();
        Log.d("tag", "SHIXCONNET BridgeService onCreate()");

        NativeCaller.PPPPSetCallbackContext(this);


    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {

        return super.onStartCommand(intent, flags, startId);
    }


    @Override
    public void onDestroy() {
        super.onDestroy();
        stopForeground(true);
        NativeCaller.Free();
    }


    // ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    public void CallBackTransferMessage(String did, String buffer, int cmd) {
        CommonUtil.Log(1, "SHIXCONNET SHIXTRANS did:" + did + "  buffer:" + buffer);
        String strJason = buffer.substring(buffer.indexOf("{"), buffer.indexOf("}") + 1);
        CommonUtil.Log(1, "SHIXCONNET SHIXTRANS did:" + did + "  strJason:" + strJason + "LEN:" + strJason.length());
//        if (shixOMMONInterface != null) {
//            shixOMMONInterface.CallBackSHIXJasonCommon(did, buffer);
//        }

        MdlWifiTransfer transfer = new MdlWifiTransfer();
        transfer.cmd = cmd;
        transfer.buffer = buffer;
        transfer.did = did;

        EventBusManager.post(new MdlEventBus(EnumEventBus.WIFI_DEVICE_DATA_TRANS, transfer));
    }


    public void CallBack_DoorBell_CallStatus(String dbDid, String dbTime,
                                             int callstatu) {
        CommonUtil.Log(1, "SHIXCONNET CallBack_DoorBell_CallStatus:"
                + callstatu + "  did:" + dbDid + "  udid:" + dbTime);
        if (dbDid == null || dbDid.length() < 3) {
            return;
        }

    }

    public void CallBack_DoorBell_PushStatus(String did, int pushType,
                                             int validity) {
        CommonUtil.Log(1, "SHIXCONNET CallBack_DoorBell_PushStatuse:"
                + pushType + "  validity:" + validity);

    }


    public void VideoData(String did, byte[] videobuf, int h264Data, int len,
                          int width, int height, int time) {
        Log.d(TAG, "SHIXCONNET VideoData...h264Data: " + h264Data + " len: " + len
                + " videobuf len: " + videobuf.length + "  time==" + time);
        if (ipcamClientInterface != null) {
            ipcamClientInterface.callBaceVideoData(did, videobuf, h264Data, len,
                    width, height);
        }

    }

    public void MessageNotify(String did, int msgType, int param) {
        Log.d("test_four_2", "SHIXCONNET MessageNotify did: " + did + " msgType: "
                + msgType + " param: " + param);

    }

    public void AudioData(byte[] pcm, int len) {
        Log.d(TAG, "SHIXCONNET AudioData: len :+ " + len);
        if (ipcamClientInterface != null) {
            ipcamClientInterface.callBackAudioData(pcm, len);
        }
    }

    public void PPPPMsgNotify(String did, int type, int param) {
        Log.d(TAG, "SHIXCONNET PPPPMsgNotify  did:" + did + " type:" + type + " param:"
                + param);
        if (ipcamClientInterface != null) {
            ipcamClientInterface.BSMsgNotifyData(did, type, param);
        }
    }

    public void SearchResult(int cameraType, String strMac, String strName,
                             String strDeviceID, String strIpAddr, int port) {
        Log.d(TAG, "SHIXCONNET SearchResult: " + strIpAddr + " " + port);
        if (strDeviceID.length() == 0) {
            return;
        }

            MdlWifiDevice wifiDevice = new MdlWifiDevice();
            wifiDevice.cameraType = cameraType;
            wifiDevice.strMac = strMac;
            wifiDevice.strName = strName;
            wifiDevice.strDeviceID = strDeviceID;
            wifiDevice.strIpAddr = strIpAddr;
            wifiDevice.port = port;

//            shixOMMONInterface.SearchResult(cameraType, strMac, strName, strDeviceID, strIpAddr, port);
//            shixOMMONInterface.SearchResult(wifiDevice);

        EventBusManager.post(new MdlEventBus(EnumEventBus.FIND_WIFI_DEVICE, wifiDevice));

    }


    private void PPPPSnapshotNotify(String did, byte[] bImage, int len) {
        Log.d(TAG, "SHIXCONNET did:" + did + " len:" + len);
        if (ipcamClientInterface != null) {
            ipcamClientInterface.BSSnapshotNotify(did, bImage, len);
        }

    }

    public void CallBack_Snapshot(String did, byte[] data, int len) {
        Log.d("ddd", "SHIXCONNET CallBack_Snapshot");
        if (ipcamClientInterface != null) {
            ipcamClientInterface.BSSnapshotNotify(did, data, len);
        }
    }


    public void CallBack_AlarmNotifyDoorBell(String did, String dbTime,
                                             String dbDid, String dbType) {
        Log.e("test", "doorbell:db_did:" + dbDid + "  db_type:" + dbType
                + "  db_time:" + dbTime);

    }


    public void CallBack_AlarmNotify(String did, int alarmtype) {
        Log.d("tag", "callBack_AlarmNotify did:" + did + " alarmtype:"
                + alarmtype);
    }

    private void CallBack_RecordFileSearchResult(String did, String filename,
                                                 int nFileSize, int nRecordCount, int nPageCount, int nPageIndex,
                                                 int nPageSize, int bEnd) {

    }

    private void CallBack_PlaybackVideoData(String did, byte[] videobuf,
                                            int h264Data, int len, int width, int height, int time) {

    }

    private void CallBack_H264Data(String did, byte[] h264, int type, int size) {
        // Log.e("tag", "did=" + did + "  h264=" + h264.length);

    }


    private static IpcamClientInterface ipcamClientInterface;

    public static void setIpcamClientInterface(IpcamClientInterface ipcInterface) {
        ipcamClientInterface = ipcInterface;
    }

    public interface IpcamClientInterface {
        void BSMsgNotifyData(String did, int type, int param);

        void BSSnapshotNotify(String did, byte[] bImage, int len);

        void callBaceVideoData(String did, byte[] videobuf, int h264Data,
                               int len, int width, int height);

        void callBackMessageNotify(String did, int msgType, int param);

        void callBackAudioData(byte[] pcm, int len);

        void callBackH264Data(String did, byte[] h264, int type, int size);
    }


}
