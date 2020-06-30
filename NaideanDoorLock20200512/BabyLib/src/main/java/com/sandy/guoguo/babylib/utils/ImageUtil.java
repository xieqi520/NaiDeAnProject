package com.sandy.guoguo.babylib.utils;

import android.app.Activity;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.PixelFormat;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.provider.MediaStore;
import android.support.v4.app.Fragment;

import com.sandy.guoguo.babylib.R;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;

import me.iwf.photopicker.utils.MyFileProviderUtil;

public class ImageUtil {
    private static String crop(Object context, Uri uri, int reqCode, int aspectX, int aspectY, int outputX, int outputY) {
        Intent intent = new Intent("com.android.camera.action.CROP");
        intent.setDataAndType(uri, "image/*");
        intent = MyFileProviderUtil.fitAPI24(intent);
        intent.putExtra("crop", "true");
        // 裁剪框的比例，1：1
        intent.putExtra("aspectX", aspectX);
        intent.putExtra("aspectY", aspectY);
        // 裁剪后输出图片的尺寸大小
        intent.putExtra("outputX", outputX);
        intent.putExtra("outputY", outputY);
        intent.putExtra("outputFormat", Bitmap.CompressFormat.JPEG.toString());// 图片格式
        intent.putExtra("noFaceDetection", true);// 取消人脸识别
        intent.putExtra("return-data", false);


        String path = Utility.getPhotoPath();
        //这里千万不能用MyFileProviderUtil.getUriForFile(context, path);
//        Uri targetUri = MyFileProviderUtil.getUriForFile(context, path);

        Uri targetUri = Uri.fromFile(new File(path));

        intent.putExtra(MediaStore.EXTRA_OUTPUT,targetUri);
        if (context instanceof Fragment) {
            ((Fragment) context).startActivityForResult(intent, reqCode);
        } else if (context instanceof Activity) {
            ((Activity) context).startActivityForResult(intent, reqCode);
        } else {
            throw new IllegalArgumentException("非法上下文对象裁剪图片");
        }
        return path;
    }

    public static String cropUserHeadPic(Object context, Uri uri, int reqCode) {
        return crop(context, uri, reqCode, 1, 1, ResourceUtil.getDimension(R.dimen.dp_head),ResourceUtil.getDimension(R.dimen.dp_head));
    }
    public static String cropTeamLogoPic(Object context, Uri uri, int reqCode) {
        return crop(context, uri, reqCode, 1, 1, ResourceUtil.getDimension(R.dimen.dp_logo),ResourceUtil.getDimension(R.dimen.dp_logo));
    }
    public static String cropGoodsPic(Object context, Uri uri, int reqCode) {
        return crop(context, uri, reqCode, 1, 1, ResourceUtil.getDimension(R.dimen.dp_goods),ResourceUtil.getDimension(R.dimen.dp_goods));
    }


    public static void saveBmp2File(){}

    public static Bitmap drawable2Bitmap(Drawable drawable) {
        Bitmap bitmap = Bitmap.createBitmap(drawable.getIntrinsicWidth(), drawable.getIntrinsicHeight(),
                drawable.getOpacity() != PixelFormat.OPAQUE ? Bitmap.Config.ARGB_8888 : Bitmap.Config.RGB_565);
        Canvas canvas = new Canvas(bitmap);

        drawable.setBounds(0, 0, drawable.getIntrinsicWidth(), drawable.getIntrinsicHeight());
        drawable.draw(canvas);
        return bitmap;
    }

    public static byte[] Bitmap2Bytes(Bitmap bitmap) {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, baos);
        return baos.toByteArray();
    }

    public static Bitmap Bytes2Bimap(byte[] b) {
        if ((b != null) && (b.length != 0)) {
            return BitmapFactory.decodeByteArray(b, 0, b.length);
        }

        return null;
    }

    public static String getImageFilePathFromIntent(Intent intent, Activity activity) {
//        Activity activity;
        if ((intent != null) && (activity != null)) {
            Uri uri = intent.getData();
            String[] projection = {"_data"};
            Cursor cursor;
            int column_index = (
                    cursor = activity.managedQuery(uri, projection, null, null, null))
                    .getColumnIndexOrThrow("_data");
            cursor.moveToFirst();

            return cursor.getString(column_index);
        }

        return null;
    }

    public static boolean compressImageFileToNewFileSize(File oldFile, File newFile, long finalSize) {
        int quality = 100;
        boolean result = false;
        compressImageFileToNewFile(oldFile, newFile, 100);
        long l;
        while ((
                l = newFile.length()) >
                finalSize) {
            quality--;
            if (quality <= 0) {
                quality = 1;
            }
            compressImageFileToNewFile(oldFile, newFile, quality);
            if (quality <= 1) {
//                break label58;
            }
        }

        result = true;

        label58:
        return result;
    }

    public static boolean compressImageFileToNewFile(File oldFile, File newFile, int quality) {
//        int quality;
        if ((oldFile != null) && (newFile != null) && (oldFile.exists())) {
            try {
                if (newFile.exists()) {
                    newFile.delete();
                }
                newFile.createNewFile();

                if (newFile.exists()) {

                    FileOutputStream fos = new FileOutputStream(newFile);
                    fos.close();
                    return true;
                }

                return false;
            } catch (Exception localException) {
                return false;
            }
        }

        return false;
    }
}
