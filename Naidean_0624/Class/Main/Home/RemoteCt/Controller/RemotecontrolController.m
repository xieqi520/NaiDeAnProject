//
//  RemotecontrolController.m
//  Naidean
//
//  Created by xujun on 2018/1/4.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "RemotecontrolController.h"
//#import "CameraViewController.h"
#import "SYVideoViewController.h"

///优载云
#import <AVFoundation/AVFoundation.h>  //包含类 AVPlayer
//#import "APPLEAGView.h"

#import "YZYRecordPCMPlayer.h"

#import "WLSQCameraControl.h"//控制摄像头类

//摄像头
#import "AppDelegate.h"
#import "SHIXCommonProtocol.h"
#import "APICommon.h"
#import "SHIXGLController.h"

#define ISUSEOPENGL 0
@interface RemotecontrolController ()<UITextFieldDelegate,SHIXCommonProtocol>

@property (strong, nonatomic)  UIImageView *BackImgView;
@property (strong, nonatomic)  UILabel *EnergyLabel;
@property (strong, nonatomic)  UILabel *Energy;
@property (strong, nonatomic)  UIImageView *IconImgVIew;
@property (strong, nonatomic)  UIImageView *IconLockImgView;
@property (strong, nonatomic)  UIButton *nameBtn;
@property (strong, nonatomic)  UILabel *NotesLabel;
@property (strong, nonatomic)  UITextField *Passwordtextfild;
@property (strong, nonatomic)  UIButton *CameraswitchBtn;
@property (strong, nonatomic)  UILabel  *CameraswitchLabel;
@property (strong, nonatomic)  UIButton *VoiceBtn;
@property (strong, nonatomic)  UILabel  *VoiceLabel;
@property (strong, nonatomic)  UIButton *UnlockBtn;
@property (strong, nonatomic)  UILabel  *UnlockLabel;
@property (strong, nonatomic)  UIButton *SnapBtn;
@property (strong, nonatomic)  UILabel  *SnapLabel;
@property (nonatomic, strong)  SYVideoViewController *videoVC;
@property (nonatomic, assign)  int PPPPStatus;//设备状态

@property (strong, nonatomic)  UIImageView *camaraImg;


@property (strong, nonatomic) SHIXGLController *shixView;
@end


@implementation RemotecontrolController
{
    UIImageView *_bgImageView;
    AppDelegate *appDelegate;
}

- (void)dealloc {
    NSLog(@"===========RemotecontrolController dealloc=============");
    
    self.shixView = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UserManageClass sharedManager].isCamera = 1;
   
    if (self.videoVC ) {
        self.videoVC = nil;
        /***
         停止视频
         ****/
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [UserManageClass sharedManager].isCamera = 0;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubviews];
    [self startConnectDevice];
    
    NSLog(@"%@",self.device.mj_keyValues);
}

- (void)configSubviews {
    self.view.backgroundColor =[UIColor whiteColor];
    self.title = @"远程开锁";
    self.BackImgView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg1"]];
    self.BackImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.BackImgView.clipsToBounds = YES;
    [self.view addSubview:self.BackImgView];
    
    self.camaraImg = [[UIImageView alloc]init];
    [self.BackImgView addSubview:self.camaraImg];
    
    
    

    
// 430
    CGFloat h = WIN_WIDTH * 72 / 128;
    [self.BackImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(h + 150);
    }];
    
    
    
    [self.camaraImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.BackImgView);
        make.height.mas_equalTo(h);
        make.centerY.equalTo(self.BackImgView);
    }];
    
    
    
#if ISUSEOPENGL
    self.shixView = [[SHIXGLController alloc] init];
    self.shixView.view.frame = CGRectMake(0, 0, WIN_WIDTH, h);
    [self.BackImgView addSubview:self.shixView.view];
#else
    
    
#endif
    
    

    
    self.Energy =[[UILabel alloc] init];
    self.Energy.text=@"100%";
    self.Energy.textAlignment = NSTextAlignmentLeft;
    self.Energy.font =kSystemFontSize(getWidth(15));
    self.Energy.textColor=[UIColor whiteColor];
    [self.BackImgView addSubview:self.Energy];
    [self.Energy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(getWidth(8));
        make.right.equalTo(self.view.mas_right).offset(getWidth(-10));
        make.size.mas_equalTo(CGSizeMake(getWidth(40), getWidth(21)));
    }];
    
    self.EnergyLabel =[[UILabel alloc] init];
    self.EnergyLabel.text=@"设备电量:";
    self.EnergyLabel.textAlignment = NSTextAlignmentRight;
    self.EnergyLabel.font =kSystemFontSize(getWidth(15));
    self.EnergyLabel.textColor =[UIColor whiteColor];
    [self.BackImgView addSubview:self.EnergyLabel];
    [self.EnergyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.Energy);
        make.size.mas_equalTo(CGSizeMake(getWidth(70), getWidth(21)));
        make.right.equalTo(self.Energy.mas_left).offset(getWidth(-5));
    }];
    
    self.nameBtn = [[UIButton alloc] init];
    self.nameBtn.userInteractionEnabled = NO;
    [self.BackImgView addSubview:self.nameBtn];
    [self.nameBtn setBackgroundImage:[UIImage imageNamed:@"bg_mensuobeizhu"] forState:UIControlStateNormal];
    [self.nameBtn setImage:[UIImage imageNamed:@"rename"] forState:UIControlStateNormal];
    [self refreshDeviceNameWithName:self.device.name];
    
    self.IconLockImgView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wifi_lock"]];
    [self.BackImgView addSubview:self.IconLockImgView];
    [self.IconLockImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameBtn.mas_bottom).offset(getHeight(22));
        make.centerX.equalTo(self.BackImgView);
        make.size.mas_equalTo(CGSizeMake(getWidth(180), getWidth(180)));
    }];
    
    self.NotesLabel =[[UILabel alloc] init];
    self.NotesLabel.textAlignment = NSTextAlignmentCenter;
    self.NotesLabel.font =kSystemFontSize(getWidth(15));
    self.NotesLabel.textColor=[UIColor colorWithHexString:@"#ff7b06" alpha:1];
    self.NotesLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    [self.BackImgView addSubview:self.NotesLabel];
    [self.NotesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.BackImgView);
        make.size.mas_equalTo(CGSizeMake(WIN_WIDTH, getHeight(40)));
        make.top.equalTo(self.BackImgView.mas_bottom).offset(getHeight(-40));
    }];
    
    
    
    
    
    //底部按钮
    self.CameraswitchBtn=[UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.CameraswitchBtn setBackgroundImage:[UIImage imageNamed:@"camera_ed"] forState:UIControlStateNormal];
    [self.CameraswitchBtn addTarget:self action:@selector(CameraswitchBtnCilck:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.CameraswitchBtn];
    [self.CameraswitchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.BackImgView.mas_bottom).offset(getHeight(35));
        make.size.mas_equalTo(CGSizeMake(getWidth(72), getWidth(72)));
        make.left.equalTo(self.view.mas_left).offset(getWidth(47));
    }];
    
    
    
    
    
    self.CameraswitchLabel=[[UILabel alloc] init];
    self.CameraswitchLabel.text=@"摄像";
    self.CameraswitchLabel.textAlignment = NSTextAlignmentCenter;
    self.CameraswitchLabel.font =kSystemFontSize(getWidth(14));
    self.CameraswitchLabel.textColor=[UIColor colorWithHexString:@"#484b5f" alpha:1];
    [self.view addSubview:self.CameraswitchLabel];
    [self.CameraswitchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.CameraswitchBtn);
        make.top.equalTo(self.CameraswitchBtn.mas_bottom).offset(getHeight(6));
        make.size.mas_equalTo(CGSizeMake(getWidth(150), getHeight(21)));
    }];
    
    self.VoiceBtn=[UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.VoiceBtn addTarget:self action:@selector(voiceBtnTalkDown:) forControlEvents:UIControlEventTouchDown];
    [self.VoiceBtn addTarget:self action:@selector(voiceBtnTalkUp:) forControlEvents:UIControlEventTouchUpInside];

    [self.VoiceBtn setBackgroundImage:[UIImage imageNamed:@"voice_ed"] forState:UIControlStateNormal];
    [self.view addSubview:self.VoiceBtn];
    [self.VoiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.BackImgView.mas_bottom).offset(getHeight(35));
        make.size.mas_equalTo(CGSizeMake(getWidth(72), getWidth(72)));
        make.centerX.equalTo(self.view);
    }];
    
    self.VoiceLabel=[[UILabel alloc] init];
    self.VoiceLabel.text=@"语音对讲";
    self.VoiceLabel.textAlignment = NSTextAlignmentCenter;
    self.VoiceLabel.font =kSystemFontSize(getWidth(14));
    self.VoiceLabel.textColor=[UIColor colorWithHexString:@"#484b5f" alpha:1];
    [self.view addSubview:self.VoiceLabel];
    [self.VoiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.VoiceBtn);
        make.top.equalTo(self.VoiceBtn.mas_bottom).offset(getHeight(6));
        make.size.mas_equalTo(CGSizeMake(getWidth(150), getHeight(21)));
    }];
    
    
    
    self.SnapBtn=[UIButton buttonWithType:(UIButtonTypeCustom)];
//    [self.SnapBtn addTarget:self action:@selector(voiceBtnTalkDown:) forControlEvents:UIControlEventTouchDown];
    [self.SnapBtn addTarget:self action:@selector(snapBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.SnapBtn setBackgroundImage:[UIImage imageNamed:@"ip_snap"] forState:UIControlStateNormal];
    [self.view addSubview:self.SnapBtn];
    [self.SnapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.VoiceLabel.mas_bottom).offset(getHeight(15));
        make.size.mas_equalTo(CGSizeMake(getWidth(72), getWidth(72)));
        make.centerX.equalTo(self.view);
    }];
    
    self.SnapLabel=[[UILabel alloc] init];
    self.SnapLabel.text=@"抓拍";
    self.SnapLabel.textAlignment = NSTextAlignmentCenter;
    self.SnapLabel.font =kSystemFontSize(getWidth(14));
    self.SnapLabel.textColor=[UIColor colorWithHexString:@"#484b5f" alpha:1];
    [self.view addSubview:self.SnapLabel];
    [self.SnapLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.SnapBtn.mas_bottom).offset(getHeight(6));
        make.size.mas_equalTo(CGSizeMake(getWidth(150), getHeight(21)));
    }];
    
    self.UnlockBtn=[UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.UnlockBtn setBackgroundImage:[UIImage imageNamed:@"lock_ed"] forState:UIControlStateNormal];
    [self.UnlockBtn addTarget:self action:@selector(UnlockBtnCilck:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.UnlockBtn];
    [self.UnlockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.BackImgView.mas_bottom).offset(getHeight(35));
        make.size.mas_equalTo(CGSizeMake(getWidth(72), getWidth(72)));
        make.right.equalTo(self.view.mas_right).offset(getWidth(-46));
    }];
    self.UnlockLabel=[[UILabel alloc] init];
    self.UnlockLabel.text=@"开锁";
    self.UnlockLabel.textAlignment = NSTextAlignmentCenter;
    self.UnlockLabel.font =kSystemFontSize(getWidth(14));
    self.UnlockLabel.textColor=[UIColor colorWithHexString:@"#484b5f" alpha:1];
    [self.view addSubview:self.UnlockLabel];
    [self.UnlockLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.UnlockBtn);
        make.top.equalTo(self.UnlockBtn.mas_bottom).offset(getHeight(6));
        make.size.mas_equalTo(CGSizeMake(getWidth(150), getHeight(21)));
    }];
    
    [self refreshBtnStyle];   //更新设备状态
}

//连接设备
- (void)startConnectDevice {
    
    NSString *str = [self.device.videoId stringByReplacingOccurrencesOfString:@"-" withString:@""];
    self.device.videoId = str;
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate SHIX_StartConnect:self.device.videoId USER:@"admin" PWD:@"123456"];
    [appDelegate SHIX_DevStatus:self.device.videoId PRO:self];
    
}

//更新设备状态
- (void)updateStatus:(NSNumber *)status{
    int sta = [status intValue];
    NSString *strStatus = [self getStatusString:(int)sta];
    self.NotesLabel.text = strStatus;
    //当前设备状态
    self.PPPPStatus = sta;
    [self refreshBtnStyle];
}

- (NSString *)getStatusString:(int)PPPPStatus{
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
            
            [self configPushParam];
            
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




- (void)refreshBtnStyle {
    if (self.PPPPStatus == SHIX_PPPP_STATUS_ON_LINE) {
        self.CameraswitchBtn.enabled = YES;
        [self.CameraswitchBtn setBackgroundImage:[UIImage imageNamed:@"camera_ed"] forState:UIControlStateNormal];
        self.UnlockBtn.enabled = YES;
        [self.UnlockBtn setBackgroundImage:[UIImage imageNamed:@"lock_ed"] forState:UIControlStateNormal];
        self.VoiceBtn.enabled = YES;
        [self.VoiceBtn setBackgroundImage:[UIImage imageNamed:@"voice_ed"] forState:UIControlStateNormal];
        self.SnapBtn.enabled = YES;
        [self.SnapBtn setBackgroundImage:[UIImage imageNamed:@"ip_snap_ed"] forState:UIControlStateNormal];
    }else {
        self.CameraswitchBtn.enabled = YES;
        [self.CameraswitchBtn setBackgroundImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
        self.UnlockBtn.enabled = YES;
        [self.UnlockBtn setBackgroundImage:[UIImage imageNamed:@"lock"] forState:UIControlStateNormal];
        self.VoiceBtn.enabled = YES;
        [self.VoiceBtn setBackgroundImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
        self.SnapBtn.enabled = YES;
        [self.SnapBtn setBackgroundImage:[UIImage imageNamed:@"ip_snap"] forState:UIControlStateNormal];

    }
}
#pragma mark--  解码后的数据回调
- (void)YUVNotify:(Byte *)yuv length:(int)length width:(int)width height:(int)height timestamp:(unsigned int)timestamp DID:(NSString *)did{

    
#if ISUSEOPENGL
    [self.shixView YUVRefresh:yuv Len:length width:width height:height];
#else
    UIImage *image=[APICommon YUV420ToImage:yuv width:width height:height];
    if (image != nil) {
        [self performSelectorOnMainThread:@selector(updateImage:) withObject:image waitUntilDone:NO];
    }
#endif
    
}


- (void) updateImage:(UIImage *)data
{
//    if (self.BackImgView!=nil) {
//        self.BackImgView.image = data;
//    }
    if (self.camaraImg != nil) {
        self.camaraImg.image = data;
    }
    
    data = nil;
}


//
-(void)snapBtn{
    if (self.PPPPStatus == SHIX_PPPP_STATUS_ON_LINE) {
        /***
         设备在线后再获取视频（获取任何设备端之类的参数都是要设备的连接状态是在线）
         ****/
        [appDelegate SHIX_Snapshot:self.device.videoId];
        [appDelegate SHIX_Video:self.device.videoId PRO:self];
        
        //        self.videoVC = [SYVideoViewController new];
        //        [self.navigationController pushViewController:self.videoVC animated:YES];
    }else {
        [MBProgressHUD showTipMessageInView:@"设备不在线"];
    }
    
}
#pragma mark - event response
//摄像
- (void)CameraswitchBtnCilck:(UIButton*)sender {
    if (self.PPPPStatus == SHIX_PPPP_STATUS_ON_LINE) {
        /***
         设备在线后再获取视频（获取任何设备端之类的参数都是要设备的连接状态是在线）
         ****/
        [appDelegate SHIX_Video:self.device.videoId PRO:self];
        
//        self.videoVC = [SYVideoViewController new];
//        [self.navigationController pushViewController:self.videoVC animated:YES];
    }else {
        [MBProgressHUD showTipMessageInView:@"设备不在线"];
    }
}

//语音对讲
- (void)voiceBtnTalkDown:(UIButton*)sender {
//    /***
//     对讲，发送手机音频数据到设备。。。。。。测试时 请先请求视频
//     ****/
    [appDelegate SHIX_StartTalk:self.device.videoId];
//    [test ControlAudioType:2];
}

- (void)voiceBtnTalkUp:(UIButton*)sender {
//    /***
//     对讲，发送手机音频数据到设备。。。。。。测试时 请先请求视频
//     ****/
    [appDelegate SHIX_StopTalk:self.device.videoId];
//    [test ControlAudioType:1];
}

//开锁
- (void)UnlockBtnCilck:(UIButton*)sender {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"lock_control" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:119] forKey:@"cmd"];
    [parameters setValue:@"admin" forKey:@"user"];
    [parameters setValue:@"123456" forKey:@"pwd"];
    [parameters setValue:[NSNumber numberWithInt:1] forKey:@"value"];
    NSData *data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    [appDelegate SHIX_SendTrans:self.device.videoId SEND:str];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入开锁密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *deviceNameTF = alert.textFields.firstObject;
        if (deviceNameTF.text.length == 0) {
            [MBProgressHUD showTipMessageInView:@"密码不能为空"];
        }else{
            NSDictionary *params = @{
                                     @"id":[NSString stringWithFormat:@"%@",self.device.id],
                                     };
            DDLog(@"CHANGE_DEVICE_NAME_URL:%@;params:%@",NETWORK_REQUEST_URL(LOCK_ON_URL),params);
            NSString *httpUrl = [NSString stringWithFormat:@"%@/%@",NETWORK_REQUEST_URL(LOCK_ON_URL),[[UserManger sharedInstance] getMemberToken]];
            [HttpTool postWithURL:httpUrl params:params success:^(id json) {
                NSLog(@"result:%@",json);
                int code = [json[@"code"] intValue];
                if (code == 1000) {
                    [MBProgressHUD showTipMessageInView:@"开锁成功"];
                }else if (code == TimeOutCode)
                {
                    [MBProgressHUD showTipMessageInView:json[@"登录超时，请重新登录"]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_TimeOut_Login object:nil];
                }
                else
                {
                    [MBProgressHUD showTipMessageInView:json[@"message"]];
                }
            } failure:^(NSError *error) {
                [MBProgressHUD showTipMessageInView:[error localizedDescription]];
            }];
        }

    }]];
//    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.placeholder = @"请输入开锁密码";
//    }];
//    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mak - SHIXCommonProtocol
#pragma mark--  摄像机状态回调
- (void) PPPPStatus: (NSString*)strDID
         statusType:(NSInteger)statusType
             status:(NSInteger) status {
    [self performSelectorOnMainThread:@selector(updateStatus:) withObject:[NSNumber numberWithInteger:status] waitUntilDone:NO];
    NSLog(@"PPPPStatus strDid[%@]  status:[%ld]",strDID,status);
}




#pragma mark--  原始数据回调
- (void) H264Data: (Byte*) h264Frame
           length: (int) length
             type: (int) type
        timestamp: (NSInteger) timestamp
              DID:(NSString *)did {
    
}


#pragma mark--音频数据回调  PCM
-(void)AudioDataBack:(Byte*)data
              Length:(int)len
                 DID:(NSString *)did {
    NSLog(@"%s--%@--%@",data,@(len),did);
}

#pragma mark--  透传数据回调
- (void) JsonData: (NSString *) json
              DID:(NSString *)did {
    NSLog(@"%s--%@--%@",__func__,json,did);
}


#pragma mark - UITextFieldDelegate
// 点击键盘return键收起键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return  YES;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - private
- (void)refreshDeviceNameWithName:(NSString *)name{
    if (!name) {
        name = @"无设备";
    }
    [self.nameBtn setTitle:name forState:UIControlStateNormal];
    self.nameBtn.titleLabel.font = kSystemFontSize(getWidth(15));
    UIFont *font = self.nameBtn.titleLabel.font;
    CGSize textSize = [name sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    CGFloat btnWidth = textSize.width + 50.f;
    [self.nameBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.BackImgView);
        make.size.mas_equalTo(CGSizeMake(getWidth(btnWidth), getHeight(26)));
        make.top.equalTo(self.view.mas_top).offset(getHeight(35));
    }];
    self.nameBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -getWidth(5)-self.nameBtn.currentImage.size.width, 0, self.nameBtn.currentImage.size.width+getWidth(5));
    self.nameBtn.imageEdgeInsets = UIEdgeInsetsMake(0, getWidth(textSize.width+5)+self.nameBtn.currentImage.size.width, 0, 0);
}
@end
