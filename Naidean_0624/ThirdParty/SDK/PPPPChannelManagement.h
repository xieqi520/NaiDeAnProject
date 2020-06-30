

#ifndef _PPPP_CHANNEL_MANAGEMENT_H_
#define _PPPP_CHANNEL_MANAGEMENT_H_

#import <Foundation/Foundation.h>

#import "SHIXCommonProtocol.h"





class CPPPPChannelManagement
{
public:
    CPPPPChannelManagement();
    ~CPPPPChannelManagement();
    
    /**
     开始连接设备szDID：设备ID    user：用户名    pwd：密码
     ***/
    int Start(const char *szDID, const char *user, const char *pwd);
    /**
     断开设备连接
     ***/
    int Stop(const char *szDID);
    /**
     设备状态回调
     ***/
    int SetCameraStatusDelegate(char *szDID,id delegate);
    
    /**
     获取视频  szDID：设备ID，连接设备，设备返回在线状态再调用   delegate：回调
     ***/
    int StartPPPPLivestream(const char *szDID, id delegate);
    /**
     停止视频
     ***/
    int StopPPPPLivestream(const char * szDID);
    
    /**
     透传协议发送
     ***/
    int TransferMessage(char * szDID,char * msg, int len);
    /**
     透传协议回调
     ***/
    int SetTransferDelegate(char *szDID,id delegate);
    
    
    
    
    
    
    int StartPPPPAudio(const char *szDID);
    int StopPPPPAudio(const char *szDID);
    int StartPPPPTalk(const char *szDID);
    int StopPPPPTalk(const char *szDID);
    int TalkAudioData(const char *szDID, const char *data,  int len);
    int GetAudioFramData(const char *szDID,void* buf, int size);
    int SetAudioCount(const char *szDID,int count);
    void StopAll();
    int Snapshot(const char* szDID);
    void SetPlaybackDelegate(char *szDID, id delegate);
    int PPPPStartPlayback(char *szDID, char *szFileName, int offset);
    int PPPPStopPlayback(char *szDID);
    int getServer(const char *szDID);
    int PPPPGetSDCardRecordFileList(char *szDID, int startTime, int endTime);
    
public:
    
    
    
private:
    
    NSCondition *m_Lock;
};

#endif
