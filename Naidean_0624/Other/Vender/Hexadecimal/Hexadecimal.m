//
//  Hexadecimal.m
//  WisDatInc
//
//  Created by Adsmart on 15/9/24.
//  Copyright © 2015年 adsmart. All rights reserved.
//

#import "Hexadecimal.h"

@implementation Hexadecimal

//16进制的字符串  转  十进制的字符串
+(NSString*)HexStringToDecimal:(NSString*)device_ID
{
    NSString * copyString = [device_ID copy];
    NSInteger uNumber = 0;
    
    char s1 = [copyString characterAtIndex:1];
    uNumber += [Hexadecimal bitStringToHex:s1] *16*16*16;
    char s2 = [copyString characterAtIndex:2];
    uNumber += [Hexadecimal bitStringToHex:s2] *16*16;
    char s3 = [copyString characterAtIndex:3];
    uNumber += [Hexadecimal bitStringToHex:s3] *16;
    char s4 = [copyString characterAtIndex:4];
    uNumber += [Hexadecimal bitStringToHex:s4];
//    char s5 = [copyString characterAtIndex:4];
//    uNumber = uNumber + ([Hexadecimal bitStringToHex:s5] << 4);
//    char s6 = [copyString characterAtIndex:5];
//    uNumber = uNumber + ([Hexadecimal bitStringToHex:s6]);
    
    return [NSString stringWithFormat:@"%ld",(long)uNumber];
    
}

+(NSString*)otherHexStringToDecimal:(NSString*)device_ID
{
    NSString * copyString = [device_ID copy];
    NSInteger uNumber = 0;
    char s1 = [copyString characterAtIndex:1];
    uNumber += [Hexadecimal bitStringToHex:s1]*16;
    char s2 = [copyString characterAtIndex:2];
    uNumber += [Hexadecimal bitStringToHex:s2] ;
//    char s3 = [copyString characterAtIndex:3];
//    uNumber += [Hexadecimal bitStringToHex:s3] *16;
//    char s4 = [copyString characterAtIndex:4];
//    uNumber += [Hexadecimal bitStringToHex:s4];
    //    char s5 = [copyString characterAtIndex:4];
    //    uNumber = uNumber + ([Hexadecimal bitStringToHex:s5] << 4);
    //    char s6 = [copyString characterAtIndex:5];
    //    uNumber = uNumber + ([Hexadecimal bitStringToHex:s6]);
    
    return [NSString stringWithFormat:@"%ld",(long)uNumber];
    
}


+(NSInteger)bitStringToHex:(char)bit
{
    switch (bit) {
        case '0':
            return 0;
            break;
        case '1':
            return 1;
            break;
        case '2':
            return 2;
            break;
        case '3':
            return 3;
            break;
        case '4':
            return 4;
            break;
        case '5':
            return 5;
            break;
        case '6':
            return 6;
            break;
        case '7':
            return 7;
            break;
        case '8':
            return 8;
            break;
        case '9':
            return 9;
            break;
        case 'a':
            return 10;
            break;
        case 'b':
            return 11;
            break;
        case 'c':
            return 12;
            break;
        case 'd':
            return 13;
            break;
        case 'e':
            return 14;
            break;
        case 'f':
            return 15;
            break;
            
        default:
            return 0;
            break;
    }
    
}
+(NSString *)getMacAddress:(NSString *)str{
    NSMutableString *macString = [[NSMutableString alloc] init];
    
    [macString appendString:[[str substringWithRange:NSMakeRange(str.length-2, 2)] uppercaseString]];
    [macString appendString:@":"];
    [macString appendString:[[str substringWithRange:NSMakeRange(str.length-4, 2)] uppercaseString]];
    [macString appendString:@":"];
    [macString appendString:[[str substringWithRange:NSMakeRange(str.length-6, 2)] uppercaseString]];
    [macString appendString:@":"];
    [macString appendString:[[str substringWithRange:NSMakeRange(str.length-8, 2)] uppercaseString]];
    [macString appendString:@":"];
    [macString appendString:[[str substringWithRange:NSMakeRange(str.length-10, 2)] uppercaseString]];
    [macString appendString:@":"];
    [macString appendString:[[str substringWithRange:NSMakeRange(str.length-12, 2)] uppercaseString]];
    
    return macString;
}

+(NSString *)getStatues:(NSString *)str{
    NSString *string;
    NSString *sub1=[str substringWithRange:NSMakeRange(0, 2)];
    NSString *sub2=[str substringWithRange:NSMakeRange(2, 2)];
    NSString *sub3=[str substringWithRange:NSMakeRange(4, 2)];
    NSString *sub4=[str substringWithRange:NSMakeRange(6, 2)];
    NSString *sub5=[str substringWithRange:NSMakeRange(8, 2)];
    NSString *sub6=[str substringWithRange:NSMakeRange(10, 2)];
    NSString *sub7=[str substringWithRange:NSMakeRange(12, 2)];
    NSString *sub8=[str substringWithRange:NSMakeRange(14, 2)];
    NSString *sub9=[str substringWithRange:NSMakeRange(16, 2)];
    NSString *sub10=[str substringWithRange:NSMakeRange(18, 2)];
    NSString *value1 = [NSString stringWithFormat:@"%lu",strtoul([sub1 UTF8String],0,16)];
    NSString * value2= [NSString stringWithFormat:@"%lu",strtoul([sub2 UTF8String],0,16)];
    NSString * value3= [NSString stringWithFormat:@"%lu",strtoul([sub3 UTF8String],0,16)];
    NSString * value4= [NSString stringWithFormat:@"%lu",strtoul([sub4 UTF8String],0,16)];
    NSString * value5= [NSString stringWithFormat:@"%lu",strtoul([sub5 UTF8String],0,16)];
    NSString * value6= [NSString stringWithFormat:@"%lu",strtoul([sub6 UTF8String],0,16)];
    NSString * value7= [NSString stringWithFormat:@"%lu",strtoul([sub7 UTF8String],0,16)];
    NSString * value8= [NSString stringWithFormat:@"%lu",strtoul([sub8 UTF8String],0,16)];
    NSString * value9= [NSString stringWithFormat:@"%lu",strtoul([sub9 UTF8String],0,16)];
    NSString * value10= [NSString stringWithFormat:@"%lu",strtoul([sub10 UTF8String],0,16)];
    
    string=[NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@:%@:%@:%@:%@",value1,value2,value3,value4,value5,value6,value7,value8,value9,value10];
    
    return string;
}

#pragma mark-NSData类型转换成NSString
+ (NSString*)hexadecimalString:(NSData *)data{
    NSString* result;
    const unsigned char* dataBuffer = (const unsigned char*)[data bytes];
    if(!dataBuffer){
        return nil;
    }
    NSUInteger dataLength = [data length];
    NSMutableString* hexString = [NSMutableString stringWithCapacity:(dataLength * 2)];
    for(int i = 0; i < dataLength; i++){
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    }
    result = [NSString stringWithString:hexString];
    return result;
}

//NSData 16进制类型转换成10进制数
+(NSString *)hexadecimalTo_TenString:(NSData *)data {
    NSString *result = [NSString stringWithFormat:@"%ld",strtoul([[self hexadecimalString:data] UTF8String],0,16)];
    return result;
}

#pragma mark - 解析MAC地址
+ (NSString *)changeUtfEncodeToNsstringWithStr:(NSString *)str
{
    //2F:B4:22:C5:B0:DD
    //A。取消两边的符号
    NSString *newStr = [str stringByReplacingOccurrencesOfString:@"<" withString:@""];
    NSString *newTwolStr = [newStr stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSString *valibelStr = [newTwolStr  stringByReplacingOccurrencesOfString:@" " withString:@""];//去掉空格
    
    //B.将字符两位一截取，转化为16进制的数
    NSString *macStr = [[NSString alloc]init];
    for (int k = (int)valibelStr.length-2; k >= 0; k-=2)
    {
        NSString *intStr = [valibelStr substringWithRange:NSMakeRange(k, 2)];
        macStr = [NSString stringWithFormat:@"%@%@",macStr,intStr];
    }
    
    NSMutableString *mutStr = [[NSMutableString alloc] initWithString:macStr];
    
    //在一个指定范围删除字符串，删除第一个":"
//    [mutStr deleteCharactersInRange:NSMakeRange(0, 1)];
    
    NSString * blueMacStr = [mutStr uppercaseString];//转换成大写
    
    if (blueMacStr.length >= 13) {
        
        //        blueMacStr = [blueMacStr substringWithRange:NSMakeRange(blueMacStr.length-17, 17)];
        blueMacStr = [blueMacStr substringWithRange:NSMakeRange(0, 12)];
    }
    return blueMacStr;
    
}

+ (NSArray *)splitArray:(NSArray *)array withSubSize:(int)subSize{
    //  数组将被拆分成指定长度数组的个数
    unsigned long count = array.count % subSize == 0 ? (array.count / subSize) : (array.count / subSize + 1);
    //  用来保存指定长度数组的可变数组对象
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    //利用总个数进行循环，将指定长度的元素加入数组
    for (int i = 0; i < count; i ++) {
        //数组下标
        int index = i * subSize;
        //保存拆分的固定长度的数组元素的可变数组
        NSMutableArray *arr1 = [[NSMutableArray alloc] init];
        //移除子数组的所有元素
        [arr1 removeAllObjects];
        
        int j = index;
        //将数组下标乘以1、2、3，得到拆分时数组的最大下标值，但最大不能超过数组的总大小
        while (j < subSize*(i + 1) && j < array.count) {
            [arr1 addObject:[array objectAtIndex:j]];
            j += 1;
        }
        //将子数组添加到保存子数组的数组中
        [arr addObject:[arr1 copy]];
    }
    
    return [arr copy];
}
@end
