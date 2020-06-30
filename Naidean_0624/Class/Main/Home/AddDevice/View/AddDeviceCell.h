//
//  AddDeviceCell.h
//  Naidean
//
//  Created by xujun on 2018/1/8.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddDeviceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *DeviceNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *DeviceNumberLabel;

@property(nonatomic,copy) void(^AddDeviceBlock)(AddDeviceCell *cell);

@property(nonatomic,copy) void(^deleteDeviceBlock)(AddDeviceCell *cell);

@property (weak, nonatomic) IBOutlet UIButton *AddDeviceBtn;

@property (weak, nonatomic) IBOutlet UIButton *bindingBtn;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end
