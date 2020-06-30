package com.sandy.guoguo.babylib.ui.mvp;

import android.app.Activity;
import android.support.v4.app.Fragment;

import com.sandy.guoguo.babylib.R;
import com.sandy.guoguo.babylib.utils.DelayHandler;
import com.sandy.guoguo.babylib.utils.LogAndToastUtil;
import com.sandy.guoguo.babylib.utils.ResourceUtil;

/**
 * Created by Administrator on 2018/4/18.
 */

public interface BaseView{
    default void showLoading() {
        if (this instanceof Fragment) {
            DelayHandler.getInstance().post(new Runnable() {
                @Override
                public void run() {
                    LogAndToastUtil.showWait(((Fragment) BaseView.this).getContext(), ResourceUtil.getString(R.string.loading));
                }
            });
        } else if (this instanceof Activity) {
            DelayHandler.getInstance().post(new Runnable() {
                @Override
                public void run() {
                    LogAndToastUtil.showWait((Activity) BaseView.this, ResourceUtil.getString(R.string.loading));
                }
            });
        }
    }


    default void hideLoading() {
        if (this instanceof Fragment) {
            DelayHandler.getInstance().post(new Runnable() {
                @Override
                public void run() {
                    LogAndToastUtil.cancelWait(((Fragment) BaseView.this).getContext());
                }
            });
        } else if (this instanceof Activity) {
            DelayHandler.getInstance().post(new Runnable() {
                @Override
                public void run() {
                    LogAndToastUtil.cancelWait((Activity) BaseView.this);
                }
            });
        }
    }

}
