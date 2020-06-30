package com.saiyi.naideanlock.new_ui.device.mvp.m;


import com.saiyi.naideanlock.data.http.HttpDataDevice;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.listener.OnLoadHttpDataListener;
import com.sandy.guoguo.babylib.ui.mvp.BaseModel;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Map;

import io.reactivex.Observer;
import io.reactivex.disposables.Disposable;
import okhttp3.MediaType;
import okhttp3.RequestBody;

/**
 * Created by Administrator on 2018/6/11.
 */

public class AuthManagerActivityModel extends BaseModel {
    public void getAuthManagerList(final int code, String deviceId,String token, final OnLoadHttpDataListener listener){
        JSONObject params = new JSONObject();
        try {
            params.put("deviceId", deviceId);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        RequestBody body = RequestBody.create(MediaType.parse("application/json"), params.toString());
        HttpDataDevice.getInstance().getAuthManagerList(body,token, new Observer<MdlBaseHttpResp>() {
            @Override
            public void onSubscribe(Disposable d) {
                AuthManagerActivityModel.this.disposable = d;
            }

            @Override
            public void onNext(MdlBaseHttpResp mdlBaseHttpResp) {
                listener.onSuccess(code, mdlBaseHttpResp);
            }

            @Override
            public void onError(Throwable e) {
                listener.onFailure(code, e);
            }

            @Override
            public void onComplete() {

            }
        });
    }
    public void renameAuthUser(final int code, String id,String memoName, String token,final OnLoadHttpDataListener listener){
        JSONObject params = new JSONObject();
        try {
            params.put("id", id);
            params.put("memoName", memoName);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        RequestBody body = RequestBody.create(MediaType.parse("application/json"), params.toString());
        HttpDataDevice.getInstance().renameAuthUser(body,token, new Observer<MdlBaseHttpResp>() {
            @Override
            public void onSubscribe(Disposable d) {
                AuthManagerActivityModel.this.disposable = d;
            }

            @Override
            public void onNext(MdlBaseHttpResp mdlBaseHttpResp) {
                listener.onSuccess(code, mdlBaseHttpResp);
            }

            @Override
            public void onError(Throwable e) {
                listener.onFailure(code, e);
            }

            @Override
            public void onComplete() {

            }
        });
    }
    public void deleteNanny(final int code, Map param, final OnLoadHttpDataListener listener){
        HttpDataDevice.getInstance().deleteNanny(param, new Observer<MdlBaseHttpResp>() {
            @Override
            public void onSubscribe(Disposable d) {
                AuthManagerActivityModel.this.disposable = d;
            }

            @Override
            public void onNext(MdlBaseHttpResp mdlBaseHttpResp) {
                listener.onSuccess(code, mdlBaseHttpResp);
            }

            @Override
            public void onError(Throwable e) {
                listener.onFailure(code, e);
            }

            @Override
            public void onComplete() {

            }
        });
    }
    public void delDeviceBinding(final int code, String id, String token, final OnLoadHttpDataListener listener){
        JSONObject params = new JSONObject();
        try {
            params.put("id", id);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        RequestBody body = RequestBody.create(MediaType.parse("application/json"), params.toString());
        HttpDataDevice.getInstance().delDeviceBinding(body,token, new Observer<MdlBaseHttpResp>() {
            @Override
            public void onSubscribe(Disposable d) {
                AuthManagerActivityModel.this.disposable = d;
            }

            @Override
            public void onNext(MdlBaseHttpResp mdlBaseHttpResp) {
                listener.onSuccess(code, mdlBaseHttpResp);
            }

            @Override
            public void onError(Throwable e) {
                listener.onFailure(code, e);
            }

            @Override
            public void onComplete() {

            }
        });
    }


}
