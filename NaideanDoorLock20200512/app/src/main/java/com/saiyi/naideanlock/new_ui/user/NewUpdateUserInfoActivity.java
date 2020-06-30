package com.saiyi.naideanlock.new_ui.user;

import android.Manifest;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.saiyi.naideanlock.R;
import com.saiyi.naideanlock.application.MyApplication;
import com.saiyi.naideanlock.bean.UserInfo;
import com.saiyi.naideanlock.new_ui.user.mvp.p.UpdateUserInfoActivityPresenter;
import com.saiyi.naideanlock.new_ui.user.mvp.v.UpdateUserInfoActivityView;
import com.saiyi.naideanlock.utils.ToastUtil;
import com.sandy.guoguo.babylib.constant.BabyExtraConstant;
import com.sandy.guoguo.babylib.constant.BabyHttpConstant;
import com.sandy.guoguo.babylib.constant.MyPermissionConstant;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.entity.MdlUser;
import com.sandy.guoguo.babylib.listener.OnMultiClickListener;
import com.sandy.guoguo.babylib.ui.MVPBaseActivity;
import com.sandy.guoguo.babylib.ui.SetContentActivity;
import com.sandy.guoguo.babylib.utils.ImageUtil;
import com.sandy.guoguo.babylib.utils.ResourceUtil;
import com.sandy.guoguo.babylib.utils.Utility;
import com.sandy.guoguo.babylib.utils.permission.PermissionUtil;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import me.iwf.photopicker.PhotoPicker;
import me.iwf.photopicker.utils.MyFileProviderUtil;

public class NewUpdateUserInfoActivity extends MVPBaseActivity<UpdateUserInfoActivityView, UpdateUserInfoActivityPresenter> implements UpdateUserInfoActivityView {
    private static final int PIC = 11;
    private static final int CROP_PIC = 13;
    private static final int INTENT_MODIFY_NAME_REQ = 0XA004;


    private String cropTeamImagePath;
    private String lastPath;
    private ImageView ivHead;
    private TextView tvNickname;
    private String mServerPicPath = "";
    private boolean updatedImage = false;

    @Override
    protected int getLayoutResId() {
        return R.layout.activity_new_update_info;
    }

    @Override
    protected int getTitleResId() {
        return R.string.personal_info;
    }

    @Override
    protected void initViewAndControl() {
        initNav();

        tvNickname = findView(R.id.tvNickname);
        String nickname = MyApplication.getInstance().mdlUserInApp.userName;
        if (!TextUtils.isEmpty(nickname)) {
            tvNickname.setText(nickname);
        }
        tvNickname.setOnClickListener(new OnMultiClickListener() {
            @Override
            public void OnMultiClick(View view) {
                clickName();
            }
        });

        cropTeamImagePath = MyApplication.getInstance().mdlUserInApp.headPicture;
        lastPath = cropTeamImagePath;
        ivHead = findView(R.id.ivHead);
        showRemoteUserHeadImage(cropTeamImagePath, ivHead);
        ivHead.setOnClickListener(new OnMultiClickListener() {
            @Override
            public void OnMultiClick(View view) {
                clickSelectPic();
            }
        });

        //presenter.getUserInfo(MyApplication.getInstance().mdlUserInApp.phone,MyApplication.getInstance().mdlUserInApp.token);
    }

    private void clickName() {
        Intent intent = new Intent(this, SetContentActivity.class);
        intent.putExtra(BabyExtraConstant.EXTRA_CONTENT, Utility.getEditTextStr(tvNickname));
        intent.putExtra(BabyExtraConstant.EXTRA_TITLE, ResourceUtil.getString(R.string.name_setting));
        startActivityForResult(intent, INTENT_MODIFY_NAME_REQ);
    }

    private void clickSelectPic() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
            PermissionUtil.checkPermission(this, MyPermissionConstant.READ_EXTERNAL_STORAGE, Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.WRITE_EXTERNAL_STORAGE);
        } else {
            permissionSuccess(MyPermissionConstant.READ_EXTERNAL_STORAGE);
        }
    }

    @Override
    public void permissionSuccess(int permissionReqCode) {
        super.permissionSuccess(permissionReqCode);
        switch (permissionReqCode) {
            case MyPermissionConstant.READ_EXTERNAL_STORAGE:
                PhotoPicker.builder()
                        .setPhotoCount(0)
                        .setShowCamera(true)
                        .setShowGif(false)
                        .setPreviewEnabled(false)
                        .start(this, PIC);
                break;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK) {
            switch (requestCode) {
                case PIC:
                    if (data != null) {

                        ArrayList<String> photos =
                                data.getStringArrayListExtra(PhotoPicker.KEY_SELECTED_PHOTOS);
                        String path = photos.get(0);

                        Uri uri = MyFileProviderUtil.getUriForFile(this.getApplicationContext(), path);
                        cropTeamImagePath = ImageUtil.cropUserHeadPic(this, uri, CROP_PIC);
                    }
                    break;

                case CROP_PIC:
                    if (data != null) {

                        showLocalUserHeadImage(cropTeamImagePath, ivHead);
                        //presenter.uploadHeadPic(new File(cropTeamImagePath));
                        updatedImage = true;
                    }
                    break;

                case INTENT_MODIFY_NAME_REQ:
                    if (data != null) {
                        String content = data.getStringExtra(BabyExtraConstant.EXTRA_CONTENT);
                        tvNickname.setText(content);
                    }
                    break;
            }
        }

    }

    private void initNav() {
        TextView tvLeft = findView(R.id.toolbarLeft);
        tvLeft.setVisibility(View.VISIBLE);
        ResourceUtil.setCompoundDrawable(tvLeft, R.drawable.dr_ic_back, 0, 0, 0);

        TextView tvRight = findView(R.id.toolbarRight);
        tvRight.setVisibility(View.VISIBLE);
        tvRight.setText(R.string.save);
        tvRight.setOnClickListener(new OnMultiClickListener() {
            @Override
            public void OnMultiClick(View view) {
                clickRight();
            }
        });
    }

    private void clickRight() {


        if (updatedImage  && !TextUtils.isEmpty(cropTeamImagePath)) {
            presenter.uploadHeadPic(new File(cropTeamImagePath));
        } else {
            String newNickname = Utility.getEditTextStr(tvNickname);
            if (TextUtils.equals(MyApplication.getInstance().mdlUserInApp.userName, newNickname)) {
                handleBackKey();
                return;
            }
            presenter.updateUserInfo(newNickname,mServerPicPath,MyApplication.getInstance().mdlUserInApp.token);
        }
    }

    @Override
    protected UpdateUserInfoActivityPresenter createPresenter() {
        return new UpdateUserInfoActivityPresenter(this);
    }

    @Override
    public void showUpdateInfoResult(MdlBaseHttpResp resp) {
        if (resp.code == BabyHttpConstant.R_HTTP_OK) {
            MyApplication.getInstance().mdlUserInApp.headPicture = mServerPicPath;
            MyApplication.getInstance().mdlUserInApp.userName = Utility.getEditTextStr(tvNickname);
            ToastUtil.toastShort(this,R.string.save_success);
        }
    }

    @Override
    public void showGetUserInfoResult(MdlBaseHttpResp resp) {

    }

    @Override
    public void showUploadPicResult(MdlBaseHttpResp<String> resp) {
        if (resp.code == BabyHttpConstant.R_HTTP_OK) {
            mServerPicPath = resp.data;
            presenter.updateUserInfo(Utility.getEditTextStr(tvNickname),mServerPicPath,MyApplication.getInstance().mdlUserInApp.token);
        }
    }

    @Override
    protected void handleBackKey() {
        MdlUser mdlUser = new MdlUser();
        mdlUser.userName = Utility.getEditTextStr(tvNickname);
        if (!TextUtils.isEmpty(mServerPicPath)) {
            mdlUser.headPicture = mServerPicPath;
        } else {
            mdlUser.headPicture = lastPath;
        }
        mdlUser.phone = MyApplication.getInstance().mdlUserInApp.phone;
        Intent intent = new Intent();
        intent.putExtra(BabyExtraConstant.EXTRA_ITEM, mdlUser);
        setResult(RESULT_OK, intent);

        super.handleBackKey();
    }
}
