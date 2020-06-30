//
//  APConnectController.h
//  Naidean
//
//  Created by Zoe on 2019/2/22.
//  Copyright © 2019年 com.saiyikeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APConnectController : UIViewController
@property(nonatomic, copy) NSString *wifiName;
@property(nonatomic, copy) NSString *wifiPass;
@property (nonatomic, assign) BOOL hasBind;//判断是否是重新配网

@end
