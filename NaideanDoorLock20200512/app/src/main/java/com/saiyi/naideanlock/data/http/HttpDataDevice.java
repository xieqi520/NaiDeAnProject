package com.saiyi.naideanlock.data.http;


import com.saiyi.naideanlock.data.api.DeviceService;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.http.BaseHttpData;
import com.sandy.guoguo.babylib.http.HttpManager;

import java.util.Map;

import io.reactivex.Observable;
import io.reactivex.Observer;
import okhttp3.RequestBody;
import retrofit2.http.Body;
import retrofit2.http.Path;

/**
 * Created by Administrator on 2018/4/17.
 */

public class HttpDataDevice extends BaseHttpData {
    private static class SingletonHolder {
        private static final HttpDataDevice INSTANCE = new HttpDataDevice();
    }

    public static HttpDataDevice getInstance() {
        return SingletonHolder.INSTANCE;
    }

    private DeviceService deviceService = HttpManager.getInstance().getRetrofit().create(DeviceService.class);


    public void getAllDeviceByType(RequestBody body, String token, Observer<MdlBaseHttpResp> observer) {
        Observable observable = deviceService.getAllDeviceByType(body,token);
        setSubscribe(observable, observer);
    }
    public void updateDeviceName(RequestBody body, String token, Observer<MdlBaseHttpResp> observer) {
        Observable observable = deviceService.updateDeviceName(body,token);
        setSubscribe(observable, observer);
    }
    public void delDeviceBinding(RequestBody body, String token, Observer<MdlBaseHttpResp> observer) {
        Observable observable = deviceService.delDeviceBinding(body,token);
        setSubscribe(observable, observer);
    }
    public void delDevice(RequestBody body, String token, Observer<MdlBaseHttpResp> observer) {
        Observable observable = deviceService.delDevice(body,token);
        setSubscribe(observable, observer);
    }
    public void addUnlockRecord(RequestBody body, String token, Observer<MdlBaseHttpResp> observer) {
        Observable observable = deviceService.addUnlockRecord(body,token);
        setSubscribe(observable, observer);
    }

    public void getPhotoList(Map params, Observer<MdlBaseHttpResp> observer) {
        Observable observable = deviceService.getPhotoList(params);
        setSubscribe(observable, observer);
    }
    public void setUnmannedMode(Map params, Observer<MdlBaseHttpResp> observer) {
        Observable observable = deviceService.setUnmannedMode(params);
        setSubscribe(observable, observer);
    }
    public void setTamperAlert(Map params, Observer<MdlBaseHttpResp> observer) {
        Observable observable = deviceService.setTamperAlert(params);
        setSubscribe(observable, observer);
    }
    public void setLowPower(Map params, Observer<MdlBaseHttpResp> observer) {
        Observable observable = deviceService.setLowPower(params);
        setSubscribe(observable, observer);
    }

    public void updateAlarm(RequestBody body, String token, Observer<MdlBaseHttpResp> observer) {
        Observable observable = deviceService.updateAlarm(body,token);
        setSubscribe(observable, observer);
    }
    public void setUnlockPwd(RequestBody body, String token, Observer<MdlBaseHttpResp> observer) {
        Observable observable = deviceService.setUnlockPwd(body,token);
        setSubscribe(observable, observer);
    }
    public void bindDevice(RequestBody body, String token, Observer<MdlBaseHttpResp> observer) {
        Observable observable = deviceService.bindDevice(body,token);
        setSubscribe(observable, observer);
    }
    public void addBind(RequestBody body, String token, Observer<MdlBaseHttpResp> observer) {
        Observable observable = deviceService.addBinding(body,token);
        setSubscribe(observable, observer);
    }

    public void updateBinding(RequestBody body, String token, Observer<MdlBaseHttpResp> observer) {
        Observable observable = deviceService.updateBinding(body,token);
        setSubscribe(observable, observer);
    }

    public void getUnlockRecord(RequestBody body, String token, Observer<MdlBaseHttpResp> observer) {
        Observable observable = deviceService.getUnlockRecord(body,token);
        setSubscribe(observable, observer);
    }
    public void deleteAllUnlockRecord(RequestBody body, String token, Observer<MdlBaseHttpResp> observer) {
        Observable observable = deviceService.deleteAllUnlockRecord(body,token);
        setSubscribe(observable, observer);
    }
    public void getAuthManagerList(RequestBody body,String token, Observer<MdlBaseHttpResp> observer) {
        Observable observable = deviceService.getAuthManagerList(body,token);
        setSubscribe(observable, observer);
    }
    public void renameAuthUser(RequestBody body,String token, Observer<MdlBaseHttpResp> observer) {
        Observable observable = deviceService.renameAuthUser(body,token);
        setSubscribe(observable, observer);
    }
    public void deleteNanny(Map params, Observer<MdlBaseHttpResp> observer) {
        RequestBody body = GenJsonParamRequestBody(params);
        Observable observable = deviceService.deleteNanny(body);
        setSubscribe(observable, observer);
    }
    public void addNanny(Map params, Observer<MdlBaseHttpResp> observer) {
        RequestBody body = GenJsonParamRequestBody(params);
        Observable observable = deviceService.addNanny(body);
        setSubscribe(observable, observer);
    }

}
