//
//  ResetPSViewController.h
//  Naidean
//
//  Created by xujun on 2018/1/15.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ForgetPassWord,  // 忘记密码
    UnlockPassWord,  // 设置密码
    ResetPhone   // 更改绑定电话
} Reset;

@interface ResetPSViewController : UIViewController
@property(nonatomic, assign) Reset reset;
@property(nonatomic, strong) DeviceModel *device;
@end
