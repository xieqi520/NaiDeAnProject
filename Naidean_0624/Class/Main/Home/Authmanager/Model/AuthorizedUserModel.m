//
//  AuthorizedUserModel.m
//  Naidean
//
//  Created by aoxin on 2018/8/8.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "AuthorizedUserModel.h"

@implementation AuthorizedUserModel

- (instancetype)initWithJSON:(id)json{
    if ([super init]) {
        [self setValuesForKeysWithDictionary:json];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"no"]) {
        [self setValue:value forKey:@"unManned"];
    }else if ([key isEqualToString:@"low"]){
        [self setValue:value forKey:@"lowPower"];
    }else if ([key isEqualToString:@"lockPeriodList"]){
        NSArray *ary = value;
        NSMutableArray *valueAry = [NSMutableArray array];
        for (NSInteger i = 0; i < ary.count; i++) {
            NSDictionary *dic = ary[i];
            [valueAry addObject:dic[@"lockPeriod"]];
        }
        [self setValue:[valueAry copy] forKey:@"lockPeriods"];
    }else if ([key isEqualToString:@"lockTimeList"]){
        NSArray *ary = value;
        NSMutableArray *valueAry = [NSMutableArray array];
        for (NSInteger i = 0; i < ary.count; i++) {
            NSDictionary *dic = ary[i];
            [valueAry addObject:dic[@"lockTime"]];
        }
        [self setValue:[valueAry copy] forKey:@"lockDays"];
    }
}

@end
