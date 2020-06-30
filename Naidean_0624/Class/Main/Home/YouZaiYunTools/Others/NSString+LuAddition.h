//
//  NSString+LuAddition.h
//  LuGeneral
//
//  Created by hkmac on 14/12/19.
//  Copyright (c) 2014年 hk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LuAddition)

#pragma mark - 加密算法
- (NSString *) md5;
- (NSString *) sha1;
- (NSString *) sha1_base64;
- (NSString *) md5_base64;
- (NSString *) base64;

#pragma - 字符串处理
/**
 *	@brief	Checking if String is Empty
 */
- (BOOL)isBlank;

/**
 *	@brief	Checking if String is empty or nil
 */
- (BOOL)isValid;

/**
 *	@brief	remove white spaces from String
 */
- (NSString *)removeWhiteSpacesFromString;

/**
 *	@brief	Counts number of Words in String
 */
- (NSUInteger)countNumberOfWords;

/**
 *	@brief	If my string contains ony letters
 */
- (BOOL)containsOnlyLetters;

/**
 *	@brief	If my string contains only numbers
 */
- (BOOL)containsOnlyNumbers;

/**
 *	@brief	If my string contains letters and numbers
 */
- (BOOL)containsOnlyNumbersAndLetters;

/**
 *	@brief	Is Valid Email
 */
- (BOOL)isValidEmail;

- (BOOL)isMobileNumber;

/**
 *	@brief	Is Valid URL
 */
- (BOOL)isValidUrl;

/**
 *	@brief	字节转换成字符串GB、MB、KB、B
 *
 *	@param 	bytes 	long long字节
 *
 *	@return	如: 3.4MB
 */
+ (NSString *)stringFromBytes:(long long)bytes;

/**
 *	@brief	从MB大小转换成字符串，1024以下就是MB，否则转换成GB
 *
 *	@param 	size 	单位为MB
 *
 *	@return	834.98MB 或 8.22GB
 */
+ (NSString *)stringFromMB:(int)size;

@end
