//
//  PhotoModel.h
//  Naidean
//
//  Created by aoxin on 2018/8/8.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoModel : NSObject

@property (nonatomic, copy) NSString *pictureId;//拍照ID
@property (nonatomic, copy) NSString *mac;//Mac地址
@property (nonatomic, copy) NSString *number;//手机号
@property (nonatomic, copy) UIImage *picture;//照片
@property (nonatomic, copy) NSString *time;//拍照时间


- (instancetype)initWithJSON:(id)json;

//过滤不存在的键值对
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;


@end
