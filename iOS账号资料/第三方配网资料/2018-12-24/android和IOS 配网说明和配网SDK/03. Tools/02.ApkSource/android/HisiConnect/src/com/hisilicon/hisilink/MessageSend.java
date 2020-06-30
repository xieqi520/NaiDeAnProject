package com.hisilicon.hisilink;

import com.hisilicon.hisilinkapi.HisiLibApi;
import android.content.Context;
import android.os.Handler;
import android.os.HandlerThread;
import android.util.Log;

public class MessageSend {
	private static final String TAG = "MessageSend";
	private Handler mHandler;

    static {
        System.loadLibrary("HisiLink");
    }

    public MessageSend(Context context){
    }

    public void multiCastThread(){
        //ͨ��Handler�����߳�    
    	HandlerThread handlerThread = new HandlerThread("MultiSocketA");
        handlerThread.start(); 
        mHandler =  new Handler(handlerThread.getLooper());  
        mHandler.post(mRunnable);
        
        
    }
    public void stopMultiCast(){
    	HisiLibApi.stopMulticast();
    }
    private Runnable mRunnable = new Runnable() {
        public void run() {
            Log.d(TAG, "Multicast run...");
            try {
            	//TBD:�쳣���ش���
            	HisiLibApi.startMulticast();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    };
}
