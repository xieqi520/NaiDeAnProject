package com.sandy.guoguo.babylib.utils;

public class ScanUtil {
    /*
    public static final int SCAN_QR_CODE_REQ = 0XA001;
    public static final String QR_CODE_TYPE = "type";
    public static final String QR_CODE_CONTENT = "content";
    private Object context;

    @EnumQrCode.QrCodeType
    private String target;

    public void scan(Object object, @EnumQrCode.QrCodeType String target) {
        this.context = object;
        this.target = target;
        PermissionUtil.checkPermission(object, MyPermissionConstant.CAMERA, Manifest.permission.CAMERA);
    }

    public void scan(Object object) {
        scan(object, EnumQrCode.QR_TYPE_NO_LIMIT);
    }

    public void go2Capture() {
        Intent intent = new Intent();
        if (context instanceof Fragment) {
            Fragment fragment = (Fragment) context;
            intent.setClass(fragment.getContext(), CaptureActivity.class);
            fragment.startActivityForResult(intent, SCAN_QR_CODE_REQ);
        } else if (context instanceof Activity) {
            Activity activity = (Activity) context;
            intent.setClass(activity, CaptureActivity.class);
            activity.startActivityForResult(intent, SCAN_QR_CODE_REQ);
        } else {
            throw new IllegalArgumentException("非法上下文对象获取权限信息");
        }
    }



    public HashMap<String, String> handleResult2Map(Intent data) {
        if (data == null) {
            return null;
        }
        Bundle bundle = data.getExtras();
        if (bundle == null) {
            return null;
        }
        if (bundle.getInt(CodeUtils.RESULT_TYPE) == CodeUtils.RESULT_SUCCESS) {
            String result = bundle.getString(CodeUtils.RESULT_STRING);
            LogAndToastUtil.log("二维码解析：%s", result);
            return parseQrCode2Map(result);
        } else if (bundle.getInt(CodeUtils.RESULT_TYPE) == CodeUtils.RESULT_FAILED) {
            LogAndToastUtil.log("二维码解析失败");
            return null;
        }
        return null;
    }

    private HashMap<String, String> parseQrCode2Map(String result) {
        HashMap<String, String> resMap = JsonUtil.fromJson(result, new TypeToken<HashMap<String, String>>() {
        }.getType());
        if (resMap == null) {
            LogAndToastUtil.toast(R.string.qr_code_not_match);
            return null;
        }
        final String content = resMap.get(QR_CODE_CONTENT);
        final String type = resMap.get(QR_CODE_TYPE);
        if (TextUtils.isEmpty(content) || TextUtils.isEmpty(type) || (!EnumQrCode.QR_TYPE_NO_LIMIT.equals(target) && !target.equals(type))) {
            LogAndToastUtil.toast(R.string.qr_code_not_match);
            return null;
        }
        return resMap;
    }
*/
}
