package com.saiyi.naideanlock.new_ui.device.mvp.m;


import com.google.gson.Gson;
import com.saiyi.naideanlock.bean.req.AddBindParams;
import com.saiyi.naideanlock.bean.req.UpdateBindParams;
import com.saiyi.naideanlock.data.http.HttpDataDevice;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.listener.OnLoadHttpDataListener;
import com.sandy.guoguo.babylib.ui.mvp.BaseModel;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;
import java.util.Map;

import io.reactivex.Observer;
import io.reactivex.disposables.Disposable;
import okhttp3.MediaType;
import okhttp3.RequestBody;

/**
 * Created by Administrator on 2018/6/11.
 */

public class AuthManagerSettingActivityModel extends BaseModel {

    public void addNanny(final int code, Map param, final OnLoadHttpDataListener listener){
        HttpDataDevice.getInstance().addNanny(param, new Observer<MdlBaseHttpResp>() {
            @Override
            public void onSubscribe(Disposable d) {
                AuthManagerSettingActivityModel.this.disposable = d;
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
                AuthManagerSettingActivityModel.this.disposable = d;
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

    public void addBinding(final int code, String mac, String memoName, List<String> times, String userId, String userType, List<Integer> week, String token, final OnLoadHttpDataListener listener){
        AddBindParams addBindParams = new AddBindParams();
        addBindParams.setDeviceId(mac);
        addBindParams.setMemoName(memoName);
        addBindParams.setTimes(times);
        addBindParams.setUserId(userId);
        addBindParams.setUserType(userType);
        addBindParams.setWeek(week);
        String params = new Gson().toJson(addBindParams);
        RequestBody body = RequestBody.create(MediaType.parse("application/json;charset=utf-8"), params);
        HttpDataDevice.getInstance().addBind(body, token, new Observer<MdlBaseHttpResp>() {
            @Override
            public void onSubscribe(Disposable d) {
                AuthManagerSettingActivityModel.this.disposable = d;
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

    public void updateBinding(final int code, String id, String memoName, List<String> times, String userType, List<Integer> week, String token, final OnLoadHttpDataListener listener){
        UpdateBindParams updateBindParams = new UpdateBindParams();
        updateBindParams.setId(id);
        updateBindParams.setMemoName(memoName);
        updateBindParams.setTimes(times);
        updateBindParams.setUserType(userType);
        updateBindParams.setWeek(week);
        String params = new Gson().toJson(updateBindParams);
        RequestBody body = RequestBody.create(MediaType.parse("application/json;charset=utf-8"), params);
        HttpDataDevice.getInstance().updateBinding(body, token, new Observer<MdlBaseHttpResp>() {
            @Override
            public void onSubscribe(Disposable d) {
                AuthManagerSettingActivityModel.this.disposable = d;
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
