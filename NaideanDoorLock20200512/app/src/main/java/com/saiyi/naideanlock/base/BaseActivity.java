package com.saiyi.naideanlock.base;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;

import com.saiyi.naideanlock.application.MyApplication;


public abstract class BaseActivity extends AppCompatActivity {

    //添加到活动管理集合中
    {
        MyApplication.getInstance().addActivityToList(this);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(getContentView());
        onCreateView(savedInstanceState);
        initView();
        topBarSet();
        topBarListener();
        initData();
        setListener();
    }

    //注入布局
    protected abstract int getContentView();

    protected abstract void onCreateView(Bundle savedInstanceState);

    //初始化视图
    protected abstract void initView();

    //初始化数据
    protected abstract void initData();

    //初始化顶部导航栏
    protected abstract void topBarSet();

    //给顶部导航栏设置监听
    protected abstract void topBarListener();

    //设置监听
    protected abstract void setListener();


    /**
     * 启动另一个Activity
     *
     * @param activityCl 需要启动的Activity
     */
    public void startActivity(Class<?> activityCl) {
        startActivity(new Intent(this, activityCl));
    }


}
