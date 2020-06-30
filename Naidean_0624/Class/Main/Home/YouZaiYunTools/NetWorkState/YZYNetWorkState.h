//
//  YZYNetWorkState.h
//  XcloudlinkDemo
//
//  Created by lijiang on 17/5/17.
//  Copyright © 2017年 lijiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"


/*
 网络状态
 */
typedef NS_ENUM(NSInteger, YZYNetWorkStateType)
{
    YZYNetWorkStateTypeNoconnect = 0,//无网络
    YZYNetWorkStateTypeGPRS = 1,//GPRS网络
    YZYNetWorkStateTypeWIFI = 2,//wifi网络
};

@protocol YZYNetWorkStateDelegate <NSObject>

@optional

/**
 * 当网络状态发生改变的时候触发， 前提是必须是添加网络状态监听
 */
- (void)netWorkStateChanged;

@end


@interface YZYNetWorkState : NSObject


@property (nonatomic, strong) Reachability *conn;

@property (nonatomic, assign) id<YZYNetWorkStateDelegate>delegate;

/**
 * 实例化单例对象
 */
+ (YZYNetWorkState *)shareMonitorNetWorkState;

/**
 * 获取当前网络类型 GPRS / wifi / noConnect
 */
- (YZYNetWorkStateType)getCurrentNetWorkType;

/**
 * 添加网络状态监听
 */
- (void)addMonitorNetWorkState;

/**
 * 获取网络状态
 * YES 有网络
 * NO  无网络
 */
- (BOOL)getNetWorkState;

@end
