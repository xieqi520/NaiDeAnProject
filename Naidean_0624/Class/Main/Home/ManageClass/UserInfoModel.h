//
//  UserInfoModel.h
//  YuJingLock
//
//  Created by SaiYi on 2018/1/12.
//  Copyright © 2018年 张泽稷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject

@property (nonatomic,copy) NSString *userID;//!< 用户id

@property (nonatomic,copy) NSString *number;//!< 用户手机号码

@property (nonatomic,copy) NSString *username;//!< 用户昵称

@property (nonatomic,copy) NSString *headPicByte;//!< 用户头像


@end
