//
//  PhotoModel.m
//  Naidean
//
//  Created by aoxin on 2018/8/8.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "PhotoModel.h"

@implementation PhotoModel

- (instancetype)initWithJSON:(id)json{
    if ([super init]) {
        [self setValuesForKeysWithDictionary:json];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}


@end
