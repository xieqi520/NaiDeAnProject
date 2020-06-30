package com.saiyi.naideanlock.new_ui.device;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.support.v7.widget.LinearLayoutManager;
import android.text.Spannable;
import android.text.TextUtils;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.ImageView;
import android.widget.TextView;

import com.jcodecraeer.xrecyclerview.XRecyclerView;
import com.loopeer.itemtouchhelperextension.ItemTouchHelperExtension;
import com.saiyi.naideanlock.R;
import com.saiyi.naideanlock.application.MyApplication;
import com.saiyi.naideanlock.bean.AuthInfo;
import com.saiyi.naideanlock.bean.MdlDevice;
import com.saiyi.naideanlock.bean.MdlHttpRespList;
import com.saiyi.naideanlock.enums.EnumDeviceAdmin;
import com.saiyi.naideanlock.new_ui.device.mvp.p.AuthManagerActivityPresenter;
import com.saiyi.naideanlock.new_ui.device.mvp.v.AuthManagerActivityView;
import com.sandy.guoguo.babylib.adapter.recycler.BaseAdapterHelper;
import com.sandy.guoguo.babylib.adapter.recycler.MySwipeRecyclerAdapter;
import com.sandy.guoguo.babylib.adapter.recycler.RecycleViewDivider;
import com.sandy.guoguo.babylib.adapter.recycler.WrapContentLinearLayoutManager;
import com.sandy.guoguo.babylib.adapter.recycler.swipe.ItemTouchHelperCallback;
import com.sandy.guoguo.babylib.constant.BabyExtraConstant;
import com.sandy.guoguo.babylib.constant.BabyHttpConstant;
import com.sandy.guoguo.babylib.dialogs.CommonDialog;
import com.sandy.guoguo.babylib.dialogs.CommonInputDialog;
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

public class NewAuthManagerActivity extends MVPBaseActivity<AuthManagerActivityView, AuthManagerActivityPresenter> implements AuthManagerActivityView {
    private static final int INTENT_ADD_REQ = 0XA007;
    private static final int INTENT_CHANGE_AUTH_REQ = 0XA008;

    private ItemTouchHelperExtension mItemTouchHelper;
    private int actionIndex = 0;
    private TextView tvEmpty;


    private MyRecyclerView<AuthInfo> mXRecyclerView;
    private MySwipeRecyclerAdapter<AuthInfo> adapter;
    private List<AuthInfo> dataList = new ArrayList<>();

    private MdlDevice mdlDevice;

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (mXRecyclerView != null) {
            mXRecyclerView.destroy();
            mXRecyclerView = null;
        }
    }

    private void initNav() {
        TextView tvLeft = findView(R.id.toolbarLeft);
        tvLeft.setVisibility(View.VISIBLE);
        ResourceUtil.setCompoundDrawable(tvLeft, R.drawable.dr_ic_back, 0, 0, 0);


        TextView tvRight = findView(R.id.toolbarRight);
        tvRight.setVisibility(View.VISIBLE);
        tvRight.setText(R.string.add_to);
        tvRight.setOnClickListener(new OnMultiClickListener() {
            @Override
            public void OnMultiClick(View view) {
                clickRight();
            }
        });
    }

    private void clickRight() {
        Intent intent = new Intent(this, NewAddAuthManagerActivity.class);
        intent.putExtra(BabyExtraConstant.EXTRA_ITEM, mdlDevice);
        startActivityForResult(intent, INTENT_ADD_REQ);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode != Activity.RESULT_OK) {
            return;
        }
        switch (requestCode) {
            case INTENT_ADD_REQ:
            case INTENT_CHANGE_AUTH_REQ:
                loadRefresh();
                break;
        }
    }

    @Override
    protected int getLayoutResId() {
        return R.layout.activity_new_auth_manager;
    }

    @Override
    protected void initViewAndControl() {
        initNav();

        mdlDevice = getIntent().getParcelableExtra(BabyExtraConstant.EXTRA_ITEM);

        MdlUser mdlUser = MyApplication.getInstance().mdlUserInApp;
        Spannable spannable = Utility.getCommon2LinesSpan(mdlUser.userName + "\n", mdlUser.phone, R.dimen.font_16, R.dimen.font_14, R.color.black, R.color.gray3);
        TextView tvName = findView(R.id.tvName);
        tvName.setText(spannable);

        ImageView ivPic = findView(R.id.ivHead);
        showRemoteUserHeadImage(mdlUser.headPicture, ivPic);

        mXRecyclerView = findView(R.id.recyclerView);
        mXRecyclerView.fillData(dataList);

        LinearLayoutManager layoutManager = new WrapContentLinearLayoutManager(this);
        layoutManager.setOrientation(LinearLayoutManager.VERTICAL);
        mXRecyclerView.setLayoutManager(layoutManager);
        mXRecyclerView.addItemDecoration(new RecycleViewDivider(this, LinearLayoutManager.HORIZONTAL));

        initAdapter();
        mXRecyclerView.setLoadingListener(new XRecyclerView.LoadingListener() {
            @Override
            public void onRefresh() {
                loadRefresh();
            }

            @Override
            public void onLoadMore() {
                loadMore();
            }
        });
        mXRecyclerView.setAdapter(adapter);
        mXRecyclerView.setLoadingMoreEnabled(false);
        mXRecyclerView.setPullRefreshEnabled(false);

        ItemTouchHelperExtension.Callback mCallback = new ItemTouchHelperCallback();
        mItemTouchHelper = new ItemTouchHelperExtension(mCallback);
        mItemTouchHelper.attachToRecyclerView(mXRecyclerView);
        adapter.setItemTouchHelperExtension(mItemTouchHelper);


        tvEmpty = findView(R.id.tvEmpty);
        tvEmpty.setOnClickListener(new OnMultiClickListener() {
            @Override
            public void OnMultiClick(View view) {
                loadRefresh();
            }
        });

        resetRecyclerView(false);
    }

    @Override
    protected void onResume() {
        super.onResume();
        loadRefresh();
    }

    private void resetRecyclerView(boolean haveData) {
        if (haveData) {
            mXRecyclerView.setVisibility(View.VISIBLE);
            tvEmpty.setVisibility(View.GONE);
        } else {
            mXRecyclerView.setVisibility(View.GONE);
            tvEmpty.setVisibility(View.VISIBLE);
        }
    }

    private void initAdapter() {
        adapter = new MySwipeRecyclerAdapter<AuthInfo>(this, R.layout._item_swipe_activity_auth_manager, R.id.clContent, R.id.llActionContainer, dataList) {
            @Override
            public void onUpdate(BaseAdapterHelper helper, final AuthInfo item, final int position) {
                if (item == null) {
                    return;
                }

                ImageView iv = helper.getView(R.id.ivHead);
                showRemoteUserHeadImage(item.getPic(), iv);//190604

                if (TextUtils.isEmpty(item.getMemoName())) {
                    helper.setText(R.id.tvName, item.getPhone());
                } else {
                    Spannable spannable = Utility.getCommon2LinesSpan(item.getMemoName() + "\n", item.getPhone(), R.dimen.font_16, R.dimen.font_14, R.color.black, R.color.gray3);
                    helper.setText(R.id.tvName, spannable);
                }


                helper.setOnClickListener(R.id.clContent, new OnMultiClickListener() {
                    @Override
                    public void OnMultiClick(View view) {
                        clickGo2Manager(position);
                    }
                });
                helper.setOnClickListener(R.id.tvRename, new OnMultiClickListener() {
                    @Override
                    public void OnMultiClick(View view) {
                        clickRename(position);
                    }
                });
                helper.setOnClickListener(R.id.tvDel, new OnMultiClickListener() {
                    @Override
                    public void OnMultiClick(View view) {
                        clickDelAuth(position);
                    }
                });
            }
        };
    }

    private void clickGo2Manager(int position) {
        AuthInfo user = dataList.get(position);
        //user.lockName = mdlDevice.lockName;
        Intent intent = new Intent(this, NewAuthManagerSettingActivity.class);
        if(dataList!=null && dataList.size() >0){
            mdlDevice.times = dataList.get(position).getTimes();
        }
        intent.putExtra(BabyExtraConstant.EXTRA_ITEM, mdlDevice);
        intent.putExtra(BabyExtraConstant.EXTRA_USER, user);
        startActivityForResult(intent, INTENT_CHANGE_AUTH_REQ);
    }

    private void clickRename(int position) {
        CommonInputDialog dialog = new CommonInputDialog(this, getString(R.string.rename), getString(R.string.please_enter_name_toast), new CommonInputDialog.ClickListener() {
            @Override
            public void clickConfirm(String content) {
                InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);

                /*
                 * 输入法状态发生逆转
                 * 如果使用Utility.hideSoftKeyboard();需要正确获取得到焦点的组件，这里用这个方便一点
                 */
                imm.toggleSoftInput(0, InputMethodManager.HIDE_NOT_ALWAYS);

                actionIndex = position;

                dataList.get(position).setMemoName(content);

                sendRename2Remote(position);
            }

            @Override
            public void clickCancel() {
            }
        });

        dialog.show();
    }

    private void sendRename2Remote(int position) {
        //Map<String, Object> params = new HashMap<>();
        //params.put("number", dataList.get(position).number);y190604
        //params.put("number", dataList.get(position).number);

        //params.put("mac", mdlDevice.mac);
        //params.put("linkType", mdlDevice.linkType);
        //params.put("remark", dataList.get(position).remark);
        presenter.renameAuthUser(dataList.get(position).getId(),dataList.get(position).getMemoName(),MyApplication.getInstance().mdlUserInApp.token);
    }

    private void clickDelAuth(final int position) {
        CommonDialog dialog = new CommonDialog(this, getString(R.string.delete), getString(R.string.sure_delete), new CommonDialog.ClickListener() {
            @Override
            public void clickConfirm() {
                actionIndex = position;
                deleteRemote(position);
            }

            @Override
            public void clickCancel() {
                mItemTouchHelper.closeOpened();
            }
        });
        dialog.show();
    }

    private void deleteRemote(int position) {
        AuthInfo authUser = dataList.get(position);
        presenter.delDeviceBinding(authUser.getId(),MyApplication.getInstance().mdlUserInApp.token);
       /*switch (authUser.getUserType()){
           case EnumDeviceAdmin.NOT_ADMIN: {
               //Map<String, Object> params = new HashMap<>();
               //params.put("id", mdlDevice.mac);
//               params.put("isAdmin", authUser.isAdmin);
//               params.put("linkType", mdlDevice.linkType);
//               params.put("number", authUser.number);
               presenter.delDeviceBinding(authUser.getId(),MyApplication.getInstance().mdlUserInApp.token);
               break;
           }
           case EnumDeviceAdmin.NANNY: {
               //Map<String, Object> params = new HashMap<>();
               //params.put("bindingId", authUser.bindingID);
               //presenter.deleteNanny(params);
               break;
           }
       }*/
    }

    private void loadRefresh() {
        currentPage = 1;
        getAuthManagerList();
    }

    private void loadMore() {
        if (currentPage < totalPage) {
            currentPage++;
            getAuthManagerList();
        }
    }

    private void getAuthManagerList() {
        /*Map<String, Object> params = new HashMap<>();
        params.put("number", MyApplication.getInstance().mdlUserInApp.phone);
        if (mdlDevice != null) {
            if (!TextUtils.isEmpty(mdlDevice.mac)) {
                params.put("mac", mdlDevice.mac);
            }
            params.put("linkType", mdlDevice.linkType);
        }*/
        presenter.getAuthManagerList(mdlDevice.id,MyApplication.getInstance().mdlUserInApp.token);
    }


    @Override
    protected AuthManagerActivityPresenter createPresenter() {
        return new AuthManagerActivityPresenter(this);
    }

    @Override
    protected int getTitleResId() {
        return R.string.permission_management;
    }


    @Override
    public void showAuthUserListResult(MdlBaseHttpResp<List<AuthInfo>> resp) {
        mXRecyclerView.loadMoreComplete();
        mXRecyclerView.refreshComplete();
        if (resp.code == BabyHttpConstant.R_HTTP_OK) {
            if (currentPage == 1) {
                dataList.clear();
            }

            boolean haveData = resp.data != null && resp.data.size() > 0;
            resetRecyclerView(haveData);
            if (haveData) {
                dataList.addAll(resp.data);
            }
            adapter.notifyDataSetChanged();
        }
    }

    @Override
    public void showRenameAuthUserResult(MdlBaseHttpResp resp) {
        mItemTouchHelper.closeOpened();
        if (resp.code == BabyHttpConstant.R_HTTP_OK) {
            mXRecyclerView.notifyItemChanged(actionIndex);
        }
    }

    @Override
    public void showDelNannyResult(MdlBaseHttpResp resp) {
        LogAndToastUtil.toast(resp.message);
        if (resp.code == BabyHttpConstant.R_HTTP_OK) {
            mItemTouchHelper.closeOpened();
            dataList.remove(actionIndex);
            mXRecyclerView.notifyItemRemoved(dataList, actionIndex);
        }
    }

    @Override
    public void showDelNoAdminResult(MdlBaseHttpResp resp) {
        LogAndToastUtil.toast(resp.message);
        if (resp.code == BabyHttpConstant.R_HTTP_OK) {
            mItemTouchHelper.closeOpened();
            dataList.remove(actionIndex);
            mXRecyclerView.notifyItemRemoved(dataList, actionIndex);
        }
    }
}
