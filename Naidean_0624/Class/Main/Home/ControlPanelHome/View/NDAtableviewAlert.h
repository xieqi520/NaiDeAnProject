//
//  NDAtableviewAlert.h
//  Naidean
//
//  Created by aoxin1 on 2019/8/8.
//  Copyright © 2019 com.saiyikeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface NDAtableviewAlert : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *dataArr;

@property (nonatomic,strong) UITableView *tableview;

@property (nonatomic,copy) void (^changeLock)(NSDictionary *dic);

@property (nonatomic,copy) void (^deleteLock)(NSIndexPath*index);

@end

NS_ASSUME_NONNULL_END
