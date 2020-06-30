//
//  NSString+LuAddition.m
//  LuGeneral
//
//  Created by hkmac on 14/12/19.
//  Copyright (c) 2014年 hk. All rights reserved.
//

#import "NSString+LuAddition.h"
#import <CommonCrypto/CommonDigest.h>
#import "GTMBase64.h"

@implementation NSString (LuAddition)

- (NSString*)sha1
{
        const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
        NSData *data = [NSData dataWithBytes:cstr length:self.length];
        
        uint8_t digest[CC_SHA1_DIGEST_LENGTH];
        
        CC_SHA1(data.bytes, data.length, digest);
        
        NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
        
        for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
                [output appendFormat:@"%02x", digest[i]];
        
        return output;
}

- (NSString *)md5
{
        const char *cStr = [self UTF8String];
        unsigned char digest[CC_MD5_DIGEST_LENGTH];
        CC_MD5( cStr, strlen(cStr), digest );
        
        NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
        
        for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
                [output appendFormat:@"%02x", digest[i]];
        
        return output;
}

- (NSString *)sha1_base64
{
        const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
        NSData *data = [NSData dataWithBytes:cstr length:self.length];
        
        uint8_t digest[CC_SHA1_DIGEST_LENGTH];
        
        CC_SHA1(data.bytes, data.length, digest);
        
        NSData * base64 = [[NSData alloc]initWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
        base64 = [GTMBase64 encodeData:base64];
        
        NSString * output = [[NSString alloc] initWithData:base64 encoding:NSUTF8StringEncoding];
        return output;
}

- (NSString *)md5_base64
{
        const char *cStr = [self UTF8String];
        unsigned char digest[CC_MD5_DIGEST_LENGTH];
        CC_MD5( cStr, strlen(cStr), digest );
        
        NSData * base64 = [[NSData alloc]initWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
        base64 = [GTMBase64 encodeData:base64];
        
        NSString * output = [[NSString alloc] initWithData:base64 encoding:NSUTF8StringEncoding];
        return output;
}

- (NSString *)base64
{
        NSData * data = [self dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        data = [GTMBase64 encodeData:data]; 
        NSString * output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; 
        return output; 
}

#pragma - 字符串处理
// Checking if String is Empty
- (BOOL)isBlank
{
        return ([[self removeWhiteSpacesFromString] isEqualToString:@""]) ? YES : NO;
}
//Checking if String is empty or nil
- (BOOL)isValid
{
        return ([[self removeWhiteSpacesFromString] isEqualToString:@""] || self == nil || [self isEqualToString:@"(null)"]) ? NO :YES;
}

// remove white spaces from String
- (NSString *)removeWhiteSpacesFromString
{
        NSString *trimmedString = [self stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        return trimmedString;
}

// Counts number of Words in String
- (NSUInteger)countNumberOfWords
{
        NSScanner *scanner = [NSScanner scannerWithString:self];
        NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        NSUInteger count = 0;
        while ([scanner scanUpToCharactersFromSet: whiteSpace  intoString: nil]) {
                count++;
        }
        
        return count;
}

// If my string contains ony letters
- (BOOL)containsOnlyLetters
{
        NSCharacterSet *letterCharacterset = [[NSCharacterSet letterCharacterSet] invertedSet];
        return ([self rangeOfCharacterFromSet:letterCharacterset].location == NSNotFound);
}

// If my string contains only numbers
- (BOOL)containsOnlyNumbers
{
        NSCharacterSet *numbersCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        return ([self rangeOfCharacterFromSet:numbersCharacterSet].location == NSNotFound);
}

// If my string contains letters and numbers
- (BOOL)containsOnlyNumbersAndLetters
{
        NSCharacterSet *numAndLetterCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
        return ([self rangeOfCharacterFromSet:numAndLetterCharSet].location == NSNotFound);
}

// Is Valid Email

- (BOOL)isValidEmail
{
        NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTestPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        return [emailTestPredicate evaluateWithObject:self];
}

- (BOOL)isMobileNumber
{
        /**
         * 手机号码134、135、136、137、138、139、147、150、151、152、157、158、159、182、187、188
         * 移动：134[0-8],135,136,137,138,139,147,150,151,152,157,158,159,182,187,188
         * 联通：130,131,132,152,155,156,185,186
         * 电信：133,1349,153,180,189
         */
        NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
        /**
         10         * 中国移动：China Mobile
         11         * 134[0-8],135,136,137,138,139,147,150,151,152,157,158,159,182,187,188
         12         */
        NSString * CM = @"^1(34[0-8]|(3[5-9]|4[7]|5[0127-9]|8[278])\\d)\\d{7}$";
        /**
         15         * 中国联通：China Unicom
         16         * 130,131,132,152,155,156,185,186
         17         */
        NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
        /**
         20         * 中国电信：China Telecom
         21         * 133,1349,153,180,189
         22         */
        NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
        /**
         25         * 大陆地区固话及小灵通
         26         * 区号：010,020,021,022,023,024,025,027,028,029
         27         * 号码：七位或八位
         28         */
        // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
        
        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
        NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
        NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
        NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
        
        if (([regextestmobile evaluateWithObject:self] == YES)
            || ([regextestcm evaluateWithObject:self] == YES)
            || ([regextestct evaluateWithObject:self] == YES)
            || ([regextestcu evaluateWithObject:self] == YES)) {
                return YES;
        } else {
                return NO;
        }
}
// Is Valid URL

- (BOOL)isValidUrl
{
        NSString *regex =@"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
        NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        return [urlTest evaluateWithObject:self];
}

+ (NSString *)stringFromBytes:(long long)bytes
{
        NSString *retString = @"0 MB";
        
        if (bytes < 1024) {
                retString = [NSString stringWithFormat:@"%lld B", bytes];
                
        } else if (bytes >= 1024 && bytes < 1024 * 1024) {
                retString = [NSString stringWithFormat:@"%.1f KB", (double)bytes / 1024];
                
        } else/* if(bytes >= 1024 * 1024 && bytes < 1024 * 1024 * 1024) */{
                retString = [NSString stringWithFormat:@"%.2f MB", (double)bytes / (1024 * 1024)];
                
        }/* else {
          return [NSString stringWithFormat:@"%.3fGB", (double)bytes / (1024 * 1024 * 1024)];
          }*/
        
        return retString;
}

/**
 *	@brief	从MB大小转换成字符串，1024以下就是MB，否则转换成GB
 *
 *	@param 	size 	单位为MB
 *
 *	@return	834.98MB 或 8.22GB
 */
+ (NSString *)stringFromMB:(int)size
{
        NSString *retString = @"0 MB";
        
        if (size < 1024) {
                retString = [NSString stringWithFormat:@"%.2f MB", (float)size];
        } else {
                retString = [NSString stringWithFormat:@"%.2f GB", size / 1024.0f];
        }
        
        return retString;
}
@end
