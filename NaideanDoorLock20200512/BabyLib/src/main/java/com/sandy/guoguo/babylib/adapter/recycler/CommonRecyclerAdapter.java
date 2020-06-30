package com.sandy.guoguo.babylib.adapter.recycler;

import android.content.Context;
import android.support.v7.util.DiffUtil;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.view.ViewGroup;

import java.util.ArrayList;
import java.util.List;


public abstract class CommonRecyclerAdapter<T> extends RecyclerView.Adapter implements IAdapter<T>, IData<T> {

    private final Context mContext;
    private final int mLayoutResId;
    private final List<T> mData;

    private OnItemClickListener mItemClickListener;
    private OnItemLongClickListener mItemLongClickListener;

    private int curPosition = 0;

    public CommonRecyclerAdapter(Context context, int layoutResId) {
        this(context, layoutResId, null);
    }

    public CommonRecyclerAdapter(Context context, int layoutResId, List<T> data) {
        this.mData = data == null ? new ArrayList<T>() : new ArrayList<>(data);
        this.mContext = context;
        this.mLayoutResId = layoutResId;
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

    @Override
    public List<T> getData() {
        return mData;
    }

    @Override
    public void add(int index, T elem) {
        mData.add(index, elem);
        notifyDataSetChanged();
        /*
        if (getItemCount() == 1 || index == 0) {
            notifyDataSetChanged();
        } else {
            notifyItemInserted(index);
        }
        */
    }

    @Override
    public void add(T elem) {
        mData.add(elem);
        notifyDataSetChanged();
        /*
        if (getItemCount() == 1) {
            notifyDataSetChanged();
        } else {
            notifyItemInserted(mData.size());
        }
        */
    }

    @Override
    public void addAll(List<T> elem) {
        mData.addAll(elem);
        notifyDataSetChanged();
        /*
        if (getItemCount() == 1) {
            notifyDataSetChanged();
            notifyDataSetChanged();
        } else {
            notifyItemRangeInserted(getItemCount(), elem.size());
            notifyItemRangeChanged(getItemCount() + elem.size(), getItemCount() - elem.size());
        }
        */
    }

    @Override
    public void addAll(int index, List<T> elem) {
        mData.addAll(index, elem);
        notifyDataSetChanged();
        /*
        if (getItemCount() == 1 || index == 0) {
            notifyDataSetChanged();
        } else {
            notifyItemRangeInserted(index, elem.size());
            notifyItemRangeChanged(index + elem.size(), getItemCount() - elem.size());
        }
        */
    }

    @Override
    public void set(T oldElem, T newElem) {
        set(mData.indexOf(oldElem), newElem);
    }

    @Override
    public void set(int index, T elem) {
        mData.set(index, elem);
        notifyItemChanged(index);
    }

    @Override
    public void remove(T elem) {
        final int position = mData.indexOf(elem);
        mData.remove(elem);
        notifyItemRemoved(position);
    }

    @Override
    public void remove(int index) {
        mData.remove(index);
        notifyItemRemoved(index);
    }

    /**
     * @param elem
     * @see {@link #replaceAll(List, DiffUtil.Callback)}
     */

    @Override
    public void replaceAll(List<T> elem) {
        if (elem == null || elem.size() == 0) {
            return;
        }
        mData.clear();
        mData.addAll(elem);
        notifyDataSetChanged();
    }

    @Override
    public boolean contains(T elem) {
        return mData.contains(elem);
    }

    @Override
    public void clear() {
        mData.clear();
        notifyDataSetChanged();
    }

    public void replaceAll(List<T> elem, DiffUtil.Callback callback) {
        mData.clear();
        mData.addAll(elem);
        DiffUtil.calculateDiff(callback, true).dispatchUpdatesTo(this);
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

    private final class RecyclerViewHolder extends RecyclerView.ViewHolder {
        BaseAdapterHelper mAdapterHelper;

        public RecyclerViewHolder(View itemView, BaseAdapterHelper adapterHelper) {
            super(itemView);
            this.mAdapterHelper = adapterHelper;

            itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (null != mItemClickListener) {
                        mItemClickListener.onItemClick(RecyclerViewHolder.this, v, getAdapterPosition());
                    }
                }
            });
            itemView.setOnLongClickListener(new View.OnLongClickListener() {
                @Override
                public boolean onLongClick(View v) {
                    if (null != mItemLongClickListener) {
                        mItemLongClickListener.onItemLongClick(RecyclerViewHolder.this, v, getAdapterPosition());
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
