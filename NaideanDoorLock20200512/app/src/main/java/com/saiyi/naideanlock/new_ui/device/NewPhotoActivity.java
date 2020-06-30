package com.saiyi.naideanlock.new_ui.device;

import android.content.Intent;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.jcodecraeer.xrecyclerview.XRecyclerView;
import com.saiyi.naideanlock.R;
import com.saiyi.naideanlock.application.MyApplication;
import com.saiyi.naideanlock.bean.MdlDevice;
import com.saiyi.naideanlock.bean.MdlHttpRespList;
import com.saiyi.naideanlock.bean.MdlPhoto;
import com.saiyi.naideanlock.new_ui.device.mvp.p.PhotoActivityPresenter;
import com.saiyi.naideanlock.new_ui.device.mvp.v.PhotoActivityView;
import com.sandy.guoguo.babylib.adapter.recycler.BaseAdapterHelper;
import com.sandy.guoguo.babylib.adapter.recycler.MyRecyclerAdapter;
import com.sandy.guoguo.babylib.adapter.recycler.WrapContentLinearLayoutManager;
import com.sandy.guoguo.babylib.constant.BabyExtraConstant;
import com.sandy.guoguo.babylib.constant.BabyHttpConstant;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.ui.MVPBaseActivity;
import com.sandy.guoguo.babylib.utils.ResourceUtil;
import com.sandy.guoguo.babylib.utils.Utility;
import com.sandy.guoguo.babylib.widgets.MyRecyclerView;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class NewPhotoActivity extends MVPBaseActivity<PhotoActivityView, PhotoActivityPresenter> implements PhotoActivityView {
    private MyRecyclerView<MdlPhoto> mXRecyclerView;
    private MyRecyclerAdapter<MdlPhoto> adapter;
    private List<MdlPhoto> dataList = new ArrayList<>();

    private TextView tvEmpty;

    private MdlDevice mdlDevice;

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
        return R.string.about_photo;
    }

    @Override
    protected int getLayoutResId() {
        return R.layout.activity_new_photo;
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

        tvEmpty = findView(R.id.tvEmpty);

        resetRecyclerView(false);

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

    private void initNav() {
        TextView tvLeft = findView(R.id.toolbarLeft);
        tvLeft.setVisibility(View.VISIBLE);
        ResourceUtil.setCompoundDrawable(tvLeft, R.drawable.dr_ic_back, 0, 0, 0);
    }



    private void initAdapter() {
        adapter = new MyRecyclerAdapter<MdlPhoto>(this, R.layout._item_activity_new_photo, dataList) {


            @Override
            public void onUpdate(BaseAdapterHelper helper, final MdlPhoto item, final int position) {
                if (item == null) {
                    return;
                }
                ImageView ivPic = helper.getView(R.id.ivPic);
                showRemoteGoodsImage(item.picture, ivPic);

                String time = Utility.myFormat("拍照时间\t\t%s", item.time);
                helper.setText(R.id.tvName, time);


            }
        };

        adapter.setOnItemClickListener(new MyRecyclerAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(RecyclerView.ViewHolder viewHolder, View view, int position) {
                position--;
                clickDetail(position);
            }
        });
    }

    private void clickDetail(int position) {
        Intent intent = new Intent(this, NewPhotoDetailActivity.class);
        intent.putExtra(BabyExtraConstant.EXTRA_ITEM, dataList.get(position).picture);
        startActivity(intent);
    }


    private void loadRefresh() {
        currentPage = 1;
        getPhotoList();
    }

    private void loadMore() {
        if (currentPage < totalPage) {
            currentPage++;
            getPhotoList();
        } else {
            mXRecyclerView.loadMoreComplete();
            mXRecyclerView.refreshComplete();
        }
    }


    private void getPhotoList() {
        Map<String, Object> params = new HashMap<>();
//        params.put("number", MyApplication.getInstance().mdlUserInApp.phone);
        params.put("deviceId", mdlDevice.mac);
        params.put("page", currentPage);
        params.put("size", BabyHttpConstant.PER_PAGE_SIZE);
        presenter.getPhotoList(params);
    }

    @Override
    protected PhotoActivityPresenter createPresenter() {
        return new PhotoActivityPresenter(this);
    }
    

    @Override
    public void showPhotoListResult(MdlBaseHttpResp<MdlHttpRespList<MdlPhoto>> resp) {
        mXRecyclerView.loadMoreComplete();
        mXRecyclerView.refreshComplete();
        if (resp.code == BabyHttpConstant.R_HTTP_OK || resp.code == BabyHttpConstant.R_RESPONSE_NO_DATA) {
            if (currentPage == 1) {
                dataList.clear();
            }


            boolean haveData = resp.data != null && resp.data.list != null && !resp.data.list.isEmpty();
            resetRecyclerView(haveData);

            if (haveData) {
//                totalPage = resp.totalItems;
                totalPage = (int) Math.ceil(resp.totalItems * 1.0f / BabyHttpConstant.PER_PAGE_SIZE);
                dataList.addAll(resp.data.list);
            }
            adapter.notifyDataSetChanged();
        }
    }
}
