package com.sandy.guoguo.babylib.ui;

import android.content.Context;
import android.os.Bundle;
import android.support.annotation.LayoutRes;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.annotation.StringRes;
import android.support.v4.app.Fragment;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.request.RequestOptions;
import com.sandy.guoguo.babylib.R;
import com.sandy.guoguo.babylib.ui.mvp.BasePresenter;
import com.sandy.guoguo.babylib.ui.mvp.BaseView;
import com.sandy.guoguo.babylib.utils.Utility;
import com.sandy.guoguo.babylib.utils.eventbus.EventBusManager;
import com.sandy.guoguo.babylib.utils.eventbus.MdlEventBus;
import com.sandy.guoguo.babylib.utils.glide.GlideApp;
import com.sandy.guoguo.babylib.utils.permission.MyPermissionResultListener;
import com.sandy.guoguo.babylib.utils.permission.PermissionUtil;

import org.greenrobot.eventbus.Subscribe;
import org.greenrobot.eventbus.ThreadMode;

/**
 * Created by Administrator on 2018/4/18.
 */

public abstract class MVPBaseFragment<MVP_V extends BaseView, MVP_P extends BasePresenter<MVP_V>> extends Fragment implements MyPermissionResultListener {
    protected MVP_P presenter;

    protected boolean isInit = false;
    protected boolean isFirstLoad = false;
    protected View view = null;
    protected LayoutInflater layoutInflater;

    protected int currentPage = 1;
    protected int totalPage;

    protected abstract @LayoutRes
    int getLayoutResId();

    protected abstract void initViewAndControl(View view);

    protected abstract void fragment2Front();

    protected abstract MVP_P createPresenter();

    private TextView tvTitle;

    protected void setTitleResId(@StringRes int resId) {
        if (tvTitle != null) {
            tvTitle.setText(resId);
        }
    }

    protected abstract int getTitleResId();

    protected void initToolbar() {
        tvTitle = findView(R.id.toolbarTitle);
        if (tvTitle != null && getTitleResId() != 0) {
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
        view = inflater.inflate(getLayoutResId(), container, false);

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
        initViewAndControl(view);
    }


    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser && isInit) {
            fragment2Front();
        }
    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    public void onEventBusMessage(MdlEventBus event) {

    }

    protected <T extends View> T findView(int viewId) {
        return (T) view.findViewById(viewId);
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        presenter = createPresenter();
        presenter.attachView((MVP_V) this);

        EventBusManager.register(this);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[]
            grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        PermissionUtil.onRequestPermissionsResult(this, requestCode, permissions, grantResults);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        EventBusManager.unregister(this);
    }

    @Override
    public void permissionSuccess(int permissionReqCode) {

    }

    @Override
    public void permissionFail(int permissionReqCode) {

    }

    protected void showRemoteUserHeadImage(String path, ImageView button) {
        if(TextUtils.isEmpty(path) || "123.jpg".equals(path)){
            return;
        }
        GlideApp.with(this).load(Utility.getRemotePicUrlFromServer(path)).apply(RequestOptions.circleCropTransform()).placeholder(R.drawable.ic_head_default).into(button);
    }

    protected void showRemoteGoodsImage(String path, ImageView button) {
        if(TextUtils.isEmpty(path) || "123.jpg".equals(path)){
            return;
        }
        GlideApp.with(this).load(Utility.getRemotePicUrlFromServer(path)).centerCrop().placeholder(R.drawable.ic_head_default).into(button);
    }


}