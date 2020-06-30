//
//  HWDecoder.h
//  CreateHWDecodeSDK
//
//  Created by 邱露祥 on 16/3/22.
//  Copyright © 2016年 邱露祥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HWDisplayGlobal.h"


#pragma mark - HWDecodeSDKDelegate
@protocol HWDecodeSDKDelegate <NSObject>

@optional
/**
 *	@brief	解码后的视频数据返回
 *
 *	@param 	frameDesc 	解码后的视频数据
 */

- (BOOL)didHardDecodePixelBuffer:(CVPixelBufferRef)pixBuffer SamplePhotoBuffer:(CMSampleBufferRef)samplePhotoBuffer forSessionID:(NSUInteger)sessionID mediaType:(NSUInteger)mediaType;

@end


#pragma mark - HWDecoder
@interface HWDecoder : NSObject

@property (nonatomic, assign) NSInteger decoderID;//该解码器的唯一ID
@property (nonatomic, assign) NSUInteger sessionID;//会话ID，每一通道视频都是唯一的
@property (nonatomic, assign) NSUInteger MediaType;
@property (nonatomic,assign) id<HWDecodeSDKDelegate>delegate;



/**
 *  初始化为视频解码器为硬解码
 *
 *  @param delegate 代理，用于返回视频解码数据
 *
 *  @return 解码器对象
 */
- (id)initAsHardMediaDecoderWithDelegate:(id<HWDecodeSDKDelegate>)delegate;


/**
 *	@brief	开始解码
 */

- (void)starDecode;


/**
 *	@brief	停止解码
 */
- (void)stopDecode;


/**
 *  将视频数据信息加到解码队列
 *
 *  @param mediaInfo 视频信息
 */
- (void)pushMediaData:(HWMediaInfoStruct)mediaInfo;




@end
