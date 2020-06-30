//
//  HWMediaQueue.h
//  CreateHWDecodeSDK
//
//  Created by 邱露祥 on 16/4/5.
//  Copyright © 2016年 邱露祥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HWDisplayGlobal.h"

#define _max_cache_frame_count   120 //最大缓存队列大小，不能小于3，不然连SPS、PPS、IDR都存不了
#define _default_media_buffer_size  102400//默认分配的视频数据大小 10k

@interface HWMediaQueue : NSObject

@property (nonatomic, readonly) NSInteger validMediaCount;

#if 0
///**
// *  将音频数据加到音频队列
// *
// *  @param audioObj 音频数据信息
// */
//- (void)pushAudioData:(HWAudioObject *)audioObj;
#endif

- (void)pushMediaInfo:(HWMediaInfoStruct)mediaInfo needProcIDR:(BOOL)bNeed;

- (HWMediaObject *)popMediaObj;

- (void)clearQueue;

@end
