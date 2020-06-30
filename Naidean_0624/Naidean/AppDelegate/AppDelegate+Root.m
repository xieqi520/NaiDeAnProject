//
//  AppDelegate+Root.m
//  Naidean
//
//  Created by xujun on 2018/1/3.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//




///优载云key secret
#define mYzyAccount   @"a81cf24b8c634bc5778eb4fd08a134c9"  //您申请的优载云开发者中心key
#define mYzyPass  @"2ae9aa03927c84b3b3114e5e2e4901e8"   //您申请的优载云开发者中心secret


#import <AdSupport/AdSupport.h>
#import "AppDelegate+Root.h"
#import "LoginController.h"
#import "ChooseLockTypeViewController.h"


@implementation AppDelegate  (Root)
/**
 APP启动完成的回调方法
 
 @param application UIApplication对象
 @param launchOptions nil
 */
- (void)rootApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    keyboardManager.enable = YES; // 控制整个功能是否启用
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    keyboardManager.enableAutoToolbar = NO; // 控制是否显示键盘上的工具条
    keyboardManager.keyboardDistanceFromTextField = 15.0f; // 输入框距离键盘的距离
    
    UserManger *manager = [UserManger sharedInstance];
    NSString *uuid = [manager getDeviceIDWithUUID];
    if (uuid.length == 0) {
        uuid = [[NSUUID UUID] UUIDString];
        [manager cacheDeviceIDWithUUIDWithString:uuid];
    }
    
    NSString *userPhone = [manager getUserPhone];
    DDLog(@"userPhone:%@",userPhone);
    if (userPhone.length > 0) {
        [self loginFast];
    }else{
        [self loginInFirstTime];
    }
    
//    [self settingYZYSDK];
    
    
}
/**
 首次登陆，进入登陆界面
 */
- (void)loginInFirstTime{
    //登录界面
    LoginController * vc = [[LoginController alloc] init];
    BaseNavController * nav = [[BaseNavController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
}


/**
 快速登录
 */
- (void)loginFast{
  
    ChooseLockTypeViewController * vc = [[ChooseLockTypeViewController alloc] init];
//    LoginController * vc = [[LoginController alloc] init];
    BaseNavController * homeNav = [[BaseNavController alloc] initWithRootViewController:vc];
    self.window.rootViewController = homeNav;
    
}

#pragma mark - 设置优载云SDK
-(void)settingYZYSDK
{
    // ---------------------------  添加检测网络切换类工具 -----------
    [[WLSQXcloulink sharedManager] addMonitorNetWorkStateWithWLSQXcloulinkNetWorkStateDelegate:self];
    
    // --------------------------------  初始化优载云 -------------------------------------------------
    [[WLSQXcloulink sharedManager] initIntelligentEquipment];
    
    // --------------------------------  添加优载云服务器 -------------------------------------------------
    [[WLSQXcloulink sharedManager] AddXCloudHostWith:@"box1.xcloudlink.com" nPort:8080 hProto:11];
    [[WLSQXcloulink sharedManager] AddXCloudHostWith:@"box1.xcloudlink.com" nPort:80 hProto:12];
    [[WLSQXcloulink sharedManager] AddXCloudHostWith:@"box1.xcloudlink.com" nPort:81 hProto:12];
    [[WLSQXcloulink sharedManager] AddXCloudHostWith:@"box2.xcloudlink.com" nPort:8080 hProto:11];
    [[WLSQXcloulink sharedManager] AddXCloudHostWith:@"box2.xcloudlink.com" nPort:80 hProto:12];
    [[WLSQXcloulink sharedManager] AddXCloudHostWith:@"box2.xcloudlink.com" nPort:81 hProto:12];
    [[WLSQXcloulink sharedManager] AddXCloudHostWith:@"box3.xcloudlink.com" nPort:8080 hProto:11];
    [[WLSQXcloulink sharedManager] AddXCloudHostWith:@"box3.xcloudlink.com" nPort:80 hProto:12];
    [[WLSQXcloulink sharedManager] AddXCloudHostWith:@"box3.xcloudlink.com" nPort:81 hProto:12];
    [[WLSQXcloulink sharedManager] AddXCloudHostWith:@"box4.xcloudlink.com" nPort:8080 hProto:11];
    [[WLSQXcloulink sharedManager] AddXCloudHostWith:@"box4.xcloudlink.com" nPort:80 hProto:12];
    [[WLSQXcloulink sharedManager] AddXCloudHostWith:@"box4.xcloudlink.com" nPort:81 hProto:12];
    [[WLSQXcloulink sharedManager] AddXCloudHostWith:@"box5.xcloudlink.com" nPort:8080 hProto:11];
    [[WLSQXcloulink sharedManager] AddXCloudHostWith:@"box5.xcloudlink.com" nPort:80 hProto:12];
    [[WLSQXcloulink sharedManager] AddXCloudHostWith:@"box5.xcloudlink.com" nPort:81 hProto:12];
    [[WLSQXcloulink sharedManager] AddXCloudHostWith:@"box6.xcloudlink.com" nPort:8080 hProto:11];
    [[WLSQXcloulink sharedManager] AddXCloudHostWith:@"box6.xcloudlink.com" nPort:80 hProto:12];
    [[WLSQXcloulink sharedManager] AddXCloudHostWith:@"box6.xcloudlink.com" nPort:81 hProto:12];
    [[WLSQXcloulink sharedManager] AddXCloudHostWith:@"box7.xcloudlink.com" nPort:8080 hProto:11];
    [[WLSQXcloulink sharedManager] AddXCloudHostWith:@"box7.xcloudlink.com" nPort:80 hProto:12];
    [[WLSQXcloulink sharedManager] AddXCloudHostWith:@"box7.xcloudlink.com" nPort:81 hProto:12];
    [[WLSQXcloulink sharedManager] AddXCloudHostWith:@"box8.xcloudlink.com" nPort:8080 hProto:11];
    [[WLSQXcloulink sharedManager] AddXCloudHostWith:@"box8.xcloudlink.com" nPort:80 hProto:12];
    [[WLSQXcloulink sharedManager] AddXCloudHostWith:@"box8.xcloudlink.com" nPort:81 hProto:12];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        [[WLSQXcloulink sharedManager] loginWithYzyAccount:mYzyAccount YzyPassword:mYzyPass];

    });
}

#pragma mark 网络监听的代理方法，当网络状态发生改变的时候触发
- (void)WLSQXcloulinkNetWorkStateChangedStateType:(YZYNetWorkStateType)netWorkStateType
{
    [[WLSQXcloulink sharedManager] setLoginState:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NDA_NetWorkStateTypeChanged" object:@(netWorkStateType)];
    DDLog(@"获取当前网络状态:************%ld",(long)netWorkStateType);
}





/**
 使用图片的原始颜色
 @param image UIImage对象
 @return UIImage对象
 */
//- (UIImage *)setImageRenderModel:(UIImage *)image
//{
//    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//}



@end
