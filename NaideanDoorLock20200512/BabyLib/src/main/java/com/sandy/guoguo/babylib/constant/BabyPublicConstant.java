package com.sandy.guoguo.babylib.constant;

import com.sandy.guoguo.babylib.ui.BaseApp;

public class BabyPublicConstant {

	public static final String APP_NAME;

	static {
		APP_NAME = BaseApp.ME.getPackageName();
	}


	public static final boolean isDebug = true;

}
