//
//  HWMediaQueue.m
//  CreateHWDecodeSDK
//
//  Created by 邱露祥 on 16/4/5.
//  Copyright © 2016年 邱露祥. All rights reserved.
//

#import "HWMediaQueue.h"
#import "WLSQXcloulink.h"
@interface HWMediaQueue ()
{
    //缓存队列操作索引
    NSInteger _popIndex;//取数据索引
    NSInteger _pushIndex;//压数据索引
    NSInteger _validMediaCount;//有效的视频数据个数，如果为0，则说明暂时没有数据，解码线程需要睡眠

}


@property (nonatomic, strong) NSMutableArray *mediaObjArr;//解码视频对象数组
@property (nonatomic, strong) NSCondition *decodeCondition;//解码锁

@end

@implementation HWMediaQueue

@synthesize validMediaCount = _validMediaCount;

- (id)init
{
    self = [super init];
    if (self) {
        self.mediaObjArr = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < _max_cache_frame_count; ++i) {
            //默认为数据缓存队列分配空间为30
            HWMediaObject *mediaObj = [[HWMediaObject alloc] initWithBufSize:_default_media_buffer_size];
            [_mediaObjArr addObject:mediaObj];
        }
        _popIndex = 0;
        _pushIndex = 0;
        _validMediaCount = 0;
        self.decodeCondition = [[NSCondition alloc] init];

    }
    return self;
}



- (void)pushMediaInfo:(HWMediaInfoStruct)mediaInfo needProcIDR:(BOOL)bNeed
{
    [_decodeCondition lock];
    
    mediaInfo.starTime = (uint32_t)[[[WLSQXcloulink sharedManager] getDatetimeHaoMiaoString] integerValue];
    
    if (bNeed) {
        //解析I帧
        [self procH264MediaData:mediaInfo];
        [_decodeCondition signal];

    } else {
        
        if(_mediaObjArr.count  > _pushIndex )
        {
            
            
            HWMediaObject *mediaObj = [_mediaObjArr objectAtIndex:_pushIndex];
            
            int ret = [mediaObj updateMediaData:mediaInfo.mediaData length:(uint32_t)mediaInfo.length time:(uint32_t)mediaInfo.time startTime:(uint32_t)mediaInfo.starTime resolution:mediaInfo.resolution mediaDecodeType:mediaInfo.mediaType frameType:mediaInfo.frameType frameID:mediaInfo.frameID];
            
            if (ret == 0) {
                if (_validMediaCount < _max_cache_frame_count) {
                    ++_validMediaCount;
                }
                [self updatePushIndex];
                [_decodeCondition signal];
            }
            
            
        }
    }
    [_decodeCondition signal];
    [_decodeCondition unlock];
}

- (HWMediaObject *)popMediaObj
{
    HWMediaObject *mediaObj = nil;
    [_decodeCondition lock];

//    NSLog(@"_validMediaCount %d", _validMediaCount);
    if (_validMediaCount == 0) {
        [_decodeCondition wait];
    }
    
    if (_validMediaCount == 0) {
        [_decodeCondition unlock];
        return nil;
    }
    mediaObj = [_mediaObjArr objectAtIndex:_popIndex];

    if (++_popIndex >= _max_cache_frame_count) {
        //已经取到了最后一个，则从头开始pop
        _popIndex = 0;
    }
    
    --_validMediaCount;

    [_decodeCondition unlock];
    
    return mediaObj;
}

- (void)clearQueue
{
    [_decodeCondition lock];
    
    [_mediaObjArr removeAllObjects];

    [_decodeCondition signal];
    [_decodeCondition unlock];
}

- (void)updatePushIndex
{
    if (++_pushIndex >= _max_cache_frame_count) {
        _pushIndex = 0;
    }
}

- (void)updatePopIndex
{
    if (++_popIndex >= _max_cache_frame_count) {
        _popIndex = 0;
    }
}

/**
 *  解析一个包含SPS、PPS、SEI帧的I帧，把它们单独分开来供硬解处理
 *
 *  @param mediaObj 原始I帧
 */
- (void)procH264MediaData:(HWMediaInfoStruct)mediaInfo
{
    int spsPos = -1;
    int ppsPos = -1;
    int seiPos = -1;
    int idrPos = -1;
    
    uint8_t *tempBuf = mediaInfo.mediaData;
    
//        printf("\n-------------------\n");
//    for (int j = 0; j < 100; ++j) {
//        printf("%x-", tempBuf[j]);
//    }
//        printf("\n-------------------\n");
    
    int iPos = 0;
    for (int i = 0; i < mediaInfo.length ; ++i) {
        
        if (tempBuf[i] == 0x00 && tempBuf[i+1] == 0x00 && tempBuf[i+2] == 0x00 && tempBuf[i+3] == 0x01)
        {
            iPos = i;
            break;
        }
    }
    
    
    for (int i = iPos; i < mediaInfo.length - iPos; ++i) {
        
        if (tempBuf[i] == 0x00 && tempBuf[i + 1] == 0x00 && tempBuf[i + 2] == 0x00 && tempBuf[i + 3] == 0x01) {
//             NSLog(@"------%x---%x---%x---%x--%x", tempBuf[i], tempBuf[i + 1], tempBuf[i + 2], tempBuf[i + 3],tempBuf[i + 4]);
            //找到开始码，后的第一个字节的低5位是否为7或8
            int type = tempBuf[i + 4] & 0x1F;
            
//            NSLog(@"nal 类型为 %d", type);
            if (type == 7) {
                //sps
                spsPos = i + 4;
            } else if (type == 8) {
                //pps
                ppsPos = i + 4;
            } else if (type == 6) {
                //sei补充信息单元
                seiPos = i + 4;
            } else {
                //IDR关键帧
                idrPos = i + 4;//67  68  06  65
                break;
            }
        }
        
    }
    
    if(_mediaObjArr.count  > _pushIndex )
    {
        if (spsPos >= 0 && ppsPos > 0) {
            //处理SPS帧
            HWMediaObject *mediaObj = [_mediaObjArr objectAtIndex:_pushIndex];
            
             int ret = [mediaObj updateMediaData:tempBuf + spsPos - 4 length:ppsPos - spsPos time:(uint32_t)mediaInfo.time startTime:(uint32_t)mediaInfo.starTime resolution:mediaInfo.resolution mediaDecodeType:mediaInfo.mediaType frameType:mediaInfo.frameType frameID:mediaInfo.frameID];
            
            if (ret == 0) {
                if (_validMediaCount < _max_cache_frame_count) {
                    ++_validMediaCount;
                }
                [self updatePushIndex];
            }
            
            //处理PPS
            uint32_t ppsSize = seiPos > ppsPos ? (seiPos - ppsPos) : (idrPos - ppsPos);
            
            mediaObj = [_mediaObjArr objectAtIndex:_pushIndex];
            
            ret = [mediaObj updateMediaData:tempBuf + ppsPos - 4 length:ppsSize time:(uint32_t)mediaInfo.time startTime:(uint32_t)mediaInfo.starTime resolution:mediaInfo.resolution mediaDecodeType:mediaInfo.mediaType frameType:mediaInfo.frameType frameID:mediaInfo.frameID];

            if (ret == 0) {
                if (_validMediaCount < _max_cache_frame_count) {
                    ++_validMediaCount;
                }
                [self updatePushIndex];
            }
        }
        
        //处理IDR
        HWMediaObject *mediaObj = [_mediaObjArr objectAtIndex:_pushIndex];
        
         int ret = [mediaObj updateMediaData:tempBuf + idrPos - 4 length:(uint32_t)mediaInfo.length - idrPos + 4 time:(uint32_t)mediaInfo.time startTime:(uint32_t)mediaInfo.starTime resolution:mediaInfo.resolution mediaDecodeType:mediaInfo.mediaType frameType:mediaInfo.frameType frameID:mediaInfo.frameID];
        
        if (ret == 0) {
            if (_validMediaCount < _max_cache_frame_count) {
                ++_validMediaCount;
            }
            [self updatePushIndex];
        }
   }
}

@end
