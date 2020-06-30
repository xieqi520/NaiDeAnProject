//
//  SYVideoViewController.h
//  Naidean
//
//  Created by aoxin on 2018/12/24.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "ViewController.h"

@interface SYVideoViewController : ViewController

@property (strong ,nonatomic) DeviceModel *device;

//刷新视频
- (void)YUVRefresh: (Byte*) pYUV Len: (int) length width: (int)width height: (int) height;
@end
