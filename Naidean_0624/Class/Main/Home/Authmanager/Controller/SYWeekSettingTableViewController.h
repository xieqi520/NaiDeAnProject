//
//  SYWeekSettingTableViewController.h
//  Naidean
//
//  Created by aoxin on 2018/8/17.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYWeekSettingTableViewController : UITableViewController


@property (nonatomic,copy) void(^selectDaysBlock)(NSArray *days);

@end
