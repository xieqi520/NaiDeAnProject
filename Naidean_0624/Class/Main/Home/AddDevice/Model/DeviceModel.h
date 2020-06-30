//
//  DeviceModel.h
//  Naidean
//
//  Created by aoxin on 2018/8/6.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYlockTimeModel.h"
@interface DeviceModel : NSObject

//@property (nonatomic,copy) NSString *masterPhone;//管理员手机号
//@property (nonatomic,assign) NSInteger bindingID;//绑定ID
//@property (nonatomic,copy) NSString *mac;//MAC地址
//@property (nonatomic,copy) NSString *lockName;//设备名
//@property (nonatomic,copy) NSString *lockPwd;//设备密码
//@property (nonatomic,copy) NSString *number;//登录的用户手机号
//@property (nonatomic,assign) NSInteger isAdmin;//是否是管理员, 0:不是,1:是
//@property (nonatomic,copy) NSString *jurisdiction;//权限
//@property (nonatomic,copy) NSString *remark;//授权用户名称
//@property (nonatomic,copy) NSString *pwd;//远程开锁密码
//@property (nonatomic,assign) NSInteger unManned;//无人模式是否开启   0:关闭,1:开启
//@property (nonatomic,assign) NSInteger prying;//防撬报警是否开启    0:关闭,1:开启
//@property (nonatomic,assign) NSInteger lowPower;//低电报警是否开启   0:关闭,1:开启
//@property (nonatomic,copy) NSString *uid;//wifi模块唯一标识
//@property (nonatomic,copy) NSString *password;//wifi模块访问密码
//@property (nonatomic, copy) NSArray *periodList;//开锁时段
//@property (nonatomic, copy) NSArray *lockTimeList;//每周可以开锁的天数

@property (nonatomic,copy) NSString *createTime;//创建时间
@property (nonatomic,copy) NSString *electricity;//电量
@property (nonatomic,copy) NSString *id;//设备ID
@property (nonatomic,assign) NSInteger low;//低电量报警 1 打开 0 关闭 null 关闭
@property (nonatomic,copy) NSString *mac;//设备MAC
@property (nonatomic,copy) NSString *name;//设备名称
@property (nonatomic,assign) NSInteger oneline;//设备在线状态 1 在线 0 离线 null 未知
@property (nonatomic,copy) NSString *openPwd;//开锁密码
@property (nonatomic,assign) NSInteger prying;//防撬报警 1 打开 0 关闭 null 关闭
@property (nonatomic,assign) NSInteger status;//锁状态 1 打开 0 关闭 null 关闭
@property (nonatomic,assign) NSInteger temperature;//温度报警 1 打开 0 关闭 null 关闭
@property (nonatomic,assign) NSInteger type;//锁类型 1 打开 0 关闭
@property (nonatomic,assign) NSInteger unmanned;//无人报警 1 打开 0 关闭 null 关闭
@property (nonatomic,assign) NSInteger userType;//用户类型 0 超级管理员 1普通用户 2保姆
@property (nonatomic, copy) NSArray *times;//开锁时段
@property (nonatomic, copy) NSArray *weeks;//每周可以开锁的天数
@property (nonatomic,copy) NSString *videoId;//摄像头 id
@property (nonatomic,copy) NSString *videoPwd;//摄像头密码
@property (nonatomic,assign) NSString *videoUser;//摄像头 用户

- (id)initWithJSON:(id)json;

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
