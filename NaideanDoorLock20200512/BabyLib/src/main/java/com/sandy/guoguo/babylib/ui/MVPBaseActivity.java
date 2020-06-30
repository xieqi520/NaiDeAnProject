package com.sandy.guoguo.babylib.ui;

import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.annotation.ColorRes;
import android.support.annotation.LayoutRes;
import android.support.annotation.NonNull;
import android.support.annotation.StringRes;
import android.support.v7.app.AppCompatActivity;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.request.RequestOptions;
import com.sandy.guoguo.babylib.R;
import com.sandy.guoguo.babylib.enums.EnumEventBus;
import com.sandy.guoguo.babylib.ui.mvp.BasePresenter;
import com.sandy.guoguo.babylib.ui.mvp.BaseView;
import com.sandy.guoguo.babylib.utils.LogAndToastUtil;
import com.sandy.guoguo.babylib.utils.StatusBarCompatUtil2;
import com.sandy.guoguo.babylib.utils.Utility;
import com.sandy.guoguo.babylib.utils.eventbus.EventBusManager;
import com.sandy.guoguo.babylib.utils.eventbus.MdlEventBus;
import com.sandy.guoguo.babylib.utils.glide.GlideApp;
import com.sandy.guoguo.babylib.utils.glide.GlideRoundTransform;
import com.sandy.guoguo.babylib.utils.permission.MyPermissionResultListener;
import com.sandy.guoguo.babylib.utils.permission.PermissionUtil;

import org.greenrobot.eventbus.Subscribe;
import org.greenrobot.eventbus.ThreadMode;


public abstract class MVPBaseActivity<MVP_V extends BaseView, MVP_P extends BasePresenter<MVP_V>> extends AppCompatActivity implements MyPermissionResultListener {
    protected MVP_P presenter;

    private TextView tvTitle;
    protected SharedPreferences sp;
    protected int currentPage = 1;
    protected int totalPage;

    @LayoutRes
    protected abstract int getLayoutResId();

    protected abstract void initViewAndControl();


    protected void setTitleResId(@StringRes int resId) {
        if (tvTitle != null) {
            tvTitle.setText(resId);
        }
    }

    protected void setTitleString(String title) {
        if (tvTitle != null) {
            tvTitle.setText(title);
        }
    }

    protected int getTitleResId() {
        return 0;
    }

    protected int getLeftStrResId() {
        return 0;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(getLayoutResId());

//        StatusBarCompatUtil.compat(this, getStatusColor());
//        StatusBarUtil.StatusBarLightMode(this, false);

//        StatusBarCompatUtil2.setImmersiveStatusBar(this, false, getStatusColor());
        StatusBarCompatUtil2.setStatusBarFontIconDark(this, false);
        presenter = createPresenter();
        presenter.attachView((MVP_V) this);

        initToolbar();
        initViewAndControl();
        EventBusManager.register(this);
    }

    protected void initToolbar() {
        tvTitle = findView(R.id.toolbarTitle);
        if (tvTitle != null && getTitleResId() != 0) {
            tvTitle.setText(getTitleResId());
        }
        TextView tvLeft = findView(R.id.toolbarLeft);
        if (tvLeft != null && getLeftStrResId() != 0) {
            tvLeft.setVisibility(View.VISIBLE);
            tvLeft.setText(getLeftStrResId());
        }

    }

    @SuppressWarnings("unchecked")
    protected <T extends View> T findView(int viewId) {

        return (T) findViewById(viewId);
    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    public void onEventBusMessage(MdlEventBus event) {
        switch (event.eventType) {
            case EnumEventBus.LOGOUT_OK:
                finish();
                break;
        }
    }

    @ColorRes
    protected int getStatusColor() {
        return R.color.transparent;
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
    protected void onDestroy() {
        super.onDestroy();
        LogAndToastUtil.clearToast();
        presenter.detachView();
        EventBusManager.unregister(this);
    }

    protected void handleBackKey() {
        Utility.hideSoftKeyboard(this);
        finish();
    }



    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            handleBackKey();
            return true;
        }
        return false;
    }

    public void clickLeft(View v) {
        handleBackKey();
    }

    protected abstract MVP_P createPresenter();


    @Override
    public void permissionSuccess(int permissionReqCode) {

    }

    @Override
    public void permissionFail(int permissionReqCode) {

    }


    protected void showRemoteUserHeadImage(String path, ImageView button) {
        if (TextUtils.isEmpty(path) || "123.jpg".equals(path)) {
            return;
        }
        GlideApp.with(this).load(Utility.getRemotePicUrlFromServer(path)).apply(RequestOptions.circleCropTransform()).placeholder(R.drawable.ic_head_default).into(button);
    }

    protected void showLocalUserHeadImage(String path, ImageView button) {
        GlideApp.with(this).load(path).centerCrop().apply(RequestOptions.circleCropTransform()).placeholder(R.drawable.ic_head_default).into(button);
    }

    protected void showLocalGoodsImage(String path, ImageView button) {
        if (TextUtils.isEmpty(path) || "123.jpg".equals(path)) {
            return;
        }
        GlideApp.with(this).load(path).centerCrop().placeholder(R.drawable.ic_shop_default).into(button);
    }

    protected void showRemoteGoodsImage(String path, ImageView button) {
        if (TextUtils.isEmpty(path) || "123.jpg".equals(path)) {
            return;
        }
        GlideApp.with(this).load(Utility.getRemotePicUrlFromServer(path)).centerCrop().placeholder(R.drawable.ic_shop_default).into(button);
    }

    public void showRoundCornerPic(String path, ImageView ivHead) {
        if (TextUtils.isEmpty(path)) {
            return;
        }


        RequestOptions myOptions = new RequestOptions().transform(new GlideRoundTransform(this, 10));

        GlideApp.with(this)
                .load(Utility.getRemotePicUrlFromServer(path))
                .apply(myOptions)
                .into(ivHead);
    }
}