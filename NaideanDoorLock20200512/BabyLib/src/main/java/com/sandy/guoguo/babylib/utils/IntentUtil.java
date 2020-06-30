package com.sandy.guoguo.babylib.utils;

import android.content.Intent;
import android.net.Uri;
import android.provider.MediaStore;
import android.text.TextUtils;

import java.io.File;

public class IntentUtil {
    public static Intent getIntentOpenBrowser(String url) {
        if (TextUtils.isEmpty(url)) {
            return null;
        }
        Intent intent;
        (
                intent = new Intent())
                .setAction("android.intent.action.VIEW");
        Uri content_url = Uri.parse(url);
        intent.setData(content_url);
        return intent;
    }

    public static Intent getIntentSelectLocalImage() {
        return new Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
    }

    public static Intent getIntentTakePhoto(File saveFile) {
        if (saveFile == null) {
            return null;
        }
        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
//        intent = MyFileProviderUtil.fitAPI24(intent);
//        Uri uri = MyFileProviderUtil.getUriForFile(BaseApp.ME, saveFile);
//        intent.putExtra(MediaStore.EXTRA_OUTPUT, uri);
        return intent;
    }

    public static Intent getIntentCallPhone(String phoneNumber) {
        return new Intent("android.intent.action.DIAL", Uri.parse("tel:" + phoneNumber));
    }
}
