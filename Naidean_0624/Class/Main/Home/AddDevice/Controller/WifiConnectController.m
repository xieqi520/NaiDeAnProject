//
//  WifiConnectController.m
//  Naidean
//
//  Created by xujun on 2018/1/8.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "WifiConnectController.h"
#import "APConnectController.h"
#import "APDeviceSearchController.h"

#import <SystemConfiguration/CaptiveNetwork.h>
#import "NetworkManagerByReachability.h"
#import <CoreLocation/CLLocationManager.h>
#import "HMScanerCardViewController.h"

@interface WifiConnectController ()<UITextFieldDelegate,CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *NotesLabel1;

@property (weak, nonatomic) IBOutlet UILabel *NotesLabel2;

//@property (nonatomic,strong) NSTimer *updataWifi;// 实时更新连接的wifi
@property (nonatomic, strong) CLLocationManager *locManager;
@end

@implementation WifiConnectController
- (void)dealloc
{
//    [self.updataWifi invalidate];
//    self.updataWifi = nil;
}
- (IBAction)saoMa:(UIButton *)sender {
    
    
    if (self.SelectWifitextfield.text.length < 3 || [self.SelectWifitextfield.text containsString:@"IKB-"]) {
        return;
    }
    if (self.WifiPStextfield.text.length < 8) {
        return;
    }
    
    
    NSMutableDictionary *mut = [NSMutableDictionary dictionary];
    [mut setValue:self.SelectWifitextfield.text forKey:@"ssid"];
    [mut setValue:self.WifiPStextfield.text forKey:@"password"];
    
    NSString *mutStr = mut.mj_JSONString;
    
    HMScanerCardViewController *vc = [[HMScanerCardViewController alloc]initWithCardName:mutStr avatar:nil];
    vc.title = @"二维码配网";
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

//    [self.updataWifi invalidate];
//    self.updataWifi = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getUpdataWifi];
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse ||
        status == kCLAuthorizationStatusAuthorizedAlways) {
        //再重新获取ssid
        [self getUpdataWifi];
        NSString *wifi = [WifiConnectController wifSsid];
        if (![wifi containsString:@"IKB-"]) {
            self.SelectWifitextfield.text = wifi;
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"WIFI链接";
    [self getcurrentLocation];
    [self initWithUI];
    [self WifiConfigureNetwork];
    
    NSString *wifi = [WifiConnectController wifSsid];
    if (![wifi containsString:@"IKB-"]) {
        self.SelectWifitextfield.text = wifi;
    }
    
    self.WifiPStextfield.secureTextEntry = YES;
//
//    D-Link_DIR-816 saiyimcu987654321
    self.SelectWifitextfield.text = @"D-Link_DIR-816";
    self.WifiPStextfield.text = @"saiyimcu987654321";
    
    
//
    
//    self.SelectWifitextfield.text = @"HUAWEI Mate 10";
//    self.WifiPStextfield.text = @"123456789";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"扫码" style:UIBarButtonItemStyleDone target:self action:@selector(saoMa:)];
    
}
- (void)getcurrentLocation {
    if (@available(iOS 13.0, *)) {
        //用户明确拒绝，可以弹窗提示用户到设置中手动打开权限
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
            //使用下面接口可以打开当前应用的设置页面
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
        
        self.locManager = [[CLLocationManager alloc] init];
        self.locManager.delegate = self;
        if(![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
            //弹框提示用户是否开启位置权限
            [self.locManager requestWhenInUseAuthorization];
        }
    }
}

- (void)WifiConfigureNetwork
{
    BOOL isWIFI = [GLobalNetworkManagerByReachability isWiFiEnabled];
    if (!isWIFI) {//如果WiFi没有打开，作出弹窗提示
        [self alertController:@"Wi-Fi未打开，继续操作需要打开Wi-Fi，是否前往？"];
    }
    
//    self.updataWifi = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(getUpdataWifi) userInfo:nil repeats:YES];
}

+ (NSString*)wifSsid
{
    NSArray *interfaces = (__bridge_transfer NSArray*)CNCopySupportedInterfaces();
    NSDictionary *info = nil;
    for (NSString *ifname in interfaces) {
        info = (__bridge_transfer NSDictionary*)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifname);
        if (info && [info count]) {
            break;
        }
        info = nil;
    }
    
    NSString *ssid = nil;
    
    if (info){
        ssid = [info objectForKey:@"SSID"];
    }
    info = nil;
    return ssid? ssid:@"";
}


// 实时更新连接的wifi
- (void)getUpdataWifi {
    // 获取wifi基本设置
    NSString *connectedSSID = [GLobalNetworkManagerByReachability getWifiSSID];
    if(connectedSSID == nil)
    {
        [self alertController:@"Wi-Fi未关联，继续操作需要打开Wi-Fi进行关联，是否前往？"];
    }
}

#pragma mark - 获取wifi信息
- (void)initWithUI
{
    
    UIView *line =[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 15)];
    line.backgroundColor=[UIColor colorWithHexString:@"#f5f5f9" alpha:1];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(getWidth(15));
    }];
    
    [self.ConnectImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(getWidth(50));
        make.size.mas_equalTo(CGSizeMake(getWidth(114), getWidth(114)));
        make.centerX.equalTo(self.view);
    }];
    
    self.NotesLabel1.font =kSystemFontSize(getWidth(14));
    [self.NotesLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.ConnectImageview.mas_bottom).offset(getWidth(28));
        make.size.mas_equalTo(CGSizeMake(getWidth(140), getWidth(30)));
    }];
    
    self.NotesLabel2.font =kSystemFontSize(getWidth(14));
    [self.NotesLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.NotesLabel1.mas_bottom).offset(getWidth(20));
        make.size.mas_equalTo(CGSizeMake(WIN_WIDTH, getWidth(30)));
    }];
    
    UIColor *color = [UIColor colorWithHexString:@"#a0a0a0" alpha:1];
    self.SelectWifitextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入WIFI名称" attributes:@{NSForegroundColorAttributeName: color}];
    self.WifiPStextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入WIFI密码" attributes:@{NSForegroundColorAttributeName: color}];
    
    UIView *left =[[UIView alloc] initWithFrame:CGRectMake(10, 0, 10, 30)];
    left.backgroundColor=[UIColor whiteColor];
    self.SelectWifitextfield.leftView =left;
    self.SelectWifitextfield.leftViewMode = UITextFieldViewModeAlways;
    
    
    UIView *PSleft =[[UIView alloc] initWithFrame:CGRectMake(10, 0, 10, 30)];
    PSleft.backgroundColor=[UIColor whiteColor];
    self.WifiPStextfield.leftView = PSleft;
    self.WifiPStextfield.leftViewMode = UITextFieldViewModeAlways;
    self.WifiPStextfield.delegate = self;
    
    UIColor *colorline = [UIColor colorWithHexString:@"#969696" alpha:1];
    self.SelectWifitextfield.layer.borderColor =colorline.CGColor;
    self.SelectWifitextfield.layer.borderWidth = 0.5;
    self.WifiPStextfield.layer.borderColor =colorline.CGColor;
    self.WifiPStextfield.layer.borderWidth = 0.5;
    
    [self.SelectWifitextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(getWidth(15));
        make.right.equalTo(self.view.mas_right).offset(getWidth(-15));
        make.top.equalTo(self.NotesLabel2.mas_bottom).offset(getWidth(70));
        make.height.mas_equalTo(getWidth(48));
    }];
    
    [self.WifiPStextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(getWidth(15));
        make.right.equalTo(self.view.mas_right).offset(getWidth(-15));
        make.height.mas_equalTo(getWidth(48));
        make.top.equalTo(self.SelectWifitextfield.mas_bottom).offset(getWidth(15));
    }];
    
    self.ConnectBtn.titleLabel.font = kSystemFontSize(getWidth(16));
    [self.ConnectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(getWidth(15));
        make.right.equalTo(self.view.mas_right).offset(getWidth(-15));
        make.height.mas_equalTo(getWidth(48));
        make.top.equalTo(self.WifiPStextfield.mas_bottom).offset(getWidth(58));
    }];
    
   
    
}

#pragma mark - event response
- (IBAction)ConnectAction:(id)sender {
    if (self.WifiPStextfield.text.length == 0) {
        [MBProgressHUD showTipMessageInView:@"请输入WIFI密码"];
        return;
    }
    
    if ([[WifiConnectController wifSsid] containsString:@"IKB-"]) {
        [self go2ConnectWifi];
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请连接设备热点" message:@"您可以在”设置“中连接以IKB-开头的设备热点" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSURL *url = [NSURL URLWithString:@"App-Prefs:root=WIFI"];
//        if (@available(iOS 10.0, *)) {
//            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
//        } else {
//            // Fallback on earlier versions
//            [[UIApplication sharedApplication] openURL:url];
//        }
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//        [self go2ConnectWifi];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)go2ConnectWifi {
    
    [self.view endEditing:YES];
    
    APConnectController *vc =[[APConnectController alloc] init];
    vc.wifiName = self.SelectWifitextfield.text;
    vc.wifiPass = self.WifiPStextfield.text;
    vc.hasBind = self.hasBind;
    [self.navigationController pushViewController:vc animated:YES];
    
//    test
//    APDeviceSearchController *vc = [[APDeviceSearchController alloc] init];
//    vc.deviceID = @"IKB-000113-VZHDT";
//    vc.wifiName = self.SelectWifitextfield.text;
//    vc.wifiPass = self.WifiPStextfield.text;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing: YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];//此处是限制空格输入
    if (![string isEqualToString:tem]) {
        return NO;
    }
    return YES;
}

#pragma mark - private
- (void)alertController:(NSString *)alertMessage
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:alertMessage preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {

        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];

    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"点击了取消按钮");
//        exit(0);
    }]];

    [self presentViewController:alert animated:YES completion:nil];
}

@end
