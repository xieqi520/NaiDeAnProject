//
//  AuthCell.h
//  Naidean
//
//  Created by xujun on 2018/1/5.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthCell : UITableViewCell

@property(nonatomic,copy)void(^IndexselectBlcok)(NSIndexPath *index);
/**开关的回调*/
@property (nonatomic, copy) void(^SelectOrNoBlock)(BOOL isSelect);
@property (weak, nonatomic) IBOutlet UIImageView *Authimageview;
@property (weak, nonatomic) IBOutlet UILabel *Authname;
@property (weak, nonatomic) IBOutlet UIButton *SelectBtn;

@end
