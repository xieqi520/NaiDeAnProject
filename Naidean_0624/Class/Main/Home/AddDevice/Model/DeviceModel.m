//
//  DeviceModel.m
//  Naidean
//
//  Created by aoxin on 2018/8/6.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "DeviceModel.h"

@implementation DeviceModel

- (id)initWithJSON:(id)json{
    if (self=[super init])
    {
        [self setValuesForKeysWithDictionary:json];
        if ([json[@"oneline"] isEqual:[NSNull null]]) {
            self.oneline = 0;
        }
        
        if ([json[@"status"] isEqual:[NSNull null]]) {
            self.status = 0;
        }
        
        if ([json[@"electricity"] isEqual:[NSNull null]]) {
            self.electricity = @"";
        }
        if ([json[@"temperature"] isEqual:[NSNull null]]) {
            self.temperature = 0;
        }
        if ([json[@"unmanned"] isEqual:[NSNull null]]) {
            self.unmanned = 0;
        }
        if ([json[@"prying"] isEqual:[NSNull null]]) {
            self.prying = 0;
        }
        if ([json[@"low"] isEqual:[NSNull null]]) {
            self.low = 0;
        }
        
        
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"no"]) {
        [self setValue:value forKey:@"unManned"];
    }else if ([key isEqualToString:@"low"]){
        [self setValue:value forKey:@"lowPower"];
    }
}

@end
