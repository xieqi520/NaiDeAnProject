//
//  AppDelegate.m
//  Naidean
//
//  Created by xujun on 2018/1/3.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//  188 2343 2527

// 引入JPush功能所需头文件
#import "JPUSHService.h"
#import "SYIncomingCallController.h"
#import "LoginController.h"
#import "DeviceModel.h"

// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max

#import <UserNotifications/UserNotifications.h>

#endif

#import "AppDelegate.h"
#import "AppDelegate+Root.h"
#import "PPPPChannelManagement.h"
//#import "XGPush.h"



@interface AppDelegate ()<JPUSHRegisterDelegate>
{
    CPPPPChannelManagement *m_pPPPPChannelMgt;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self rootApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    
    application.statusBarStyle = UIStatusBarStyleLightContent;
    application.statusBarHidden = NO;
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    
    //视频
    m_pPPPPChannelMgt = new CPPPPChannelManagement();
    
    //添加初始化APNs代码
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // init Push
    /**
     apsForProduction
     1.3.1版本新增，用于标识当前应用所使用的APNs证书环境。
     0 (默认值)表示采用的是开发证书，1 表示采用生产证书发布应用。
     注：此字段的值要与Build Settings的Code Signing配置的证书环境一致。
     */   //极光账号：naidean@163.com       Czq869908
    [JPUSHService setupWithOption:launchOptions appKey:@"569cfd4631acba8668d8764b"
                          channel:nil
                 apsForProduction:0
            advertisingIdentifier:nil];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:)name:kJPFNetworkDidReceiveMessageNotification object:nil];

//    [self initXG:launchOptions];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self configPushParam];
    });
    
    [self configPushParam];
    return YES;
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
        [self SHIX_SendTrans:deviceId SEND:str];
    }
    
}

//-(void)initXG:(NSDictionary*)launchOptions{
//
////
//    [[XGPush defaultManager] startXGWithAppID:2200262432 appKey:@"I89WTUY132GJ" delegate:self];
//    // 清除角标
//    if ([XGPush defaultManager].xgApplicationBadgeNumber > 0) {
//        [[XGPush defaultManager] setXgApplicationBadgeNumber:0];
//    }
//    [[XGPush defaultManager] reportXGNotificationInfo:launchOptions];
//}
//
//#pragma --mark
//
//
//#pragma mark - XGPushDelegate
//- (void)xgPushDidFinishStart:(BOOL)isSuccess error:(NSError *)error {
//    NSLog(@"%s, result %@, error %@", __FUNCTION__, isSuccess?@"OK":@"NO", error);
//    UIViewController *ctr = [self.window rootViewController];
//    if ([ctr isKindOfClass:[UINavigationController class]]) {
//
//    }
//}
//
//- (void)xgPushDidFinishStop:(BOOL)isSuccess error:(NSError *)error {
//    UIViewController *ctr = [self.window rootViewController];
//    if ([ctr isKindOfClass:[UINavigationController class]]) {
//
//    }
//
//}
//
//- (void)xgPushDidRegisteredDeviceToken:(NSString *)deviceToken error:(NSError *)error {
//    NSLog(@"%s, result %@, error %@--%@", __FUNCTION__, error?@"NO":@"OK", error,deviceToken);
//
//}

// iOS 10 新增 API
// iOS 10 会走新 API, iOS 10 以前会走到老 API
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// App 用户点击通知
// App 用户选择通知中的行为
// App 用户在通知中心清除消息
// 无论本地推送还是远程推送都会走这个回调
//- (void)xgPushUserNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
//    NSLog(@"[XGDemo] click notification");
//    if ([response.actionIdentifier isEqualToString:@"xgaction001"]) {
//        NSLog(@"click from Action1");
//    } else if ([response.actionIdentifier isEqualToString:@"xgaction002"]) {
//        NSLog(@"click from Action2");
//    }
//
//    if (@available(iOS 10.0, *)) {
//        [[XGPush defaultManager] reportXGNotificationResponse:response];
//    } else {
//        // Fallback on earlier versions
//    }
//
//    completionHandler();
//}

// App 在前台弹通知需要调用这个接口
//- (void)xgPushUserNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
//    [[XGPush defaultManager] reportXGNotificationInfo:notification.request.content.userInfo];
//    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
//}
#endif
/**
 统一收到通知消息的回调
 @param notification 消息对象
 @param completionHandler 完成回调
 @note SDK 3.2.0+
 */
//- (void)xgPushDidReceiveRemoteNotification:(id)notification withCompletionHandler:(void (^)(NSUInteger))completionHandler {
//    if ([notification isKindOfClass:[NSDictionary class]]) {
//        [[XGPush defaultManager] reportXGNotificationInfo:(NSDictionary *)notification];
//        completionHandler(UIBackgroundFetchResultNewData);
//    } else if ([notification isKindOfClass:[UNNotification class]]) {
//        [[XGPush defaultManager] reportXGNotificationInfo:((UNNotification *)notification).request.content.userInfo];
//        completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
//    }
//}
//
//- (void)xgPushDidSetBadge:(BOOL)isSuccess error:(NSError *)error {
//    NSLog(@"%s, result %@, error %@", __FUNCTION__, error?@"NO":@"OK", error);
//}

#pragma mark  --- 视频相关方法


-(int)SHIX_StopAll{
    
    if (m_pPPPPChannelMgt == NULL) {
        m_pPPPPChannelMgt = new CPPPPChannelManagement();
    }
    
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->StopAll();
    }else{
        return -1;
    }
    return 0;
}

-(int)SHIX_StartConnect:(NSString *)did USER:(NSString *)user PWD:(NSString *)pwd{
    if (m_pPPPPChannelMgt == NULL) {
        m_pPPPPChannelMgt = new CPPPPChannelManagement();
    }
    
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->Start([did UTF8String], [user UTF8String], [pwd UTF8String]);
    }else{
        return -1;
    }
    return 0;
}

-(int)SHIX_StoptConnect:(NSString *)did{
    
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->Stop([did UTF8String]);
    }else{
        return -1;
    }
    return 0;
}

-(int)SHIX_DevStatus:(NSString *)did PRO:(id)delegate{
    if (m_pPPPPChannelMgt == NULL) {
        m_pPPPPChannelMgt = new CPPPPChannelManagement();
    }
    
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->SetCameraStatusDelegate((char *)[did UTF8String], delegate);
    }else{
        return -1;
    }
    return 0;
}

-(int)SHIX_TansPro:(NSString *)did PRO:(id)delegate{
    
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->SetTransferDelegate((char *)[did UTF8String], delegate);
    }else{
        return -1;
    }
    return 0;
}
-(int)SHIX_Heart:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd{
    
    
    if (m_pPPPPChannelMgt == NULL) {
        return 0;
    }
    
    if (did==NULL||user==NULL||pwd==NULL) {
        NSLog(@"SHIX_startP2P did==NULL||user==NULL||pwd==NULL");
        return 0;
    }
    
    
    NSMutableDictionary *parameters1 = [NSMutableDictionary dictionary];
    [parameters1 setValue:@"dev_control" forKey:@"pro"];
    [parameters1 setValue:[NSNumber numberWithInt:102] forKey:@"cmd"];
    
    [parameters1 setValue:user forKey:@"user"];
    [parameters1 setValue:pwd forKey:@"pwd"];
    [parameters1 setValue:[NSNumber numberWithInt:1] forKey:@"heart"];
    
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters1 options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}
-(int)SHIX_SendTrans:(NSString *)did SEND:(NSString *)str{
    if (m_pPPPPChannelMgt == NULL) {
        m_pPPPPChannelMgt = new CPPPPChannelManagement();
    }
    
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return -1;
    }
    return 0;
}

-(int)SHIX_Video:(NSString *)did PRO:(id)delegate{
    if (m_pPPPPChannelMgt == NULL) {
        m_pPPPPChannelMgt = new CPPPPChannelManagement();
    }
    
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->StartPPPPLivestream((char *)[did UTF8String], delegate);
    }else{
        return -1;
    }
    return 0;
}

-(int)SHIX_StopVideo:(NSString *)did{
    

    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->StopPPPPLivestream((char *)[did UTF8String]);
    }else{
        return -1;
    }
    return 0;
}

-(int)SHIX_Snapshot:(NSString *)did{
    if (m_pPPPPChannelMgt == NULL) {
        m_pPPPPChannelMgt = new CPPPPChannelManagement();
    }
    
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->Snapshot((char *)[did UTF8String]);
    }else{
        return -1;
    }
    return 0;
}
-(int)SHIX_StartAudio:(NSString *)did{
    if (m_pPPPPChannelMgt == NULL) {
        m_pPPPPChannelMgt = new CPPPPChannelManagement();
    }
    
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->StartPPPPAudio((char *)[did UTF8String]);
    }else{
        return -1;
    }
    return 0;
}
-(int)SHIX_StopAudio:(NSString *)did{
   
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->StopPPPPAudio((char *)[did UTF8String]);
    }else{
        return -1;
    }
    return 0;
}

-(int)SHIX_StartTalk:(NSString *)did{
    if (m_pPPPPChannelMgt == NULL) {
        m_pPPPPChannelMgt = new CPPPPChannelManagement();
    }
    
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->StartPPPPTalk((char *)[did UTF8String]);
    }else{
        return -1;
    }
    return 0;
}
-(int)SHIX_StopTalk:(NSString *)did{
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->StopPPPPTalk((char *)[did UTF8String]);
    }else{
        return -1;
    }
    return 0;
}


-(int)SHIX_WillEchoData:(NSString *)did LEN:(int)len Data:(void *)data{
    
    if (m_pPPPPChannelMgt == NULL) {
        m_pPPPPChannelMgt = new CPPPPChannelManagement();
    }
    
    if (m_pPPPPChannelMgt!=NULL) {
        return  m_pPPPPChannelMgt->GetAudioFramData([did UTF8String], data,len);
    }else{
        return -1;
    }
    return 0;
}

-(int)SHIX_EchoData:(NSString *)did Data:(const char *)data Len:(int)len{
    
    if (m_pPPPPChannelMgt!=NULL) {
        return  m_pPPPPChannelMgt->TalkAudioData([did UTF8String], data, len);
    }else{
        return -1;
    }
    return 0;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
      [[WLSQXcloulink sharedManager] AddBackgroundTaskInvalid];
    //发送通知 程序进入后台
    if ([UserManageClass sharedManager].isCamera == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"isDidEnterBackground" object:nil];
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    //发送通知 程序从后台进入前台
    if ([UserManageClass sharedManager].isCamera == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"isWillEnterForeground" object:nil];
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    NSString *deviceTokenString = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""]stringByReplacingOccurrencesOfString:@">" withString:@""]stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"方式2：%@", deviceTokenString);
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//    NSString *appToken = [defaults objectForKey:@"deviceToken"];//保存设备所获取到到deviceToken
    [defaults setObject:deviceTokenString forKey:@"deviceToken"];
    [defaults synchronize];
//    [[XGPushTokenManager defaultTokenManager]bindWithIdentifier:deviceTokenString type:XGPushTokenBindTypeAccount];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {//Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    NSString *NoitType = [userInfo valueForKey:@"type"];
    if ([NoitType isEqualToString:@"doorbell"]) {
        NSString *deviceId = [userInfo valueForKey:@"deviceId"];
        NSLog(@"deviceId ===%@",deviceId);
        BaseNavController * homeNav = (BaseNavController *)self.window.rootViewController;
        UIViewController *fristview = [homeNav.viewControllers objectAtIndex:0];
        if (![fristview isKindOfClass:[LoginController class]] && homeNav.viewControllers.count > 1) {
            UIViewController *lastview = homeNav.viewControllers.lastObject;
            HomeController *homeview = [homeNav.viewControllers objectAtIndex:1];
            SYIncomingCallController *doorbellVC = [[SYIncomingCallController alloc] init];
            for(DeviceModel *mode in homeview.menuArray)
            {
                if ([mode.id isEqualToString:deviceId]) {
                    doorbellVC.deviceModel = mode;
                    break;
                }
            }
            [lastview.navigationController pushViewController:doorbellVC animated:YES];
        }
    }
    else if([NoitType isEqualToString:@"status"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Add_Device_Success" object:nil];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

#endif

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    
       /**
        
             *参数描述：
        
             content：获取推送的内容
        
             extras：获取用户自定义参数
        
             customizeField1：根据自定义key获取自定义的value
        
             */
    
       NSDictionary * userInfo = [notification userInfo];
    
       NSString *content = [userInfo valueForKey:@"content"];
    
       NSDictionary *extras = [userInfo valueForKey:@"extras"];
    
       NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; ///服务端传递的Extras附加字段，key是自己定义的
    
        NSInteger badge = [[[userInfo valueForKey:@"aps"]valueForKey:@"badge"]integerValue];
    
       NSLog(@"%jiaobao--ld",(long)badge);
    
        NSLog(@"custuserInfo:%@",userInfo);
    
        NSLog(@"custcontent:%@",content);
    
        NSLog(@"custextras:%@",extras);
    
       NSLog(@"customizeField1:%@",customizeField1);
    
        NSLog(@"cust获取注册ID:%@",    [JPUSHService registrationID]);
    
        
    
}

//设备别名
- (void) setTags:(NSString *) alias
{
        [JPUSHService setTags:nil alias:alias fetchCompletionHandle:^(int iResCode,NSSet *iTags, NSString *iAlias) {
                NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags , iAlias);//对应的状态码返回为0，代表成功
            }];
}
@end
