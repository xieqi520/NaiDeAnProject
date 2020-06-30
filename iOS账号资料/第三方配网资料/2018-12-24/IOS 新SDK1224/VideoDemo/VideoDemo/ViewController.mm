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
@interface ViewController ()<SHIXCommonProtocol>
{
    AppDelegate *appDelegate;
      SHIXGLController *shixView;
}
@end

@implementation ViewController
@synthesize labelStatus;
@synthesize labelTest;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    shixView = [[SHIXGLController alloc] init];
    shixView.view.frame = CGRectMake(50, 50, 300, 200);
    [self.view addSubview:shixView.view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)BtnConnect:(id)sender{
    /***
     连接设备
     ****/
    [appDelegate SHIX_StartConnect:@"IKB000102JVKSJ" USER:@"admin" PWD:@""];
    [appDelegate SHIX_DevStatus:@"IKB000102JVKSJ" PRO:self];
}

-(IBAction)BtnVideo:(id)sender{
    
    /***
     设备在线后再获取视频（获取任何设备端之类的参数都是要设备的连接状态是在线）
     ****/
    [appDelegate SHIX_Video:@"IKB000102JVKSJ" PRO:self];
    
}
-(IBAction)BtnStopVideo:(id)sender{
    
    /***
     停止视频
     ****/
    [appDelegate SHIX_StopVideo:@"IKB000102JVKSJ"];
    
}


-(IBAction)BtnHeatTest:(id)sender{
    /***
     心跳，设备如果为请求视频，10s左右会休眠，如果在不请求视频的情况下需要设备保持在线，建议启用线程5s一次发送心跳
     ****/
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"dev_control" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:102] forKey:@"cmd"];
    [parameters setValue:@"admin" forKey:@"user"];
    [parameters setValue:@"" forKey:@"pwd"];
    [parameters setValue:[NSNumber numberWithInt:1] forKey:@"heart"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
   [appDelegate SHIX_SendTrans:@"IKB000102JVKSJ" SEND:str];
    
   
   
    
}

-(IBAction)BtnTansTest:(id)sender{
    
    /***
     透传测试，具体协议根据协议文档和设备沟通数据
     ****/
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"get_user" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:103] forKey:@"cmd"];
    [parameters setValue:@"admin" forKey:@"user"];
    [parameters setValue:@"" forKey:@"pwd"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    [appDelegate SHIX_TansPro:@"IKB000102JVKSJ" PRO:self];
    [appDelegate SHIX_SendTrans:@"IKB000102JVKSJ" SEND:str];
    
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
      [shixView YUVRefresh:yuv Len:length width:width height:height];
}

/**
 视频原始数据回调
 **/
-(void)H264Data:(Byte *)h264Frame length:(int)length type:(int)type timestamp:(NSInteger)timestamp DID:(NSString *)did{
    
}

-(void)JsonData:(NSString *)json DID:(NSString *)did{
        NSLog(@"JsonData strDid[%@]  json:[%@]",did,json);
    [self performSelectorOnMainThread:@selector(updateTest:) withObject:json waitUntilDone:NO];
}

@end
