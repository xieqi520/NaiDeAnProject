//
//  SYPermissionSettingViewController.h
//  Naidean
//
//  Created by aoxin on 2018/8/17.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthorizedUserModel.h"

@interface SYPermissionSettingViewController : UIViewController

@property (nonatomic, strong)AuthorizedUserModel *authorizedModel;
@property (nonatomic, strong)DeviceModel *device;

@end
