package com.saiyi.naideanlock.new_ui.user;

import android.content.Intent;
import android.view.View;

import com.saiyi.naideanlock.R;
import com.saiyi.naideanlock.config.Config;
import com.saiyi.naideanlock.new_ui.basis.NewLoginActivity;
import com.saiyi.naideanlock.utils.SharedPreferencesUtils;
import com.sandy.guoguo.babylib.ui.BaseActivity;

public class ProtocolActivity extends BaseActivity {

    @Override
    protected int getLayoutResId() {
        return R.layout.activity_protocol;
    }

    @Override
    protected void initViewAndControl() {
        findView(R.id.btn_close).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                boolean isLogin = SharedPreferencesUtils.getInstance().getSPFBoolean(Config.IS_LOGIN);
                if(!isLogin){
                    Intent intent = new Intent(ProtocolActivity.this, NewLoginActivity.class);
                    startActivity(intent);
                }
                finish();
            }
        });
    }

    @Override
    protected int getTitleResId() {
        return R.string.about_protocol;
    }

}
