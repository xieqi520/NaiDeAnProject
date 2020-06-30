package com.sandy.guoguo.babylib.adapter.recycler;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.view.ViewGroup;

import java.util.List;


public abstract class MyRecyclerAdapter<T> extends RecyclerView.Adapter implements IAdapter<T> {

    private final Context mContext;
    private final int mLayoutResId;
    private List<T> mData;

    private OnItemClickListener mItemClickListener;
    private OnItemLongClickListener mItemLongClickListener;

    private int curPosition = 0;

    public MyRecyclerAdapter(Context context, int layoutResId, List<T> data) {
        this.mData = data;
        if(data == null){
            throw new IllegalArgumentException("非法参数，此处的data只能是引用！！！");
        }
        this.mContext = context;
        this.mLayoutResId = layoutResId;
    }

    public void setData(List<T> data){
        this.mData = data;
        notifyDataSetChanged();
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        final BaseAdapterHelper helper = BaseAdapterHelper.get(mContext, null, parent, viewType, -1);
        return new RecyclerViewHolder(helper.getView(), helper);
    }

    public BaseAdapterHelper getAdapterHelper(RecyclerView.ViewHolder holder) {
        return ((RecyclerViewHolder) holder).mAdapterHelper;
    }

    @SuppressWarnings("unchecked")
    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int position) {
        BaseAdapterHelper helper = getAdapterHelper(holder);
        helper.setAssociatedObject(getItem(position));
        onUpdate(helper, getItem(position), position);
    }



    @Override
    public int getItemViewType(int position) {
        return getLayoutResId(getItem(position), position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public int getItemCount() {
        return mData.size();
    }

    @Override
    public int getLayoutResId(T item, int position) {
        return this.mLayoutResId;
    }


    public T getItem(int position) {
        return position >= mData.size() ? null : mData.get(position);
    }

    public void setOnItemClickListener(OnItemClickListener itemClickListener) {
        this.mItemClickListener = itemClickListener;
    }

    public void setOnItemLongClickListener(OnItemLongClickListener itemLongClickListener) {
        this.mItemLongClickListener = itemLongClickListener;
    }

    public interface OnItemClickListener {
        void onItemClick(RecyclerView.ViewHolder viewHolder, View view, int position);
    }

    public interface OnItemLongClickListener {
        void onItemLongClick(RecyclerView.ViewHolder viewHolder, View view, int position);
    }

    public final class RecyclerViewHolder extends RecyclerView.ViewHolder{
        BaseAdapterHelper mAdapterHelper;

        public RecyclerViewHolder(View itemView, BaseAdapterHelper adapterHelper) {
            super(itemView);
            this.mAdapterHelper = adapterHelper;

            itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (null != mItemClickListener) {
                        mItemClickListener.onItemClick(MyRecyclerAdapter.RecyclerViewHolder.this, v, getAdapterPosition());
                    }
                }
            });
            itemView.setOnLongClickListener(new View.OnLongClickListener() {
                @Override
                public boolean onLongClick(View v) {
                    if (null != mItemLongClickListener) {
                        mItemLongClickListener.onItemLongClick(MyRecyclerAdapter.RecyclerViewHolder.this, v, getAdapterPosition());
                        return true;
                    }
                    return false;
                }
            });
        }

    }

    public void setCurPosition(int position) {
        this.curPosition = position;
    }

    public int getCurPosition() {
        return this.curPosition;
    }
}
