package com.saiyi.naideanlock.utils;

import java.io.ByteArrayOutputStream;

/**
 * 描述：解码工具类 -- 将byte数组转成16进制或其他进制
 * 创建作者：ask
 * 创建时间：2017/9/20 16:18
 */

public class DecodeUtil {

    private static DecodeUtil instance;

    //十六进制字符串
    private final static String HEX_STRING = "0123456789ABCDEF";

    public static synchronized DecodeUtil getInstance() {
        if (instance == null) {
            instance = new DecodeUtil();
        }
        return instance;
    }

    /**
     * 将16进制数组解码成字符串,适用于所有字符（包括中文）
     *
     * @param bytes 16进制字节数组
     * @return 对应的字符串
     */
    public String hexByteToStr(byte[] bytes) {
        return hexStrToStr(bytesToHexStr(bytes));
    }


    /**
     * 将16进制数字解码成字符串,适用于所有字符（包括中文）
     *
     * @param byteStr 将十六进制字符串
     * @return 返回对应的字符串
     */

    public String hexStrToStr(String byteStr) {
        final ByteArrayOutputStream byteStream = new ByteArrayOutputStream(byteStr.length() / 2);
        // 将每2位16进制整数组装成一个字节
        for (int i = 0; i < byteStr.length(); i += 2) {
            byteStream.write((HEX_STRING.indexOf(byteStr.charAt(i)) << 4 |
                    HEX_STRING.indexOf(byteStr.charAt(i + 1))));
        }
        return byteStream.toString();
    }

    /**
     * 将字节数组转换成16进制字符串
     *
     * @param bytes 字节数组
     * @return 16进制字符串
     */
    public String bytesToHexStr(byte[] bytes) {
        int temp;
        String valueTemp;
        final StringBuilder strBuilder = new StringBuilder();
        for (byte value : bytes) {
            temp = value & 0xFF;
            valueTemp = Integer.toHexString(temp);
            if (valueTemp.length() < 2) {
                strBuilder.append(0);
            }
            strBuilder.append(valueTemp);
        }
        return strBuilder.toString();
    }

    /**
     * 将字节数组转换成16进制字符串
     *
     * @param data 字节数据
     * @return 16进制字符串
     */
    public String byteToHexStr(byte data) {
        return bytesToHexStr(new byte[]{data});
    }

    /**
     * 16进制字符串转换成16进制字节数组
     *
     * @param hexStr 16进制字符串
     * @return 返回16进制字节
     */
    public static byte[] hexStrToBytes(String hexStr) {
        if (hexStr == null || hexStr.equals("")) {
            return null;
        }
        hexStr = hexStr.toUpperCase().replace(" ", "");
        final char[] hexChars = hexStr.toCharArray();
        final byte[] byteData = new byte[hexStr.length() / 2];
        for (int i = 0; i < byteData.length; i++) {
            int pos = i * 2;
            byteData[i] = (byte) (charToByte(hexChars[pos]) << 4 | charToByte(hexChars[pos + 1]));
        }
        return byteData;
    }

    /**
     * 将字符串转换成16进制byte[]
     *
     * @param str 字符串
     * @return 返回16进制字节
     */
    public static byte[] strToHexBytes(String str) {
        return hexStrToBytes(strToHexStr(str));
    }

    /**
     * 将字符串编码成16进制数字,适用于所有字符（包括中文）
     *
     * @param str 需要编码的字符串
     * @return 转换成的16进制的字符串
     */
    public static String strToHexStr(String str) {
        // 根据默认编码获取字节数组
        byte[] bytes = str.getBytes();
        StringBuilder sb = new StringBuilder(bytes.length * 2);
        // 将字节数组中每个字节拆解成2位16进制整数
        for (int i = 0; i < bytes.length; i++) {
            sb.append(HEX_STRING.charAt((bytes[i] & 0xf0) >> 4));
            sb.append(HEX_STRING.charAt((bytes[i] & 0x0f) >> 0));
        }
        return sb.toString();
    }

    /**
     * 十进制字符串转十进制字节
     * 将字符串按位置转成对应位数的字节
     *
     * @param str 字符串
     * @return byte[]
     */
    public static byte[] strToBytes(String str) {
        int index = 0;
        final char[] dataChars = str.toCharArray();
        final byte[] dataBytes = new byte[dataChars.length];
        for (; index < dataBytes.length; index++) {
            dataBytes[index] = charToByte(dataChars[index]);
        }
        return dataBytes;
    }

    /**
     * 将当个字符串转换成16进制字节
     *
     * @param c 需要转换的字符
     * @return 转换后的字节
     */
    private static byte charToByte(char c) {
        return (byte) HEX_STRING.indexOf(c);
    }


    /**
     * 将一个mac地址转成6位的byte数组
     *
     * @param mac mac地址
     * @return
     */
    public static byte[] getMacBytes(String mac) {
        byte[] macBytes = new byte[8];
        String[] strArr = mac.split(":");

        for (int i = 0; i < strArr.length; i++) {
            int value = Integer.parseInt(strArr[i], 16);
            macBytes[i] = (byte) value;
        }
        return macBytes;
    }
}
