//
//  LoglistCell.h
//  Naidean
//
//  Created by xujun on 2018/1/6.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LockLogModel.h"

typedef enum{
    fingerprint,
    password,
    remotecontrol
}Unlock;

@interface LoglistCell : UITableViewCell

@property(nonatomic,assign) Unlock unlock;                          //开锁类型
@property (weak, nonatomic) IBOutlet UIImageView *Userimageview;    //个人头像
@property (weak, nonatomic) IBOutlet UILabel *Methodlabel;          //开锁方法
@property (weak, nonatomic) IBOutlet UIImageView *MethodImageview;  //开锁类型图片
@property (weak, nonatomic) IBOutlet UILabel *Datelabel;            //日期
@property (weak, nonatomic) IBOutlet UILabel *Timelabel;            //时间


- (void)displayViewWithLogModel:(LockLogModel *)model;

@end
