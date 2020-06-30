package com.saiyi.naideanlock.new_ui.user;

import android.app.Activity;
import android.content.Intent;
import android.content.IntentFilter;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.saiyi.naideanlock.R;
import com.saiyi.naideanlock.application.MyApplication;
import com.saiyi.naideanlock.bean.MdlHttpRespList;
import com.saiyi.naideanlock.bean.MdlVersion;
import com.saiyi.naideanlock.config.Config;
import com.saiyi.naideanlock.constant.PublicConstant;
import com.saiyi.naideanlock.new_ui.user.mvp.p.UserInfoActivityPresenter;
import com.saiyi.naideanlock.new_ui.user.mvp.v.UserInfoActivityView;
import com.saiyi.naideanlock.utils.SharedPreferencesUtils;
import com.sandy.guoguo.babylib.constant.BabyExtraConstant;
import com.sandy.guoguo.babylib.constant.BabyHttpConstant;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.entity.MdlUser;
import com.sandy.guoguo.babylib.listener.OnMultiClickListener;
import com.sandy.guoguo.babylib.ui.MVPBaseActivity;
import com.sandy.guoguo.babylib.utils.LogAndToastUtil;
import com.sandy.guoguo.babylib.utils.ResourceUtil;
import com.sandy.guoguo.babylib.utils.Utility;

import java.util.HashMap;
import java.util.Map;


public class NewUserInfoActivity extends MVPBaseActivity<UserInfoActivityView, UserInfoActivityPresenter> implements UserInfoActivityView {
    private static final int INTENT_UPDATE_INFO_REQ = 0XA006;

    private TextView tvName;
    private ImageView ivPic;

    private void initNav() {
        TextView tvLeft = findView(R.id.toolbarLeft);
        tvLeft.setVisibility(View.VISIBLE);
        ResourceUtil.setCompoundDrawable(tvLeft, R.drawable.dr_ic_back, 0, 0, 0);
    }

    @Override
    protected void initViewAndControl() {
        initNav();

        tvName = findView(R.id.tvName);
        tvName.setOnClickListener(new OnMultiClickListener() {
            @Override
            public void OnMultiClick(View view) {
                click2UpdateInfo();
            }
        });
        ivPic = findView(R.id.ivPic);
        ivPic.setOnClickListener(new OnMultiClickListener() {
            @Override
            public void OnMultiClick(View view) {
                click2UpdateInfo();
            }
        });

        //findView(R.id.tvBindPhone).setOnClickListener(new SwitchClickListener());
        findView(R.id.tvBindPhone).setVisibility(View.GONE);
        findView(R.id.view3).setVisibility(View.GONE);
        findView(R.id.tvHelp).setOnClickListener(new SwitchClickListener());
//        findView(R.id.tvUpdate).setOnClickListener(new SwitchClickListener());
        findView(R.id.tvAbout).setOnClickListener(new SwitchClickListener());
        findView(R.id.tvProtocol).setOnClickListener(new SwitchClickListener());
        findView(R.id.btnExit).setOnClickListener(new OnMultiClickListener() {
            @Override
            public void OnMultiClick(View view) {
                SharedPreferencesUtils.getInstance().putBoolean(Config.IS_LOGIN,false);
                Utility.needLogin(NewUserInfoActivity.this);
            }
        });

        //getUserInfo();
        showUserInfo(MyApplication.getInstance().mdlUserInApp,false);
    }

    private void click2UpdateInfo(){
        Intent intent = new Intent(this, NewUpdateUserInfoActivity.class);
        startActivityForResult(intent, INTENT_UPDATE_INFO_REQ);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if(resultCode == Activity.RESULT_OK){
            MdlUser user = data.getParcelableExtra(BabyExtraConstant.EXTRA_ITEM);
            showUserInfo(user,true);
        }
    }

    private void getUserInfo() {
        //Map<String, Object> params = new HashMap<>();
        //params.put("number", MyApplication.getInstance().mdlUserInApp.phone);
        presenter.getUserInfo(MyApplication.getInstance().mdlUserInApp.phone,MyApplication.getInstance().mdlUserInApp.token);
    }

    private class SwitchClickListener extends OnMultiClickListener {
        @Override
        public void OnMultiClick(View view) {

            switch (view.getId()) {
                case R.id.tvBindPhone: {
                    Intent phoneIntent = new Intent(NewUserInfoActivity.this, NewChangeBindPhoneActivity.class);
                    startActivityForResult(phoneIntent, PublicConstant.REQ_PHONE);
                    break;
                }
                case R.id.tvHelp: {
                    Intent intent = new Intent(NewUserInfoActivity.this, NewHelpActivity.class);
                    startActivity(intent);
                    break;
                }

//                case R.id.tvUpdate: {
//                    presenter.getAppVersionInfo(new HashMap());
//                    break;
//                }
                case R.id.tvAbout:{
                    Intent intent = new Intent(NewUserInfoActivity.this, NewAboutActivity.class);
                    startActivity(intent);
                    break;
                }
                case R.id.tvProtocol: {//用户协议
                    Intent intent = new Intent(NewUserInfoActivity.this, ProtocolActivity.class);
                    startActivity(intent);
                    break;
                }
            }
        }
    }


    @Override
    protected int getLayoutResId() {
        return R.layout.activity_new_user_info;
    }


    @Override
    protected int getTitleResId() {
        return R.string.user_information;
    }

    @Override
    protected UserInfoActivityPresenter createPresenter() {
        return new UserInfoActivityPresenter(this);
    }


    @Override
    public void showUserInfoResult(MdlBaseHttpResp<MdlUser> resp) {
        if(resp.code == BabyHttpConstant.R_HTTP_OK){
            MdlUser user = resp.data;
            showUserInfo(user,true);
        }
    }

    private void showUserInfo(MdlUser user,boolean isRefresh) {
        LogAndToastUtil.log("----------user:%s",user.toString());
        String s = MyApplication.getInstance().mdlUserInApp.userName+"\n";
        if(!TextUtils.isEmpty(user.userName)){
            s = user.userName+"\n";
            if (isRefresh) {
                MyApplication.getInstance().mdlUserInApp.userName = user.userName;
            }
        }
        if(!TextUtils.isEmpty(user.headPicture)){
            if (isRefresh) {
                MyApplication.getInstance().mdlUserInApp.headPicture = user.headPicture;
            }
            showRemoteUserHeadImage(user.headPicture, ivPic);
        }
        if(!TextUtils.isEmpty(user.phone)){
            if (isRefresh) {
                MyApplication.getInstance().mdlUserInApp.phone = user.phone;
            }
        }

        s += user.phone;

        tvName.setText(s);
    }


    @Override
    public void showAppVersionResult(MdlBaseHttpResp<MdlHttpRespList<MdlVersion>> resp) {
        if(resp.code == BabyHttpConstant.R_HTTP_OK){

        }
    }
}
