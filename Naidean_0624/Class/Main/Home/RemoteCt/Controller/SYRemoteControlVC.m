//
//  SYRemoteControlVC.m
//  Naidean
//
//  Created by aoxin1 on 2020/6/23.
//  Copyright © 2020 com.saiyikeji. All rights reserved.
//

#import "SYRemoteControlVC.h"
#import "echo.h"
#import "APICommon.h"
#import "SHIXCommonProtocol.h"
#import "SHIXGLController.h"
@interface SYRemoteControlVC ()<EchoDelegate,SHIXCommonProtocol>
{
    BOOL bPlaying;
    echo *test;
    BOOL isTakepicturing;
    BOOL isVideo;
    BOOL isAudio;
    int takePicNumber;
    NSCondition *m_RecordLock;
    int writeH264Number; //写入连续h264视频数
    int writeAudioDataNumber; //写入的音频数
    SHIXGLController *myGLViewController;
    AppDelegate *appDelegate;
}


@property (weak, nonatomic) IBOutlet UIButton *wifiBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;

@property (weak, nonatomic) IBOutlet UILabel *statusLB;

@property (nonatomic, assign)  NSInteger PPPPStatus;//设备状态
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;

@property (weak, nonatomic) IBOutlet UIView *playView;

@property (nonatomic, copy) NSString *strDID;
@property (nonatomic, copy) NSString *strUser;
@property (nonatomic, copy) NSString *strPwd;
@end

@implementation SYRemoteControlVC
- (IBAction)btnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 200://摄像
        {
            
            if (self.PPPPStatus == SHIX_PPPP_STATUS_ON_LINE) {
                /***
                 设备在线后再获取视频（获取任何设备端之类的参数都是要设备的连接状态是在线）
                 ****/
                [appDelegate SHIX_Video:self.strDID PRO:self];
            }else {
                [MBProgressHUD showTipMessageInView:@"设备不在线"];
            }
            
        }
            break;
        case 201://对讲
        {
            if (self.PPPPStatus == SHIX_PPPP_STATUS_ON_LINE) {
                /***
                 设备在线后再获取视频（获取任何设备端之类的参数都是要设备的连接状态是在线）
                 ****/
                 [self btnAudioClick:sender];
            }else {
                [MBProgressHUD showTipMessageInView:@"设备不在线"];
            }
           
        }
            break;
        case 202://开锁
        {
            
        }
            break;
        case 203://拍照
        {
            if (self.PPPPStatus == SHIX_PPPP_STATUS_ON_LINE) {
                /***
                 设备在线后再获取视频（获取任何设备端之类的参数都是要设备的连接状态是在线）
                 ****/
               [self btnPicClick:sender];
            }else {
                [MBProgressHUD showTipMessageInView:@"设备不在线"];
            }
            
        }
            break;
            
        default:
            break;
    }
}


-(void)initParam{
    self.strDID = self.device.videoId;
    self.strUser = self.device.videoUser;
    self.strPwd = self.device.videoPwd;
    [appDelegate SHIX_TansPro:self.strDID PRO:self];
    test = [[echo alloc]initWithContext:self PCMBufferSize:1024*1024 LOG:YES];
    [test initEcho];
    
    [test startEcho:1];
}
#pragma mark--  摄像机状态回调
- (void) PPPPStatus: (NSString*)strDID
         statusType:(NSInteger)statusType
             status:(NSInteger) status {
    self.PPPPStatus = status;
    //如果是ID号无效，则停止该设备的P2P
    if (status == SHIX_PPPP_STATUS_INVALID_ID
        || status == SHIX_PPPP_STATUS_CONNECT_TIMEOUT
        || status == SHIX_PPPP_STATUS_DEVICE_NOT_ON_LINE
        || status == SHIX_PPPP_STATUS_CONNECT_FAILED||statusType==SHIX_PPPP_STATUS_INVALID_USER_PWD) {
        [appDelegate SHIX_StopAll];
    }
    else if (status == SHIX_PPPP_STATUS_ON_LINE){
        [self initParam];
        [self configPushParam];
        [appDelegate SHIX_Heart:self.strDID User:@"admin" Pwd:@"123456"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshUI];
        self.statusLB.text = [self getStatusString:status];
        
        if (status == SHIX_PPPP_STATUS_ON_LINE) {
            self.wifiBtn.hidden = YES;
            self.bgImg.hidden = YES;
        }else{
            self.wifiBtn.hidden = NO;
            self.bgImg.hidden = NO;
        }
    });
    NSLog(@"PPPPStatus strDid[%@]  status:[%ld]",strDID,status);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"远程开锁";
    [self refreshUI];
    [self startConnectDevice];
}

-(void)refreshUI{
    if (self.PPPPStatus == SHIX_PPPP_STATUS_ON_LINE) {
        [self.btn1 setImage:[UIImage imageNamed:@"camera_ed"] forState:UIControlStateNormal];
        [self.btn2 setImage:[UIImage imageNamed:@"voice_ed"] forState:UIControlStateNormal];
        [self.btn3 setImage:[UIImage imageNamed:@"lock_ed"] forState:UIControlStateNormal];
        [self.btn4 setImage:[UIImage imageNamed:@"ip_snap_ed"] forState:UIControlStateNormal];
    }else{
        [self.btn1 setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
        [self.btn2 setImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
        [self.btn3 setImage:[UIImage imageNamed:@"lock"] forState:UIControlStateNormal];
        [self.btn4 setImage:[UIImage imageNamed:@"ip_snap"] forState:UIControlStateNormal];
    }
}

//连接设备
- (void)startConnectDevice {
    
    NSString *str = [self.device.videoId stringByReplacingOccurrencesOfString:@"-" withString:@""];
    self.device.videoId = str;
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate SHIX_StartConnect:self.device.videoId USER:@"admin" PWD:@"123456"];
    [appDelegate SHIX_DevStatus:self.device.videoId PRO:self];
    
}
-(IBAction)btnPicClick:(id)sender{
 
    if (self.PPPPStatus == SHIX_PPPP_STATUS_ON_LINE) {
        /***
         设备在线后再获取视频（获取任何设备端之类的参数都是要设备的连接状态是在线）
         ****/
        if (isTakepicturing) {
            return ;
        }
        isTakepicturing=YES;
    }else {
        [MBProgressHUD showTipMessageInView:@"设备不在线"];
    }
}
-(IBAction)btnAudioClick:(id)sender{
  
    if (self.PPPPStatus != SHIX_PPPP_STATUS_ON_LINE) {
        return;
    }
   
    if (!isAudio) {
        [appDelegate SHIX_StartAudio:self.strDID];
//        [self.tools SHIX_StartPPPPAudio:self.strDID];
//        imgAudio.image = [UIImage imageNamed:@"n_audio_have"];
    }else{
        [appDelegate SHIX_StopAudio:self.strDID];
//        [self.tools SHIX_StopPPPPAudio:self.strDID];
//        imgAudio.image = [UIImage imageNamed:@"n_audio_no"];
    }
    
    isAudio = !isAudio;
    
}

-(IBAction)btnTalkDown:(id)sender{
//    imgTalk.image = [UIImage imageNamed:@"n_play_bom_talkpress"];
    
    if (self.PPPPStatus != SHIX_PPPP_STATUS_ON_LINE) {
        return;
    }
    [appDelegate SHIX_StartTalk:self.strDID];

    if (test!=nil) {
        NSLog(@"SHIXTALK  [test ControlAudioType:0]");
        [test ControlAudioType:0];
    }
    
}
-(IBAction)btnTalkUp:(id)sender{
   
    if (self.PPPPStatus != SHIX_PPPP_STATUS_ON_LINE) {
        return;
    }
//    imgTalk.image = [UIImage imageNamed:@"n_play_bom_talk"];

    [appDelegate SHIX_StopTalk:self.strDID];
    if (test!=nil) {
        NSLog(@"SHIXTALK  [test ControlAudioType:1]");
        [test ControlAudioType:1];
    }
}

#pragma mark------CreateOpenGl
- (void) CreateGLView
{
    NSLog(@">>>>>>>>>>>>>>>CreateGLView");
    
    myGLViewController = [[SHIXGLController alloc] init];
    myGLViewController.view.frame = CGRectMake(0, 0, self.playView.frame.size.width, self.playView.frame.size.height);
    [self.playView addSubview:myGLViewController.view];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.PPPPStatus == SHIX_PPPP_STATUS_ON_LINE) {
        [appDelegate SHIX_StopVideo:self.strDID];
        [appDelegate SHIX_TansPro:self.strDID PRO:nil];
        if (isAudio) {
            [appDelegate SHIX_StopAudio:self.strDID];
        }
        
        if (test != nil) {
            [test stopEcho];
            [test unInitEcho];
            test = nil;
        }
    }else{
        [appDelegate SHIX_StopAll];
    }
    
    
}
- (NSString *)getStatusString:(NSInteger)PPPPStatus{
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

-(void)configPushParam{
    NSMutableDictionary *mut = [NSMutableDictionary dictionary];
    mut[@"pro"] = @"setpush";
    mut[@"cmd"] = @"118";
    mut[@"user"] = @"admin";
    mut[@"pwd"] = @"123456";
    mut[@"UserUUID"] = [[UserManger sharedInstance]getDeviceIDWithUUID];
    mut[@"phonetype"] = @(0);
    mut[@"enable"] = @(1);
    //    mut[@"app_pack_name"] = @"com.foshao.Naidean";
    mut[@"validity"] = @(120);
    mut[@"pushType"] = @(0);
    mut[@"jg_appkey"] = @"569cfd4631acba8668d8764b";
    mut[@"jg_master"] = @"76a62836128e9b3bfc5a322e";
    mut[@"jg_alias"] = [[UserManger sharedInstance]getAliaId];
    mut[@"environment"] = @(1);// 1:开发  2:生产
    NSString *did = [[UserManger sharedInstance]getCaramaDid];
    
    NSLog(@"%@--%@",mut,did);
    if (did) {
        NSString *deviceId = [did stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSData *data=[NSJSONSerialization dataWithJSONObject:mut options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        [appDelegate SHIX_SendTrans:deviceId SEND:str];
    }
    
}
-(void)AudioDataBack:(Byte *)data Length:(int)len DID:(NSString *)did{
    [self AudioDataBack:data Length:len];
}
-(void)AudioDataBack:(Byte *)data Length:(int)len{
    NSLog(@"AudioDataBack... length: %d", len);
    [test writePcmToBuffer:data Size:len];
}
- (void) YUVNotify:(Byte *)yuv length:(int)length width:(int)width height:(int)height timestamp:(unsigned int)timestamp DID:(NSString *)did
{
       NSLog(@"YUVNotifyw.... length: %d, timestamp: %d, width: %d, height: %d DID:%@", length, timestamp, width, height,did);
    
    if (bPlaying == NO)
    {
        
        bPlaying = YES;
        [self performSelectorOnMainThread:@selector(CreateGLView) withObject:nil waitUntilDone:YES];
    }
    
    [myGLViewController YUVRefresh:yuv Len:length width:width height:height];
    
    if (isTakepicturing) {
        UIImage *image=[APICommon YUV420ToImage:yuv width:width height:height];
        [self takePicProcess:image];
    }
    
    
}

-(void)takePicProcess:(UIImage*)img{
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}
-(void)EchoData:(const char *)data Len:(int)len{
    
    //NSLog(@"---EchoData---len[%d] ret[%d]",len,0);
    int ret = [appDelegate SHIX_EchoData:self.strDID Data:data Len:len];
    NSLog(@"SHIXTALK  [test EchoData:%d] ret[%d]",len,ret);
}

-(int)WillEchoData:(int)len Data:(void *)data{
    NSLog(@"---WillEchoData---");
    
    //    char PCMBuf[372 + 1] = {0};
    //     memset(PCMBuf, 0, sizeof(PCMBuf));
    //
    //    int ret = m_pPPPPChannelMgt->GetAudioFramData([strDID UTF8String], data,len);
    //    if (ret>0) {
    //
    //        return ret;
    //
    //    }else{
    //
    //        return 0;
    //    }
    return 0;
}




-(void)JsonData:(NSString *)json DID:(NSString *)did{
    NSLog(@"JsonData [%@]  [%@]",did,json);
    
    if (json==nil) {
        return;
    }
    
    NSError *error;
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];

    int result = [[weatherDic objectForKey:@"result"] intValue];
    if (result !=0) {
        return;
    }
    
    int cmd = [[weatherDic objectForKey:@"cmd"] intValue];
    
    if (cmd!=134) {
        return;
    }
    
//    outputvol= [[weatherDic objectForKey:@"outputvol"] intValue];
//    inputvol= [[weatherDic objectForKey:@"inputvol"] intValue];
//    batvalue= [[weatherDic objectForKey:@"batvalue"] intValue];
//    batstatus= [[weatherDic objectForKey:@"batstatus"] intValue];
    
    [self performSelectorOnMainThread:@selector(refreshUI) withObject:nil waitUntilDone:NO];
}

-(UIImage *)getBatteryRes:(int) battery{
    if (battery >= 90) {
        return [UIImage imageNamed:@"home_power_100"];
    } else if (battery >= 60) {
        return [UIImage imageNamed:@"home_power_80"];
    } else if (battery >= 40) {
        return [UIImage imageNamed:@"home_power_60"];
    } else if (battery >= 20) {
        return [UIImage imageNamed:@"home_power_40"];
    } else {
        return [UIImage imageNamed:@"home_power_20"];
    }
    return nil;
}


@end
