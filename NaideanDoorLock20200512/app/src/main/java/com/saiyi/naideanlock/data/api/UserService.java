package com.saiyi.naideanlock.data.api;

import com.saiyi.naideanlock.bean.MdlHttpRespList;
import com.saiyi.naideanlock.bean.MdlVersion;
import com.saiyi.naideanlock.bean.UserInfo;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;
import com.sandy.guoguo.babylib.entity.MdlUser;

import java.util.Map;

import io.reactivex.Observable;
import okhttp3.MultipartBody;
import okhttp3.RequestBody;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.Multipart;
import retrofit2.http.POST;
import retrofit2.http.Part;
import retrofit2.http.Path;
import retrofit2.http.QueryMap;

public interface UserService {
    //@GET("latch-web/latch_app/queryUser")
    //@POST("app/user/selectUserByPhone")
    //Observable<MdlBaseHttpResp<MdlUser>> getUserInfo(@Body RequestBody body,@Path("token") String token);

    @GET("latch-web/latch_app/findedition")
    Observable<MdlBaseHttpResp<MdlHttpRespList<MdlVersion>>> getVersionInfo(@QueryMap Map<String, Object> map);


    @Multipart
    @POST("other/file/upload/image")
    Observable<MdlBaseHttpResp<String>> uploadHeadPic(@Part MultipartBody.Part file);

    @POST("app/user/updateUserInfo/{token}")
    Observable<MdlBaseHttpResp> updateUserInfo(@Body RequestBody body,@Path("token") String token);

    @POST("app/user/selectUserByPhone/{token}")
    Observable<MdlBaseHttpResp<UserInfo>> getUserInfo(@Body RequestBody body, @Path("token") String token);


    //@POST("latch-web/latch_app/checkNumber")
    @POST("app/user/checkUserAccount/{token}")
    Observable<MdlBaseHttpResp> changeBindCheckPhone(@Body RequestBody body, @Path("token") String token);

    @POST("app/user/updatePhone/{token}")
    Observable<MdlBaseHttpResp> changeBindUpdatePhone(@Body RequestBody body, @Path("token") String token);

    @POST("app/user/autoLogin/{token}")
    Observable<MdlBaseHttpResp> autoLogin(@Body RequestBody body, @Path("token") String token);
}
