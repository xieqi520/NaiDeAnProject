//
//  Hexadecimal.h
//  WisDatInc
//
//  Created by Adsmart on 15/9/24.
//  Copyright © 2015年 adsmart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Hexadecimal : NSObject

+(NSString*)HexStringToDecimal:(NSString*)device_ID;
+(NSString*)otherHexStringToDecimal:(NSString*)device_ID;
//获取MAC地址
+(NSString *)getMacAddress:(NSString *)str;
//NSData类型转换成NSString
+(NSString*)hexadecimalString:(NSData *)data;
//NSData 16进制类型转换成10进制数
+(NSString*)hexadecimalTo_TenString:(NSData *)data;
//获取数据的转换
+(NSString *)getStatues:(NSString *)str;
+ (NSString *)changeUtfEncodeToNsstringWithStr:(NSString *)str;

/**
 *  将数组拆分成固定长度的子数组}
 *
 *  @param array 需要拆分的数组
 *
 *  @param subSize 指定长度
 *
 */
+ (NSArray *)splitArray: (NSArray *)array withSubSize : (int)subSize;
/*
 //转 asc
 Byte byte[] = {0x35,0x32,0x38,0x30,0x30,0x30,0x30,0x30,0x31};
 NSData *deviceNameData = [NSData dataWithBytes:byte length:0x09];
 NSString *deviceNameStr = [[NSString alloc] initWithData:deviceNameData encoding:NSUTF8StringEncoding];
 NSLog(@"=====%@",deviceNameStr);
 
 //转10进制
 Byte byte1[] = {0xc0};
 NSData *deviceNameData1 = [NSData dataWithBytes:byte1 length:0x01];
 NSString *a = [NSString stringWithFormat:@"%ld",strtoul([[Hexadecimal hexadecimalString:deviceNameData1] UTF8String],0,16)];
 NSLog(@"=====%@",a);
 
 */
@end
