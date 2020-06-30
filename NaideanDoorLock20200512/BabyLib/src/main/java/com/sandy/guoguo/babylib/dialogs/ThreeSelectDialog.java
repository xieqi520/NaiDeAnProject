package com.sandy.guoguo.babylib.dialogs;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.util.DisplayMetrics;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.widget.TextView;

import com.sandy.guoguo.babylib.R;
import com.sandy.guoguo.babylib.utils.Utility;

public class ThreeSelectDialog extends AlertDialog implements View.OnClickListener{
    public static final int SELECT_1 = 0;
    public static final int SELECT_2 = 1;
    public static final int SELECT_3 = 2;

    private int type;

    private ClickListener listener;
    private String[] contents;
    private Context context;

    public ThreeSelectDialog(@NonNull Context context, int type, String[] contents, ClickListener listener) {
        super(context, R.style.dialog);
        this.context = context;
        this.listener = listener;
        this.contents = contents;
        this.type = type;
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Window window = this.getWindow();
        window.setGravity(Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL);
        window.getDecorView().setPadding(20, 0, 20, 0);
        DisplayMetrics dm = Utility.getDisplayScreenSize((Activity) context);
        window.setLayout(dm.widthPixels, dm.heightPixels / 3);

        setContentView(R.layout.dialog_3_select);

        initViewAndControl();
    }


    private void initViewAndControl() {
        TextView tvOne = findViewById(R.id.tvOne);
        TextView tvTwo = findViewById(R.id.tvTwo);
        TextView tvThree = findViewById(R.id.tvThree);
        if(contents != null && contents.length >= 3){
            tvOne.setText(contents[SELECT_1]);
            tvTwo.setText(contents[SELECT_2]);
            tvThree.setText(contents[SELECT_3]);
        }

        tvOne.setOnClickListener(this);
        tvTwo.setOnClickListener(this);
        tvThree.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        if(listener == null){
            return;
        }
        int i = v.getId();
        if (i == R.id.tvOne) {
            listener.clickPosition(type, SELECT_1);

        } else if (i == R.id.tvTwo) {
            listener.clickPosition(type, SELECT_2);
            dismiss();

        } else if (i == R.id.tvThree) {
            listener.clickPosition(type, SELECT_3);
            dismiss();
        }

    }

    public interface ClickListener{
        void clickPosition(int type, int index);
    }
}
