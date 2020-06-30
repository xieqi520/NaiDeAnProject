//
//  LockLogModel.h
//  Naidean
//
//  Created by aoxin on 2018/8/7.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LockLogModel : NSObject

@property (nonatomic, copy) NSString *id;//开锁记录ID
@property (nonatomic, copy) NSString *deviceMac;//Mac地址
@property (nonatomic, copy) NSString *openType;// 开锁类型：1 APP 2 钥匙开锁 3 指纹开锁 4 密码开锁 0 关锁
@property (nonatomic, copy) NSString *createTime;//开锁时间
@property (nonatomic, assign) NSInteger openValue;//门锁状态  1:开门,0:失败
@property (nonatomic, copy) NSString *memoName;//用户名
@property (nonatomic, copy) NSString *pic;//头像
@property (nonatomic, copy) NSString *deviceId;  //设备ID
@property (nonatomic, copy) NSString *userId;  //用户ID
@property (nonatomic, copy) NSString *phone;//手机号

- (id)initWithJSON:(id)json;

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
