//
//  HttpTool.h
//  BPCheck
//
//  Created by xujun on 2018/5/18.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

//typedef enum : NSUInteger {
//    NetworkStatusUnknown = -1, // 未知网络
//    NetworkStatusNotReachable = 0, // 无网络连接
//    NetworkStatusWWAN = 1, // 蜂窝移动网络
//    NetworkStatusWiFi = 2,  //wifi
//} NetworkStatus;


@interface SingleAFHTTPSessionManager : AFHTTPSessionManager

@end

@interface HttpTool : NSObject

/**
 检查网络
 
 @param callBack 返回网络状态
 */
+(void)getNetworkStatus:(void (^)(AFNetworkReachabilityStatus networkStatus))callBack;


//+(void)checkMemberTokenIsAvailableSuccess:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  发送一个POST请求(上传文件数据)
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param formDataArray  文件参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  发送一个GET请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  发送一个PUT请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)putWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  发送一个DELETE请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)deleteWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  将图片上传到阿里云
 *
 *  @param images     需要上传的图片
 *  @param completion 上传完回调的block,返回urls数组
 */
+ (void)uploadImages:(NSArray *)images completion:(void (^)(NSArray<NSString *> *urls))completion;


+(void)uploadImage:(UIImage *)image imageName:(NSString *)name urlString:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;


@end

/**
 *  用来封装文件数据的模型
 */
@interface IWFormData : NSObject
/**
 *  文件数据
 */
@property (nonatomic, strong) NSData *data;

/**
 *  参数名
 */
@property (nonatomic, copy) NSString *name;

/**
 *  文件名
 */
@property (nonatomic, copy) NSString *filename;

/**
 *  文件类型
 */
@property (nonatomic, copy) NSString *mimeType;

@end
