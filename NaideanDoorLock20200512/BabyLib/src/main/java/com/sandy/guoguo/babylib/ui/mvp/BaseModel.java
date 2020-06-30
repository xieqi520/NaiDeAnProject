package com.sandy.guoguo.babylib.ui.mvp;

import io.reactivex.disposables.Disposable;

/**
 * Created by Administrator on 2018/4/17.
 */

public class BaseModel {
    protected Disposable disposable;

    public void detachModel(){
        if(disposable != null && !disposable.isDisposed()){
            disposable.dispose();
            disposable = null;
        }
    }
}
