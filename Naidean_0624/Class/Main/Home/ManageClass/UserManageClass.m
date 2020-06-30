//
//  UserManageClass.m
//  MusicMovement
//
//  Created by SaiYi on 2017/11/30.
//  Copyright © 2017年 saiyi. All rights reserved.
//

#import "UserManageClass.h"

@implementation UserManageClass

static UserManageClass *_userManage = nil;

+(instancetype)sharedManager
{
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        _userManage = [[self alloc] init];

        _userManage.bindingState = NO;
        
        _userManage.userNumber = @"";
        
        _userManage.userPassword = @"";
        
        _userManage.dianliang = @"";
        
        _userManage.jurisdiction = @"";
        
        _userManage.myMac = @"";
        
        _userManage.isAdmin = 0;
        
        _userManage.isCamera = 0;
        
    });
    return _userManage;
}

+(void)clearData
{
    _userManage = nil;
}

//限制方法，类只能初始化一次
//alloc的时候调用
//+ (id) allocWithZone:(struct _NSZone *)zone{
//    if(_userManage == nil){
//        _userManage = [super allocWithZone:zone];
//    }
//    return _userManage;
//}

@end
