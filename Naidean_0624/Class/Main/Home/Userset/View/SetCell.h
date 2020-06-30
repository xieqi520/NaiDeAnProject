//
//  SetCell.h
//  Naidean
//
//  Created by xujun on 2018/1/5.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Setname;
@property (weak, nonatomic) IBOutlet UISwitch *Switch;
@property (weak, nonatomic) IBOutlet UIImageView *Nextiamgeview;
@property (copy, nonatomic) void(^SwitchBlock)(UITableViewCell *cell,BOOL Switch);

@end
