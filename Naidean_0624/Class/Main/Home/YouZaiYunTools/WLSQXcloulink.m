//
//  WLSQXcloulink.m
//  Community
//
//  Created by lijiang on 16/7/13.
//  Copyright © 2016年 李江. All rights reserved.
//

#import "WLSQXcloulink.h"
#import <sys/socket.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <net/if.h>
#import <arpa/inet.h>
#import <CommonCrypto/CommonDigest.h>
#import "JSONKit.h"


@implementation WLSQXcloulink

NSMutableArray *_hostMuArray;//存储优载云服务器地址
NSString *_nSIDSting;//存储收到设备回调的ID
BOOL _LoginState;//记录优载云登录状态
__weak id<WLSQXcloulinkDelegete>_delegete;//代理对象
__weak id<WLSQXcloulinkNetWorkStateDelegate>_netWorkStateDelegate;//网络切换代理对象
HWDecoder * _hwDecoder; //视频解码
HWDecoder * _hwDecoder_SDPlay; //SD卡视频解码
BOOL _Capture_state;//是否抓拍图片
NSString *_yzyAccount;//存储申请的优载云开发者中心key
NSString *_yzyPassword;//存储申请的优载云开发者中心secret
NSInteger _LoginNum;//重登次数
 BOOL _waitIfarmre;//等待I帧


struct {
    
    BOOL bNeedRecord;
    BOOL bWaitKeyFrame;
    uint32_t frameWidth;
    uint32_t frameHeight;
    uint32_t frameRate;
    char filePath[1024];
    
} _recordStruct;

/**
 创建单例
 */
static WLSQXcloulink* defaultManager = nil;

+ (WLSQXcloulink*) sharedManager
{
    if (!defaultManager)
    {
        defaultManager = [[self alloc] init];
    }
    return defaultManager;
}

/**
 获取当前版本
 
 @return 返回版本
 */
- (NSString *)getVersion
{
    return @"demo版本-->version :2018.01.20.203";

}


/**
 获取优载云登录状态  YES 登录  NO 登录失败
 */
- (BOOL)getLoginState
{
    return _LoginState;
}

/**
 添加网络检测切换类工具
 */
- (void)addMonitorNetWorkStateWithWLSQXcloulinkNetWorkStateDelegate:(id<WLSQXcloulinkNetWorkStateDelegate>)netWorkStateDelegate
{
    _netWorkStateDelegate = netWorkStateDelegate;
    [YZYNetWorkState shareMonitorNetWorkState].delegate = self;
    [[YZYNetWorkState shareMonitorNetWorkState] addMonitorNetWorkState];

}


/**
 获取当前网络类型状态
 
 @return YZYNetWorkStateType
 */
- (YZYNetWorkStateType)getWLSQXcloulinkNetWorkStateType
{
    // 获取当前网络类型
    YZYNetWorkStateType currentNetWorkState = [[YZYNetWorkState shareMonitorNetWorkState] getCurrentNetWorkType];
    return currentNetWorkState;
}


/**
 设置优载云登录状态 (一般用于网络切换切换登录状态)
 
 @param LoginBool YES 登录成功  NO 登录失败
 */
- (void)setLoginState:(BOOL)LoginBool
{

    _LoginState = LoginBool;
}

/**
 设置代理,回调消息和媒体数据
 
 @param delegete 代理对象
 @param nSID 订阅设备ID的回调
 */
- (void)setXcloulinkdelegete:(id)delegete
                        nSID:(NSString *)nSID
{
    _delegete = delegete;
    _nSIDSting = nSID;

}


/**
 添加后台操作用于后台重登
 */
- (void)AddBackgroundTaskInvalid
{

    UIApplication* app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });

}


/**
 初始化SDK并且注册回调函数

 @return YES 成功  NO 失败
 */
- (BOOL)initIntelligentEquipment
{
    int type = CDK_InitXCloudLink(1, &xmsgCallBack, &xmediaCallBack);
    _hostMuArray = [NSMutableArray new];
    _LoginState = NO;
    _Capture_state = NO;
    _recordStruct.bNeedRecord = NO;
    return type > 0 ? YES : NO;
    
}

/**
 添加要登录的优载云服务器地址
 
 @param hostString 优载云服务器地址
 @param nPort  优载云服务器端口
 @param hProto  udp(11) / tcp(12)
 @return YES 添加成功  NO 添加失败
 */
- (BOOL)AddXCloudHostWith:(NSString *)hostString
                    nPort:(int)nPort
                   hProto:(int)hProto
{
    NSDictionary *dic = @{@"hostString":hostString,
                               @"nPort":[NSString stringWithFormat:@"%d",nPort],
                              @"hProto":[NSString stringWithFormat:@"%d",hProto]};
    [_hostMuArray addObject:dic];
    
    return YES;
}


/**
 登录优载云(登录前先注销登录)
 
 @param YzyAccount 您申请的优载云开发者中心key
 @param YzyPassword 您申请的优载云开发者中心secret
 @return YES 发送成功  NO 发送失败
 */
- (BOOL)loginWithYzyAccount:(NSString *)YzyAccount
                YzyPassword:(NSString *)YzyPassword
{
    
     [self logoutYZY];
    
    _yzyAccount = YzyAccount;
    _yzyPassword = YzyPassword;
    
    NSInteger leng_Num = _hostMuArray.count;
    XHOSTInfo hostArray[leng_Num];
    
    for (int i = 0; i < _hostMuArray.count; i ++) {
        NSDictionary *dic = _hostMuArray[i];
        NSString *hostString = dic[@"hostString"];
        int nPort = [dic[@"nPort"] intValue];
        int hProto =  [dic[@"hProto"] intValue];
        XHOSTInfo host;
        strcpy( host.aryIP,(char *)hostString.UTF8String);
        host.nPort = nPort;
        host.hProto = hProto;
        hostArray[i] = host;
    }
        
    int type = CDK_LogIn((char *)YzyAccount.UTF8String, (char *)YzyPassword.UTF8String, hostArray , leng_Num);
    return type > 0 ? YES : NO;

}


/**
 重新登录优载云(此方法要先调用loginWithYzyAccount:YzyPassword: 这个方法来存储key和secret,用于重登)
 
 @return YES 发送成功  NO 发送失败
 */
- (BOOL)LoginAgainYZY
{
    if (_yzyAccount && _yzyPassword) {
        
        return [self loginWithYzyAccount:_yzyAccount YzyPassword:_yzyPassword];
    }

    return NO;
}


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
{
    
    NSString *encryption_pass = @"";

    if(encryptionMode == YZYEncryptionModeNo)
    {
    
       encryption_pass = nSIDPassword;
    }
    
    if(encryptionMode == YZYEncryptionModeMD5)
    {
        
        encryption_pass = [self encryptMD5String:nSIDPassword];
    }
    
    
    int type = CDK_Subscribe((char *)nSID.UTF8String, (char *)encryption_pass.UTF8String, 1);
//    NSLog(@"%@",type > 0 ? [NSString stringWithFormat:@"%@订阅成功",nSID]:[NSString stringWithFormat:@"%@订阅失败",nSID]);
    return type > 0 ? YES : NO;

}

/**
 连接设备
 
 @param nSID 设备ID
 @return YES 连接成功  NO 连接失败
 */
- (BOOL)HelloXManSID:(NSString *)nSID
{
    int  type =  CDK_HelloXMan((char *)nSID.UTF8String);
    return type > 0 ? YES : NO;

}
    
#pragma mark -------------  消息回调 -----------------------
static  int xmsgCallBack(unsigned short nMsg, unsigned int hParam, unsigned int lParam, char *pString, unsigned int nSize)
{
    
    //登录成功
    if (nMsg == XCLOUDMSG_LOGINSUCCESS) {
        NSLog(@"======== 登录优载云成功 ===================");
        _LoginState = YES;
        _LoginNum = 0;

    }
    //登录失败
    if(nMsg == XCLOUDMSG_LOGINFAIL){
        
        if (hParam == 0 || hParam == 1 || hParam == 2 || hParam == 3) {
          
            _LoginNum ++;
           
            if(_LoginNum < 4)
            {
                //重新登录
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    [[WLSQXcloulink sharedManager] LoginAgainYZY];
                    
                });
                
            } else {
                
                NSLog(@"======== 登录优载云失败 ===================");
                _LoginNum = 0;
                _LoginState = NO;

            }
            
        }

    }

    //_LoginNum表示为0时 说明登录成功  或者重登四次都失败
    if (_LoginNum == 0) {
        
        if ( [_delegete respondsToSelector:@selector(xmsgCallBack:hParam:lParam:withpString:withiLen:)]) {
            [_delegete xmsgCallBack:nMsg hParam:hParam lParam:lParam withpString:pString withiLen:nSize];
        }

    }
   
    return 1;
    
}

#pragma mark -------------  多媒体数据回调 -----------------------
static void xmediaCallBack(unsigned int nSID, unsigned short MediaType, unsigned short hParam, unsigned short lParam, char *pBuf, unsigned int nBuflen)
{
    
//     NSLog(@"************* nSID:%d MediaType:%d  hParam :%d lParam:%d nBuflen:%u ***************",nSID,MediaType,hParam,lParam,nBuflen);
    
    //把视频数据送去解码池解码 _XCLOUDRES_H264_2 标清  _XCLOUDRES_H264_1 高清视频  _XCLOUDRES_FILE_VODVIDEO  SD卡录像视频回调
    if(MediaType == _XCLOUDRES_H264_1 || MediaType == _XCLOUDRES_H264_2 || MediaType == _XCLOUDRES_FILE_VODVIDEO)
    {
        
        
        //播放sd卡模式不能MOV录像
        if(_recordStruct.bNeedRecord && MediaType != _XCLOUDRES_FILE_VODVIDEO)
        {
            
            if (_recordStruct.bWaitKeyFrame && hParam == 1) {
                _recordStruct.bWaitKeyFrame = NO;
            }
            
            if (_recordStruct.bWaitKeyFrame == NO) {
                
                Mov_Record_Write_Video((unsigned char *)pBuf, (int)nBuflen, hParam == 1);
            }
            
        }
        
        

        
        HWMediaInfoStruct stru;
        stru.mediaData = (unsigned char*)pBuf ;
        stru.length = nBuflen;
        stru.starTime = 0;
        stru.time = lParam;
        stru.resolution = HWResolutionMode_Q720P;
        stru.mediaType = HWMediaType_H264;
        if (hParam == 1) {
            stru.frameType = HWMediaFrameType_IFrame;
        } else {
            stru.frameType = HWMediaFrameType_PFrame;
        }
        
        stru.frameID = hParam;
       
        //sd卡视频解码
        if(MediaType == _XCLOUDRES_FILE_VODVIDEO)
        {
            _hwDecoder_SDPlay.MediaType =  MediaType;
            [_hwDecoder_SDPlay starDecode];
            [_hwDecoder_SDPlay pushMediaData:stru];
        }
        
        //视频解码
        if(MediaType == _XCLOUDRES_H264_1 || MediaType == _XCLOUDRES_H264_2)
        {
            
            //等待I帧
            if(_waitIfarmre && hParam == 1)
            {
                _waitIfarmre = NO;
            }
            
            if (!_waitIfarmre) {
                
                _hwDecoder.MediaType =  MediaType;
                [_hwDecoder starDecode];
                [_hwDecoder pushMediaData:stru];
            
            }
       
        }
    
      
        
    }
    
    
    //直播音频
     if(MediaType == _XCLOUDRES_G711a)
    {
        
        
        if(_recordStruct.bNeedRecord )
        {
            //MOV声音录像
            short *m_pPCMBuffer = NULL;
            m_pPCMBuffer = malloc(nBuflen * 2);
            int leg  = G711XDecoder((unsigned char*)pBuf, m_pPCMBuffer, nBuflen, lParam);
            
            Mov_Record_Write_Audio((unsigned char *)m_pPCMBuffer, (int)leg, 0);
            free(m_pPCMBuffer);
       
        }
        
        short *outpcm = NULL;
        outpcm = malloc(nBuflen * 2);
        int leg  = G711XDecoder((unsigned char*)pBuf, outpcm, nBuflen, lParam);
        
        if ( [_delegete respondsToSelector:@selector(didListeningWithpBuf:withnBuflen:)]) {

            [_delegete didListeningWithpBuf:(unsigned char*)outpcm withnBuflen:leg];

        }
        
        free(outpcm);
        
    }
    
    //TF卡音频
    if(MediaType == _XCLOUDRES_FILE_VODAUDIO)
    {
        

        short *outpcm = NULL;
        outpcm = malloc(nBuflen * 2);
        int leg  = G711XDecoder((unsigned char*)pBuf, outpcm, nBuflen, lParam);
     
        if ( [_delegete respondsToSelector:@selector(didListening_IF_WithpBuf:withnBuflen:)]) {
            
            [_delegete didListening_IF_WithpBuf:(unsigned char*)outpcm withnBuflen:leg];
            
        }
        
        free(outpcm);
        
    }
    
    
    if ( [_delegete respondsToSelector:@selector(xmediaCallBack:withmediaType:withhParam:withlParam:withpBuf:withnBuflen:)]) {
       
        [_delegete xmediaCallBack:nSID withmediaType:MediaType withhParam:hParam withlParam:lParam withpBuf:pBuf withnBuflen:nBuflen];
    
    }
    
  
    
}

#pragma mark ----------------- 视频硬解码成功回调 -----------------------------
- (BOOL)didHardDecodePixelBuffer:(CVPixelBufferRef)pixBuffer SamplePhotoBuffer:(CMSampleBufferRef)samplePhotoBuffer forSessionID:(NSUInteger)sessionID mediaType:(NSUInteger)mediaType
{
    if(pixBuffer) {
   
        if ([_delegete respondsToSelector:@selector(didHardDecodePixelBuffer:SamplePhotoBuffer:sessionID:mediaType:)]) {
            
            if(_Capture_state && (mediaType == _XCLOUDRES_H264_1 || mediaType == _XCLOUDRES_H264_2))
            {
                _Capture_state = NO;
              
                UIImage *image = [self imageFromSampleBuffer:pixBuffer];
              
                if ([_delegete respondsToSelector:@selector(getCaptureWithimage:)]) {
                  
                    [_delegete getCaptureWithimage:image];
               
                }
                
            }
            
            [_delegete didHardDecodePixelBuffer:pixBuffer SamplePhotoBuffer:samplePhotoBuffer sessionID:(int)sessionID mediaType:(int)mediaType];
            
        }
        
    }
 
    return YES;
    
}


/**
 注销登录
 
 @return 退出成功  NO 退出失败
 */
- (BOOL)logoutYZY
{
    int type = CDK_LogOut();
    return type > 0 ? YES : NO;
}


/**
 自定义发送的消息(订阅成功才能发送)
 
 @param nSID 要发送消息的设备id
 @param nMessage 默认传0，备用
 @param Messagen 要发送的任何消息，可以透传
 @return YES 发送成功  NO 发送成功
 */
- (BOOL)CDK_PostXMessagenWithnSID:(NSString *)nSID
                         nMessage:(int)nMessage
                          pString:(NSString *)pString
{

    int type =  CDK_PostXMessage((char *)nSID.UTF8String, nMessage, (char *)pString.UTF8String);
    return type > 0 ? YES : NO;

}

/**
 系统化格式类型发送消息(订阅成功才能发送,透传)
 
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
{

    NSDictionary *devices = @{@"device_id":sudDevice_id,
                              @"device_type":@([sudDevice_type integerValue]),
                              @"services":services_dic
                              };
    
    NSArray *array = @[devices];
    
    NSDictionary *dic = @{@"msg_id":@([msg_id integerValue]),
                          @"msg_type":msg_type,
                          @"device_id":device_id,
                          @"device_type":@([device_type integerValue]),
                          @"devices":array
                          };
    
    NSString *str = [dic JSONString];
    

    int type =  CDK_PostXMessage((char *)device_id.UTF8String, 0, (char *)str.UTF8String);
    return type > 0 ? YES : NO;
  
}


/**
 通过优载云传输多媒体数据，比方说A端录音编码之后传输给设备B
 
 @param openSession       CDK_OpenSession返回的会话句柄，如果是录音CDK_OpenSession的nRW就是
 @param nResType  要传输的多媒体类型，_XCLOUDRES_H264_1 高清视频,_XCLOUDRES_H264_2 标清视频,_XCLOUDRES_G711a 音频
 @param iFreamType 帧类型
 @param lparam  默认传0
 @param pMediaBuffer 要传输给优载云的经过G711XEncode编码后的音频
 @param nMediaBufferSize 经过G711XEncode编码后的数据长度
 @return YES 发送成功  NO 发送成功
 
 */
- (BOOL)CDK_SendMediaDataWithopenSession:(unsigned int)openSession
                                nResType:(unsigned short)nResType
                              iFreamType:(unsigned char )iFreamType
                                  lparam:(unsigned short)lparam
                            pMediaBuffer:(char *)pMediaBuffer
                        nMediaBufferSize:(unsigned int)nMediaBufferSize
{
    
    
    int type =  CDK_SendMediaData(openSession, nResType, iFreamType, lparam, pMediaBuffer, nMediaBufferSize);
    return type > 0 ? YES : NO;

}


/**
 打开会话(视频,音频)CDK_OpenSession和CDK_CloseSession必须成对出现
 
 @param nSID 目标设备ID
 @param nResType 多媒体类型，_XCLOUDRES_H264_1 高清视频,_XCLOUDRES_H264_2 标清视频,_XCLOUDRES_G711a音频
 @param nRW   读还是写 _XLOUDRES_OPT_READ 表示播放音视频  _XLOUDRES_OPT_WRITE 表示录音或者录制视频
 @return 此返回值是CDK_CloseSession要关闭的参数nSessionID
 */
- (int)CDK_OpenSessionWithnSID:(NSString *)nSID
                      nResType:(unsigned short)nResType
                           nRW:(unsigned short)nRW
{

    if(nResType == _XCLOUDRES_H264_1 || nResType == _XCLOUDRES_H264_2)
    {
        
        _waitIfarmre = YES;
        //硬解码视频数据
        [_hwDecoder stopDecode];
        _hwDecoder = [[HWDecoder alloc]initAsHardMediaDecoderWithDelegate:self];
        _hwDecoder.sessionID =  CDK_OpenSession((char *)nSID.UTF8String,nResType,nRW);
         return (int)_hwDecoder.sessionID;
        
    }
    
  return  CDK_OpenSession((char *)nSID.UTF8String,nResType,nRW);
    
}

/**
 关闭会话(视频,音频) CDK_OpenSession和CDK_CloseSession必须成对出现，两个方法的nSessionID和nResType要一样才能被关闭对应的流
 
 @param nSessionID 目标设备ID，CDK_OpenSession的返回值
 @param nResType  媒体类型，_XCLOUDRES_H264_1 高清视频,_XCLOUDRES_H264_2 标清视频,_XCLOUDRES_G711a音频
 @return YES 成功  NO 成功
 */
- (BOOL)CDK_CloseSessionWithnSessionID:(unsigned int)nSessionID
                              nResType:(unsigned short)nResType;
{

    if(nResType == _XCLOUDRES_H264_1 || nResType == _XCLOUDRES_H264_2)
    {
        //硬解码视频数据
        [_hwDecoder stopDecode];

    }
    int type =  CDK_CloseSession(nSessionID, nResType);
    return type > 0 ? YES : NO;

}

/**
 读取TF卡录像视频文件数据
 
 @param nSID 目标设备ID
 @param strFilename TF卡录像地址
 @param nResType 媒体类型，_XCLOUDRES_H264_1 高清视频,_XCLOUDRES_H264_2 标清视频,_XCLOUDRES_G711a音频
 @param nRW 读还是写 _XLOUDRES_OPT_READ 表示播放音视频  _XLOUDRES_OPT_WRITE 表示录音或者录制视频
 @return 此返回值是CDK_CloseXCloudFile要关闭的参数nSessionID
 */
- (int)CDK_OpenXCloudFileWithnSID:(NSString *)nSID
                      strFilename:(NSString *)strFilename
                         nResType:(unsigned short)nResType
                              nRW:(unsigned short)nRW
{

    if(nResType == _XCLOUDRES_FILE_VODVIDEO)
    {
        
        _waitIfarmre = YES;
        //硬解码视频数据
        [_hwDecoder_SDPlay stopDecode];
        _hwDecoder_SDPlay = [[HWDecoder alloc]initAsHardMediaDecoderWithDelegate:self];
        _hwDecoder_SDPlay.sessionID =  CDK_OpenXCloudFile((char *)nSID.UTF8String, (char *)strFilename.UTF8String, nResType, nRW);
        return (int)_hwDecoder_SDPlay.sessionID;

    }
 
     return CDK_OpenXCloudFile((char *)nSID.UTF8String, (char *)strFilename.UTF8String, nResType, nRW);

}

/**
 关闭读取TF卡录像视频文件数据 CDK_OpenXCloudFile和CDK_CloseXCloudFile必须成对出现，两个方法的nSessionID和nResType要一样才能被关闭对应的流
 
 @param nSessionID 目标设备ID，CDK_OpenXCloudFile的返回值
 @param nResType  媒体类型，_XCLOUDRES_FILE_VODVIDEO
 @return YES 成功  NO 成功
 */
- (BOOL)CDK_CloseXCloudFileWithnSessionID:(unsigned int)nSessionID
                                 nResType:(unsigned short)nResType
{
    if(nResType == _XCLOUDRES_FILE_VODVIDEO)
    {
        //硬解码视频数据
        [_hwDecoder_SDPlay stopDecode];
  
    }

     int type = CDK_CloseXCloudFile(nSessionID, nResType);
     return type >= 0 ? YES : NO;

}

/**
 抓拍图片
 
 @return 抓拍图片
 */
- (void)getCapture
{
    
    _Capture_state = YES;

}

- (UIImage *) imageFromSampleBuffer:(CVPixelBufferRef)pixelBuffer
{
    
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext
                             createCGImage:ciImage
                             fromRect:CGRectMake(0, 0,
                                                 CVPixelBufferGetWidth(pixelBuffer),
                                                 CVPixelBufferGetHeight(pixelBuffer))];
    
    UIImage *uiImage = [UIImage imageWithCGImage:videoImage];
    CGImageRelease(videoImage);
    return uiImage;
    
}


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
{
    if (!_recordStruct.bNeedRecord) {
    
        memset(_recordStruct.filePath, 0, sizeof(_recordStruct.filePath));
        strcpy(_recordStruct.filePath, pFilePath.UTF8String);
        _recordStruct.bWaitKeyFrame = YES;
        _recordStruct.frameWidth = iWidth;
        _recordStruct.frameHeight = iHeight;
        _recordStruct.frameRate = framerate;
        Mov_Record_Init(_recordStruct.frameWidth, _recordStruct.frameHeight, framerate, audio);
        int type = Mov_Record_Open(pFilePath.UTF8String);
        _recordStruct.bNeedRecord = YES;
      
        return type >= 0 ? YES : NO;
        
        
    } else {
    
        _recordStruct.bNeedRecord = NO;
        return NO;
    
    }
    
   
    
}


/**
 关闭Mov文件(退出控制器要关闭录制)
 
 @return YES 成功  NO 成功
 */
- (BOOL)CDK_Mov_Record_Close
{
    
   _recordStruct.bNeedRecord = NO;
    int type = Mov_Record_Close();
    return type >= 0 ? YES : NO;

}


// ************************************************************************************


/**
 开启局域网搜索广播

 @param nRecPort WiFi端口(3252)
 @param nSndPort 自己端口(3251)
 @return  @return YES 成功  NO 成功
 */
- (BOOL)CDK_XBroadcastOpenWithnRecPort:(unsigned short)nRecPort
                              nSndPort:(unsigned short)nSndPort
{
    int type = CDK_XBroadcastOpen(nRecPort,nSndPort);
    return type >= 0 ? YES : NO;
}


/**
 发起局域网搜索广播
 
 @return YES 成功  NO 成功
 */
- (BOOL)CDK_XBroadcast
{
    
    NSString *ip =[self getDeviceIPIpAddresses];
    
    //获取夏令时
    NSTimeZone *stZone = [NSTimeZone systemTimeZone];
    BOOL isDST = [stZone isDaylightSavingTime];
    
    //获取当前时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone] ;///获取当前时区信息
    NSInteger sourceGMTOffset = ([destinationTimeZone secondsFromGMTForDate:[NSDate date]] -  (isDST == YES ? 3600 : 0));///获取偏移秒数
    NSInteger  localTimeZone = sourceGMTOffset/3600;
    NSString *localTimeZoneString = [NSString stringWithFormat:@"%@",localTimeZone > 0 ? [NSString stringWithFormat:@"+%zd",localTimeZone] : [NSString stringWithFormat:@"%zd",localTimeZone]];
    NSLog(@"系统的时区 = %@",localTimeZoneString);///除以3600即可获取小时数，即为当前时区
    
    NSDictionary *dic = @{@"msg_id":@([[self getDatetimeString] intValue]),
                          @"msg_type":@"lan_discovery",
                          @"timestamp":[self getDatetimeString],
                          @"timezone":localTimeZoneString,
                          @"dst":isDST == YES ? @"on" : @"off"
                          };
    NSString *string = [dic JSONString];
    //发送数据
    int type = CDK_XBroadcast((char *)ip.UTF8String, (char *)string.UTF8String, string.length);

    return type >= 0 ? YES : NO;

}


/**
 关闭搜索退出局域网广播
 
 @return YES 成功  NO 成功
 */
- (BOOL)CDK_XBroadcastClose
{
    int type = CDK_XBroadcastClose();
    return type >= 0 ? YES : NO;

}

/**
 查询是否优载云ID设备
 
 @param nSID ID
 @param nReserve 1
 @return 返回 2 是优载云ID  查询
 */
- (int)CDK_GetCompanyByIDWithnSID:(NSString *)nSID
                         nReserve:(unsigned short)nReserve
{
    return CDK_GetCompanyByID((char *)nSID.UTF8String, nReserve);
    
}

/**
 转换ID
 
 @param nID hParam 通过hParam转换成设备ID
 @return 设备ID
 */
- (NSString *)CDK_CDK_GetDevNameByIDWithnID:(unsigned int)nID
{
    
    char device_char[256]={0};
    CDK_GetDevNameByID(nID, device_char);
    return [NSString stringWithUTF8String:device_char];
}

/**
 查询报警列表能力值特征值代码
 
 @return  查询报警列表能力值特征值代码
 */
- (NSString *)CDK_Queryalarm_typewith:(NSDictionary *)dic_alarm
{
    
    NSArray* alarm_key_array = [dic_alarm allKeys];
    
    NSString *key_string =  [NSString stringWithFormat:@"%@",alarm_key_array.firstObject];
    
    NSDictionary *new_dic = dic_alarm[key_string];
    
    NSArray* new_dic_key_array = [new_dic allKeys];
    
    //如果是移动侦测报警类型
    if ([key_string isEqualToString:@"motion_detection"]) {
        
        for (NSString *key_string in new_dic_key_array) {
            
            //移动测试报警
            if ([key_string isEqualToString:@"alarm"]) {
                
                return @"alarm";
            }
            
            //关闭移动侦测 / 开启移动侦测
            if ([key_string isEqualToString:@"on_off"]) {
                
                return @"on_off";
                
            }
            
        }
        
    }
    
    return nil;
}


/**
 对NSDictionary进行md5加密
 
 @param string 未加密的字符串
 @return md5加密后的字符串
 */
- (NSString*)encryptMD5String:(NSString *)string
{
    const char *cStr = [string UTF8String];
    unsigned char result[16];
    
    NSNumber *num = [NSNumber numberWithUnsignedLong:strlen(cStr)];
    CC_MD5( cStr,[num intValue], result );
    
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             
             result[0], result[1], result[2], result[3],
             
             result[4], result[5], result[6], result[7],
             
             result[8], result[9], result[10], result[11],
             
             result[12], result[13], result[14], result[15]
             
             ] uppercaseString];

}

/**
 获取手机ip地址
 
 @return 返回获取手机ip地址
 */
- (NSString *)getDeviceIPIpAddresses

{
    
    int sockfd =socket(AF_INET,SOCK_DGRAM, 0);
    
    //    if (sockfd <</span> 0) return nil;
    
    NSMutableArray *ips = [NSMutableArray array];
    
    
    
    int BUFFERSIZE =4096;
    
    struct ifconf ifc;
    
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    
    struct ifreq *ifr, ifrcopy;
    
    ifc.ifc_len = BUFFERSIZE;
    
    ifc.ifc_buf = buffer;
    
    if (ioctl(sockfd,SIOCGIFCONF, &ifc) >= 0){
        
        for (ptr = buffer; ptr < buffer + ifc.ifc_len; ){
            
            ifr = (struct ifreq *)ptr;
            
            int len =sizeof(struct sockaddr);
            
            if (ifr->ifr_addr.sa_len > len) {
                
                len = ifr->ifr_addr.sa_len;
                
            }
            
            ptr += sizeof(ifr->ifr_name) + len;
            
            if (ifr->ifr_addr.sa_family !=AF_INET) continue;
            
            if ((cptr = (char *)strchr(ifr->ifr_name,':')) != NULL) *cptr =0;
            
            if (strncmp(lastname, ifr->ifr_name,IFNAMSIZ) == 0)continue;
            
            memcpy(lastname, ifr->ifr_name,IFNAMSIZ);
            
            ifrcopy = *ifr;
            
            ioctl(sockfd,SIOCGIFFLAGS, &ifrcopy);
            
            if ((ifrcopy.ifr_flags &IFF_UP) == 0)continue;
            
            
            
            NSString *ip = [NSString stringWithFormat:@"%s",inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
            
            [ips addObject:ip];
            
        }
        
    }
    
    close(sockfd);
    
    
    
    
    
    NSString *deviceIP =@"";
    
    for (int i=0; i < ips.count; i++)
        
    {
        
        if (ips.count >0)
            
        {
            
            deviceIP = [NSString stringWithFormat:@"%@",ips.lastObject];
            
            
            
        }
        
    }
    
//    NSLog(@"deviceIP========%@",deviceIP);
    return deviceIP;
    
}

/**
 获取系统当前的时间戳
 
 @return 返回时间戳
 */
- (NSString *)getDatetimeString
{
    //获取系统当前的时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    return timeString;

}

/**
 获取系统当前的时间戳(毫秒级)
 
 @return 返回时间戳(毫秒级)
 */
- (NSString *)getDatetimeHaoMiaoString
{
    
    //获取系统当前的时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970] * 1000;
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    return timeString;
    
    
}

/**
 Json数据转字NSDictionary
 
 @param string Json数据
 @return NSDictionary
 */
- (NSDictionary *)JSONKitString:(NSString *)string
{
    if(string == nil)
    {
        return NULL;
    }
    
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    
    return dic;

}

- (NSString *)ReplacingNewLineAndWhitespaceCharactersFromJson:(NSString *)JsonStr
{
    
    NSScanner *scanner = [[NSScanner alloc] initWithString:JsonStr];
    [scanner setCharactersToBeSkipped:nil];
    NSMutableString *result = [[NSMutableString alloc] init];
    
    NSString *temp;
    NSCharacterSet*newLineAndWhitespaceCharacters = [ NSCharacterSet newlineCharacterSet];
    // 扫描
    while (![scanner isAtEnd])
    {
        temp = nil;
        [scanner scanUpToCharactersFromSet:newLineAndWhitespaceCharacters intoString:&temp];
        if (temp) [result appendString:temp];
        
        // 替换换行符
        if ([scanner scanCharactersFromSet:newLineAndWhitespaceCharacters intoString:NULL]) {
            if (result.length > 0 && ![scanner isAtEnd]) // Dont append space to beginning or end of result
                [result appendString:@"|"];
        }
    }
    return result;
}


#pragma mark 网络监听的代理方法，当网络状态发生改变的时候触发
- (void)netWorkStateChanged{
    
    
    //当网络状态改变要把优载云登录状态值为NO
    _LoginState = NO;
    
    // 获取当前网络类型
    YZYNetWorkStateType currentNetWorkState = [[YZYNetWorkState shareMonitorNetWorkState] getCurrentNetWorkType];
    
    if ([_netWorkStateDelegate respondsToSelector:@selector(WLSQXcloulinkNetWorkStateChangedStateType:)]) {
        
         [_netWorkStateDelegate WLSQXcloulinkNetWorkStateChangedStateType:currentNetWorkState];
        
    }
    
}


@end
