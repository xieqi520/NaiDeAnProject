package com.sandy.guoguo.babylib.http;

import android.text.TextUtils;

import com.sandy.guoguo.babylib.constant.BabyHttpConstant;
import com.sandy.guoguo.babylib.utils.BaseSPUtil;

import java.io.IOException;

import okhttp3.Interceptor;
import okhttp3.Request;
import okhttp3.Response;

public class TokenInterceptor implements Interceptor {
    @Override
    public Response intercept(Chain chain) throws IOException {
        Request request = chain.request();
        Response response = chain.proceed(request);

        if (isTokenExpired(response) && !TextUtils.isEmpty(BaseSPUtil.getPwdFromSP())) {//根据和服务端的约定判断token过期
            //同步请求方式，获取最新的Token
            String newToken = getNewToken();
            //使用新的Token，创建新的请求
            Request newRequest = chain.request()
                    .newBuilder()
                    .header("token", newToken)
                    .header("Cookie", "JSESSIONID=" + newToken)
                    .build();
            //重新请求
            return chain.proceed(newRequest);
        }
        return response;
    }

    /**
     * 根据Response，判断Token是否失效
     *
     * @param response
     * @return
     */
    private boolean isTokenExpired(Response response) {
        return response.code() == BabyHttpConstant.R_TOKEN_EXPIRE;
    }

    private String getNewToken() throws IOException {
        return "";
    }

    /**
     * 同步请求方式，获取最新的Token
     *
     * @return

    private String getNewToken() throws IOException {
        // 通过一个特定的接口获取新的token，此处要用到同步的retrofit请求

        String account = TextUtils.isEmpty(SPUtil.getAccountFromSP()) ? SPUtil.getPhoneFromSP() : SPUtil.getAccountFromSP();

        Map<String, String> params = new HashMap<>();
        params.put("type", EnumGetLoginType.LOGIN_USE_PWD);
        params.put("password", SPUtil.getPwdFromSP());
        params.put("account", account);

        BasisService basisService = HttpManager.getInstance().getRetrofit().create(BasisService.class);
        Call<MdlBaseHttpResp<MdlUser>> call = basisService.getToken(HttpUtil.GenJsonParamRequestBody(params));
        MdlBaseHttpResp<MdlUser> resp = call.execute().body();

        MdlUser mdlUser = resp.data;
        BaseApp.ME.mdlUserInApp = mdlUser;

        LogAndToastUtil.log("------拦截器刷新token---:%s", mdlUser.toString());

        String token = mdlUser.token;
        SPUtil.saveToken2SP(token);

        return token;
    }
     */
}
