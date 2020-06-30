//
//  WLSQXcloulink.h
//  Community
//
//  Created by lijiang on 16/7/13.
//  Copyright © 2016年 李江. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "xcloudlink.h"//优载云sdk
#import "HWDecoder.h"//视频解码库
#import "XDecoder.h"
#import "XMP4_RecInter.h"
#import "EasyAACEncoderAPI.h"
#import "YZYNetWorkState.h"//网络监测类
#import "avrecord.h"

enum _XCLOUDMSG
{
    
    XCLOUDMSG_XBROADCAST =110,        //获取wifi列表
    XCLOUDMSG_LOGINFAIL = 111,        //登录认证失败
    XCLOUDMSG_LOGINSUCCESS=112,       //登录成功
    XCLOUDMSG_MANOFFLINE=113,         //设备离线
    XCLOUDMSG_MANONLINE=114,          //设备在线
    XCLOUDMSG_SESSIONFAIL=115,        //会话失败
    XCLOUDMSG_SESSIONSUCCESS=116,     //会话成功
    XCLOUDMSG_OPENSESSION=117,
    XCLOUDMSG_CLOSESESSION=118,
    XCLOUDMSG_TRANSALT=119,           //透传
    XCLOUDMSG_ALARM=120,              //报警消息
    XCLOUDMSG_CONTROL=121,            //控制指令
    XCLOUDMSG_SESSION_WRITE_START=122, //开始打开媒体资源，并可以CDK_SendMediaData
    XCLOUDMSG_SESSION_WRITE_STOP=123,  //关闭写资源
    XCLOUDMSG_SESSION_READ_START=124,  //开始接收对应的媒体数据
    XCLOUDMSG_SESSION_READ_STOP=125,   //停止接收对应的媒体数据
    XCLOUDMSG_SUBSCRIBEFAIL=126,       //设备订阅失败
    XCLOUDMSG_SUBSCRIBESUCCESS=127,    //设备订阅成功
    XCLOUDMSG_TRANSALT_BIN = 128,
    XCLOUDMSG_TRANSALT_A = 129,
    XCLOUDMSG_TRANSALT_COMA = 130,
    XCLOUDMSG_TRANSALT_COMB = 131,
    XCLOUDMSG_MESSAGE_PUSH = 132,
    XCLOUDMSG_MESSAGE_SYSTEM = 133,
    
    
    //    XCLOUDEFRM_IMP = 0,                //消息数据
    //    XCLOUDEFRM_FRAMEI = 1,             //视频I帧
    //    XCLOUDEFRM_FRAMEP = 2,             //视频P帧
    //    XCLOUDEFRM_YLOST = 3,              //音频数据
};


/*
 密码加密方式
 */
typedef NS_ENUM(NSInteger, YZYEncryptionMode)
{
    
    YZYEncryptionModeNo,// 不加密
    YZYEncryptionModeMD5,//md5 加密
    
    
};

@protocol WLSQXcloulinkDelegete <NSObject>

@optional


/**
 消息回调 优载云的消息回调函数,hParam设备能力描述
 
 @param nMsg       回调的消息类型
 @param hParam     随着nMsg的不同会有不同的含义，消息回调的参数说明
 @param lParam     随着nMsg的不同会有不同的含义，消息回调的参数说明
 @param pString    详细的命令说明，可以是json等任何自定义数据
 @param iLen       pString的长度
 */
- (void)xmsgCallBack:(int)nMsg hParam:(int)hParam lParam:(int)lParam withpString:(char *)pString withiLen:(int)iLen;

/**
 音视频的回调 (未解码原始音视频数据)
 
 @param nSID       打开的会话ID
 @param MediaType  媒体类型，_XCLOUDRES_H264_1 高清视频,_XCLOUDRES_H264_2 标清视频,_XCLOUDRES_G711a音频
 @param hParam     1是I帧，2是P帧
 @param lParam     这个帧的延迟时间
 @param pBuf       传输过来的流
 @param nBuflen    传输过来的流大小
 */
- (void)xmediaCallBack:(int)nSID withmediaType:(int)MediaType withhParam:(int)hParam withlParam:(int)lParam withpBuf:(char *)pBuf withnBuflen:(int)nBuflen;


/**
 解码后的视频数据返回
 
 @param pixBuffer 解码后的视频数据
 @param samplePhotoBuffer 解码后的视频数据
 @param sessionID 对应打开视频的会话ID
 @param mediaType 类型
 */
- (void)didHardDecodePixelBuffer:(CVPixelBufferRef)pixBuffer SamplePhotoBuffer:(CMSampleBufferRef)samplePhotoBuffer sessionID:(int)sessionID mediaType:(int)mediaType;



/**
 解码后的音频数据返回
 
 @param m_pPCMBuffer 音频数据
 @param nBuflen 音频长度
 */
- (void)didListeningWithpBuf:(unsigned char *)m_pPCMBuffer withnBuflen:(int)nBuflen;


/**
 解码后的IF卡音频数据返回
 
 @param m_pPCMBuffer  解码后的音频数据
 @param nBuflen 音频长度
 */
- (void)didListening_IF_WithpBuf:(unsigned char *)m_pPCMBuffer withnBuflen:(int)nBuflen;



/**
 抓拍图片
 
 @param image 返回抓拍图片
 */
- (void)getCaptureWithimage:(UIImage *)image;



@end

// --------------------------------------------- 检测网络切换工具类回调 --------------------------

@protocol WLSQXcloulinkNetWorkStateDelegate <NSObject>

@optional

/**
 * 当网络状态发生改变的时候触发， 前提是必须是添加网络状态监听
 */
- (void)WLSQXcloulinkNetWorkStateChangedStateType:(YZYNetWorkStateType)netWorkStateType;


@end




@interface WLSQXcloulink : NSObject<HWDecodeSDKDelegate,YZYNetWorkStateDelegate>


/**
 创建单例
 */
+ (WLSQXcloulink *)sharedManager;


/**
 获取当前版本
 
 @return 返回版本
 */
- (NSString *)getVersion;

/**
 获取优载云登录状态  YES 登录成功  NO 登录失败
 */
- (BOOL)getLoginState;

/**
 添加网络检测切换类工具
 */
- (void)addMonitorNetWorkStateWithWLSQXcloulinkNetWorkStateDelegate:(id<WLSQXcloulinkNetWorkStateDelegate>)netWorkStateDelegate;


/**
 获取当前网络类型状态
 
 @return YZYNetWorkStateType
 */
- (YZYNetWorkStateType)getWLSQXcloulinkNetWorkStateType;


/**
 设置优载云登录状态 (一般用于网络切换切换登录状态)
 
 @param LoginBool YES 登录成功  NO 登录失败
 */
- (void)setLoginState:(BOOL)LoginBool;

/**
 设置代理,回调消息和媒体数据
 
 @param delegete 代理对象
 @param nSID 表示订阅设备ID的回调
 */
- (void)setXcloulinkdelegete:(id)delegete
                        nSID:(NSString *)nSID;



/**
 添加后台操作用于后台重登
 */
- (void)AddBackgroundTaskInvalid;


/**
 初始化SDK并且注册回调函数
 
 @return YES 成功  NO 失败
 */
- (BOOL)initIntelligentEquipment;


/**
 添加要登录的优载云服务器地址
 
 @param hostString 优载云服务器地址
 @param nPort  优载云服务器端口
 @param hProto  udp(11) / tcp(12)
 @return YES 发送成功  NO 发送失败
 */
- (BOOL)AddXCloudHostWith:(NSString *)hostString
                    nPort:(int)nPort
                   hProto:(int)hProto;


/**
 登录优载云
 
 @param YzyAccount 您申请的优载云开发者中心key
 @param YzyPassword 您申请的优载云开发者中心secret
 @return YES 发送成功  NO 发送失败
 */
- (BOOL)loginWithYzyAccount:(NSString *)YzyAccount
                YzyPassword:(NSString *)YzyPassword;



/**
 重新登录优载云(此方法要先调用loginWithYzyAccount:YzyPassword: 这个方法来存储key和secret,用于重登)
 
 @return YES 发送成功  NO 发送失败
 */
- (BOOL)LoginAgainYZY;

/**
 订阅设备
 
 @param nSID 设备ID
 @param nSIDPassword 设备密码
 @param encryptionMode 加密方式
 @param nOption 备用，默认传1
 @return YES 发送成功  NO 发送失败
 */
- (BOOL)SubscribenSID:(NSString *)nSID
         nSIDPassword:(NSString *)nSIDPassword
       encryptionMode:(YZYEncryptionMode)encryptionMode
              nOption:(int)nOption;


/**
 连接设备 建立P2P连接
 
 @param nSID 设备ID
 @return YES 连接成功  NO 连接失败
 */
- (BOOL)HelloXManSID:(NSString *)nSID;



/**
 注销登录
 
 @return YES 退出成功  NO 退出失败
 */
- (BOOL)logoutYZY;


/**
 自定义发送的消息(订阅成功才能发送,透传)
 
 @param nSID 要发送消息的设备id
 @param nMessage 默认传0，备用
 @param pString 要发送的任何消息，可以透传
 @return YES 发送成功  NO 发送成功
 */
- (BOOL)CDK_PostXMessagenWithnSID:(NSString *)nSID
                         nMessage:(int)nMessage
                          pString:(NSString *)pString;


/**
 系统化格式类型发送消息(订阅成功才能发送,透传),优载云定义标准命令格式
 
 @param services_dic 命令语句
 @param msg_type 命令类型
 @param msg_id 消息Id(时间戳)
 @param device_id 设备id
 @param device_type 设备类型
 @param sudDevice_id 子设备ID
 @param sudDevice_type 子设备类型
 @return YES 发送成功  NO 发送成功
 */
- (BOOL)CDK_PostXMessagenWithservices_dic:(NSDictionary *)services_dic
                                 msg_type:(NSString *)msg_type
                                   msg_id:(NSString *)msg_id
                                device_id:(NSString *)device_id
                              device_type:(NSString *)device_type
                             sudDevice_id:(NSString *)sudDevice_id
                           sudDevice_type:(NSString *)sudDevice_type;


/**
 通过优载云传输多媒体数据，比方说A端录音编码之后传输给设备B
 
 @param openSession       CDK_OpenSession返回的会话句柄，如果是录音CDK_OpenSession的nRW就是
 @param nResType  要传输的多媒体类型，_XCLOUDRES_H264_1 高清视频,_XCLOUDRES_H264_2 标清视频,_XCLOUDRES_G711a 音频
 @param iFreamType 帧类型
 @param lparam  默认传0
 @param pMediaBuffer 要传输给优载云的经过G711XEncode编码后的音频
 @param nMediaBufferSize 经过G711XEncode编码后的数据长度
 @return YES 发送成功  NO 发送失败
 
 */
- (BOOL)CDK_SendMediaDataWithopenSession:(unsigned int)openSession
                                nResType:(unsigned short)nResType
                              iFreamType:(unsigned char )iFreamType
                                  lparam:(unsigned short)lparam
                            pMediaBuffer:(char *)pMediaBuffer
                        nMediaBufferSize:(unsigned int)nMediaBufferSize;


/**
 打开会话(视频,音频)CDK_OpenSession和CDK_CloseSession必须成对出现
 
 @param nSID 目标设备ID
 @param nResType 多媒体类型，_XCLOUDRES_H264_1 高清视频,_XCLOUDRES_H264_2 标清视频,_XCLOUDRES_G711a音频
 @param nRW   读还是写 _XLOUDRES_OPT_READ 表示播放音视频  _XLOUDRES_OPT_WRITE 表示录音或者录制视频
 @return 此返回值是CDK_CloseSession要关闭的参数nSessionID
 */
- (int)CDK_OpenSessionWithnSID:(NSString *)nSID
                      nResType:(unsigned short)nResType
                           nRW:(unsigned short)nRW;



/**
 关闭会话(视频,音频) CDK_OpenSession和CDK_CloseSession必须成对出现，两个方法的nSessionID和nResType要一样才能被关闭对应的流
 
 @param nSessionID 目标设备ID，CDK_OpenSession的返回值
 @param nResType  媒体类型，_XCLOUDRES_H264_1 高清视频,_XCLOUDRES_H264_2 标清视频,_XCLOUDRES_G711a音频
 @return YES 成功  NO 成功
 */
- (BOOL)CDK_CloseSessionWithnSessionID:(unsigned int)nSessionID
                              nResType:(unsigned short)nResType;

/**
 抓拍图片
 
 */
- (void)getCapture;


// *******************************************   TF卡读取    ***************************************

/**
 读取TF卡录像视频文件数据
 
 @param nSID 目标设备ID
 @param strFilename TF卡录像地址
 @param nResType 媒体类型，_XCLOUDRES_FILE_VODVIDEO
 @param nRW 读还是写 _XLOUDRES_OPT_READ 表示播放音视频  _XLOUDRES_OPT_WRITE 表示录音或者录制视频
 @return 此返回值是CDK_CloseXCloudFile要关闭的参数nSessionID
 */
- (int)CDK_OpenXCloudFileWithnSID:(NSString *)nSID
                      strFilename:(NSString *)strFilename
                         nResType:(unsigned short)nResType
                              nRW:(unsigned short)nRW;


/**
 关闭读取TF卡录像视频文件数据 CDK_OpenXCloudFile和CDK_CloseXCloudFile必须成对出现，两个方法的nSessionID和nResType要一样才能被关闭对应的流
 
 @param nSessionID 目标设备ID，CDK_OpenXCloudFile的返回值
 @param nResType  媒体类型，_XCLOUDRES_FILE_VODVIDEO
 @return YES 成功  NO 成功
 */
- (BOOL)CDK_CloseXCloudFileWithnSessionID:(unsigned int)nSessionID
                                 nResType:(unsigned short)nResType;


// ********************************************  Mov文件录制 ****************************************

/**
 创建/打开待写/读的Mov文件
 
 @param iWidth 视频宽度
 @param iHeight 视频高度
 @param framerate 视频帧率
 @param audio 保留 默认1
 @param pFilePath 文件名(绝对路径文件名)
 @return YES 成功  NO 成功
 */
- (BOOL)CDK_Mov_Record_InitwithiWidth:(unsigned int)iWidth
                              iHeight:(unsigned int)iHeight
                            framerate:(unsigned int)framerate
                                audio:(unsigned int)audio
                            pFilePath:(NSString *)pFilePath;


/**
 关闭Mov文件(退出控制器要关闭录制)
 
 @return YES 成功  NO 成功
 */
- (BOOL)CDK_Mov_Record_Close;


/**
 开启局域网搜索广播(开启和关闭是成对存在的)
 
 @param nRecPort WiFi端口(3252)
 @param nSndPort 自己端口(3251)
 @return YES 成功  NO 成功
 */
- (BOOL)CDK_XBroadcastOpenWithnRecPort:(unsigned short)nRecPort
                              nSndPort:(unsigned short)nSndPort;


/**
 发起局域网搜索
 
 @return YES 成功  NO 成功
 */
- (BOOL)CDK_XBroadcast;


/**
 关闭搜索退出局域网
 
 @return YES 成功  NO 成功
 */
- (BOOL)CDK_XBroadcastClose;


/**
 查询报警列表能力值特征值代码
 
 @return  查询报警列表能力值特征值代码
 */
- (NSString *)CDK_Queryalarm_typewith:(NSDictionary *)dic_alarm;


/**
 查询是否优载云ID设备
 
 @param nSID ID
 @param nReserve 1
 @return 返回 2 是优载云ID  查询
 */
- (int)CDK_GetCompanyByIDWithnSID:(NSString *)nSID
                         nReserve:(unsigned short)nReserve;


/**
 转换ID
 
 @param nID hParam 通过hParam转换成设备ID
 @return 设备ID
 */
- (NSString *)CDK_CDK_GetDevNameByIDWithnID:(unsigned int)nID;


/**
 对NSDictionary进行md5加密
 
 @param string 未加密的字符串
 @return md5加密后的字符串
 */
- (NSString*)encryptMD5String:(NSString *)string;


/**
 获取系统当前的时间戳
 
 @return 返回时间戳
 */
- (NSString *)getDatetimeString;


/**
 获取系统当前的时间戳(毫秒级)
 
 @return 返回时间戳(毫秒级)
 */
- (NSString *)getDatetimeHaoMiaoString;


/**
 获取手机ip地址
 
 @return 返回获取手机ip地址
 */
- (NSString *)getDeviceIPIpAddresses;



/**
 Json数据转字NSDictionary
 
 @param string Json数据
 @return NSDictionary
 */
- (NSDictionary *)JSONKitString:(NSString *)string;



@end

