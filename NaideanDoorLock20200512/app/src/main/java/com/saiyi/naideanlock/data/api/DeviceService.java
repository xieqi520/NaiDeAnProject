package com.saiyi.naideanlock.data.api;


import com.saiyi.naideanlock.bean.AuthInfo;
import com.saiyi.naideanlock.bean.MdlDevice;
import com.saiyi.naideanlock.bean.MdlDeviceTest;
import com.saiyi.naideanlock.bean.MdlHttpRespList;
import com.saiyi.naideanlock.bean.MdlPhoto;
import com.saiyi.naideanlock.bean.MdlUnlockRecord;
import com.sandy.guoguo.babylib.entity.MdlBaseHttpResp;

import java.util.List;
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

public interface DeviceService {

    /**控制面板-查询设备列表*/
//    @GET("latch-web/latch_app/getDeviceAll")
    @POST("app/device/getAll/{token}")
    Observable<MdlBaseHttpResp<List<MdlDevice>>> getAllDeviceByType(@Body RequestBody body, @Path("token") String token);

    /**控制面板-修改设备名称*/
//    @GET("latch-web/latch_app/updateLockName")
    @POST("app/device/updateDeviceName/{token}")
    Observable<MdlBaseHttpResp> updateDeviceName(@Body RequestBody body, @Path("token") String token);

    /**控制面板-删除设备*/
//    @GET("latch-web/latch_app/cancelBinding")
    @POST("app/binding/deleteBinding/{token}")
    Observable<MdlBaseHttpResp> delDeviceBinding(@Body RequestBody body, @Path("token") String token);

    @POST("app/device/deleteDevice/{token}")
    Observable<MdlBaseHttpResp> delDevice(@Body RequestBody body, @Path("token") String token);

    /**添加蓝牙开锁记录*/
//    @GET("latch-web/latch_app/insertRecord")
    @POST("app/log/addBleLockLog/{token}")
    Observable<MdlBaseHttpResp> addUnlockRecord(@Body RequestBody body, @Path("token") String token);

    /**查询照片相关-列表*/
//    @GET("latch-web/latch_app/findPic")
    @POST("app/log/selectPics")
    Observable<MdlBaseHttpResp<MdlHttpRespList<MdlPhoto>>> getPhotoList(@QueryMap Map<String, Object> map);

    /**无人模式报警*/
//    @GET("latch-web/latch_app/setNoMode")
    @POST("app/device/updateAlarm")
    Observable<MdlBaseHttpResp> setUnmannedMode(@QueryMap Map<String, Object> map);
    /**防撬报警*/
//    @GET("latch-web/latch_app/setPryMode")
    @POST("app/device/updateAlarm")
    Observable<MdlBaseHttpResp> setTamperAlert(@QueryMap Map<String, Object> map);
    /**低电提醒*/
//    @GET("latch-web/latch_app/setLowMode")
    @POST("app/device/updateAlarm")
    Observable<MdlBaseHttpResp> setLowPower(@QueryMap Map<String, Object> map);

    @POST("app/device/updateAlarm/{token}")
    Observable<MdlBaseHttpResp> updateAlarm(@Body RequestBody body, @Path("token") String token);

    /**设置开锁密码*/
//    @GET("latch-web/latch_app/setPwd")
    @POST("app/device/updateOpenPwd/{token}")
    Observable<MdlBaseHttpResp> setUnlockPwd(@Body RequestBody body, @Path("token") String token);

    //@GET("latch-web/latch_app/bindingDevice")
    @POST("app/device/addDevice/{token}")
    Observable<MdlBaseHttpResp> bindDevice(@Body RequestBody body, @Path("token") String token);

    @POST("app/binding/addBinding/{token}")
    Observable<MdlBaseHttpResp> addBinding(@Body RequestBody body, @Path("token") String token);

    @POST("app/binding/updateBinding/{token}")
    Observable<MdlBaseHttpResp> updateBinding(@Body RequestBody body, @Path("token") String token);

    /**获取开锁记录*/
//    @GET("latch-web/latch_app/getRecord")
    @POST("app/log/selectLockLog/{token}")
    Observable<MdlBaseHttpResp<MdlHttpRespList<MdlUnlockRecord>>> getUnlockRecord(@Body RequestBody body, @Path("token") String token);

    /**删除开锁记录*/
//    @GET("latch-web/latch_app/deleteRecordAll")
    @POST("app/log/deleteLockLogAll/{token}")
    Observable<MdlBaseHttpResp> deleteAllUnlockRecord(@Body RequestBody body, @Path("token") String token);

    /**权限管理-列表*/
    //@GET("latch-web/latch_app/getAuthUsers")
    @POST("app/binding/selectAll/{token}")
    Observable<MdlBaseHttpResp<List<AuthInfo>>> getAuthManagerList(@Body RequestBody body, @Path("token") String token);

    /**权限管理-重命名*/
    @POST("app/binding/updateMomeName/{token}")
    Observable<MdlBaseHttpResp> renameAuthUser(@Body RequestBody body, @Path("token") String token);

    /**权限管理-删除保姆*/
    //@POST("latch-web/latch_app/deleteNurseRole")
    @POST("app/binding/updateMomeName/{token}")
    Observable<MdlBaseHttpResp> deleteNanny(@Body RequestBody map);

    /**权限管理-添加保姆*/
    @POST("latch-web/latch_app/addNurseRole")
    Observable<MdlBaseHttpResp> addNanny(@Body RequestBody map);
}
