//
//  YZYNetWorkState.m
//  XcloudlinkDemo
//
//  Created by lijiang on 17/5/17.
//  Copyright © 2017年 lijiang. All rights reserved.
//

#import "YZYNetWorkState.h"

@implementation YZYNetWorkState

// 实例化单例对象
+ (YZYNetWorkState *)shareMonitorNetWorkState{
    
    static YZYNetWorkState *shareObj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareObj = [[YZYNetWorkState alloc] init];
    });
    
    return shareObj;
}

// 获取当前网络类型
- (YZYNetWorkStateType)getCurrentNetWorkType{
    
    YZYNetWorkStateType netWorkType;
    // 1.检测wifi状态
    Reachability *wifi = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    // 2.检测手机是否能上网络(WIFI\3G\2.5G)
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    
    // 3.判断网络状态
    if ([wifi currentReachabilityStatus] == ReachableViaWiFi) {
        
        // 有wifi
        netWorkType = YZYNetWorkStateTypeWIFI;
  
    } else if ([conn currentReachabilityStatus] == ReachableViaWWAN) {
        
        // 没有使用wifi, 使用手机自带网络进行上网
        netWorkType = YZYNetWorkStateTypeGPRS;
   
    } else {
        
        // 没有网络
        netWorkType = YZYNetWorkStateTypeNoconnect;
    }
    return netWorkType;
}

// 添加网络监听
- (void)addMonitorNetWorkState{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkStateChanged) name:kReachabilityChangedNotification object:nil];
    self.conn = [Reachability reachabilityForInternetConnection];
    [self.conn startNotifier];
}

// 触发时机，网络状态发生改变
- (void)netWorkStateChanged{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(netWorkStateChanged)]) {
        
        [self.delegate netWorkStateChanged];
    }
}

/**
 * 获取网络状态
 * YES 有网络
 * NO  无网络
 */
- (BOOL)getNetWorkState{
    
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    
    if ([wifi currentReachabilityStatus] != NotReachable) {
        
        return YES;
    }else if([conn currentReachabilityStatus] != NotReachable) {
        
        return YES;
    }else{
        
        return NO;
    }
}


@end
