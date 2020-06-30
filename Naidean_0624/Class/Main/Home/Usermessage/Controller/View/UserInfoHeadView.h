//
//  UserInfoHeadView.h
//  Naidean
//
//  Created by xujun on 2018/1/5.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoHeadView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *UserImageView;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *userAccount;

@property (weak, nonatomic) IBOutlet UIImageView *EnterImageView;


@property (copy, nonatomic)dispatch_block_t ChangeImgBlock;
@end
