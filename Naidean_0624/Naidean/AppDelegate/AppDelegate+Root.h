//
//  AppDelegate+Root.h
//  Naidean
//
//  Created by xujun on 2018/1/3.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Root)

/**
 APP启动完成的回调方法
 
 @param application UIApplication对象
 @param launchOptions nil
 */
- (void)rootApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
/**
 首次登陆，进入登陆界面
 
 */
- (void)loginInFirstTime;
/**
 快速登录
 */
- (void)loginFast;


@end
