package com.sandy.guoguo.babylib.http;

import com.sandy.guoguo.babylib.utils.JsonUtil;
import com.sandy.guoguo.babylib.utils.LogAndToastUtil;

import java.util.Map;

import okhttp3.MediaType;
import okhttp3.RequestBody;

public class HttpUtil {
    public static RequestBody GenJsonParamRequestBody(Map param) {

        String jsonObj = JsonUtil.createJson(param);

        LogAndToastUtil.log("jsonObj:%s", jsonObj);

        try {

            RequestBody requestBody = RequestBody.create(MediaType.parse("application/json"), jsonObj);
            return requestBody;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }

    }
}
