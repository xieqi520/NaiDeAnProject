//
//  Helper.m
//  Naidean
//
//  Created by xujun on 2018/1/12.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "Helper.h"

@implementation Helper
/*
 *获取当前时间
 */
+ (NSDate *)getLocalDate {
    NSDate *date = [NSDate date];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: date];
    
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
}
/**
 *  获取当前日期是周几
 *
 *  @return 周几
 */
+ (NSInteger)weekday:(NSDate *)date {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday) fromDate:date];
    NSInteger weekday = [comps weekday];
    
    return weekday;
}
/**
 *  将日期转换成指定格式的字符串
 */
+ (NSString *)formatDate:(NSDate *)date withFormat:(NSString*)format {
    if (date) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:format];
        NSString *currentDateStr = [dateFormatter stringFromDate:date];
        return currentDateStr;
    } else {
        return nil;
    }
}

/**
 将时间戳转换成时间格式
 
 @param timestamp 时间戳
 @param type 转换的类型
 @return 返回的时间格式
 */
+ (NSString *)getDateStringByTimestamp:(NSString *) timestamp WithType:(HelperTimeType) type{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    if (type == YearMonthDay) {
        formatter.dateFormat = @"YYYY-MM-dd";
    }else if(type == YearMonthDayHourMinSecond){
        formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    }else{
        ;
    }
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
    NSString * dateString = [formatter stringFromDate:date];
    return dateString;
}
/**
 *  根据时间字符串返回时间对象
 *
 *  @param dateString 日期字符串
 *
 *  @return 日期对象
 */
+ (NSDate *)getDateFromString:(NSString *)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}

/**
 在指定的视图上展示进度条,自动消失
 
 @param tip 文字提示
 @param view 即将展示的视图
 */
+ (void)showTip:(NSString *) tip withView:(UIView *)view{
    MBProgressHUD * progressHUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].windows.lastObject];
    [view addSubview:progressHUD];
    progressHUD.labelText = tip;
    progressHUD.mode = MBProgressHUDModeText;
    progressHUD.labelColor = [UIColor whiteColor];
    progressHUD.labelFont = [UIFont systemFontOfSize:12];
    [progressHUD showAnimated:true whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [progressHUD removeFromSuperview];
    }];
}
/**
 在window上展示进度条
 
 @param tip 文字提示
 */
+ (void)showTip:(NSString *)tip{
    [Helper showTip:tip withView:[UIApplication sharedApplication].windows.lastObject];
}

/**
 获取标签（UILabel）的高度
 
 @param size 标签的大小
 @param fontSize 标签的文字大小
 @param contentStr 标签内的文字信息
 @return 返回标签的高度
 */
+ (CGFloat)labelHeightWithSize:(CGSize)size andFontSize:(NSInteger)fontSize andContent:(NSString *)contentStr{
    return [contentStr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]} context:nil].size.height;
    
}
/**
 判断是否为手机号码
 
 @param mobileNum 输入的手机号码
 @return 返回YES：是正确的手机号码，NO：错误的手机号码
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum {
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:mobileNum];
}
/**
 颜色转换为背景图片
 
 @param color 生成图片的颜色
 
 @return 返回图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 将视图转换成图片
 
 @param view 转换图片的视图
 @return 图片
 */
+ (UIImage*) imageWithUIView:(UIView*) view{
    
    UIGraphicsBeginImageContext(view.bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [view.layer renderInContext:context];
    
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tImage;
    
}
/**
 *  获取当前时间的时间戳（例子：1464326536）
 *
 *  @return 时间戳字符串型
 */
+ (NSString *)getCurrentTimestamp
{
    //获取系统当前的时间戳
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    //NSTimeZone 是有时间差计算的方法的
    //我们通过NSTimeZone 计算时间差，就可以得到想要的时区对应的NSDate对象。
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    NSTimeInterval interval = [timeZone secondsFromGMTForDate:date];
    //当前时间
    NSDate *localDate = [date dateByAddingTimeInterval:interval];
    //获取时间戳
    NSTimeInterval timeInterval = [localDate timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%lf", timeInterval];
    // 转为字符型
    return timeString;
}

/**
 *  替换电话号码部分数字
 *
 *  @return 电话号码
 */
+ (NSString *)hiddenPartOfTel:(NSString *)tel{
    if (tel.length >= 7) {
        return [tel stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    return tel;
}

/**
 处理图片的URL
 
 @param imgUrlStr 图片地址
 @return   图片地址
 */
+ (NSString *)processImgUrl:(NSString *)imgUrlStr{
    if (imgUrlStr.length > 0) {
        NSString * subImgUrl = [imgUrlStr substringFromIndex:0];
        return [NSString stringWithFormat:@"%@",subImgUrl];
    }
    return  imgUrlStr;
}
/**
 把字典和数组转换成json字符串
 
 @param temps 将要转换成json数据的对象
 
 @return 返回的json字符串
 */
+ (NSString *)stringToJson:(id)temps
{
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:temps
                                                      options:NSJSONWritingPrettyPrinted error:nil];
    NSMutableString *jsonStr=[[NSMutableString alloc] initWithData:jsonData
                                                          encoding:NSUTF8StringEncoding];
    
    NSString *responseString = [NSString stringWithString:jsonStr];
    
    responseString = [responseString stringByReplacingOccurrencesOfString:@" " withString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return responseString;
}
/**
 点赞动画
 
 @param sender 按钮
 */
+ (void)addBtnAnimation:(UIButton *)sender{
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [sender.layer addAnimation:animation forKey:nil];
}
/**
 改变量是否为制定的类
 
 @param myClass 要比较的类
 @param compareClass 是否为制定的类
 @return YES ／NO
 */
+ (BOOL)isKindOfClass:(id)myClass andClass:(Class)compareClass{
    if ([myClass class] == compareClass) {
        return YES;
    }
    return NO;
}

/**
 判断邮箱
 
 @param email 邮箱
 */
+ (BOOL)isEmailAddress:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/**
 获取验证码按钮
 
 @param button 按钮
 */
+ (void)verifyBtnAction:(UIButton *)button : (Helper *)helper
{
    //倒计时时间 - 60秒
    __block NSInteger timeOut = 59;
    //执行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //计时器 dispatch_source_set_timer自动生成
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (timeOut <= 0) {
            dispatch_source_cancel(timer);
            //主线程设置按钮样式
            dispatch_async(dispatch_get_main_queue(), ^{
                [button setTitle:@"重新发送" forState:UIControlStateNormal];
                [button setUserInteractionEnabled:YES];
            });
        }else{
            if (helper.verifyblock) {
                helper.verifyblock(timer);
            }
            //开始计时 剩余秒数
            NSInteger seconds = timeOut % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.1ld",seconds];
            //主线程设置按钮样式
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1.0];
                [button setTitle:[NSString stringWithFormat:@"%@ S",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                //计时器不允许点击
                [button setUserInteractionEnabled:NO];
            });
            timeOut--;
        }
    });
    
    dispatch_resume(timer);


}

//传入命令格式string 返回data 发送给蓝牙
+ (NSData *)mutString:(NSMutableString *)dataStr
{
    unsigned long styleLengh = dataStr.length/2;
    
    Byte styleByte[styleLengh];
    
    
    for (int i =0; i<styleLengh; i++)
    {
        styleByte[i] = strtoul([[dataStr substringWithRange:NSMakeRange(i*2, 2)]UTF8String], 0, 16);
    }
    NSData *styleData = [NSData dataWithBytes:styleByte length:styleLengh];
    
    return styleData;
}

/**
 传入命令格式string  返回异或string
 */
+ (NSString *)stylestring:(NSMutableString *)styleStr
{
    unsigned long styleLengh = styleStr.length/2;
    
    Byte styleByte[styleLengh];
    
    for (int i =0; i<styleLengh; i++)
    {
        styleByte[i] = strtoul([[styleStr substringWithRange:NSMakeRange(i*2, 2)]UTF8String], 0, 16);
    }
    NSData *styleData = [NSData dataWithBytes:styleByte length:styleLengh];
    Byte * returnStyleBT = (Byte *)[styleData bytes];
    Byte styleTemp = returnStyleBT[0];//用于保存异或结果
    
    for (int j=1; j<styleLengh; j++)
    {
        styleTemp ^= returnStyleBT[j];
    }
    
    NSString * lastStr = [NSString stringWithFormat:@"%0X",styleTemp];
    
    return lastStr;
    
}

//data转换为十六进制的string
+ (NSString *)hexStringFromData:(NSData *)myD
{
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    
    return hexStr;
}



//普通字符串转换为十六进制的。
+(NSString *)convertStringToHexStr:(NSString*)string{
    if (!string || [string length] == 0) {
        return @"";
    }
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}



//10进制转16进制
+ (NSString *)getHexByDecimal:(NSInteger)decimal {
    
    NSString *hex = @"";
    NSString *letter;
    NSInteger number;
    for (int i = 0; i<9; i++) {
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number) {
            case 10:
                letter = @"A"; break;
            case 11:
                letter = @"B"; break;
            case 12:
                letter = @"C"; break;
            case 13:
                letter = @"D"; break;
            case 14:
                letter = @"E"; break;
            case 15:
                letter = @"F"; break;
            default:
                letter = [NSString stringWithFormat:@"%ld", (long)number];
        }
        hex = [letter stringByAppendingString:hex];
        
        if (decimal == 0) {
            break;
        }
        
    }
    if (hex.length < 2) {
        return [NSString stringWithFormat:@"0%@",hex];
    }
    return hex;
}

//十六进制字符串转十进制
+(NSString*)hexStringFromString:(NSString*)str
{
    if (str == nil) {
        return nil;
    }
    NSString * string = [NSString stringWithFormat:@"%lu",strtoul([str UTF8String],0,16)];
    return string;
}

@end
