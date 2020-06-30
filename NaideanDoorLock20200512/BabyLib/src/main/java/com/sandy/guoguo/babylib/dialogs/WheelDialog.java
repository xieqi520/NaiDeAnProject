package com.sandy.guoguo.babylib.dialogs;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v7.app.AlertDialog;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.TextView;

import com.sandy.guoguo.babylib.R;
import com.sandy.guoguo.babylib.utils.Utility;
import com.sandy.guoguo.babylib.widgets.wheel.ArrayWheelAdapter;
import com.sandy.guoguo.babylib.widgets.wheel.WheelView;
import com.sandy.guoguo.babylib.widgets.wheel.listens.OnWheelChangedListener;
import com.sandy.guoguo.babylib.widgets.wheel.listens.OnWheelScrollListener;

public class WheelDialog extends AlertDialog implements View.OnClickListener {
    private Context context;
    private ClickListener listener;
    private String[] wheelData;
    private String unit;
    private WheelView wheelView;

    public WheelDialog(@NonNull Context context, String[] wheelData, String unit, ClickListener listener) {
        super(context, R.style.dialog);
        this.context = context;
        this.listener = listener;
        this.wheelData = wheelData;
        this.unit = unit;
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Window window = this.getWindow();
        window.setGravity(Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL);
        window.getDecorView().setPadding(20, 0, 20, 0);
        window.setLayout(WindowManager.LayoutParams.MATCH_PARENT, WindowManager.LayoutParams.WRAP_CONTENT);

        setContentView(R.layout.dialog_wheel);

        initViewAndControl();
    }


    private void initViewAndControl() {
        findViewById(R.id.tvComplete).setOnClickListener(this);

        if (wheelData == null) {
            throw new IllegalArgumentException("------滑动非法参数异常-----");
        }

        TextView tvUnit = findViewById(R.id.tvUnit);
        if (TextUtils.isEmpty(unit)) {
            tvUnit.setVisibility(View.GONE);
        } else {
            tvUnit.setText(unit);
        }

        wheelView = findViewById(R.id.wheelView);

        DisplayMetrics dm = Utility.getDisplayScreenSize((Activity) context);
        wheelView.setHeight(dm.heightPixels / 3);
        initWheel(wheelView, wheelData);
    }


    private void initWheel(WheelView wheelView, String[] data) {
        ArrayWheelAdapter<String> itemAdapter = new ArrayWheelAdapter<>(context, data);
        itemAdapter.setItemResource(R.layout.wheel_text_item);//设置圈里面View的视图
        wheelView.setViewAdapter(itemAdapter);

        wheelView.addChangingListener(new OnWheelChangedListener() {

            @Override
            public void onChanged(WheelView wheel, int oldValue, int newValue) {
                wheel.invalidateWheel(true);
            }
        });

        wheelView.addScrollingListener(new OnWheelScrollListener() {

            @Override
            public void onScrollingStarted(WheelView wheel) {
            }


            @Override
            public void onScrollingFinished(WheelView wheel) {
            }
        });

        wheelView.setCyclic(false);
        wheelView.setCurrentItem(0);
    }

    @Override
    public void onClick(View v) {
        if (listener == null) {
            return;
        }
        int i = v.getId();
        if (i == R.id.tvComplete) {
            listener.clickConfirm(wheelView.getCurrentItem());

        }
        dismiss();
    }

    public interface ClickListener {
        void clickConfirm(int index);
    }
}