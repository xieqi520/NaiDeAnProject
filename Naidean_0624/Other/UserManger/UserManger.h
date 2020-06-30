//
//  UserManger.h
//  Naidean
//
//  Created by xujun on 2018/1/12.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserManger : NSObject

+(UserManger*)sharedInstance;
/**保存用户Id*/
-(void)cacheUserId:(NSString *)userId;
-(NSString *)getUserId;
-(void)removeUserId;
/**保存用户手机号*/
-(void)cacheUserPhone:(NSString *)phone;
-(NSString *)getUserPhone;
-(void)removeUserPhone;

// 用户昵称
-(void)cacheUserNickname:(NSString *)phone;

-(NSString *)getUserNickname;

-(void)removeUserNickname;

/**保存用户登录名*/
- (void)cacheUserName:(NSString *)userName;
/**获取用户登录名*/
- (NSString *)getUserName;
/**移除用户登录名*/
- (void)removeUserName;

/**保存用户登录密码*/
- (void)cacheUserPassWord:(NSString *)userPassWord;
/**获取用户登录密码*/
- (NSString *)getUserPassWord;
/**移除用户登录密码*/
- (void)removePassWord;

/**保存Token值*/
- (void)cacheMemberToken:(NSString *)memberToken;
/**获取Token值*/
- (NSString *)getMemberToken;
/**移除Token值*/
- (void)removeMemberToken;

/**保存用户登录密码*/
- (void)cacheSelectDeviceIndex:(NSInteger)index;
/**获取用户登录密码*/
- (NSInteger)getSelectDeviceIndex;

/**保存用户头像地址*/
-(void)cacheHeadPortrait:(NSString *)headPortraitPath;
-(NSString *)getHeadPortrait;

/**保存开锁方式*/
- (void)cacheUnlockType:(NSInteger)type;
- (NSInteger)getUnlockType;

/**本地删除的开锁记录ID*/
- (void)cacheIgnoreIds:(NSArray *)ary;
- (NSArray *)getIgnoreIds;

/**清除manager*/
- (void)destroyManager;

/**保存UUID*/
- (void)cacheDeviceIDWithUUIDWithString:(NSString *)string;
- (NSString *)getDeviceIDWithUUID;


-(void)cacheCaramaDid:(NSString *)did;
-(NSString *)getCaramaDid;

-(void)cacheAliaId:(NSString *)Id;
-(NSString *)getAliaId;
@end
