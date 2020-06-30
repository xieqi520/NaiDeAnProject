package com.sandy.guoguo.babylib.adapter.recycler;

public interface IAdapter<T> {

    void onUpdate(BaseAdapterHelper helper, T item, int position);

    int getLayoutResId(T item, int position);
}
