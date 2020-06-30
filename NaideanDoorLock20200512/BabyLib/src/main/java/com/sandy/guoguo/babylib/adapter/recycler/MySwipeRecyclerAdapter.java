package com.sandy.guoguo.babylib.adapter.recycler;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;

import com.loopeer.itemtouchhelperextension.Extension;
import com.loopeer.itemtouchhelperextension.ItemTouchHelperExtension;

import java.util.List;

/**
 * https://github.com/liup1211/itemtouchhelper-extension
 */
public abstract class MySwipeRecyclerAdapter<T> extends RecyclerView.Adapter implements IAdapter<T> {

    private final Context mContext;
    private final int mLayoutResId;
    private List<T> mData;

    private OnItemClickListener mItemClickListener;
    private OnItemLongClickListener mItemLongClickListener;
    private ItemTouchHelperExtension mItemTouchHelperExtension;

    private int curPosition = 0;

    private int contentResId;
    private int actionResId;

    /***
     * @param context
     * @param layoutResId
     * @param contentResId 滑动的item不滑动部分最外层id
     * @param actionResId 动画按钮最外层的id
     * @param data
     */
    public MySwipeRecyclerAdapter(Context context, int layoutResId, int contentResId,int actionResId, List<T> data) {
        this.mData = data;
        if (data == null) {
            throw new IllegalArgumentException("非法参数，此处的data只能是引用！！！");
        }
        this.contentResId = contentResId;
        this.actionResId = actionResId;
        this.mContext = context;
        this.mLayoutResId = layoutResId;
    }

    public void setData(List<T> data) {
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
//        ((RecyclerViewHolder)holder).bind();
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

    public void setItemTouchHelperExtension(ItemTouchHelperExtension itemTouchHelperExtension) {
        mItemTouchHelperExtension = itemTouchHelperExtension;
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


    public final class RecyclerViewHolder extends RecyclerView.ViewHolder implements Extension {
        public BaseAdapterHelper mAdapterHelper;
        public View contentView;

        public RecyclerViewHolder(View itemView, BaseAdapterHelper adapterHelper) {
            super(itemView);
            this.mAdapterHelper = adapterHelper;
            contentView = itemView.findViewById(contentResId);

            contentView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (null != mItemClickListener) {
                        mItemClickListener.onItemClick(MySwipeRecyclerAdapter.RecyclerViewHolder.this, v, getAdapterPosition());
                    }
                }
            });
            contentView.setOnLongClickListener(new View.OnLongClickListener() {
                @Override
                public boolean onLongClick(View v) {
                    if (null != mItemLongClickListener) {
                        mItemLongClickListener.onItemLongClick(MySwipeRecyclerAdapter.RecyclerViewHolder.this, v, getAdapterPosition());
                        return true;
                    }
                    return false;
                }
            });

            itemView.setOnTouchListener(new View.OnTouchListener() {
                @Override
                public boolean onTouch(View v, MotionEvent event) {
                    if (event.getAction() == MotionEvent.ACTION_DOWN) {
                        mItemTouchHelperExtension.startDrag(RecyclerViewHolder.this);
                    }
                    return true;
                }
            });
        }



        @Override
        public float getActionWidth() {
            return mAdapterHelper.getView(actionResId).getWidth();
        }
    }

    public void move(int from, int to) {
        if (from < 1) from = 1;
        if (to < 1) to = 1;
        T t = mData.remove(from);
        mData.add(to > from ? to - 1 : to, t);
        notifyItemMoved(from, to);
    }

    public void setCurPosition(int position) {
        this.curPosition = position;
    }

    public int getCurPosition() {
        return this.curPosition;
    }
}
