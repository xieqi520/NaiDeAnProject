//
//  SYTimeSettingTableViewCell.h
//  Naidean
//
//  Created by aoxin on 2018/8/17.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthorizedUserModel.h"

@interface SYTimeSettingTableViewCell : UITableViewCell
//@property (weak, nonatomic) IBOutlet UILabel *titleLab;
//@property (weak, nonatomic) IBOutlet UITextField *firstTF;
//@property (weak, nonatomic) IBOutlet UITextField *secondTF;
//@property (weak, nonatomic) IBOutlet UITextField *thirdTF;

@property (weak, nonatomic) IBOutlet UIButton *firstBtn;

@property (weak, nonatomic) IBOutlet UIButton *secondBtn;

@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;

- (void)displayWithTimePicker:(SYTimePickerView *)timePicker AuthorizedUserModel:(AuthorizedUserModel *)model;

@end
