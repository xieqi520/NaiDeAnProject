
//
//  APDeviceSearchController.m
//  Naidean
//
//  Created by Zoe on 2019/2/23.
//  Copyright © 2019年 com.saiyikeji. All rights reserved.
//

#import "APDeviceSearchController.h"
#import "SearchDVS.h"
#import "AppDelegate.h"
#import "SHIXCommonProtocol.h"
#import "APICommon.h"
static int TIMER_MULTICAST_TIMEOUT   = 60;//30s

@interface APDeviceSearchController ()<SHIXCommonProtocol>
{
    CSearchDVS *m_pSearchDVS;
    NSTimer *searchTimer;
}

@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (nonatomic, strong) NSTimer *sendTimeOutTimer;
@property (nonatomic, assign) NSInteger totalSecond;
@property (nonatomic, strong) DeviceModel *currentDevice;
@end

@implementation APDeviceSearchController
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubviews];
}

- (void)configSubviews {
    self.title = @"正在连接";
    self.confirmBtn.enabled = NO;
    self.confirmBtn.alpha = 0.4;
    self.totalSecond = TIMER_MULTICAST_TIMEOUT;
    self.countDownLabel.text = [@(self.totalSecond) description];
    
    [self creatTimer];
}

- (void)creatTimer {
    //create the start timer
    searchTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
    // 加入RunLoop中
    [[NSRunLoop mainRunLoop] addTimer:searchTimer forMode:NSDefaultRunLoopMode];
}

#pragma mark - event response
- (IBAction)confirmAction:(UIButton *)sender {
    if (self.hasBind) {
        [self backToHomeVC:@"设备重新配网成功"];
    }else {
        //添加设备
        NSString *linkType = [NSString stringWithFormat:@"%zd",[[UserManger sharedInstance] getUnlockType]];
        NSString *phone = [NSString stringWithFormat:@"%@",[[UserManger sharedInstance] getUserPhone]];
//        NSDictionary *params = @{
//                                 @"number":phone,
//                                 @"mac":self.deviceID,
//                                 @"lockName":self.deviceID,
//                                 @"isAdmin":@"0",
//                                 @"linkType":linkType,
//                                 @"uid":self.wifiName,//WiFi模块的唯一标识
//                                 @"password":self.wifiPass//WiFi模块访问密码
//                                 };
//        DDLog(@"授权用户绑定设备:%@;params:%@",NETWORK_REQUEST_URL(BINDING_DEVICES_URL),params);
//        [MBProgressHUD showActivityMessageInView:@"正在添加设备"];
//        [HttpTool getWithURL:NETWORK_REQUEST_URL(BINDING_DEVICES_URL) params:params success:^(id json) {
//            NSLog(@"result:%@",json);
//            [MBProgressHUD hideHUD];
//            [MBProgressHUD showTipMessageInView:json[@"resMessage"]];
//            int status = [json[@"resCode"] intValue];
//            if (status == 0) {
//                [self backToHomeVC:json[@"resMessage"]];
//            }else{
//                [MBProgressHUD showTipMessageInView:json[@"resMessage"]];
//            }
//        } failure:^(NSError *error) {
//            [MBProgressHUD hideHUD];
//            [MBProgressHUD showTipMessageInView:[error localizedDescription]];
//        }];
        
        NSDictionary *params = @{
                                 @"mac":self.currentDevice.mac,
                                 @"name":self.currentDevice.name,
                                 @"type":linkType,
                                 @"videoId":self.deviceID,
                                 @"videoPwd":self.wifiPass,
                                 @"videoUser":self.wifiName
                                 };
        
        [MBProgressHUD showActivityMessageInView:@"正在添加设备"];
        NSString *httpUrl = [NSString stringWithFormat:@"%@/%@",NETWORK_REQUEST_URL(BINDING_DEVICES_URL),[[UserManger sharedInstance] getMemberToken]];
        
      
        WEAK_SELF
        [HttpTool postWithURL:httpUrl params:params success:^(id json) {
            STRONG_SELF
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInView:json[@"message"]];
            
            int code = [json[@"code"] intValue];
            if (code == 1000) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Add_Device_Success" object:nil];
                [strongSelf.navigationController popToRootViewControllerAnimated:YES];
            }
            else if (code == TimeOutCode)
            {
                [MBProgressHUD showTipMessageInView:json[@"登录超时，请重新登录"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_TimeOut_Login object:nil];
            }
            else
            {
                [MBProgressHUD showTipMessageInView:json[@"message"]];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInView:[error localizedDescription]];
        }];
    }
}

- (void)handleTimer:(NSTimer *)timer
{
    self.totalSecond--;
    self.countDownLabel.text = [@(self.totalSecond) description];

    //两秒搜索一次设备
    if (self.currentDevice == nil && self.totalSecond%2 == 0) {
        [self startSearch];
    }
    if (self.totalSecond == 0) {
        [MBProgressHUD showInfoMessage:@"搜索超时，请重新配置"];
        [self stopTimer];
        [self stopSearch];
    }
}

#pragma mark - 局域网搜索
- (void)startSearch
{
    [self stopSearch];
    m_pSearchDVS = new CSearchDVS();
    m_pSearchDVS->searchResultDelegate = self;
    m_pSearchDVS->Open();
}

- (void)stopSearch
{
    if (m_pSearchDVS != NULL) {
        m_pSearchDVS->searchResultDelegate = nil;
        SAFE_DELETE(m_pSearchDVS);
    }
}

- (void)stopTimer {
    [searchTimer invalidate];
    searchTimer = nil;
}

#pragma mark - 搜索设备成功
- (void)searchDeviceSuccess:(NSString *)deviceID {
    [MBProgressHUD showSuccessMessage:@"配置搜索成功"];
    self.confirmBtn.enabled = YES;
    self.confirmBtn.alpha = 1;
    [self stopSearch];
    [self stopTimer];
}

- (void)backToHomeVC:(NSString *)resMessage {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:resMessage message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Add_Device_Success" object:nil];
        UINavigationController *navVC = self.navigationController;
        NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
        for (UIViewController *vc in [navVC viewControllers]) {
            [viewControllers addObject:vc];
            if ([vc isKindOfClass:[HomeController class]]) {
                break;
            }
        }
        
        [navVC setViewControllers:viewControllers animated:YES];
    }];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - SHIXCommonProtocol
/**
 局域网搜索回调
 **/
- (void)SearchCameraResult:(NSString *)mac Name:(NSString *)name Addr:(NSString *)addr Port:(NSString *)port DID:(NSString *)did {
//    000000000000--IKBELL--192.168.0.118--0--IKB-000120-TTKGV
//    NSLog(@"%@--%@--%@--%@--%@",mac,name,addr,port,did);
    if ([did isEqualToString:self.deviceID]) {
        self.currentDevice = [DeviceModel new];
        self.currentDevice.mac = did;
        self.currentDevice.name = name ? name : did;
        [self performSelectorOnMainThread:@selector(searchDeviceSuccess:) withObject:did waitUntilDone:NO];
    }
}

@end
