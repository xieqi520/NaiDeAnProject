package com.saiyi.naideanlock.utils;

import com.saiyi.naideanlock.constant.PublicConstant;
import com.saiyi.naideanlock.enums.EnumBLECmd;
import com.sandy.guoguo.babylib.utils.LogAndToastUtil;
import com.sandy.guoguo.babylib.utils.Utility;
import com.sandy.guoguo.babylib.utils.eventbus.EventBusManager;
import com.sandy.guoguo.babylib.utils.eventbus.MdlEventBus;

import java.util.Arrays;

public class BLEDeviceCmd {
    private static final byte[] APP_2_DEVICE_HEADER = {0X5A, MyUtility.int2UInt8(0XA5)};
    private static final byte[] DEVICE_2_APP_HEADER = {0X5A, MyUtility.int2UInt8(0XA5)};

    public static byte[] bondDevice() {
        byte b = Utility.int2byte(0x0);
        byte[] data = {b, b, b, b, b, b, b, b};
        return create(EnumBLECmd.BONDED, data);
    }

    public static byte[] setPwd(String content) {
        return create(EnumBLECmd.SET_PWD, content);
    }

    public static byte[] getPower() {
        return create(EnumBLECmd.GET_POWER, PublicConstant.DEVICE_DEFAULT_PWD);
    }

    public static byte[] unlock() {
        return create(EnumBLECmd.UNLOCK, PublicConstant.DEVICE_DEFAULT_PWD);
    }

    public static byte[] resetPwd(String content) {
        return create(EnumBLECmd.RESET_PWD, content);
    }

    private static byte[] create(@EnumBLECmd._Flag int cmdFlag, String srcData) {
        byte[] content = MD5Util.MD5App2DeviceCmd(srcData);
        //数据头+指令+内容长度+内容+CRC
        byte[] data = new byte[APP_2_DEVICE_HEADER.length + 2 + content.length + 1];
        System.arraycopy(APP_2_DEVICE_HEADER, 0, data, 0, APP_2_DEVICE_HEADER.length);
        data[APP_2_DEVICE_HEADER.length] = MyUtility.int2UInt8(cmdFlag);
        data[APP_2_DEVICE_HEADER.length + 1] = MyUtility.int2UInt8(content.length);

        System.arraycopy(content, 0, data, APP_2_DEVICE_HEADER.length + 2, content.length);
        byte crc = MyUtility.getCrc(Arrays.copyOf(data, data.length - 1));

        data[data.length - 1] = crc;

        return data;
    }

    private static byte[] create(@EnumBLECmd._Flag int cmdFlag, byte[] content) {
        //数据头+指令+内容长度+内容+CRC
        byte[] data = new byte[APP_2_DEVICE_HEADER.length + 2 + content.length + 1];
        System.arraycopy(APP_2_DEVICE_HEADER, 0, data, 0, APP_2_DEVICE_HEADER.length);
        data[APP_2_DEVICE_HEADER.length] = MyUtility.int2UInt8(cmdFlag);
        data[APP_2_DEVICE_HEADER.length + 1] = MyUtility.int2UInt8(content.length);

        System.arraycopy(content, 0, data, APP_2_DEVICE_HEADER.length + 2, content.length);
        byte crc = MyUtility.getCrc(Arrays.copyOf(data, data.length - 1));

        data[data.length - 1] = crc;

        return data;
    }

    public static void handleDevice2AppData(byte[] data) {
        if (data[0] != DEVICE_2_APP_HEADER[0] || data[1] != DEVICE_2_APP_HEADER[1]) {
            LogAndToastUtil.log("无用的数据----");
        } else {
            byte type = data[2];
            byte[] significantData = Arrays.copyOfRange(data, 4, 4 + data[3]);

            EventBusManager.post(new MdlEventBus(type, significantData));
        }
    }
}
