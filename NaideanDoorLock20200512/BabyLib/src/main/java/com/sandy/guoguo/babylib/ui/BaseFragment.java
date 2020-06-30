package com.sandy.guoguo.babylib.ui;

import android.content.Context;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.annotation.StringRes;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.sandy.guoguo.babylib.R;
import com.sandy.guoguo.babylib.utils.LogAndToastUtil;
import com.sandy.guoguo.babylib.utils.eventbus.EventBusManager;
import com.sandy.guoguo.babylib.utils.eventbus.MdlEventBus;
import com.sandy.guoguo.babylib.utils.permission.MyPermissionResultListener;
import com.sandy.guoguo.babylib.utils.permission.PermissionUtil;

import org.greenrobot.eventbus.Subscribe;
import org.greenrobot.eventbus.ThreadMode;

/**
 * Created by haozo on 2017/9/26.
 */

public abstract class BaseFragment extends Fragment implements MyPermissionResultListener {
    protected boolean isInit = false;
    protected boolean isFirstLoad = false;
    protected View view = null;
    private LayoutInflater layoutInflater;

    protected int currentPage = 1;
    protected int totalPage;

    protected abstract int getLayoutId();

    protected abstract void initView(View view);

    protected abstract void fragment2Front();

    private TextView tvTitle;

    protected void setTitleResId(@StringRes int resId){
        if(tvTitle != null) {
            tvTitle.setText(resId);
        }
    }

    protected int getTitleResId(){
        return 0;
    }

    protected void initToolbar(){
        tvTitle = findView(R.id.toolbarTitle);
        if (tvTitle != null && getTitleResId() != 0){
            tvTitle.setText(getTitleResId());
        }
    }


    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        this.layoutInflater = inflater;
        view = inflater.inflate(getLayoutId(), container, false);

        isInit = true;
        return view;
    }



    @Override
    public void onDestroyView() {
        super.onDestroyView();
        isInit = false;
        isFirstLoad = false;
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);

        initToolbar();
        initView(view);
    }

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser && isInit) {
            fragment2Front();
        }
    }

    protected <T extends View> T findView(int viewId) {
        return (T) view.findViewById(viewId);
    }


    @Subscribe(threadMode = ThreadMode.MAIN)
    public void onEventBusMessage(MdlEventBus event) {

    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        //下面的调用父类的语句不能省略，否则，以这个Activity做为容器的fragment请求权限时，回调会有问题
        //问题描述：http://blog.csdn.net/liup1211/article/details/76507896
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
//        Permissions4M.onRequestPermissionsResult(this, requestCode, grantResults);
        PermissionUtil.onRequestPermissionsResult(this, requestCode, permissions, grantResults);
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);


        EventBusManager.register(this);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        LogAndToastUtil.clearToast();
        EventBusManager.unregister(this);
    }

    @Override
    public void permissionSuccess(int permissionReqCode) {

    }

    @Override
    public void permissionFail(int permissionReqCode) {

    }

}
