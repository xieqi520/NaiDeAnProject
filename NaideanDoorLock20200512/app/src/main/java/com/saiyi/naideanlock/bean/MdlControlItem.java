package com.saiyi.naideanlock.bean;

import android.support.annotation.DrawableRes;

import com.saiyi.naideanlock.enums.EnumControlItemId;

public class MdlControlItem {
    @EnumControlItemId._Type
    public int targetId;

    public boolean enable;
    public String name;
    @DrawableRes
    public int iconRes;

    public MdlControlItem() {
    }


    public MdlControlItem(boolean enable, String name, int iconRes) {
        this(0, enable, name, iconRes);
    }

    public MdlControlItem(int targetId, String name, int iconRes) {
        this(targetId, true, name, iconRes);
    }

    public MdlControlItem(int targetId, boolean enable, String name, int iconRes) {
        this.targetId = targetId;
        this.enable = enable;
        this.name = name;
        this.iconRes = iconRes;
    }
}
