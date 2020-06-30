//
//  ViewController.m
//  VideoDemo
//
//  Created by zhaogenghuai on 2018/12/24.
//  Copyright © 2018年 zhaogenghuai. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "SHIXCommonProtocol.h"
#import "SHIXGLController.h"
#import "APICommon.h"
#import "SearchDVS.h"
#import "echo.h"

#ifndef SAFE_DELETE
#define SAFE_DELETE(p)\
{\
if((p) != NULL)\
{\
delete (p);\
(p) = NULL;\
}\
}
#endif

/*
 关于配网的三种方式
 
 1.手机生产需要配置的WIFI信息的二维码，二维码格式为{"ssid":"zmg1994","password":"123456"}
 
 2.AP配网，流程是  连接设备热点   然后将需要配置的WIFI信息通过TCP设置过去  ，设置成功，设备会返回设备ID
 协议 jason协议
 设备AP连接时的IP：192.168.43.1   端口：11111
 
 AP配网流程  1.  先连接要配置的WIFI ，软件缓存起来   2.跳转到系统设置，选择设备热点   3.返回软件，直接TCP将前面的要配置的WIFI 发送到设备    5.设备连接上网络   热点会自动关掉
 
 NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
 [parameters setValue:@"set_wifi" forKey:@"pro"];
 [parameters setValue:[NSNumber numberWithInt:114] forKey:@"cmd"];
 [parameters setValue:@"admin" forKey:@"user"];
 [parameters setValue:@"" forKey:@"pwd"];
 [parameters setValue:wifissid forKey:@"wifissid"];
 [parameters setValue:wifipwd forKey:@"wifipwd"];
 NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
 NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
 [appDelegate SHIX_SendTrans:@"IKB000000MMEEC" SEND:str];

 3.Hilink配网，暂时不用
 
 **/


/*
 关于开锁协议，  锁按呼叫键后  value=1是开锁   value=0 是挂断
 
 NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
 [parameters setValue:@"lock_control" forKey:@"pro"];
 [parameters setValue:[NSNumber numberWithInt:119] forKey:@"cmd"];
 [parameters setValue:@"admin" forKey:@"user"];
 [parameters setValue:@"" forKey:@"pwd"];
 [parameters setValue:[NSNumber numberWithInt:1] forKey:@"value"];
 
 **/



#define ISUSEOPENGL 1

@interface ViewController ()<SHIXCommonProtocol,EchoDelegate>
{
     AppDelegate *appDelegate;
     SHIXGLController *shixView;
       CSearchDVS *m_pSearchDVS;
     NSTimer *searchTimer;
    BOOL isAudio;
     echo *test;
}
@property (nonatomic,retain) UIImageView *testimageView;

@property(nonatomic,copy)NSString *did;
@end

@implementation ViewController
@synthesize labelStatus;
@synthesize labelTest;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
// IKB000103CMVHF
//  IKB000120TTKGV 
//    IKB000000MMEEC
    self.did = @"IKB000000MMEEC";
    m_pSearchDVS = NULL;
    isAudio = NO;
#if ISUSEOPENGL
    shixView = [[SHIXGLController alloc] init];
    shixView.view.frame = CGRectMake(50, 50, 300, 200);
    [self.view addSubview:shixView.view];
#else
    self.testimageView = [[UIImageView alloc] init];
    self.testimageView.frame =CGRectMake(50, 50, 300, 200);
    [self.view addSubview:self.testimageView];
#endif
    
    test = [[echo alloc]initWithContext:self LOG:NO];
    [test initEcho];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    if (test!=nil) {
        [test stopEcho];
        [test unInitEcho];
        test = nil;
        
    }
}

-(IBAction)BtnAudio:(id)sender{
    /***
    监听，播放设备音频数据。。。。。。测试时 请先请求视频
     ****/
      [test startEcho:1];
    if (isAudio) {
        isAudio = NO;
        [appDelegate SHIX_StopAudio:self.did];
    }else{
        isAudio = YES;
        [appDelegate SHIX_StartAudio:self.did];
        // [test ControlAudioType:2];
    }
}

-(IBAction)BtnTalkDown:(id)sender{
    /***
     对讲，发送手机音频数据到设备。。。。。。测试时 请先请求视频
     ****/
    [appDelegate SHIX_StartTalk:self.did];
      [test ControlAudioType:2];
}

-(IBAction)BtnTalkUp:(id)sender{
    /***
     对讲，发送手机音频数据到设备。。。。。。测试时 请先请求视频
     ****/
     [appDelegate SHIX_StopTalk:self.did];
     [test ControlAudioType:1];
}

-(IBAction)BtnConnect:(id)sender{
    /***
     连接设备  admin
     ****/
    [appDelegate SHIX_StartConnect:self.did USER:@"admin" PWD:@"123456"];
    [appDelegate SHIX_DevStatus:self.did PRO:self];
   
}

-(IBAction)BtnVideo:(id)sender{
    
    /***
     设备在线后再获取视频（获取任何设备端之类的参数都是要设备的连接状态是在线）
     ****/
    [appDelegate SHIX_Video:self.did PRO:self];
    
}
-(IBAction)BtnStopVideo:(id)sender{
    
    /***
     停止视频
     ****/
    [appDelegate SHIX_StopVideo:self.did];
    
}



-(IBAction)BtnSearch:(id)sender{
    
    /***
     局域网搜索
     ****/
    [self startSearch];
    
}

-(IBAction)BtnHeatTest:(id)sender{
    /***
     心跳，设备如果没有请求视频，10s左右会休眠，如果在不请求视频的情况下需要设备保持在线，建议启用线程5s一次发送心跳
     ****/
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"dev_control" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:102] forKey:@"cmd"];
    [parameters setValue:@"admin" forKey:@"user"];
    [parameters setValue:@"" forKey:@"pwd"];
    [parameters setValue:[NSNumber numberWithInt:1] forKey:@"heart"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    [appDelegate SHIX_SendTrans:self.did SEND:str];
}


-(IBAction)BtnTansTest:(id)sender{
    /***
     透传测试，具体协议根据协议文档和设备沟通数据 。。。。。  所有和设备端的协议（除了音视频协议），都可走此方法跟设备沟通！具体协议请参照协议文档
     ****/
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"get_user" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:103] forKey:@"cmd"];
    [parameters setValue:@"admin" forKey:@"user"];
    [parameters setValue:@"" forKey:@"pwd"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    [appDelegate SHIX_TansPro:self.did PRO:self];
    [appDelegate SHIX_SendTrans:self.did SEND:str];
    
}

-(NSString *)getStatusString:(int)PPPPStatus{
    NSString *strPPPPStatus = nil;
    switch (PPPPStatus) {
        case SHIX_PPPP_STATUS_UNKNOWN:
            strPPPPStatus = @"未知状态";
            break;
        case SHIX_PPPP_STATUS_CONNECTING:
            strPPPPStatus = @"连接中";
            break;
        case SHIX_PPPP_STATUS_INITIALING:
            strPPPPStatus = @"未初始化";
            break;
        case SHIX_PPPP_STATUS_CONNECT_FAILED:
            strPPPPStatus = @"连接失败";
            break;
        case SHIX_PPPP_STATUS_DISCONNECT:
            strPPPPStatus = @"断线，等待连接";
            break;
        case SHIX_PPPP_STATUS_INVALID_ID:
            strPPPPStatus = @"无效ID";
            break;
        case SHIX_PPPP_STATUS_ON_LINE:
            strPPPPStatus = @"在线";
              break;
        case SHIX_PPPP_STATUS_DEVICE_NOT_ON_LINE:
            strPPPPStatus = @"设备不在线";
            break;
        case SHIX_PPPP_STATUS_CONNECT_TIMEOUT:
            strPPPPStatus = @"连接超时";
            break;
        case SHIX_PPPP_STATUS_INVALID_USER_PWD:
            strPPPPStatus = @"用户名或密码错误";
            break;
        case SHIX_PPPP_STATUS_USER_LOGIN:
            strPPPPStatus =  @"其它用户已连接";
            break;
        case SHIX_PPPP_STATUS_PWD_CUO:
            strPPPPStatus = @"用户名或密码错误";
            break;
            
        default:
            strPPPPStatus = @"未知状态";
            break;
    }
    return strPPPPStatus;
}
-(void)updateStatus:(NSNumber *)status{
    int sta = [status intValue];
    NSString *strStatus = [self getStatusString:(int)sta];
    labelStatus.text = strStatus;
}

-(void)updateTest:(NSString *)test{
    labelTest.text = test;
}

/**
 状态回调
 **/
-(void)PPPPStatus:(NSString *)strDID statusType:(NSInteger)statusType status:(NSInteger)status{
   
   // NSString *strStatus = [self getStatusString:(int)status];
    
    [self performSelectorOnMainThread:@selector(updateStatus:) withObject:[NSNumber numberWithInteger:status] waitUntilDone:NO];
    
  
     NSLog(@"PPPPStatus strDid[%@]  status:[%ld]",strDID,status);
}

/**
 解码后数据回调
 **/
-(void)YUVNotify:(Byte *)yuv length:(int)length width:(int)width height:(int)height timestamp:(unsigned int)timestamp DID:(NSString *)did{
      NSLog(@"YUVNotify strDid[%@]  width:[%d] height:[%d]",did,width,height);
    #if ISUSEOPENGL
      [shixView YUVRefresh:yuv Len:length width:width height:height];
    #else
     //以下方式装贴图，效率比gl渲染差，如牌照或者录像  可使用此转码接口  转成IMAGE  然后保存
    UIImage *image=[APICommon YUV420ToImage:yuv width:width height:height];
    if (image != nil) {
        
        [self performSelectorOnMainThread:@selector(updateImage:) withObject:image waitUntilDone:NO];
        
    }
    #endif
}
 #if ISUSEOPENGL
 #else
- (void) updateImage:(UIImage *)data
{
    // UIImage *img = (UIImage*)data;
    
    if (self.testimageView!=nil) {
        self.testimageView.image = data;
    }
    data = nil;
    
}
 #endif
- (void)handleTimer:(NSTimer *)timer
{
   
    //time is up, invalidate the timer
    [searchTimer invalidate];
    
}

- (void) startSearch
{
    [self stopSearch];
    
    m_pSearchDVS = new CSearchDVS();
    m_pSearchDVS->searchResultDelegate = self;
    m_pSearchDVS->Open();
    
    //create the start timer
    searchTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(handleTimer:) userInfo:nil repeats:NO];
}

- (void) stopSearch
{
    
    if (m_pSearchDVS != NULL) {
        m_pSearchDVS->searchResultDelegate = nil;
        SAFE_DELETE(m_pSearchDVS);
    }
}


/**
 这是我声音播放库中的回调，如果有更好的方式，可不使用我的库播放，SDK中音频发送参考此方法就行
 ***/
-(void)EchoData:(const char *)data Len:(int)len{
     int ret = [appDelegate SHIX_EchoData:self.did Data:data Len:len];
     NSLog(@"---EchoData---len[%d] ret[%d]",len,ret);
}

/**
 这是我声音播放库中的回调，如果有更好的方式，可不使用我的库播放，SDK中音频接收参考此方法就行
 ***/
-(int)WillEchoData:(int)len Data:(void *)data{
 
    int ret = [appDelegate SHIX_WillEchoData:self.did LEN:len Data:data];
      NSLog(@"---WillEchoData--- ret[%d]  len[%d]",ret,len);
    if (ret>0) {
        return ret;
        
    }else{
        return 0;
    }
    
}




/**
 视频原始数据回调，分装MP4 可使用原始数据封装
 **/
-(void)H264Data:(Byte *)h264Frame length:(int)length type:(int)type timestamp:(NSInteger)timestamp DID:(NSString *)did{
    
}
/**
 设备返回数据回调
 **/
-(void)JsonData:(NSString *)json DID:(NSString *)did{
        NSLog(@"JsonData strDid[%@]  json:[%@]",did,json);
    [self performSelectorOnMainThread:@selector(updateTest:) withObject:json waitUntilDone:NO];
}


/**
 局域网搜索回调
 **/
-(void)SearchCameraResult:(NSString *)mac Name:(NSString *)name Addr:(NSString *)addr Port:(NSString *)port DID:(NSString *)did{
    [self performSelectorOnMainThread:@selector(updateTest:) withObject:did waitUntilDone:NO];
}

@end
