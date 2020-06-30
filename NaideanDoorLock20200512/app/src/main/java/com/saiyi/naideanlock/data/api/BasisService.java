package com.saiyi.naideanlock.data.api;


import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.entity.MdlUser;

import java.util.Map;

import io.reactivex.Observable;
import okhttp3.RequestBody;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.POST;
import retrofit2.http.Path;
import retrofit2.http.QueryMap;

/**
 * Created by Administrator on 2018/6/11.
 */

public interface BasisService {

    //@GET("latch-web/latch_app/register")
    @POST("app/user/regUser")
    Observable<MdlBaseHttpResp> register(@Body RequestBody body);

    //@GET("latch-web/latch_app/getIdentify")
    @POST("other/sms/sendSmsCode")
    Observable<MdlBaseHttpResp> getCheckCode(@Body RequestBody body);

    //@GET("latch-web/latch_app/login")
    @POST("app/user/login")
    Observable<MdlBaseHttpResp<MdlUser>> login(@Body RequestBody body);

    @POST("app/user/login")
    Observable<MdlBaseHttpResp<MdlUser>> login1(@Body RequestBody body);

    //@POST("latch-web/latch_app/findBack")
    @POST("app/user/updatePasswordByCode")
    Observable<MdlBaseHttpResp> findPwd(@Body RequestBody body);

    @POST("app/user/checkLogin/{token}")
    Observable<MdlBaseHttpResp> checkLogin(@Body RequestBody body, @Path("token") String token);

}
