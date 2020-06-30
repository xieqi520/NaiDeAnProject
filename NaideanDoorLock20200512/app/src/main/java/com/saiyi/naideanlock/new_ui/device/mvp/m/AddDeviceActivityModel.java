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

public class AddDeviceActivityModel extends BaseModel {
    public void bindDevice(final int code, String mac, String name, String type, String token, final OnLoadHttpDataListener listener){
        JSONObject result = new JSONObject();
        try {
            result.put("mac", mac);
            result.put("name", name);
            result.put("type", type);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        RequestBody body = RequestBody.create(MediaType.parse("application/json;charset=utf-8"), result.toString());

        HttpDataDevice.getInstance().bindDevice(body, token, new Observer<MdlBaseHttpResp>() {
            @Override
            public void onSubscribe(Disposable d) {
                AddDeviceActivityModel.this.disposable = d;
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

    public void getAllDeviceByType(final int code, int type,String token, final OnLoadHttpDataListener listener) {
        JSONObject params = new JSONObject();
        try {
            params.put("type", type);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        RequestBody body = RequestBody.create(MediaType.parse("application/json;charset=utf-8"), params.toString());
        HttpDataDevice.getInstance().getAllDeviceByType(body,token, new Observer<MdlBaseHttpResp>() {
            @Override
            public void onSubscribe(Disposable d) {
                AddDeviceActivityModel.this.disposable = d;
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

    public void delDevice(final int code, String id,String token, final OnLoadHttpDataListener listener) {
        JSONObject params = new JSONObject();
        try {
            params.put("id", id);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        RequestBody body = RequestBody.create(MediaType.parse("application/json;charset=utf-8"), params.toString());
        HttpDataDevice.getInstance().delDevice(body,token, new Observer<MdlBaseHttpResp>() {
            @Override
            public void onSubscribe(Disposable d) {
                AddDeviceActivityModel.this.disposable = d;
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
