//
//  SYVideoViewController.m
//  Naidean
//
//  Created by aoxin on 2018/12/24.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "SYVideoViewController.h"
#import "AppDelegate.h"
#import "SHIXCommonProtocol.h"
#import "SHIXGLController.h"
#import "APICommon.h"

@interface SYVideoViewController ()<SHIXCommonProtocol>
{
    AppDelegate *appDelegate;
}
@property (nonatomic,strong) UIImageView *testimageView;
@end

@implementation SYVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"摄像头";
    self.view.backgroundColor = [UIColor whiteColor];
    self.testimageView = [[UIImageView alloc] init];
    self.testimageView.frame = CGRectMake(0, 0, WIN_WIDTH, getHeight(300));
    [self.view addSubview:self.testimageView];
}

//刷新视频
- (void)YUVRefresh: (Byte*) pYUV Len: (int) length width: (int)width height: (int) height {
    UIImage *image = [APICommon YUV420ToImage:pYUV width:width height:height];
    if (image != nil) {
        
        [self performSelectorOnMainThread:@selector(updateImage:) withObject:image waitUntilDone:NO];
    }
}

- (void) updateImage:(UIImage *)data
{
    if (self.testimageView!=nil) {
        self.testimageView.image = data;
    }
    data = nil;
}
@end
