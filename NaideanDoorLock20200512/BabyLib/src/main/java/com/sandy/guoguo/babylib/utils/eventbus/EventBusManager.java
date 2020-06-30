package com.sandy.guoguo.babylib.utils.eventbus;

import org.greenrobot.eventbus.EventBus;

/**
 * Created by Administrator on 2018/4/16.
 */

public class EventBusManager {
    private static EventBus getEventBus(){
        return EventBus.getDefault();
    }

    public static void register(Object subscriber){
        getEventBus().register(subscriber);
    }
    public static void unregister(Object subscriber){
        getEventBus().unregister(subscriber);
    }

    public static void post(MdlEventBus eventBus){
        getEventBus().post(eventBus);
    }
}
