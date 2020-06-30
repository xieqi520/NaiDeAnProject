//
//  UserManageClass.h
//  MusicMovement
//
//  Created by SaiYi on 2017/11/30.
//  Copyright © 2017年 saiyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"
@interface UserManageClass : NSObject

@property (nonatomic,strong) UserInfoModel *userInfoModel;//!< 用户数据模型

@property (nonatomic,assign) BOOL bindingState;//!< 记录设备绑定状态

@property (nonatomic,copy) NSString *userNumber;//!< 用户手机号

@property (nonatomic,copy) NSString *userPassword;//!< 用户密码

@property (nonatomic,copy) NSString *dianliang;//!< 设备电量

@property (nonatomic,copy) NSString *jurisdiction;//!< 用户权限 1:远程开锁 2:指纹开锁 3：门禁

@property (nonatomic,assign) NSInteger isAdmin;//!< 是否是管理员 0:授权用户  1:管理员

@property (nonatomic,copy) NSString *myMac;//!< 设备mac （匹配备用电源电量时候用的）

@property (nonatomic,assign) NSInteger isCamera;//!< 当前页面是否在门禁页面 1:是 0:否


/// 获取单例
+ ( instancetype )sharedManager;
/// 清空单例
+ (void)clearData;

@end
