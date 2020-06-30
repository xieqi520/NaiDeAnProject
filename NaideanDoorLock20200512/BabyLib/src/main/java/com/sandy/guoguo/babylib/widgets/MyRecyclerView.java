package com.sandy.guoguo.babylib.widgets;

import android.content.Context;
import android.util.AttributeSet;

import com.jcodecraeer.xrecyclerview.XRecyclerView;
import com.sandy.guoguo.babylib.adapter.recycler.IData;

import java.util.List;

public class MyRecyclerView<T> extends XRecyclerView implements IData<T> {
    private List<T> data;
    private boolean isFillData = false;
    public MyRecyclerView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public void fillData(List<T> data){
        this.data = data;
        if(data == null){
            throw new IllegalArgumentException("MyRecyclerView-------非法参数，此处的data只能是引用！！！");
        }
        isFillData = true;
    }

    @Override
    public List<T> getData() {
        if(!isFillData){
            throw new IllegalArgumentException("MyRecyclerView-------还未填充数据！！！");
        }
        return data;
    }

    @Override
    public void add(T elem) {
        if(!isFillData){
            throw new IllegalArgumentException("MyRecyclerView-------还未填充数据！！！");
        }
        data.add(elem);
        notifyItemInserted(data, data.size() - 1);
    }

    @Override
    public void add(int index, T elem) {
        if(!isFillData){
            throw new IllegalArgumentException("MyRecyclerView-------还未填充数据！！！");
        }
        data.add(index,elem);
        notifyItemInserted(data, index);
    }

    @Override
    public void addAll(List<T> elem) {
        if(!isFillData){
            throw new IllegalArgumentException("MyRecyclerView-------还未填充数据！！！");
        }
        int len = data.size();
        data.addAll(len, elem);
        notifyItemInserted(data, len);
    }

    @Override
    public void addAll(int index, List<T> elem) {
        if(!isFillData){
            throw new IllegalArgumentException("MyRecyclerView-------还未填充数据！！！");
        }
        data.addAll(index, elem);
        notifyItemInserted(data, index);
    }

    @Override
    public void set(T oldElem, T newElem) {
        if(!isFillData){
            throw new IllegalArgumentException("MyRecyclerView-------还未填充数据！！！");
        }
        set(data.indexOf(oldElem), newElem);
    }

    @Override
    public void set(int index, T elem) {
        if(!isFillData){
            throw new IllegalArgumentException("MyRecyclerView-------还未填充数据！！！");
        }
        data.set(index, elem);
        notifyItemChanged(index);
    }

    @Override
    public void remove(T elem) {
        if(!isFillData){
            throw new IllegalArgumentException("MyRecyclerView-------还未填充数据！！！");
        }
        remove(data.indexOf(elem));
    }

    @Override
    public void remove(int index) {
        if(!isFillData){
            throw new IllegalArgumentException("MyRecyclerView-------还未填充数据！！！");
        }
        data.remove(index);
        notifyItemRemoved(data, index);
    }

    @Override
    public void replaceAll(List<T> elem) {
        if(!isFillData){
            throw new IllegalArgumentException("MyRecyclerView-------还未填充数据！！！");
        }
        if (elem == null || elem.size() == 0) {
            return;
        }
        data.clear();
        data.addAll(elem);
        getAdapter().notifyDataSetChanged();
    }

    @Override
    public boolean contains(T elem) {
        if(!isFillData){
            throw new IllegalArgumentException("MyRecyclerView-------还未填充数据！！！");
        }
        return data.contains(elem);
    }

    @Override
    public void clear() {
        if(!isFillData){
            throw new IllegalArgumentException("MyRecyclerView-------还未填充数据！！！");
        }
        data.clear();
        getAdapter().notifyDataSetChanged();
    }
}
