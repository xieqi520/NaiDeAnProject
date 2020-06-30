//
//  UIColor+changeColor.h
//  Naidean
//
//  Created by xujun on 2018/1/3.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (changeColor)

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;


+ (UIColor*)colorWithHexString:(NSString *)color;

@end
