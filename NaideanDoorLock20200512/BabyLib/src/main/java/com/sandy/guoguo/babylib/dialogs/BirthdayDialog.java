package com.sandy.guoguo.babylib.dialogs;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v7.app.AlertDialog;
import android.util.DisplayMetrics;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;

import com.sandy.guoguo.babylib.R;
import com.sandy.guoguo.babylib.utils.Utility;
import com.sandy.guoguo.babylib.widgets.wheel.ArrayWheelAdapter;
import com.sandy.guoguo.babylib.widgets.wheel.WheelView;
import com.sandy.guoguo.babylib.widgets.wheel.listens.OnWheelChangedListener;
import com.sandy.guoguo.babylib.widgets.wheel.listens.OnWheelScrollListener;

import java.util.Calendar;


public class BirthdayDialog extends AlertDialog implements View.OnClickListener {
    private Context context;
    private ClickListener listener;
    private WheelView viewYear;
    private WheelView viewMonth;
    private WheelView viewDay;
    private ArrayWheelAdapter<String> dayAdapter;

    public BirthdayDialog(@NonNull Activity context, ClickListener listener) {
        super(context, R.style.dialog);
        this.context = context;
        this.listener = listener;
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Window window = this.getWindow();
        window.setGravity(Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL);
        window.getDecorView().setPadding(20, 0, 20, 0);
        window.setLayout(WindowManager.LayoutParams.MATCH_PARENT, WindowManager.LayoutParams.WRAP_CONTENT);


        setContentView(R.layout.dialog_birthday);

        initViewAndControl();
    }


    private void initViewAndControl() {
        findViewById(R.id.tvComplete).setOnClickListener(this);

        viewYear = findViewById(R.id.wheelViewYear);
        viewMonth = findViewById(R.id.wheelViewMonth);
        viewDay = findViewById(R.id.wheelViewDay);

        DisplayMetrics dm = Utility.getDisplayScreenSize((Activity) context);
        viewYear.setHeight(dm.heightPixels / 3);
        viewMonth.setHeight(dm.heightPixels / 3);
        viewDay.setHeight(dm.heightPixels / 3);

        initWheel();
    }


    private void initWheel() {
        Calendar calendar = Calendar.getInstance();
        int currentYear = calendar.get(Calendar.YEAR);

        int len = currentYear - 1900 + 1;
        final String[] yearData = new String[len];

        for (int i = 0; i < len; i++) {
            yearData[i] = String.valueOf(i + 1900);
        }

        ArrayWheelAdapter<String> yearAdapter = new ArrayWheelAdapter<>(context, yearData);
        yearAdapter.setItemResource(R.layout.wheel_text_item);//设置圈里面View的视图
        viewYear.setViewAdapter(yearAdapter);


        len = 12;
        final String[] monthData = new String[len];
        for (int i = 0; i < len; i++) {
            monthData[i] = String.valueOf(i + 1);
        }


        ArrayWheelAdapter<String> monthAdapter = new ArrayWheelAdapter<>(context, monthData);
        monthAdapter.setItemResource(R.layout.wheel_text_item);//设置圈里面View的视图
        viewMonth.setViewAdapter(monthAdapter);

        len = calendar.getActualMaximum(Calendar.DAY_OF_MONTH);
        final String[] dayData = new String[len];
        for (int i = 0; i < len; i++) {
            dayData[i] = String.valueOf(i + 1);
        }

        ArrayWheelAdapter<String> dayAdapter = new ArrayWheelAdapter<>(context, dayData);
        dayAdapter.setItemResource(R.layout.wheel_text_item);//设置圈里面View的视图
        viewDay.setViewAdapter(dayAdapter);

        viewYear.addChangingListener(changedListener);
        viewMonth.addChangingListener(changedListener);
        viewDay.addChangingListener(changedListener);

        viewYear.addScrollingListener(scrollListener);
        viewMonth.addScrollingListener(scrollListener);
        viewDay.addScrollingListener(scrollListener);

        viewYear.setCyclic(false);
        viewYear.setCurrentItem(currentYear - 1900);


        viewMonth.setCyclic(false);
        viewMonth.setCurrentItem(calendar.get(Calendar.MONTH));

        viewDay.setCyclic(false);
        viewDay.setCurrentItem(calendar.get(Calendar.DAY_OF_MONTH) - 1);
    }

    private OnWheelScrollListener scrollListener = new OnWheelScrollListener() {
        @Override
        public void onScrollingStarted(WheelView wheel) {

        }

        @Override
        public void onScrollingFinished(WheelView wheel) {
            int i = wheel.getId();
            if (i == R.id.wheelViewYear || i == R.id.wheelViewMonth || i == R.id.wheelViewDay) {
                resetDay();

            }
        }
    };

    private void resetDay() {
        int yearPosition = viewYear.getCurrentItem();
        int monthPosition = viewMonth.getCurrentItem();

        final int[] days = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
        if (monthPosition == 1) {//2月份
            int realYear = 1900 + yearPosition;
            if (realYear % 100 == 0) {
                if (realYear % 400 == 0) {
                    days[1] = 29;
                }
            } else {
                if (realYear % 4 == 0) {
                    days[1] = 29;
                }
            }
        }

        int len = days[monthPosition];
        final String[] dayData = new String[len];
        for (int i = 0; i < len; i++) {
            dayData[i] = String.valueOf(i + 1);
        }

        dayAdapter = new ArrayWheelAdapter<>(context, dayData);
        dayAdapter.setItemResource(R.layout.wheel_text_item);//设置圈里面View的视图
        viewDay.setViewAdapter(dayAdapter);

        viewDay.setCyclic(false);
//        viewDay.setCurrentItem(3);
    }

    private OnWheelChangedListener changedListener = new OnWheelChangedListener() {
        @Override
        public void onChanged(WheelView wheel, int oldValue, int newValue) {
            wheel.invalidateWheel(true);
        }
    };

    @Override
    public void onClick(View v) {
        if (listener == null) {
            return;
        }
        int i = v.getId();
        if (i == R.id.tvComplete) {
            listener.clickConfirm(viewYear.getCurrentItem() + 1900, viewMonth.getCurrentItem() + 1, viewDay.getCurrentItem() + 1);

        }
        dismiss();
    }

    public interface ClickListener {
        void clickConfirm(int year, int month, int day);
    }
}
