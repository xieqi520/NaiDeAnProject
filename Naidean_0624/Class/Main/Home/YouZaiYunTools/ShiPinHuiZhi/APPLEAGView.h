//
//  APPLEAGView.h
//  XcloudlinkDemo
//
//  Created by lijiang on 17/5/4.
//  Copyright © 2017年 lijiang. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 根据状态显示加载UI提示
 */
typedef NS_ENUM(NSInteger, APPLEAGViewStateType)
{
    APPLEAGViewStateTypeNoconnect = 0,//无网络
    APPLEAGViewStateTypeGPRS = 1,//GPRS网络
    APPLEAGViewStateTypeWIFI = 2,//wifi网络
    APPLEAGViewStateTypeNotLine = 3,//设备不在线
    APPLEAGViewStateTypeLoading = 4,//Loading
    APPLEAGViewStateTypeNotView = 5,//无提示
};

// --------------------------------------------- 检测网络切换工具类回调 --------------------------

@protocol APPLEAGViewDelegate <NSObject>

@optional

/**
 * 当网络状态发生改变的时候触发， 前提是必须是添加网络状态监听
 */
- (void)playAPPLEAGView;


@end


@interface APPLEAGView : UIView



- (instancetype)initWithFrame:(CGRect)frame;


@property(nonatomic,assign)id<APPLEAGViewDelegate>delegate;

/**
 传入视频流数据
 */
@property CVPixelBufferRef pixelBuffer;


/**
 设置视频背景图片

 @param image 视频背景图片
 */
- (void)setbgimage:(UIImage *)image;



/**
 根据状态显示加载UI提示

 @param StateType 提示
 */
- (void)setAPPLEAGViewStateType:(APPLEAGViewStateType)StateType;


/**
 隐藏加载动画(默认是显示加载动画)
 */
- (void)HiddenloadView;


@property(nonatomic,assign)int videoWidth;
@property(nonatomic,assign)int videoHeight;

//点击放大按钮block
//@property (nonatomic,copy) void(^fangdaBlcok)(void);

//点击缩小按钮block
//@property (nonatomic,copy) void(^suoxiaoBlock)(void);

//开锁按钮block
@property (nonatomic,copy) void(^unLockBlock)(void);

@end
