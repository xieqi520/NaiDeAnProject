//
//  LockLogModel.m
//  Naidean
//
//  Created by aoxin on 2018/8/7.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "LockLogModel.h"

@implementation LockLogModel

- (id)initWithJSON:(id)json{
    if (self=[super init])
    {
        [self setValuesForKeysWithDictionary:json];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
