package com.sandy.guoguo.babylib.http;

import java.util.Map;

import io.reactivex.Observable;
import io.reactivex.Observer;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.schedulers.Schedulers;
import okhttp3.RequestBody;

public class BaseHttpData {
    protected RequestBody GenJsonParamRequestBody(Map param) {
        return HttpUtil.GenJsonParamRequestBody(param);
    }

    protected <T> void setSubscribe(Observable<T> observable, Observer<T> observer){
        observable.subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(observer);
    }
}
