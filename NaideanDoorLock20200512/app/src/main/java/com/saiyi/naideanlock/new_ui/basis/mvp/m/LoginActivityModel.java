package com.saiyi.naideanlock.new_ui.basis.mvp.m;


import com.saiyi.naideanlock.data.http.HttpDataBasis;
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

public class LoginActivityModel extends BaseModel {
    public void login(final int code, String phone,String password, final OnLoadHttpDataListener listener){
        JSONObject result = new JSONObject();
        try {
            result.put("phone", phone);
            result.put("password", password);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        RequestBody body = RequestBody.create(MediaType.parse("application/json;charset=utf-8"), result.toString());
        HttpDataBasis.getInstance().login(body, new Observer<MdlBaseHttpResp>() {
            @Override
            public void onSubscribe(Disposable d) {
                LoginActivityModel.this.disposable = d;
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


    public void login1(final int code, String phone,String password, String phoneBrand,String phoneId,String phoneModel,String phoneSystem,final OnLoadHttpDataListener listener){
        JSONObject result = new JSONObject();
        try {
            result.put("phone", phone);
            result.put("password", password);
            result.put("phoneBrand", phoneBrand);
            result.put("phoneId", phoneId);
            result.put("phoneModel", phoneModel);
            result.put("phoneSystem", phoneSystem);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        RequestBody body = RequestBody.create(MediaType.parse("application/json;charset=utf-8"), result.toString());
        HttpDataBasis.getInstance().login1(body, new Observer<MdlBaseHttpResp>() {
            @Override
            public void onSubscribe(Disposable d) {
                LoginActivityModel.this.disposable = d;
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
