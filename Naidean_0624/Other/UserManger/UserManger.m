//
//  UserManger.m
//  Naidean
//
//  Created by xujun on 2018/1/12.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#define uUserName @"kUserName" //用户名
#define uPassword @"kPassWord" //密码
#define uToken @"kToken"       //Token值
#define uUserId @"kUserId"      //用户ID
#define uHeadPortrait @"kHeadPortrait" //用户头像
#define uUserPhone @"kUserPhone" //用户手机号
#define uUserNickname @"kUserNickname" //用户手机号
#define uSelectDevice @"kSeleteDevice"//用户选择的设备
#define uUnlockType @"kUnlockType"//开锁方式
#define uIgnoreIds @"kIgnoreIds"//删除的开锁记录ID
#define uDeviceUUID @"kDeviceUUID"//设备唯一标识符

#define uCamaraDID @"kCamaraDID"
#define uAliaDID @"kAliaDID"
#import "UserManger.h"
@interface UserManger ()

@property(nonatomic,strong)NSUserDefaults *defaults;

@end

@implementation UserManger

static UserManger *userManager;
+(UserManger*)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userManager = [[UserManger alloc] init];
        userManager.defaults = [NSUserDefaults standardUserDefaults];
    });
    return userManager;
    
}

#pragma mark - 用户Id

-(void)cacheUserId:(NSString *)userId{
    [self.defaults setObject:userId forKey:uUserId];
    [self.defaults synchronize];
}

-(NSString *)getUserId{
    return [self.defaults objectForKey:uUserId];
}

-(void)removeUserId{
    [self.defaults removeObjectForKey:uUserId];
    [self.defaults synchronize];
}

#pragma mark - 用户手机号

-(void)cacheUserPhone:(NSString *)phone{
    [self.defaults setObject:phone forKey:uUserPhone];
    [self.defaults synchronize];
}

-(NSString *)getUserPhone{
    return [self.defaults objectForKey:uUserPhone];
}

-(void)removeUserPhone{
    [self.defaults removeObjectForKey:uUserPhone];
    [self.defaults synchronize];
}

#pragma mark - 用户昵称

-(void)cacheUserNickname:(NSString *)phone{
    [self.defaults setObject:phone forKey:uUserNickname];
    [self.defaults synchronize];
}

-(NSString *)getUserNickname{
    return [self.defaults objectForKey:uUserNickname];
}

-(void)removeUserNickname{
    [self.defaults removeObjectForKey:uUserNickname];
    [self.defaults synchronize];
}

#pragma mark - 用户头像

-(void)cacheHeadPortrait:(NSString *)headPortraitPath{
    [self.defaults setObject:headPortraitPath forKey:uHeadPortrait];
    [self.defaults synchronize];
}
-(NSString *)getHeadPortrait{
    return [self.defaults objectForKey:uHeadPortrait];
}

#pragma mark - 用户名

-(void)cacheUserName:(NSString *)userName{
    [self.defaults setObject:userName forKey:uUserName];
    [self.defaults synchronize];
}
-(NSString *)getUserName{
    return [self.defaults valueForKey:uUserName];
}
-(void)removeUserName{
    [self.defaults removeObjectForKey:uUserName];
    [self.defaults synchronize];
}

#pragma mark - 密码
- (void)cacheUserPassWord:(NSString *)userPassWord{
    [self.defaults setObject:userPassWord forKey:uPassword];
    [self.defaults synchronize];
}
-(NSString *)getUserPassWord{
    return [self.defaults valueForKey:uPassword];
}
-(void)removePassWord{
    [self.defaults removeObjectForKey:uPassword];
    [self.defaults synchronize];
}

#pragma mark - Token值
- (void)cacheMemberToken:(NSString *)memberToken{
    [self.defaults setObject:memberToken forKey:uToken];
    [self.defaults synchronize];
}
- (NSString *)getMemberToken{
    return [self.defaults valueForKey:uToken];
}
- (void)removeMemberToken{
    [self.defaults removeObjectForKey:uToken];
    [self.defaults synchronize];
}

#pragma mark - 用户选择的设备
- (void)cacheSelectDeviceIndex:(NSInteger)index{
    
    [self.defaults setObject:[NSNumber numberWithInteger:index] forKey:uSelectDevice];
    [self.defaults synchronize];
}
- (NSInteger)getSelectDeviceIndex{
    return [[self.defaults objectForKey:uSelectDevice] integerValue];
}

#pragma mark - 用户选择的开锁方式
- (void)cacheUnlockType:(NSInteger)type{
    [self.defaults setObject:[NSNumber numberWithInteger:type] forKey:uUnlockType];
    [self.defaults synchronize];
}
- (NSInteger)getUnlockType{
    return [[self.defaults objectForKey:uUnlockType] integerValue];
}


- (void)cacheIgnoreIds:(NSArray *)ary{
    [self.defaults setObject:ary forKey:uIgnoreIds];
    [self.defaults synchronize];
}
- (NSArray *)getIgnoreIds{
    return [self.defaults objectForKey:uIgnoreIds];
}

#pragma mark - 清除UserDefaults

- (void)destroyManager{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [self.defaults removePersistentDomainForName:appDomain];
//    self.defaults = nil;
}

- (void)cacheDeviceIDWithUUIDWithString:(NSString *)string{
    [self.defaults setObject:string forKey:uDeviceUUID];
    [self.defaults synchronize];
}

- (NSString *)getDeviceIDWithUUID {
    return [self.defaults objectForKey:uDeviceUUID];
}

-(void)cacheCaramaDid:(NSString *)did{
    [self.defaults setObject:did forKey:uCamaraDID];
    [self.defaults synchronize];
}
-(NSString *)getCaramaDid{
    return [self.defaults objectForKey:uCamaraDID];
}

-(void)cacheAliaId:(NSString *)Id{
    [self.defaults setObject:Id forKey:uAliaDID];
    [self.defaults synchronize];
}
-(NSString *)getAliaId{
    return [self.defaults objectForKey:uAliaDID];
}
@end
