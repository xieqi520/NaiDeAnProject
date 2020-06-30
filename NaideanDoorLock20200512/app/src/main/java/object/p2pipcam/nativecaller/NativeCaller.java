package object.p2pipcam.nativecaller;

import android.content.Context;

public class NativeCaller {
	/** Called when the activity is first created. */

	static {
		System.loadLibrary("ffmpeg");
		System.loadLibrary("object_jni");
		System.loadLibrary("avi_utils");
	}

	private static final String LOG_TAG = "NativeCaller";

	public native static int SnapShot(String did, String filename);

	public native static void StartSearch();

	public native static void StopSearch();

	public native static void Init();

	public native static void Free();

	public native static int StartPPPP(String did, String user, String pwd,String server);

	public native static int StopPPPP(String did);

	public native static int StartPPPPLivestream(String did, int streamid,String fileName,int videoFram);

	public native static int StopPPPPLivestream(String did);

	public native static int PPPPStartAudio(String did);

	public native static int PPPPStopAudio(String did);

	public native static int PPPPStartTalk(String did);

	public native static int PPPPStopTalk(String did);

	public native static int PPPPTalkAudioData(String did, byte[] data, int len);

	public native static int PPPPNetworkDetect();

	public native static void PPPPInitial(String svr);

	public native static int PPPPSetCallbackContext(Context object);

	public native static int PPPPRebootDevice(String did);

	public native static int PPPPRestorFactory(String did);

	public native static int StartPlayBack(String did, String filename,
										   int offset);

	public native static int StopPlayBack(String did);

	public native static int PPPPGetSDCardRecordFileList(String did,
														 int startTime, int endTime);


	public native static int PPPPGetSystemParams(String did, int paramType);

	// takepicture
	public native static int YUV4202RGB565(byte[] yuv, byte[] rgb, int width,
										   int height);

	public native static int DecodeH264Frame(byte[] h264frame, int bIFrame,
											 byte[] yuvbuf, int length, int[] size);

	public native static int FormatSD(String did);

	public native static int TransferMessage(String did, String cgi, int type);

	public native static int TransferMessage1(String did, String cgi, int type);

	public native static int OpenAviFileName(String did, String filename,
											 String forcc, int height, int width, int framerate,int hzk);

	public native static int CloseAvi(String did);

	public native static int WriteData(String did, byte[] data, int len,
									   int keyframe);

	public native static int WriteAudioData(String did, byte[] data, int len);
}