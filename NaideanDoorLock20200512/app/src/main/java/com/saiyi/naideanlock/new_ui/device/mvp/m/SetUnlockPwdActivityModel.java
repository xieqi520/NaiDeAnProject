package com.saiyi.naideanlock.new_ui.device.mvp.m;


import com.saiyi.naideanlock.data.http.HttpDataBasis;
import com.saiyi.naideanlock.data.http.HttpDataDevice;
import com.saiyi.naideanlock.new_ui.basis.mvp.m.RegisterActivityModel;
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

public class SetUnlockPwdActivityModel extends BaseModel {
    public void setUnlockPwd(final int code, String id,String phoneCode,String openPwd,String token,final OnLoadHttpDataListener listener){
        JSONObject result = new JSONObject();
        try {
            result.put("id", id);
            result.put("code", phoneCode);
            result.put("openPwd", openPwd);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        RequestBody body = RequestBody.create(MediaType.parse("application/json;charset=utf-8"), result.toString());
        HttpDataDevice.getInstance().setUnlockPwd(body,token, new Observer<MdlBaseHttpResp>() {
            @Override
            public void onSubscribe(Disposable d) {
                SetUnlockPwdActivityModel.this.disposable = d;
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
        RequestBody body = RequestBody.create(MediaType.parse("application/json;charset=utf-8"), result.toString());
        HttpDataBasis.getInstance().getCheckCode(body, new Observer<MdlBaseHttpResp>() {
            @Override
            public void onSubscribe(Disposable d) {
                SetUnlockPwdActivityModel.this.disposable = d;
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
