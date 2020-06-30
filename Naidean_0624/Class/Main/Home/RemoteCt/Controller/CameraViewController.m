//
//  CameraViewController.m
//  Naidean
//
//  Created by xujun on 2018/7/30.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "CameraViewController.h"

///优载云
#import <AVFoundation/AVFoundation.h>  //包含类 AVPlayer
//#import "APPLEAGView.h"
#import "YZYRecordPCMPlayer.h"

#import "WLSQCameraControl.h"//控制摄像头类


@interface CameraViewController ()<WLSQXcloulinkDelegete,YZYRecordPCMPlayerDelegete,APPLEAGViewDelegate>
{
    int voice_SessionType;//视频SessionType
    int listen_SessionType;//听SessionType
    int speak_SessionType;//说SessionType
    
    APPLEAGView  *_aapLEAGView;//视频播放
    
    UIImageView *_bgImageView;
    
    YZYRecordPCMPlayer *_yzyRecordPCMPlayer;//语音通话类
    
    WLSQCameraControl *_wlsqCameraControl;//摄像头基础
    
}


@property (nonatomic,strong) NSString *gateway_uid;
@property (nonatomic,strong) NSString *gateway_pwd;
@property (nonatomic,strong) NSString *type_code;//!< 设备类型

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"摄像头";
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
//    _gateway_uid = @"wlsq3016113spb";
//    _gateway_pwd = @"158500";
//    _gateway_uid = @"wlsq235070nuqf";
//    _gateway_pwd = @"600381";
    _gateway_uid = self.device.uid;
    _gateway_pwd = self.device.password;
    //摄像头基础控制类(实现摄像头控制器基础控制)
    _wlsqCameraControl = [[WLSQCameraControl alloc]initWithnSID:_gateway_uid device_type:@"12"];
    
    //初始化视频绘制
    _aapLEAGView = [[APPLEAGView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, getHeight(300))];
    [_aapLEAGView setbgimage:[UIImage imageNamed:@"btn_tianjia"]];
    _aapLEAGView.delegate = self;
    [self.view addSubview:_aapLEAGView];
    
    //获取网络状态
    YZYNetWorkStateType type = [[WLSQXcloulink sharedManager] getWLSQXcloulinkNetWorkStateType];
    //网络处于gprs状态时不自动播放
    if (type == YZYNetWorkStateTypeGPRS) {
        
        [_aapLEAGView setAPPLEAGViewStateType:APPLEAGViewStateTypeGPRS];
        
    } else  if (type == YZYNetWorkStateTypeWIFI) {
        
        [_aapLEAGView setAPPLEAGViewStateType:APPLEAGViewStateTypeWIFI];
        
        [[WLSQXcloulink sharedManager] SubscribenSID:_gateway_uid nSIDPassword:_gateway_pwd encryptionMode:YZYEncryptionModeMD5 nOption:1];
    } else {
        
        [_aapLEAGView setAPPLEAGViewStateType:APPLEAGViewStateTypeNoconnect];
    }
    
    //网络改变的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(YZYnetWorkStateChanged:) name:@"NDA_NetWorkStateTypeChanged" object:nil];
}

/**
 当网络状态发生改变要进行重新登录和订阅
 
 */
- (void)YZYnetWorkStateChanged:(NSNotification *)noti
{
    NSLog(@"网络状态发生改变要进行重新登录和订阅");
    [self clearVC];
    //网络处于gprs状态时不自动播放
    if ([noti.object intValue] == YZYNetWorkStateTypeGPRS) {
        [_aapLEAGView setAPPLEAGViewStateType:APPLEAGViewStateTypeGPRS];
        //重新登录优载云
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[WLSQXcloulink sharedManager] LoginAgainYZY];
        });
    } else  if ([noti.object intValue]  == YZYNetWorkStateTypeWIFI) {
        [_aapLEAGView setAPPLEAGViewStateType:APPLEAGViewStateTypeWIFI];
        //重新登录优载云
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[WLSQXcloulink sharedManager] LoginAgainYZY];
        });
        
    } else {
        [_aapLEAGView setAPPLEAGViewStateType:APPLEAGViewStateTypeNoconnect];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[WLSQXcloulink sharedManager] setXcloulinkdelegete:self nSID:_gateway_uid];
}

#pragma mark --------------------------- APPLEAGViewDelegate -------------
//流量网络状态下，点击播放按钮代理事件
- (void)playAPPLEAGView
{
    [[WLSQXcloulink sharedManager] SubscribenSID:_gateway_uid nSIDPassword:_gateway_pwd encryptionMode:YZYEncryptionModeMD5 nOption:1];
    [self HelloXManSID];
}

//连接设备 打开视频
- (void)HelloXManSID
{
    
    [[WLSQXcloulink sharedManager] HelloXManSID:_gateway_uid];
    
    //视频
    voice_SessionType = [[WLSQXcloulink sharedManager] CDK_OpenSessionWithnSID:_gateway_uid nResType:_XCLOUDRES_H264_1 nRW:_XCLOUDRES_OPT_READ];
    NSLog(@"***********打开视频:%d",voice_SessionType);
    
}

#pragma mark ---------------------- WLSQXcloulinkDelegete  --------------------------------------
/**
 消息回调 优载云的消息回调函数,hParam设备能力描述
 
 @param nMsg       回调的消息类型
 @param hParam     随着nMsg的不同会有不同的含义，消息回调的参数说明
 @param lParam     随着nMsg的不同会有不同的含义，消息回调的参数说明
 @param pString    详细的命令说明，可以是json等任何自定义数据
 @param iLen       pString的长度
 */
- (void)xmsgCallBack:(int)nMsg hParam:(int)hParam lParam:(int)lParam withpString:(char *)pString withiLen:(int)iLen
{
    NSLog(@"deviceStatus--WLSQXcloulinkDelegete:%d\n%s",nMsg,pString);
    //登录成功
    if (nMsg == XCLOUDMSG_LOGINSUCCESS) {
        //订阅设备
        [[WLSQXcloulink sharedManager] SubscribenSID:_gateway_uid nSIDPassword:_gateway_pwd encryptionMode:YZYEncryptionModeMD5 nOption:1];
        
    }
    
    //登录失败
    if(nMsg == XCLOUDMSG_LOGINFAIL){
        
        DDLog(@"***************登录失败");
        [_aapLEAGView setAPPLEAGViewStateType:APPLEAGViewStateTypeNotLine];
    }
    
    //设备在线
    if(nMsg == XCLOUDMSG_MANONLINE)
    {
        DDLog(@"设备重新上线");
    }
    //设备离线
    if(nMsg == XCLOUDMSG_MANOFFLINE)
    {
        //设备单相给回调说明
        DDLog(@"当前设备离线");
        dispatch_async(dispatch_get_main_queue(), ^{
            [_aapLEAGView setAPPLEAGViewStateType:APPLEAGViewStateTypeNotLine];
        });
    }
    
    //订阅成功
    if (nMsg == XCLOUDMSG_SUBSCRIBESUCCESS) {
        NSString *strBuf = [NSString stringWithUTF8String:pString];
        [self procWanDevicekalarminfo:strBuf nMsg:XCLOUDMSG_SUBSCRIBESUCCESS];
        DDLog(@"订阅成功");
    }
    
    //订阅失败
    if (nMsg == XCLOUDMSG_SUBSCRIBEFAIL) {
        
        NSString *strBuf = [NSString stringWithUTF8String:pString];
        [self procWanDevicekalarminfo:strBuf nMsg:XCLOUDMSG_SUBSCRIBEFAIL];
        NSLog(@"订阅失败");
    }
    
    
    //透传
    if (nMsg == XCLOUDMSG_TRANSALT) {
        
        DDLog(@"透传");
    }
}

#pragma mark --------------------------- 订阅成功/失败 消息回调处理 -------------------------------------
- (void)procWanDevicekalarminfo:(NSString *)pString nMsg:(int)nMsg
{
    if(nMsg == XCLOUDMSG_SUBSCRIBESUCCESS || nMsg == XCLOUDMSG_SUBSCRIBEFAIL)
    {
        
        NSDictionary *dic = [[WLSQXcloulink sharedManager] JSONKitString:pString];
        NSLog(@"收到回调:%@",dic);
        NSString *gateway_uid = [NSString stringWithFormat:@"%@",dic[@"product_uid"]];
        [[WLSQXcloulink sharedManager] HelloXManSID:gateway_uid];
        //说明密码错误
        if ([dic[@"error_code"] integerValue] == 1) {
            
            DDLog(@"密码错误");
            
        } else {
            
            //说明设备在线离线状态 0:离线 1:在线
            if ([dic[@"product_status"] integerValue] == 1) {
                //打开视频
                if ([[WLSQXcloulink sharedManager] getWLSQXcloulinkNetWorkStateType] == YZYNetWorkStateTypeWIFI) {
                    [self HelloXManSID];
                }
            }else if([dic[@"product_status"] integerValue] == 0){
                DDLog(@"设备离线");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_aapLEAGView setAPPLEAGViewStateType:APPLEAGViewStateTypeNotLine];
                    [MBProgressHUD showTipMessageInView:@"当前设备不在线"];
                });
            }
        }
        
    }
    
}

/**
 解码后的视频数据返回
 
 @param pixBuffer 解码后的视频数据
 @param samplePhotoBuffer 解码后的视频数据
 @param sessionID 对应打开视频的会话ID
 @param mediaType 类型
 */
- (void)didHardDecodePixelBuffer:(CVPixelBufferRef)pixBuffer SamplePhotoBuffer:(CMSampleBufferRef)samplePhotoBuffer sessionID:(int)sessionID mediaType:(int)mediaType
{
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        
        if (sessionID == voice_SessionType  && ( mediaType == _XCLOUDRES_H264_1 ||  mediaType == _XCLOUDRES_H264_2)) {
            
            _aapLEAGView.pixelBuffer = pixBuffer;
        }
        
    });
}

-(void)dealloc{
    [self clearVC];
    
    NSLog(@"*************** YTJDemoVC释放");
}

- (void)clearVC
{
    //关闭视频流
    [[WLSQXcloulink sharedManager] CDK_CloseSessionWithnSessionID:voice_SessionType nResType:_XCLOUDRES_H264_1];
    //关闭视频Mov录制
    [[WLSQXcloulink sharedManager] CDK_Mov_Record_Close];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
