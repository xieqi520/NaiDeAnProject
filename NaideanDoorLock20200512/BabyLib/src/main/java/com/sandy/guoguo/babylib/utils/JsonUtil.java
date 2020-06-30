package com.sandy.guoguo.babylib.utils;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import java.lang.reflect.Type;

/**
 * Created by Liu on 2018/3/12.
 */

public class JsonUtil {
    private static Gson gson = new Gson();

    public static<T> T fromJson(String resp, Type type){
        try{

            T model = gson.fromJson(resp, type);
            return model;
        }catch (Exception e){
            e.printStackTrace();
            LogAndToastUtil.log("json parse error");
            return null;
        }

    }
    public static<T> T fromJson(JsonObject obj, Type type){
        try{

            T model = gson.fromJson(obj, type);
            return model;
        }catch (Exception e){
            e.printStackTrace();
            LogAndToastUtil.log("json parse error");
            return null;
        }

    }

    public static<T> T fromJson(String resp, Class<T> cls) {
        try{
            T model = gson.fromJson(resp, cls);
            return model;
        }catch (Exception e){
            e.printStackTrace();
            LogAndToastUtil.log("json parse error");
            return null;
        }
    }
    public static<T> T fromJson(JsonObject obj, Class<T> cls) {
        try{
            T model = gson.fromJson(obj, cls);
            return model;
        }catch (Exception e){
            e.printStackTrace();
            LogAndToastUtil.log("json parse error");
            return null;
        }
    }

    public static String createJson(Object object){
        return gson.toJson(object);
    }
}
