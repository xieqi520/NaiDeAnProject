//
//  PrefixHeader.h
//  Naidean
//
//  Created by xujun on 2018/1/3.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#ifndef PrefixHeader_h
#define PrefixHeader_h



//账号密码输入限制
#define COUNTNUM @"0123456789"
#define PASSWORD @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

//屏幕的宽
#define WIN_WIDTH    [UIScreen mainScreen].bounds.size.width
//屏幕的高
#define WIN_HEIGHT   [UIScreen mainScreen].bounds.size.height

#define SYColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
//宽高的比以6为准
#define getHeight(y)      ((y)*WIN_HEIGHT/667.0)
#define getWidth(x)       ((x)*WIN_WIDTH/375.0)

// 弱引用
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self
#define WEAK_SELF           __weak __typeof(self) weakSelf = self;
#define STRONG_SELF         __strong __typeof(self) strongSelf = weakSelf;

// 颜色转换设置
#define SetColor(x)    [UIColor colorWithHexString:x]

//加粗字体
#define kBoldSystemFontSize(x) [UIFont boldSystemFontOfSize:(x)]

// 字体设置
#define kSystemFontSize(x) [UIFont systemFontOfSize:(x)]


// 获取图片资源
#define kGetImage(imageName) [[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]




#define UI_IS_IPHONE            ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define UI_IS_IPHONE6           (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0)
#define UI_IS_IPHONE6PLUS       (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height >= 736.0 || [[UIScreen mainScreen] bounds].size.width >= 736.0)

#define NA_BACKGROUND_COLOR  [UIColor colorWithHexString:@"#3F424E" alpha:1]

#ifdef DEBUG
#define DDLog(format, ...) printf("[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define DDLog(format, ...)
#endif

#endif /* PrefixHeader_h */
