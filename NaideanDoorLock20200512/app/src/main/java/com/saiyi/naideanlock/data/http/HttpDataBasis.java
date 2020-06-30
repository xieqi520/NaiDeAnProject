package com.saiyi.naideanlock.data.http;


import com.saiyi.naideanlock.data.api.BasisService;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.http.BaseHttpData;
import com.sandy.guoguo.babylib.http.HttpManager;

import java.util.Map;

import io.reactivex.Observable;
import io.reactivex.Observer;
import okhttp3.RequestBody;

/**
 * Created by Administrator on 2018/4/17.
 */

public class HttpDataBasis extends BaseHttpData {
    private static class SingletonHolder {
        private static final HttpDataBasis INSTANCE = new HttpDataBasis();
    }

    public static HttpDataBasis getInstance() {
        return SingletonHolder.INSTANCE;
    }

    private BasisService basisService = HttpManager.getInstance().getRetrofit().create(BasisService.class);


    public void register(RequestBody body, Observer<MdlBaseHttpResp> observer) {
        Observable observable = basisService.register(body);
        setSubscribe(observable, observer);
    }

    public void checkLogin(RequestBody body,String token, Observer<MdlBaseHttpResp> observer) {
        Observable observable = basisService.checkLogin(body,token);
        setSubscribe(observable, observer);
    }

    public void getCheckCode(RequestBody body, Observer<MdlBaseHttpResp> observer) {
        Observable observable = basisService.getCheckCode(body);
        setSubscribe(observable, observer);
    }

    public void login(RequestBody body, Observer<MdlBaseHttpResp> observer) {
        Observable observable = basisService.login(body);
        setSubscribe(observable, observer);
    }

    public void login1(RequestBody body, Observer<MdlBaseHttpResp> observer) {
        Observable observable = basisService.login1(body);
        setSubscribe(observable, observer);
    }


    public void findPwd(RequestBody body, Observer<MdlBaseHttpResp> observer) {
        Observable observable = basisService.findPwd(body);
        setSubscribe(observable, observer);
    }

}
