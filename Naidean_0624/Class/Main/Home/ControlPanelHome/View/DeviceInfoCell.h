//
//  DeviceInfoCell.h
//  Naidean
//
//  Created by aoxin1 on 2019/8/8.
//  Copyright © 2019 com.saiyikeji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceInfoCell : UITableViewCell

@property (nonatomic,copy) NSString *status;

@property (nonatomic,copy) NSArray *weeks;

@property (nonatomic,assign) NSInteger temperature;

@property (nonatomic,copy) NSString *low;

@property (nonatomic,copy) NSString *delTime;

@property (nonatomic,copy) NSString *userType;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *type;

@property (nonatomic,copy) NSString *idStr;

@property (nonatomic,copy) NSString *videoPwd;

@property (nonatomic,copy) NSString *openPwd;

@property (nonatomic,copy) NSString *videoUser;

@property (nonatomic,assign) NSInteger vprying;

@property (nonatomic,assign) NSInteger unmanned;

@end

NS_ASSUME_NONNULL_END
