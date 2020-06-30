//
//  HWDisplayGlobal.h
//  CreateHWDecodeSDK
//
//  Created by 邱露祥 on 16/3/22.
//  Copyright © 2016年 邱露祥. All rights reserved.
//

#ifndef HWDisplayGlobal_h
#define HWDisplayGlobal_h

#import <VideoToolbox/VideoToolbox.h>
#import <UIKit/UIKit.h>

#define MEDIA_FRAME_TYPE_VIDEO	(1 << 0) /**< 视频帧. */
#define MEDIA_FRAME_TYPE_KEY	(1 << 1) /**< 视频帧(关键帧). */
#define MEDIA_FRAME_TYPE_FAST	(1 << 2) /**< 需要播放器进行快速处理（不根据视频帧PTS进行延时）的视频帧. */
#define MEDIA_FRAME_TYPE_AUDIO	(1 << 3) /**< 音频帧. */
#define MEDIA_FRAME_TYPE_GPS	(1 << 4) /**< GPS帧. */
#define MEDIA_FRAME_TYPE_HDR	(1 << 5) /**< 录像文件头部帧. */
#define MEDIA_FRAME_TYPE_TAIL	(1 << 6) /**< 录像文件尾部帧. */
#define MEDIA_FRAME_TYPE_DATA	(1 << 7) /**< 数据帧. */
#define MEDIA_FRAME_TYPE_NSTR	(1 << 8) /**< 新媒体流通知帧. */
#define MEDIA_FRAME_TYPE_EOS	(1 << 9) /**< 媒体流结束通知帧. */
#define MEDIA_FRAME_TYPE_INDEX	(1 << 10)/**< 索引构建结束通知帧. */
#define MEDIA_FRAME_TYPE_RECORD_DATA    (1 << 11)/*录像回调未解码数据*/

#define SAFE_DELETE(ptr) 	do { if (NULL != ptr) { delete ptr; ptr = NULL; } } while (0)
#define SAFE_FREE(ptr) 		do { if (NULL != ptr) { free(ptr); ptr = NULL; } } while (0)


typedef enum : NSInteger {
    HWResolutionMode_QQ720P   = 1, //320*180
    HWResolutionMode_CIF      = 2, //352x288
    HWResolutionMode_QVGA     = 3, //320x240
    HWResolutionMode_Q720P    = 4, //640*360
    HWResolutionMode_VGA      = 5, //640x480
    HWResolutionMode_D1N      = 6, //704x480
    HWResolutionMode_D1P      = 7, //704x576
    HWResolutionMode_XGA      = 8, //1024x768
    HWResolutionMode_720P     = 9, //1280*720
    HWResolutionMode_SXGA     =10, //1280x1024
    HWResolutionMode_1080P    =11, //1920*1080
    
    HWResolutionMode_unknow = -1,
} HWResolutionMode;

typedef enum : NSUInteger {
    HWDecoderType_unknow,//未知
    HWDecoderType_hard,//硬解码
    HWDecoderType_soft,//软解码
} HWDecoderType;

typedef enum : NSUInteger {
    HWMediaType_H264,
    HWMediaType_MJPEG,
    HWMediaType_MPEG4,
    HWMediaType_H265
} HWMediaType;

typedef enum {
    HWAudioType_Unknow = 0,
    HWAudioType_PCM,
    HWAudioType_G711A,
    HWAudioType_G726,
    HWAudioType_G729
} HWAudioType;

typedef enum : NSUInteger {
    HWMediaFrameType_IFrame = 1,
    HWMediaFrameType_PFrame = 2,
} HWMediaFrameType;


typedef struct {
    uint8_t *mediaData;
    uint32_t length;
    uint32_t time;
    uint32_t starTime;
    HWResolutionMode resolution;
    HWMediaType mediaType;
    HWMediaFrameType frameType;
    unsigned long long frameID;
} HWMediaInfoStruct;

#pragma mark - HWAudioObject
@interface HWAudioObject : NSObject

- (id)initWithAudioData:(char *)pDataBuf andSize:(int)nSize;

@end

#pragma mark - HWMediaObject
@interface HWMediaObject : NSObject

- (id)initWithBufSize:(uint32_t)bufSize;

/**
 *  更新视频数据，如果默认分配的空间大小不够，则会自动追加空间
 *
 *  @param data       视频数据
 *  @param length     数据长度
 *  @param resolution 分辨率
 *  @param mediaType  视频类型
 *  @param frameType  帧类型
 *  @param frameID    每一帧的唯一ID，两个连续的数据之间该ID也是连续的，如果不连续，则说明有丢帧
 *
 *  @return 0成功，-1失败
 */
- (int)updateMediaData:(uint8_t *)data
                length:(uint32_t)length
                  time:(uint32_t)time
             startTime:(uint32_t)startTime
            resolution:(HWResolutionMode)resolution
       mediaDecodeType:(HWMediaType)mediaType
             frameType:(HWMediaFrameType)frameType
               frameID:(unsigned long long)frameID;

/**
 *  重置数据信息
 */
- (void)resetMediaInfo;

@property (nonatomic, readonly) uint8_t *mediaData;
@property (nonatomic, readonly) uint32_t length;
@property (nonatomic, readonly) uint32_t time;
@property (nonatomic, readonly) uint32_t starTime;
@property (nonatomic, readonly) unsigned long long frameID;
@property (nonatomic, readonly) HWResolutionMode resolution;
@property (nonatomic, readonly) HWMediaType mediaType;
@property (nonatomic, readonly) HWMediaFrameType frameType;

@end






#endif /* HWDisplayGlobal_h */
