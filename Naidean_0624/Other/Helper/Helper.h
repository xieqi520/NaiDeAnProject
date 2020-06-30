//
//  Helper.h
//  Naidean
//
//  Created by xujun on 2018/1/12.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum : NSUInteger {
    YearMonthDay,
    YearMonthDayHourMinSecond,
} HelperTimeType;

#define kDateFormat_Hm         @"HH:mm"

@interface Helper : NSObject

@property(nonatomic,copy) void(^verifyblock)(dispatch_source_t time);

/*
 *获取当前时间
 */
+ (NSDate *)getLocalDate;

/**
 *  获取当前日期是周几
 *
 *  @return 周几
 */
+ (NSInteger)weekday:(NSDate *)date;
/**
 *  将日期转换成指定格式的字符串
 */
+ (NSString *)formatDate:(NSDate *)date withFormat:(NSString*)format;
/**
 将时间戳转换成时间格式
 
 @param timestamp 时间戳
 @param type 转换的类型
 @return 返回的时间格式
 */
+ (NSString *)getDateStringByTimestamp:(NSString *) timestamp WithType:(HelperTimeType) type;

/**
 *  根据时间字符串返回时间对象
 *
 *  @param dateString 日期字符串
 *
 *  @return 日期对象
 */
+ (NSDate *)getDateFromString:(NSString *)dateString;
/**
 在指定的视图上展示进度条
 
 @param tip 文字提示
 @param view 即将展示的视图
 */
+ (void)showTip:(NSString *) tip withView:(UIView *)view;
/**
 在window上展示进度条
 
 @param tip 文字提示
 */
+ (void)showTip:(NSString *)tip;
/**
 获取标签（UILabel）的高度
 
 @param size 标签的大小
 @param fontSize 标签的文字大小
 @param contentStr 标签内的文字信息
 @return 返回标签的高度
 */
+ (CGFloat)labelHeightWithSize:(CGSize)size andFontSize:(NSInteger)fontSize andContent:(NSString *)contentStr;
/**
 判断是否为手机号码
 
 @param mobileNum 输入的手机号码
 @return 返回YES：是正确的手机号码，NO：错误的手机号码
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
/**
 颜色转换为背景图片
 
 @param color 生成图片的颜色
 
 @return 返回图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;
/**
 *  获取当前时间的时间戳（例子：1464326536）
 *
 *  @return 时间戳字符串型
 */
/**
 将视图转换成图片
 
 @param view 转换图片的视图
 @return 图片
 */
+ (UIImage*) imageWithUIView:(UIView*) view;

+ (NSString *)getCurrentTimestamp;
/**
 *  替换电话号码部分数字
 *
 *  @return 电话号码
 */
+ (NSString *)hiddenPartOfTel:(NSString *)tel;
/**
 处理图片的URL
 
 @param imgUrlStr 图片地址
 @return   图片地址
 */
+ (NSString *)processImgUrl:(NSString *)imgUrlStr;
/**
 把字典和数组转换成json字符串
 
 @param temps 将要转换成json数据的对象
 
 @return 返回的json字符串
 */
+ (NSString *)stringToJson:(id)temps;
/**
 点赞动画
 
 @param sender 按钮
 */
+ (void)addBtnAnimation:(UIButton *)sender;

/**
 改变量是否为制定的类
 
 @param myClass 要比较的类
 @param compareClass 是否为制定的类
 @return YES ／NO
 */
+ (BOOL)isKindOfClass:(id)myClass andClass:(Class)compareClass;


/**
 判断邮箱
 
 @param email 邮箱
 */
+ (BOOL)isEmailAddress:(NSString*)email;

/**
 获取验证码按钮
 
 @param button 按钮
 */
+ (void)verifyBtnAction:(UIButton*)button : (Helper *)helper;

//传入命令格式string 返回data 发送给蓝牙
+ (NSData *)mutString:(NSMutableString *)dataStr;

/**
 传入命令格式string  返回异或string
 */
+ (NSString *)stylestring:(NSMutableString *)styleStr;

//data转换为十六进制的string
+ (NSString *)hexStringFromData:(NSData *)myD;

//普通字符串转换为十六进制的。
+(NSString *)convertStringToHexStr:(NSString*)string;

//10进制转16进制
+ (NSString *)getHexByDecimal:(NSInteger)decimal;

//十六进制字符串转十进制
+(NSString*)hexStringFromString:(NSString*)str;

@end
