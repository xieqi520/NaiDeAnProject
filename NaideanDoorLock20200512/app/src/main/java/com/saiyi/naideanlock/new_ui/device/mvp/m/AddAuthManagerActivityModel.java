package com.saiyi.naideanlock.new_ui.device.mvp.m;


import com.google.gson.Gson;
import com.saiyi.naideanlock.bean.req.AddBindParams;
import com.saiyi.naideanlock.data.http.HttpDataDevice;
import com.saiyi.naideanlock.data.http.HttpDataUser;
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

public class AddAuthManagerActivityModel extends BaseModel {
    public void searchUserInfo(final int code, String phone,String token, final OnLoadHttpDataListener listener) {
        JSONObject result = new JSONObject();
        try {
            result.put("phone", phone);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        RequestBody body = RequestBody.create(MediaType.parse("application/json;charset=utf-8"), result.toString());
        HttpDataUser.getInstance().getUserInfo(body,token, new Observer<MdlBaseHttpResp>() {
            @Override
            public void onSubscribe(Disposable d) {
                AddAuthManagerActivityModel.this.disposable = d;
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

    public void addBinding(final int code, String mac, String memoName, List<String> times, String userId,String userType, List<Integer> week, String token, final OnLoadHttpDataListener listener){
        AddBindParams addBindParams = new AddBindParams();
        addBindParams.setDeviceId(mac);
        addBindParams.setMemoName(memoName);
        addBindParams.setTimes(times);
        addBindParams.setUserId(userId);
        addBindParams.setUserType(userType);
        addBindParams.setWeek(week);
        String params = new Gson().toJson(addBindParams);
        /*JSONObject result = new JSONObject();
        try {
            result.put("deviceId", mac);
            result.put("memoName", memoName);
            result.pu("times", times);
            result.put("userId", userId);
            result.put("userType", userType);
            result.put("week", week);
        } catch (JSONException e) {
            e.printStackTrace();
        }*/
        RequestBody body = RequestBody.create(MediaType.parse("application/json;charset=utf-8"), params);
        HttpDataDevice.getInstance().addBind(body, token, new Observer<MdlBaseHttpResp>() {
            @Override
            public void onSubscribe(Disposable d) {
                AddAuthManagerActivityModel.this.disposable = d;
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

    public void bindDevice(final int code,String mac, String name, String type, String token, final OnLoadHttpDataListener listener){
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
                AddAuthManagerActivityModel.this.disposable = d;
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
