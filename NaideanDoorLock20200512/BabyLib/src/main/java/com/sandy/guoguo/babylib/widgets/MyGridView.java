package com.sandy.guoguo.babylib.widgets;

import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.util.AttributeSet;
import android.widget.GridView;

public class MyGridView extends GridView {
	public MyGridView(Context context, AttributeSet attrs) {
		super(context, attrs);
		//去掉选中时默认显示的效果
		this.setSelector(new ColorDrawable(Color.TRANSPARENT));
	}

	public MyGridView(Context context) {
		super(context);
		//去掉选中时默认显示的效果
		this.setSelector(new ColorDrawable(Color.TRANSPARENT));
	}

	public MyGridView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		//去掉选中时默认显示的效果
		this.setSelector(new ColorDrawable(Color.TRANSPARENT));
	}
//
//	@Override
//	public void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
//		int expandSpec = MeasureSpec.makeMeasureSpec(Integer.MAX_VALUE >> 2, MeasureSpec.AT_MOST);
//		super.onMeasure(widthMeasureSpec, expandSpec);
//	}
}