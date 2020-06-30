//
//  WifiConnectController.h
//  Naidean
//
//  Created by xujun on 2018/1/8.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WifiConnectController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *ConnectImageview;
@property (weak, nonatomic) IBOutlet UITextField *SelectWifitextfield;

@property (weak, nonatomic) IBOutlet UITextField *WifiPStextfield;

@property (weak, nonatomic) IBOutlet UIButton *ConnectBtn;
@property (nonatomic, assign) BOOL hasBind;//判断是否是重新配网
@end
