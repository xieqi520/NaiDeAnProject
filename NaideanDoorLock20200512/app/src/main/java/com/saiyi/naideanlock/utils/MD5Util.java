package com.saiyi.naideanlock.utils;

import java.security.MessageDigest;
import java.util.Arrays;

/**
 * 描述：MD5加密和 一个简单的加密解密工具
 * 创建作者：ask
 * 创建时间：2017/11/1 11:38
 */

public class MD5Util {
    /**
     * MD5加密
     *
     * @param inStr
     * @return
     */
    public static String MD5(String inStr) {
        MessageDigest md5 = null;
        try {
            md5 = MessageDigest.getInstance("MD5");
        } catch (Exception e) {
            System.out.println(e.toString());
            e.printStackTrace();
            return "";
        }
        char[] charArray = inStr.toCharArray();
        byte[] byteArray = new byte[charArray.length];

        for (int i = 0; i < charArray.length; i++)
            byteArray[i] = (byte) charArray[i];

        byte[] md5Bytes = md5.digest(byteArray);

        StringBuffer hexValue = new StringBuffer();

        for (int i = 0; i < md5Bytes.length; i++) {
            int val = ((int) md5Bytes[i]) & 0xff;
            if (val < 16)
                hexValue.append("0");
            hexValue.append(Integer.toHexString(val));
        }

        return hexValue.toString();
    }

    public static byte[] MD5(byte[] srcData) {
        MessageDigest md5 = null;
        try {
            md5 = MessageDigest.getInstance("MD5");
        } catch (Exception e) {
            System.out.println(e.toString());
            e.printStackTrace();
            return null;
        }

        return md5.digest(srcData);
    }

    public static byte[] MD5App2DeviceCmd(String content) {
        MessageDigest md5;
        byte[] srcData;
        try {
            md5 = MessageDigest.getInstance("MD5");
            srcData = content.getBytes("utf-8");
        } catch (Exception e) {
            System.out.println(e.toString());
            e.printStackTrace();
            return null;
        }
        byte[] md5Bytes = md5.digest(srcData);
        //16位的MD5
        md5Bytes = Arrays.copyOfRange(md5Bytes, 4, 12);

        return md5Bytes;
    }


    /**
     * 可逆加密算法
     *
     * @param information
     * @return
     */
    public static String encryption(String information) {
        // String s = new String(inStr);
        char[] a = information.toCharArray();
        for (int i = 0; i < a.length; i++) {
            a[i] = (char) (a[i] ^ 't');
        }
        String s = new String(a);
        return s;
    }

    /**
     * 加密后解密
     *
     * @param information
     * @return
     */
    public static String decrypt(String information) {
        char[] a = information.toCharArray();
        for (int i = 0; i < a.length; i++) {
            a[i] = (char) (a[i] ^ 't');
        }
        String k = new String(a);
        return k;
    }
}
