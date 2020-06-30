package com.sandy.guoguo.babylib.utils.eventbus;


/**
 * Created by Administrator on 2018/4/16.
 */

public class MdlEventBus {
    public int eventType;
    public Object data;

    public MdlEventBus(int eventType){
        this.eventType = eventType;
    }

    public MdlEventBus(int eventType, Object data) {
        this.eventType = eventType;
        this.data = data;
    }
}
