package com.saiyi.naideanlock.new_ui.user.mvp.m;


import com.saiyi.naideanlock.bean.UserInfo;
import com.saiyi.naideanlock.data.http.HttpDataUser;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.listener.OnLoadHttpDataListener;
import com.sandy.guoguo.babylib.ui.mvp.BaseModel;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.util.Map;

import io.reactivex.Observer;
import io.reactivex.disposables.Disposable;
import okhttp3.MediaType;
import okhttp3.MultipartBody;
import okhttp3.RequestBody;

/**
 * Created by Administrator on 2018/6/11.
 */

public class UpdateUserInfoActivityModel extends BaseModel {

    public void getUserInfo(final int code, String phone,String token,final OnLoadHttpDataListener listener) {

        JSONObject params = new JSONObject();
        try {
            params.put("phone", phone);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        RequestBody body = RequestBody.create(MediaType.parse("application/json"), params.toString());
        HttpDataUser.getInstance().getUserInfo(body,token, new Observer<MdlBaseHttpResp>() {
            @Override
            public void onSubscribe(Disposable d) {
                UpdateUserInfoActivityModel.this.disposable = d;
            }

            @Override
            public void onNext(MdlBaseHttpResp responseBody) {
                listener.onSuccess(code, responseBody);
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

    public void updateUserInfo(final int code, String nickName,String pic, String token,final OnLoadHttpDataListener listener) {

        JSONObject params = new JSONObject();
        try {
            params.put("nickName", nickName);
            params.put("pic", pic);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        RequestBody body = RequestBody.create(MediaType.parse("application/json"), params.toString());
        HttpDataUser.getInstance().updateUserInfo(body,token, new Observer<MdlBaseHttpResp>() {
            @Override
            public void onSubscribe(Disposable d) {
                UpdateUserInfoActivityModel.this.disposable = d;
            }

            @Override
            public void onNext(MdlBaseHttpResp responseBody) {
                listener.onSuccess(code, responseBody);
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

    public void uploadHeadPic(final int code, File file, final OnLoadHttpDataListener listener) {
        RequestBody requestFile = RequestBody.create(MediaType.parse("multipart/form-data"), file);
        MultipartBody.Part imageBody = MultipartBody.Part.createFormData("file", file.getName(), requestFile);
        HttpDataUser.getInstance().uploadHeadPic(imageBody, new Observer<MdlBaseHttpResp>() {
            @Override
            public void onSubscribe(Disposable d) {
                UpdateUserInfoActivityModel.this.disposable = d;
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
