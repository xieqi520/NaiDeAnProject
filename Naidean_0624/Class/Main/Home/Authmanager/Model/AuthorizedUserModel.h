//
//  AuthorizedUserModel.h
//  Naidean
//
//  Created by aoxin on 2018/8/8.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthorizedUserModel : NSObject

@property (nonatomic, copy) NSString *userId;//用户ID
@property (nonatomic, copy) NSString *id;//授权ID
@property (nonatomic, copy) NSString *phone;//用户手机号
@property (nonatomic, copy) NSString *deviceId;//设备ID
@property (nonatomic,assign) NSInteger userType;//是否是管理员, 1:普通管理员,2:保姆
@property (nonatomic,copy) NSString *grantUserId;//权限
@property (nonatomic,copy) NSString *memoName;//授权用户名称
@property (nonatomic,copy) NSString *pic;//授权用户头像地址
@property (nonatomic,copy) NSString *openPwd;//远程开锁密码
@property (nonatomic,assign) NSInteger unManned;//无人模式是否开启   0:关闭,1:开启
@property (nonatomic,assign) NSInteger prying;//防撬报警是否开启    0:关闭,1:开启
@property (nonatomic,assign) NSInteger lowPower;//低电报警是否开启   0:关闭,1:开启
@property (nonatomic, copy) NSArray *times;//开锁时段
@property (nonatomic, copy) NSArray *weeks;//每周可以开锁的天数

- (instancetype)initWithJSON:(id)json;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;


@end
