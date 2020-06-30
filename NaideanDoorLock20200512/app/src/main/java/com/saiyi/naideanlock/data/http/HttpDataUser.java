package com.saiyi.naideanlock.data.http;


import com.saiyi.naideanlock.data.api.UserService;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.http.BaseHttpData;
import com.sandy.guoguo.babylib.http.HttpManager;

import java.io.File;
import java.util.Map;

import io.reactivex.Observable;
import io.reactivex.Observer;
import okhttp3.MediaType;
import okhttp3.MultipartBody;
import okhttp3.RequestBody;
import retrofit2.http.Body;

/**
 * Created by Administrator on 2018/4/17.
 */

public class HttpDataUser extends BaseHttpData {
    private static class SingletonHolder {
        private static final HttpDataUser INSTANCE = new HttpDataUser();
    }

    public static HttpDataUser getInstance() {
        return SingletonHolder.INSTANCE;
    }

    private UserService userService = HttpManager.getInstance().getRetrofit().create(UserService.class);


    /*public void getUserInfo(Map params, Observer<MdlBaseHttpResp> observer) {
        Observable observable = userService.getUserInfo(params);
        setSubscribe(observable, observer);
    }*/

    public void getUserInfo(RequestBody body,String token, Observer<MdlBaseHttpResp> observer) {
        Observable observable = userService.getUserInfo(body,token);
        setSubscribe(observable, observer);
    }
    public void getVersionInfo(Map params, Observer<MdlBaseHttpResp> observer) {
        Observable observable = userService.getVersionInfo(params);
        setSubscribe(observable, observer);
    }
    public void updateUserInfo(@Body RequestBody body, String token,Observer<MdlBaseHttpResp> observer) {
        Observable observable = userService.updateUserInfo(body,token);
        setSubscribe(observable, observer);
    }

    public void uploadHeadPic(MultipartBody.Part file, Observer<MdlBaseHttpResp> observer){

        Observable observable = userService.uploadHeadPic(file);
        setSubscribe(observable, observer);
    }

    public void changeBindCheckPhone(Map params, String token, Observer<MdlBaseHttpResp> observer) {
        RequestBody body = GenJsonParamRequestBody(params);
        Observable observable = userService.changeBindCheckPhone(body,token);
        setSubscribe(observable, observer);
    }
    public void changeBindUpdatePhone(Map params, String token,Observer<MdlBaseHttpResp> observer) {
        RequestBody body = GenJsonParamRequestBody(params);
        Observable observable = userService.changeBindUpdatePhone(body,token);
        setSubscribe(observable, observer);
    }
    public void autoLogin(RequestBody body, String token,Observer<MdlBaseHttpResp> observer) {
        Observable observable = userService.autoLogin(body,token);
        setSubscribe(observable, observer);
    }
}
