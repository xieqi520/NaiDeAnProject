package com.saiyi.naideanlock.new_ui.device;

import android.content.Intent;
import android.os.Parcel;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import com.saiyi.naideanlock.R;
import com.saiyi.naideanlock.application.MyApplication;
import com.saiyi.naideanlock.bean.AuthInfo;
import com.saiyi.naideanlock.bean.MdlDevice;
import com.saiyi.naideanlock.bean.UserInfo;
import com.saiyi.naideanlock.constant.PublicConstant;
import com.saiyi.naideanlock.enums.EnumDeviceAdmin;
import com.saiyi.naideanlock.new_ui.device.mvp.p.AddAuthManagerActivityPresenter;
import com.saiyi.naideanlock.new_ui.device.mvp.v.AddAuthManagerActivityView;
import com.sandy.guoguo.babylib.adapter.recycler.BaseAdapterHelper;
import com.sandy.guoguo.babylib.adapter.recycler.MyRecyclerAdapter;
import com.sandy.guoguo.babylib.adapter.recycler.WrapContentLinearLayoutManager;
import com.sandy.guoguo.babylib.constant.BabyExtraConstant;
import com.sandy.guoguo.babylib.constant.BabyHttpConstant;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.entity.MdlUser;
import com.sandy.guoguo.babylib.listener.OnMultiClickListener;
import com.sandy.guoguo.babylib.ui.MVPBaseActivity;
import com.sandy.guoguo.babylib.utils.LogAndToastUtil;
import com.sandy.guoguo.babylib.utils.ResourceUtil;
import com.sandy.guoguo.babylib.utils.Utility;
import com.sandy.guoguo.babylib.widgets.MyRecyclerView;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class NewAddAuthManagerActivity extends MVPBaseActivity<AddAuthManagerActivityView, AddAuthManagerActivityPresenter> implements AddAuthManagerActivityView {
    private MyRecyclerView<UserInfo> mXRecyclerView;
    private MyRecyclerAdapter<UserInfo> adapter;
    private List<UserInfo> dataList = new ArrayList<>();

    private boolean isSearch = true;
    private EditText etSearch;
    private TextView tvRight;

    private MdlDevice mdlDevice;

    private int actionIndex = -1;

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (mXRecyclerView != null) {
            mXRecyclerView.destroy();
            mXRecyclerView = null;
        }
    }


    @Override
    protected int getTitleResId() {
        return R.string.add_admin;
    }

    @Override
    protected int getLayoutResId() {
        return R.layout.activity_new_add_auth_manager;
    }

    @Override
    protected void initViewAndControl() {
        initNav();

        mdlDevice = getIntent().getParcelableExtra(BabyExtraConstant.EXTRA_ITEM);

        mXRecyclerView = findView(R.id.recyclerView);
        mXRecyclerView.fillData(dataList);


        LinearLayoutManager layoutManager = new WrapContentLinearLayoutManager(this);
        layoutManager.setOrientation(LinearLayoutManager.VERTICAL);
        mXRecyclerView.setLayoutManager(layoutManager);

//        mXRecyclerView.addItemDecoration(new RecycleViewDivider(this, LinearLayoutManager.HORIZONTAL));

        initAdapter();

//        mXRecyclerView.setLoadingListener(new XRecyclerView.LoadingListener() {
//            @Override
//            public void onRefresh() {
//                loadRefresh();
//            }
//
//            @Override
//            public void onLoadMore() {
//                loadMore();
//            }
//        });
        mXRecyclerView.setAdapter(adapter);
        mXRecyclerView.setPullRefreshEnabled(false);
        mXRecyclerView.setLoadingMoreEnabled(false);

        etSearch = findView(R.id.etSearch);
        etSearch.addTextChangedListener(new TextListener());
    }

    private class TextListener implements TextWatcher {

        @Override
        public void beforeTextChanged(CharSequence s, int start, int count, int after) {

        }

        @Override
        public void onTextChanged(CharSequence s, int start, int before, int count) {
            isSearch = true;
            resetNavRightView();
        }

        @Override
        public void afterTextChanged(Editable s) {

        }
    }


    private void initNav() {
        TextView tvLeft = findView(R.id.toolbarLeft);
        tvLeft.setVisibility(View.VISIBLE);
        ResourceUtil.setCompoundDrawable(tvLeft, R.drawable.dr_ic_back, 0, 0, 0);

        tvRight = findView(R.id.toolbarRight);
        tvRight.setVisibility(View.VISIBLE);
        tvRight.setText(R.string.search);
        tvRight.setOnClickListener(new OnMultiClickListener() {
            @Override
            public void OnMultiClick(View view) {
                clickRight();
            }
        });
    }

    private void clickRight() {
        if (isSearch) {
            dataList.clear();
            adapter.notifyDataSetChanged();
            getUserInfo();
        } else {
            addDevice();
        }
    }

    private void initAdapter() {
        adapter = new MyRecyclerAdapter<UserInfo>(this, R.layout._item_activity_new_add_auth_manager, dataList) {


            @Override
            public void onUpdate(BaseAdapterHelper helper, final UserInfo item, final int position) {
                if (item == null) {
                    return;
                }
                ImageView ivPic = helper.getView(R.id.ivHead);
                showRemoteGoodsImage(item.getPic(), ivPic);

                helper.setText(R.id.tvName, item.getNickName());

                helper.setVisible(R.id.ivCheck, !isSearch);
                helper.setImageResource(R.id.ivCheck, isSearch ? R.drawable.ic_check_n : R.drawable.ic_check_c);
            }
        };

        adapter.setOnItemClickListener(new MyRecyclerAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(RecyclerView.ViewHolder viewHolder, View view, int position) {
                position--;
                actionIndex = position;
                isSearch = false;
                resetNavRightView();
                adapter.notifyDataSetChanged();
            }
        });
    }

    private void resetNavRightView() {
        if (isSearch) {
            tvRight.setText(R.string.search);
        } else {
            tvRight.setText(R.string.complete);
        }
    }


    private void getUserInfo() {
        //Map<String, Object> params = new HashMap<>();
        //params.put("number", Utility.getEditTextStr(etSearch));
        presenter.searchUserInfo(Utility.getEditTextStr(etSearch),MyApplication.getInstance().mdlUserInApp.token);
    }

    private void addDevice() {
        /*if(actionIndex < 0)
            return;
        if(TextUtils.equals(dataList.get(actionIndex).phone,MyApplication.getInstance().mdlUserInApp.phone)){
            LogAndToastUtil.toast("不能给自己授权");
            return;
        }*/

        /*Map<String, Object> params = new HashMap<>();
        params.put("number", dataList.get(actionIndex).phone);
        params.put("mac", mdlDevice.mac);
        params.put("lockName", mdlDevice.lockName);
        params.put("isAdmin", EnumDeviceAdmin.IS_ADMIN);
        params.put("linkType", mdlDevice.linkType);*/
        //presenter.addBind(mdlDevice.mac, mdlDevice.lockName, mdlDevice.linkType+"", MyApplication.getInstance().mdlUserInApp.token);
        if (dataList.size() == 0) return;
        UserInfo mdlUser = dataList.get(actionIndex);
        //user.lockName = mdlDevice.lockName;
        Intent intent = new Intent(this, NewAuthManagerSettingActivity.class);
        intent.putExtra(BabyExtraConstant.EXTRA_ITEM, mdlDevice);
        intent.putExtra(BabyExtraConstant.EXTRA_USER, mdlUser);
        intent.putExtra(BabyExtraConstant.EXTRA_ADD, true);
        startActivity(intent);
    }

    @Override
    protected AddAuthManagerActivityPresenter createPresenter() {
        return new AddAuthManagerActivityPresenter(this);
    }


    @Override
    public void showUserInfoResult(MdlBaseHttpResp<UserInfo> resp) {
        if (resp.code == BabyHttpConstant.R_HTTP_OK) {
            UserInfo user = resp.data;
            if (user != null) {
                user.setPhone(Utility.getEditTextStr(etSearch));
                dataList.add(user);
            }
            adapter.notifyDataSetChanged();
        }
    }

    @Override
    public void showAddDeviceResult(MdlBaseHttpResp resp) {
        if (resp.code == BabyHttpConstant.R_HTTP_OK) {
            setResult(RESULT_OK);
            finish();
        }
    }

    @Override
    public void showAddBindResult(MdlBaseHttpResp resp) {
        if (resp.code == BabyHttpConstant.R_HTTP_OK) {
            setResult(RESULT_OK);
            finish();
        }
    }
}
