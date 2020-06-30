//
//  UserInfoFootView.h
//  Naidean
//
//  Created by xujun on 2018/1/5.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoFootView : UIView
@property (weak, nonatomic) IBOutlet UIButton *LogoutBtn;

@property(nonatomic,copy)dispatch_block_t LogoutBlock;
@end
