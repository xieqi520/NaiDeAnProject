package object.p2pipcam.nativecaller;


import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.Service;
import android.os.Vibrator;
import android.util.Log;

import org.json.JSONException;
import org.json.JSONObject;

@SuppressLint({ "UseValueOf", "ShowToast" })
public class CommonUtil {
	private static final Boolean isLog = true;

	private static final String KEY_MIUI_VERSION_CODE = "ro.miui.ui.version.code";
	private static final String KEY_MIUI_VERSION_NAME = "ro.miui.ui.version.name";
	private static final String KEY_MIUI_INTERNAL_STORAGE = "ro.miui.internal.storage";




	public static void Vibrate(final Activity activity, long milliseconds) {
		Vibrator vib = (Vibrator) activity
				.getSystemService(Service.VIBRATOR_SERVICE);
		vib.vibrate(milliseconds);
	}

	public static void Vibrate(final Activity activity, long[] pattern,
							   int isRepeat) {
		Vibrator vib = (Vibrator) activity
				.getSystemService(Service.VIBRATOR_SERVICE);
		vib.vibrate(pattern, isRepeat);
	}

	public static final void Log(int tag, String content) {
		if (isLog) {
			if (tag == 1) {
				Log.e("LOG", "NNN--" + content);
			} else if (tag == 2) {
				Log.e("LOG", "NNN--" + content);
			}
		}
	}

	public static final byte integerToOneByte(int value) {
		if ((value > Math.pow(2, 15)) || (value < 0)) {
		}
		return (byte) (value & 0xFF);
	}

	public static final byte[] integerToTwoBytes(int value) {
		byte[] result = new byte[2];
		if ((value > Math.pow(2, 31)) || (value < 0)) {
		}
		result[0] = (byte) ((value >>> 8) & 0xFF);
		result[1] = (byte) (value & 0xFF);
		return result;
	}

	public static final byte[] integerToFourBytes(int value) {
		byte[] result = new byte[4];
		if ((value > Math.pow(2, 63)) || (value < 0)) {
		}
		result[0] = (byte) ((value >>> 24) & 0xFF);
		result[1] = (byte) ((value >>> 16) & 0xFF);
		result[2] = (byte) ((value >>> 8) & 0xFF);
		result[3] = (byte) (value & 0xFF);
		return result;
	}

	public static final int oneByteToInteger(byte value) {
		return (int) value & 0xFF;
	}

	public static final int twoBytesToInteger(byte[] value) {
		if (value.length < 2) {
		}
		int temp0 = value[0] & 0xFF;
		int temp1 = value[1] & 0xFF;
		return ((temp0 << 8) + temp1);
	}

	public static final long fourBytesToLong(byte[] value) {
		if (value.length < 4) {
		}
		int temp0 = value[0] & 0xFF;
		int temp1 = value[1] & 0xFF;
		int temp2 = value[2] & 0xFF;
		int temp3 = value[3] & 0xFF;
		return (((long) temp0 << 24) + (temp1 << 16) + (temp2 << 8) + temp3);
	}

	public static final byte[] intToByte(int number) {
		int temp = number;
		byte[] b = new byte[4];
		for (int i = 0; i < b.length; i++) {
			b[i] = new Integer(temp & 0xff).byteValue();// 锟斤拷锟斤拷锟轿伙拷锟斤拷锟斤拷锟斤拷锟斤拷位
			temp = temp >> 8;// 锟斤拷锟斤拷锟斤拷8位
		}
		return b;
	}

	public static final int byteToInt(byte[] b) {
		int s = 0;
		int s0 = b[0] & 0xff;// 锟斤拷锟轿�
		int s1 = b[1] & 0xff;
		int s2 = b[2] & 0xff;
		int s3 = b[3] & 0xff;
		s3 <<= 24;
		s2 <<= 16;
		s1 <<= 8;
		s = s0 | s1 | s2 | s3;
		return s;
	}

	public static final byte[] longToByte(long number) {
		long temp = number;
		byte[] b = new byte[8];
		for (int i = 0; i < b.length; i++) {
			b[i] = new Long(temp & 0xff).byteValue();// 锟斤拷锟斤拷锟轿伙拷锟斤拷锟斤拷锟斤拷锟斤拷位
			temp = temp >> 8;// 锟斤拷锟斤拷锟斤拷8位
		}
		return b;

	}

	public static final long byteToLong(byte[] b) {
		long s = 0;
		long s0 = b[0] & 0xff;// 锟斤拷锟轿�
		long s1 = b[1] & 0xff;
		long s2 = b[2] & 0xff;
		long s3 = b[3] & 0xff;
		long s4 = b[4] & 0xff;// 锟斤拷锟轿�
		long s5 = b[5] & 0xff;
		long s6 = b[6] & 0xff;
		long s7 = b[7] & 0xff; // s0锟斤拷锟斤拷
		s1 <<= 8;
		s2 <<= 16;
		s3 <<= 24;
		s4 <<= 8 * 4;
		s5 <<= 8 * 5;
		s6 <<= 8 * 6;
		s7 <<= 8 * 7;
		s = s0 | s1 | s2 | s3 | s4 | s5 | s6 | s7;
		return s;
	}



	public static final int jasonPaseInt(JSONObject obj,String key,int errorint) {
		int iP = errorint;

		try {
			iP = obj.getInt(key);
		} catch (JSONException e) {
			e.printStackTrace();
			iP = errorint;
		}
		return iP;
	}
	public static final String jasonPaseString(JSONObject obj,String key) {
		String iP = "";

		try {
			iP = obj.getString(key);
		} catch (JSONException e) {
			e.printStackTrace();
			iP = "";
		}
		return iP;
	}

	public static final String getCameraParms(String user,String pwd) {
		JSONObject obj = new JSONObject();
		try {
			obj.put("pro", "get_parms");
			obj.put("cmd", 101);
			obj.put("user", user);
			obj.put("pwd", pwd);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return obj.toString();
	}

	public static final String CameraControl(String user,String pwd,int parms,int value) {
		JSONObject obj = new JSONObject();
		try {
			obj.put("pro", "control");
			obj.put("cmd", 102);
			obj.put("user", user);
			obj.put("pwd", pwd);
			obj.put("parms", parms);
			obj.put("value", value);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return obj.toString();
	}

	public static final String getSDParms(String user,String pwd) {
		JSONObject obj = new JSONObject();
		try {
			obj.put("pro", "get_sd");
			obj.put("cmd", 109);
			obj.put("user", user);
			obj.put("pwd", pwd);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return obj.toString();
	}


	public static final String getUsersParms(String user,String pwd) {
		JSONObject obj = new JSONObject();
		try {
			obj.put("pro", "get_user");
			obj.put("cmd", 103);
			obj.put("user", user);
			obj.put("pwd", pwd);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return obj.toString();
	}


	public static final String addUsersParms(String user,String pwd,String newuser,String newpwd) {
		JSONObject obj = new JSONObject();
		try {
			obj.put("pro", "add_user");
			obj.put("cmd", 104);
			obj.put("user", user);
			obj.put("pwd", pwd);
			obj.put("newuser", newuser);
			obj.put("newpwd", newpwd);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return obj.toString();
	}


	public static final String editUsersParms(String user,String pwd,String edituser,String newuser,String newpwd) {
		JSONObject obj = new JSONObject();
		try {
			obj.put("pro", "edit_user");
			obj.put("cmd", 106);
			obj.put("user", user);
			obj.put("pwd", pwd);
			obj.put("edituser", edituser);
			obj.put("newuser", newuser);
			obj.put("newpwd", newpwd);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return obj.toString();
	}


	public static final String deleteUsersParms(String user,String pwd,String deluser) {
		JSONObject obj = new JSONObject();
		try {
			obj.put("pro", "del_user");
			obj.put("cmd", 105);
			obj.put("user", user);
			obj.put("pwd", pwd);
			obj.put("deluser", deluser);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return obj.toString();
	}



	public static final String formatSDParms(String user,String pwd) {
		JSONObject obj = new JSONObject();
		try {
			obj.put("pro", "set_sd");
			obj.put("cmd", 110);
			obj.put("user", user);
			obj.put("pwd", pwd);
			obj.put("format", 1);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return obj.toString();
	}


	public static final String getAlarmParms(String user,String pwd) {
		JSONObject obj = new JSONObject();
		try {
			obj.put("pro", "get_alarm");
			obj.put("cmd", 107);
			obj.put("user", user);
			obj.put("pwd", pwd);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return obj.toString();
	}


	public static final String getWifiParms(String user,String pwd) {
		JSONObject obj = new JSONObject();
		try {
			obj.put("pro", "get_wifi");
			obj.put("cmd", 112);
			obj.put("user", user);
			obj.put("pwd", pwd);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return obj.toString();
	}

	public static final String scanWifi(String user,String pwd) {
		JSONObject obj = new JSONObject();
		try {
			obj.put("pro", "scan_wifi");
			obj.put("cmd", 113);
			obj.put("user", user);
			obj.put("pwd", pwd);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return obj.toString();
	}


	public static final String SHIX_LockControl(String user,String pwd,int value) {
		JSONObject obj = new JSONObject();
		try {
			obj.put("pro", "lock_control");
			obj.put("cmd", 119);
			obj.put("user", user);
			obj.put("pwd", pwd);
			obj.put("value", value);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return obj.toString();
	}



	public static final String SHIX_SetWifi(String user,String pwd,String wifissid,String wifipwd) {
		JSONObject obj = new JSONObject();
		try {
			obj.put("pro", "set_wifi");
			obj.put("cmd", 114);
			obj.put("user", user);
			obj.put("pwd", pwd);
			obj.put("wifissid", wifissid);
			obj.put("wifipwd", wifipwd);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return obj.toString();
	}


	public static final String SHIX_Heat(String user,String pwd) {
		JSONObject obj = new JSONObject();
		try {
			obj.put("pro", "dev_control");
			obj.put("cmd", 102);
			obj.put("user", user);
			obj.put("pwd", pwd);
			obj.put("heart", 1);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return obj.toString();
	}

}
