
package com.sandy.guoguo.babylib.adapter.recycler.swipe;

import android.graphics.Canvas;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.helper.ItemTouchHelper;

import com.loopeer.itemtouchhelperextension.ItemTouchHelperExtension;
import com.sandy.guoguo.babylib.adapter.recycler.MySwipeRecyclerAdapter;

public class ItemTouchHelperCallback extends ItemTouchHelperExtension.Callback {

    @Override
    public int getMovementFlags(RecyclerView recyclerView, RecyclerView.ViewHolder viewHolder) {
        //        return makeMovementFlags(ItemTouchHelper.UP|ItemTouchHelper.DOWN, ItemTouchHelper.START);
        return makeMovementFlags(0, ItemTouchHelper.START);
    }

    @Override
    public boolean onMove(RecyclerView recyclerView, RecyclerView.ViewHolder viewHolder, RecyclerView.ViewHolder target) {
//        MySwipeRecyclerAdapter adapter = (MySwipeRecyclerAdapter) recyclerView.getAdapter();
//        adapter.move(viewHolder.getAdapterPosition()-1, target.getAdapterPosition()-1);
        return false;
    }

    @Override
    public void onSwiped(RecyclerView.ViewHolder viewHolder, int direction) {

    }

    @Override
    public boolean isLongPressDragEnabled() {
        return true;
    }

    @Override
    public void onChildDraw(Canvas c, RecyclerView recyclerView, RecyclerView.ViewHolder viewHolder, float dX, float dY, int actionState, boolean isCurrentlyActive) {
//        if (dY != 0 && dX == 0)
//            super.onChildDraw(c, recyclerView, viewHolder, dX, dY, actionState, isCurrentlyActive);
        MySwipeRecyclerAdapter.RecyclerViewHolder holder = (MySwipeRecyclerAdapter.RecyclerViewHolder) viewHolder;

        holder.contentView.setTranslationX(dX);

    }
}
