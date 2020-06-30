package com.saiyi.naideanlock.new_ui.device;

import android.content.Intent;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.TextView;

import com.saiyi.naideanlock.R;
import com.saiyi.naideanlock.bean.MdlWeekCheck;
import com.sandy.guoguo.babylib.adapter.recycler.BaseAdapterHelper;
import com.sandy.guoguo.babylib.adapter.recycler.MyRecyclerAdapter;
import com.sandy.guoguo.babylib.adapter.recycler.RecycleViewDivider;
import com.sandy.guoguo.babylib.adapter.recycler.WrapContentLinearLayoutManager;
import com.sandy.guoguo.babylib.constant.BabyExtraConstant;
import com.sandy.guoguo.babylib.ui.BaseActivity;
import com.sandy.guoguo.babylib.utils.ResourceUtil;
import com.sandy.guoguo.babylib.widgets.MyRecyclerView;

import java.util.ArrayList;
import java.util.List;

public class NewAuthManagerSettingWeekActivity extends BaseActivity {
    private MyRecyclerView<MdlWeekCheck> mXRecyclerView;
    private MyRecyclerAdapter<MdlWeekCheck> adapter;
    private List<MdlWeekCheck> dataList = new ArrayList<>();


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
        return R.string.unlock_time_period;
    }

    @Override
    protected int getLayoutResId() {
        return R.layout.activity_new_auth_manager_setting_week;
    }

    @Override
    protected void initViewAndControl() {
        initNav();

        List<Integer> weekCheckList = getIntent().getIntegerArrayListExtra(BabyExtraConstant.EXTRA_ITEM);

        mXRecyclerView = findView(R.id.recyclerView);
        mXRecyclerView.fillData(dataList);


        LinearLayoutManager layoutManager = new WrapContentLinearLayoutManager(this);
        layoutManager.setOrientation(LinearLayoutManager.VERTICAL);
        mXRecyclerView.setLayoutManager(layoutManager);

        mXRecyclerView.addItemDecoration(new RecycleViewDivider(this, LinearLayoutManager.HORIZONTAL));

        initAdapter();

        mXRecyclerView.setAdapter(adapter);
        mXRecyclerView.setLoadingMoreEnabled(false);
        mXRecyclerView.setPullRefreshEnabled(false);

        initList(weekCheckList);
    }


    private void initNav() {
        TextView tvLeft = findView(R.id.toolbarLeft);
        tvLeft.setVisibility(View.VISIBLE);
        ResourceUtil.setCompoundDrawable(tvLeft, R.drawable.dr_ic_back, 0, 0, 0);
    }


    private void initAdapter() {
        adapter = new MyRecyclerAdapter<MdlWeekCheck>(this, R.layout._item_activity_new_manager_setting_week, dataList) {


            @Override
            public void onUpdate(BaseAdapterHelper helper, final MdlWeekCheck item, final int position) {
                if (item == null) {
                    return;
                }
                helper.setText(R.id.tvName, item.name);
                helper.setVisible(R.id.ivCheck, item.isCheck ? View.VISIBLE : View.GONE);
            }
        };

        adapter.setOnItemClickListener(new MyRecyclerAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(RecyclerView.ViewHolder viewHolder, View view, int position) {
                position--;
                clickItem(position);
            }
        });
    }

    private void clickItem(int position) {
        MdlWeekCheck weekCheck = dataList.get(position);
        weekCheck.isCheck = !weekCheck.isCheck;
        mXRecyclerView.notifyItemChanged(position);
    }


    private void initList(List<Integer> list) {
        dataList.add(new MdlWeekCheck("每周日"));
        dataList.add(new MdlWeekCheck("每周一"));
        dataList.add(new MdlWeekCheck("每周二"));
        dataList.add(new MdlWeekCheck("每周三"));
        dataList.add(new MdlWeekCheck("每周四"));
        dataList.add(new MdlWeekCheck("每周五"));
        dataList.add(new MdlWeekCheck("每周六"));
        if (!list.isEmpty()) {
            for (int item : list) {
                dataList.get(item - 1).isCheck = true;
            }
        }

        adapter.notifyDataSetChanged();
    }

    @Override
    protected void handleBackKey() {
        ArrayList<Integer> list = new ArrayList<>();
        int len = dataList.size();
        MdlWeekCheck weekCheck;
        for (int i = 0; i < len; i++) {
            weekCheck = dataList.get(i);
            if (weekCheck.isCheck) {
                list.add(i+1);
            }
        }
        Intent intent = new Intent();
        intent.putIntegerArrayListExtra(BabyExtraConstant.EXTRA_ITEM, list);
        setResult(RESULT_OK, intent);
        super.handleBackKey();
    }
}
