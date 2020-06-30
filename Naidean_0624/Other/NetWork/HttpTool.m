//
//  HttpTool.m
//  BPCheck
//
//  Created by xujun on 2018/5/18.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "HttpTool.h"


#define AFNManager [SingleAFHTTPSessionManager sharedManager]

@implementation SingleAFHTTPSessionManager

static SingleAFHTTPSessionManager *_instance;
+ (id)allocWithZone:(NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    return _instance;
}

+ (SingleAFHTTPSessionManager *)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = (SingleAFHTTPSessionManager *)[[AFHTTPSessionManager alloc] init];
    });
    return _instance;
}

@end

@implementation HttpTool

#pragma mark - 网络请求相关
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    //    DDLog(@"url = %@\nparams = %@",url,params);
    
#if 0
    // 2.发送请求
    [AFNManager POST:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
#endif
   
    AFNManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
     AFNManager.requestSerializer = requestSerializer;
     AFNManager.requestSerializer.timeoutInterval = 20;
    
    NSString *tokenString = @"";
    NSString *memberTok = [[UserManger sharedInstance] getMemberToken];
    if (memberTok.length != 0) {
        tokenString = memberTok;
    }else{
        tokenString = @"";
    }
    
    // 2.发送请求
    DDLog(@"%@--%@",url,params);
    [AFNManager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            DDLog(@"%s %@",__FUNCTION__,responseObject);
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            DDLog(@"%s %@",__FUNCTION__,error);
            failure(error);
        }
    }];
}



+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    DDLog(@"url = %@\nparams = %@",url,params);
    
    // 2.发送请求
#if 0
    [AFNManager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (IWFormData *data in formDataArray) {
            [formData appendPartWithFileData:data.data name:data.name fileName:data.filename mimeType:data.mimeType];
        }
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            DDLog(@"%s %@",__FUNCTION__,responseObject);
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
#endif
    
    [AFNManager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (IWFormData *data in formDataArray) {
            [formData appendPartWithFileData:data.data name:data.name fileName:data.filename mimeType:data.mimeType];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            DDLog(@"%s %@",__FUNCTION__,responseObject);
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}





+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
   // DDLog(@"url = %@\nparams = %@",url,params);
    
#if 0
    // 2.发送请求
    [AFNManager GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
#endif
    
    AFNManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    AFNManager.requestSerializer = requestSerializer;
    AFNManager.requestSerializer.timeoutInterval = 20;
    [AFNManager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
          //  DDLog(@"%s %@",__FUNCTION__,responseObject);
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}



+ (void)putWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    DDLog(@"url = %@\nparams = %@",url,params);
    
    // 2.发送请求
    [AFNManager PUT:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            DDLog(@"%s %@",__FUNCTION__,responseObject);
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}



+ (void)deleteWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    DDLog(@"url = %@\nparams = %@",url,params);
    // 2.发送请求
    [AFNManager DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            DDLog(@"%s %@",__FUNCTION__,responseObject);
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - 上传 & 下载

+ (void)uploadImages:(NSArray *)images completion:(void (^)(NSArray<NSString *> *))completion{
    
    NSMutableArray *urls = [NSMutableArray array];
    //用来解决上传图片的排序问题
    for (int i = 0; i<images.count; i++) {
        [urls addObject:@0];
    }
    
    //记录已经上传了的数量
    __block int num = 0;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *name = [formatter stringFromDate:[NSDate date]];
    
    for (int i = 0; i<images.count; i++) {
        
        
        [AFNManager POST:@"**************" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            UIImage *image = (UIImage *)images[i];
            NSData *imageData = UIImageJPEGRepresentation(image,0.3);
            NSString *imageFileName = [NSString stringWithFormat:@"%@.jpg", name];
            [formData appendPartWithFileData:imageData name:@"upload" fileName:imageFileName mimeType:@"image/jpg"];
            //            [formData appendPartWithFileData:UIImageJPEGRepresentation(images[i], 1.0) name:@"upload" fileName:@"file.jpg" mimeType:@"image/jpg"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            DDLog(@"上传进度--%lld,总进度---%lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            
            if ([responseObject[@"errCode"] intValue]== 1){
                NSString *imageSrc=responseObject[@"result"][@"src"];
                
                [urls replaceObjectAtIndex:i withObject:imageSrc];
                num++;
                
                if (num == images.count) {
                    //是否返回上层控制器,如果是选多张图片,上层即是编辑页,如果不是,则是上上层
                    if (completion) {
                        completion(urls);
                    }
                }
            }else{
                
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            
            
        }];
    }
}

+(void)uploadImage:(UIImage *)image imageName:(NSString *)name urlString:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure{

    [AFNManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
     AFNManager.requestSerializer.timeoutInterval = 20;
    [AFNManager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImageJPEGRepresentation(image,0.8);
        NSString *format=@"";
        if (image) {
            if (UIImagePNGRepresentation(image) == nil) {
                format=@"jpeg";
            } else {
                format=@"png";
            }
        }
        //上传时使用当前的系统事件作为文件名
        NSDateFormatter *formatter = [[ NSDateFormatter alloc ] init ];
        formatter.dateFormat = @"yyyyMMddHHmmss" ;
        NSString *str = [formatter stringFromDate :[ NSDate date ]];
        NSString *fileName = [ NSString stringWithFormat : @"%@.%@" , str,format];
        NSString *mimeType =[NSString stringWithFormat:@"image/%@",format];
        
        [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}


+ (void)uploadImages:(NSArray *)images hudView:(UIView *)hudView completion:(void (^)(NSArray<NSString *> *))completion{
    
    NSMutableArray *urls = [NSMutableArray array];
    //用来解决上传图片的排序问题
    for (int i = 0; i<images.count; i++) {
        [urls addObject:@0];
    }
    
    //记录已经上传了的数量
    __block int num = 0;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    
    for (int i = 0; i<images.count; i++) {
        
        [AFNManager POST:@"*****" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            UIImage *image = (UIImage *)images[i];
            NSData *imageData = UIImageJPEGRepresentation(image,0.5);
            NSString *name = [NSString stringWithFormat:@"%@_%02d", str, i];
            NSString *imageFileName = [NSString stringWithFormat:@"%@.jpg", name];
            [formData appendPartWithFileData:imageData name:@"upload" fileName:imageFileName mimeType:@"image/jpg"];
            //            [formData appendPartWithFileData:UIImageJPEGRepresentation(images[i], 1.0) name:@"upload" fileName:@"file.jpg" mimeType:@"image/jpg"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            DDLog(@"上传进度--%lld,总进度---%lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if ([responseObject[@"errCode"] intValue]== 1){
                
                NSString *imageSrc=responseObject[@"result"][@"src"];
                
                [urls replaceObjectAtIndex:i withObject:imageSrc];
                num++;
                
                if (num == images.count) {
                    //是否返回上层控制器,如果是选多张图片,上层即是编辑页,如果不是,则是上上层
                    if (completion) {
                        completion(urls);
                    }
                }
            }else{
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
}

//一次上传多张图片
#if 0
+ (void)uploadImages:(NSArray *)images completion:(void (^)(NSArray<NSString *> *))completion{
#if duDu
    [SVProgressHUD showWithStatus:@"正在上传图片请等待"];
#endif
    [AFNManager POST:@"http://api." parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        
        for (int i = 0; i < images.count; i ++) {
            UIImage *image = (UIImage *)images[i];
            NSData *imageData = UIImageJPEGRepresentation(image,0.5);
            NSString *name = [NSString stringWithFormat:@"%@_%02d", str, i];
            NSString *imageFileName = [NSString stringWithFormat:@"%@.png", name];
            [formData appendPartWithFileData:imageData name:@"upload" fileName:imageFileName mimeType:@"image/jpg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        DDLog(@"上传进度--%lld,总进度---%lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        //        if (progress) {
        //            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        //        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"errCode"] intValue]== 1){
            NSString *imageSrc=responseObject[@"result"][@"src"];
            //是否返回上层控制器,如果是选多张图片,上层即是编辑页,如果不是,则是上上层
            if (completion) {
                completion(@[imageSrc]);
            }
        }else{
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
#endif

#pragma mark - 网络检查

+(void)getNetworkStatus:(void (^)(AFNetworkReachabilityStatus))callBack{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    __weak __typeof(mgr) weakMgr = mgr;
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        __strong __typeof(weakMgr) strongMgr = weakMgr;
        [strongMgr stopMonitoring];
        if (callBack) {
            callBack(status);
        }
    }];
    
    [mgr startMonitoring];
}


//+(void)checkMemberTokenIsAvailableSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure{
//    if ([[UserManager sharedInstance] getMemberToken]) {
//        [AFNManager POST:baseUrlWithPath(@"ChkTokenValid") parameters:@{@"MemberToken":[[UserManager sharedInstance] getMemberToken]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            if (success) {
//                success(responseObject);
//            }
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            if (failure) {
//                failure(error);
//            }
//        }];
//    }
//}


@end

@implementation IWFormData



@end

