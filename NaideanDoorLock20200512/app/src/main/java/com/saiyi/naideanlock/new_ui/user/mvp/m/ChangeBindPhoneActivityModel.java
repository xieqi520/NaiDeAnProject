package com.saiyi.naideanlock.new_ui.user.mvp.m;


import com.saiyi.naideanlock.data.http.HttpDataBasis;
import com.saiyi.naideanlock.data.http.HttpDataUser;
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

public class ChangeBindPhoneActivityModel extends BaseModel {
    public void checkPhone(final int code, Map map, String token,final OnLoadHttpDataListener listener) {

        HttpDataUser.getInstance().changeBindCheckPhone(map, token,new Observer<MdlBaseHttpResp>() {
            @Override
            public void onSubscribe(Disposable d) {
                ChangeBindPhoneActivityModel.this.disposable = d;
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
    public void updatePhone(final int code, Map map, String token,final OnLoadHttpDataListener listener) {
        HttpDataUser.getInstance().changeBindUpdatePhone(map, token,new Observer<MdlBaseHttpResp>() {
            @Override
            public void onSubscribe(Disposable d) {
                ChangeBindPhoneActivityModel.this.disposable = d;
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

    public void getCheckCode(final int code, String phone, final OnLoadHttpDataListener listener){
        JSONObject result = new JSONObject();
        try {
            result.put("phone", phone);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        RequestBody body = RequestBody.create(MediaType.parse("application/json"), result.toString());
        HttpDataBasis.getInstance().getCheckCode(body, new Observer<MdlBaseHttpResp>() {
            @Override
            public void onSubscribe(Disposable d){ ChangeBindPhoneActivityModel.this.disposable = d;
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
