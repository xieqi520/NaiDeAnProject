//
//  SYlockTimeModel.h
//  Naidean
//
//  Created by Zoe on 2019/3/4.
//  Copyright © 2019年 com.saiyikeji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYlockTimeModel : NSObject
@property (nonatomic,copy) NSString *lockId;//时间ID
@property (nonatomic,copy) NSString *lockTime;//时间
@end

@interface SYLockPeriodModel : NSObject
@property (nonatomic,copy) NSString *lockPeriod;//时间段
@end
