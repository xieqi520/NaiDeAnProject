//
//  DeviceCell.h
//  Naidean
//
//  Created by xujun on 2018/1/8.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceCell : UITableViewCell
@property(nonatomic,strong)UILabel *Devicename;
@property(nonatomic,strong)UILabel *DeviceNumber;
@property(nonatomic,strong)UIButton *DelectBtn;
@property(nonatomic,copy) NSString *idStr;

@property(nonatomic,copy)void(^delectBlock)(DeviceCell *cell);

@end
