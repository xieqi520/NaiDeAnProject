//
//  HWDecoder.m
//  CreateHWDecodeSDK
//
//  Created by 邱露祥 on 16/3/22.
//  Copyright © 2016年 邱露祥. All rights reserved.
//

#import "HWDecoder.h"
#import <sys/time.h>
#import <VideoToolbox/VideoToolbox.h>
#import "HWMediaQueue.h"
#import "WLSQXcloulink.h"

#pragma mark - HWAudioObject
@interface HWAudioObject ()

@property (nonatomic, assign) char *audioData;
@property (nonatomic, assign) int audioLength;

@end

@implementation HWAudioObject

- (id)initWithAudioData:(char *)pDataBuf andSize:(int)nSize
{
    self = [super init];
    if (self) {
        self.audioData = (char *)calloc(1, nSize);
        if (_audioData == NULL) {
            NSLog(@"%s:(%d):malloc audio data failed ......", __func__, __LINE__);
            return nil;
        }
        self.audioLength = nSize;
        memcpy(_audioData, pDataBuf, _audioLength);
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"hk audio object is dealloc....!!!!");
    SAFE_FREE(_audioData);
}
@end

#pragma mark - HKMediaObject
/*
 这个类用来传递要解码的视频数据
 */
@interface HWMediaObject ()
{

    uint8_t *_mediaData;
    uint32_t _bufSize;
    uint32_t _length;
    unsigned long long _frameID;
    HWResolutionMode _resolution;
    HWMediaType _mediaType;
    HWMediaFrameType _frameType;
}

@end

@implementation HWMediaObject

@synthesize mediaData = _mediaData;
@synthesize length = _length, resolution = _resolution;
@synthesize mediaType = _mediaType, frameType = _frameType;
@synthesize frameID = _frameID;

- (id)initWithBufSize:(uint32_t)bufSize
{
    self = [super init];
    if (self) {
        if (bufSize == 0) {
            bufSize = _default_media_buffer_size;//默认分配1024字节
        }

        _bufSize = bufSize;
        _mediaData = (uint8_t *)malloc(bufSize);
        if (_mediaData == NULL) {
            NSLog(@"malloc media data buffer failed with buffer size %d", _bufSize);
            _bufSize = 0;
        }
    }
    return self;
}

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
               frameID:(unsigned long long)frameID
{
    if (_length != 0) {
        //进到这里来，说明队列空间不足，需要覆盖数据
        if (frameType == HWMediaFrameType_PFrame) {
            //如果是P帧想要覆盖I帧，这是不允许的
            NSLog(@"不允许P帧覆盖I帧");
            return -1;
        } else {
            NSLog(@"帧 %d 替换了帧 %d", (int)frameType, (int)_frameType);
        }
    }
    _resolution = resolution;
    _mediaType = mediaType;
    _frameType = frameType;
    _length = length;
    _frameID = frameID;
    _time = time;
    _starTime = startTime;

    if (_length > _bufSize) {
        //空间不足，追加分配内存空间，但是千万不要用realloc
        NSLog(@"重新分配内存空间 %d - %d", _length, _bufSize);
        SAFE_FREE(_mediaData);
        _mediaData = (uint8_t *)malloc(_length);

        if (_mediaData == NULL) {
            NSLog(@"remalloc media data buffer failed with buffer size %d", _bufSize);
            _bufSize = 0;
            return -1;
        }
        _bufSize = _length;
    }
    
    memcpy(_mediaData, data, _length);

    return 0;
}

/**
 *  重置数据信息
 */
- (void)resetMediaInfo
{
    _length = 0;
    _frameID = 0;
}



//- (void)dealloc
//{
//    NSLog(@"hw media object is dealloced.........!!!!");
//    SAFE_FREE(_mediaData);
//}

@end

@interface HWDecoder ()
{
    int _frameWidth;
    int _frameHeight;
    HWResolutionMode _resolution;//当前播放视频的分辨率
    HWMediaType _mediaType;//当前播放视频的编码类型
    HWAudioType _audioType;//音频类型
    BOOL _bRun;//是否正在解码
    uint8_t *_videoDecodedBuffer;//视频解码数据缓存，长度为_videoDecodedLength
    uint32_t _videoDecodedLength;//视频解码数据长度
    BOOL _waitKeyframe;//等待关键帧

    //硬解参数
    uint8_t *_sps;
    size_t _spsSize;
    uint8_t *_pps;
    size_t _ppsSize;
    VTDecompressionSessionRef _deocderSession;
    CMVideoFormatDescriptionRef _decoderFormatDescription;
    CMSampleBufferRef _sampleBuffer;
    CMBlockBufferRef _blockBuffer;
    bool g_bLostFrame;
    
}

@property (nonatomic, strong) HWMediaQueue *mediaQueue;

@property (nonatomic, strong) NSLock *decodeLock;
@end

@implementation HWDecoder


/**
 *  初始化为视频解码器为硬解码
 *
 *  @param delegate 代理，用于返回视频解码数据
 *
 *  @return 解码器对象
 */
- (id)initAsHardMediaDecoderWithDelegate:(id<HWDecodeSDKDelegate>)delegate
{
    self = [super init];
    if (self) {
        [self initMediaParam];

        _delegate = delegate;
        self.mediaQueue = [[HWMediaQueue alloc] init];
        
        g_bLostFrame = false;
        
       
    }
    return self;
}

- (void)initMediaParam
{

    _bRun = NO;
    _audioType = HWAudioType_Unknow;
    _resolution = HWResolutionMode_unknow;
    _mediaType = HWMediaType_H264;
    _videoDecodedBuffer = NULL;
    _videoDecodedLength = 0;
    _waitKeyframe = YES;

    self.decodeLock = [[NSLock alloc] init];
}


- (void)dealloc
{
    NSLog(@"decoder dealloced.....");
    [self clearH264Deocder];
}

/**
 *	@brief	开始解码
 */

- (void)starDecode
{
    if( !_bRun ){
     
        _bRun = YES;
        [NSThread detachNewThreadSelector:@selector(hardDecodeMediaData) toTarget:self withObject:nil];
    }
    

}

/**
 *	@brief	停止解码
 */
- (void)stopDecode
{
    _bRun = NO;
    [_mediaQueue clearQueue];

    [_decodeLock lock];

    SAFE_FREE(_videoDecodedBuffer);
  

    [_decodeLock unlock];
    NSLog(@"stop decode.....");
}




#pragma mark - 视频解码
/**
 *  将视频数据信息加到解码队列
 *
 *  @param mediaObj 视频信息
 */
int _i_num = 0;
- (void)pushMediaData:(HWMediaInfoStruct)mediaInfo
{
    if (!_bRun) {
        return;
    }
    
    if (mediaInfo.frameType == HWMediaFrameType_IFrame)
    {
        
        if( _i_num != 0 && _i_num < 14)
        {
//            NSLog(@"*********************************丢失P帧%d ",_i_num);
            
        }
        _i_num = 0;
    
   }
    if (mediaInfo.frameType == HWMediaFrameType_PFrame)
    {
        _i_num ++;
        
        
    }

     NSInteger operationCount = _mediaQueue.validMediaCount;
    if(operationCount > 100)
    {
        g_bLostFrame = true;
    }

    if (g_bLostFrame && mediaInfo.frameType == HWMediaFrameType_PFrame)
    {
        return;
    }
    [_mediaQueue pushMediaInfo:mediaInfo needProcIDR:( mediaInfo.frameType == HWMediaFrameType_IFrame)];
}


#pragma mark - 硬解视频部分
/**
 *  硬解线程
 */
bool _starCache = YES;

- (void)hardDecodeMediaData
{
    while (_bRun) {
        [_decodeLock lock];
        
        if (!_bRun) {
            [_decodeLock unlock];
            break;
        }
        
        NSInteger operationCount = _mediaQueue.validMediaCount;
        
        //先缓冲15桢数据
        if(operationCount > 15 && _starCache)
        {
            _starCache = NO;
            NSLog(@"********************** 缓冲完成-->数据个数为:%ld ",(long)operationCount);
            
        }
       
        
        if(!_starCache)
        {
            
            HWMediaObject *mediaObj = [_mediaQueue popMediaObj];
            
            if (!_bRun || nil == mediaObj) {
                [_decodeLock unlock];
                break;
            }
       
            if (operationCount > 100) {
                  NSLog(@"****************队列溢出 ****** 数据个数:%ld  帧数:%lu",(long)operationCount,(unsigned long)mediaObj.frameType);
                //如果是P帧
//                g_bLostFrame= true;
//                if(mediaObj.frameType == HWMediaFrameType_PFrame)
//                {
//                    //循环获取P帧并且丢掉
//                    NSLog(@"循环获取P帧并且丢掉,等待I桢");
//                    
//                } else {
//                    
//                    //解码
//                    [self procHardMediaPackege:mediaObj];
//                }
//                
//                
//            } else {
//                
//                if (g_bLostFrame && mediaObj.frameType == HWMediaFrameType_PFrame)
//                {
//                    //wait i
//                }
//                else
//                {
//                    //解码
//                    g_bLostFrame= false;
//                    [self procHardMediaPackege:mediaObj];
//                }
//                
            }

            [_decodeLock unlock];
            [self procHardMediaPackege:mediaObj];
            [mediaObj resetMediaInfo];
            continue;
        }
        
        [_decodeLock unlock];
    }
}

static void didDecompress( void *decompressionOutputRefCon, void *sourceFrameRefCon, OSStatus status, VTDecodeInfoFlags infoFlags, CVImageBufferRef pixelBuffer, CMTime presentationTimeStamp, CMTime presentationDuration ){
    
    CVPixelBufferRef *outputPixelBuffer = (CVPixelBufferRef *)sourceFrameRefCon;
    *outputPixelBuffer = CVPixelBufferRetain(pixelBuffer);
    
   
}

-(BOOL)initH264Decoder {
    
//    NSLog(@"***********************准备初始化过解码器*************************************");
    //如果有被初始化过，则直接结束
    if(_deocderSession) {
        NSLog(@"已经初始化过解码器");
        return YES;
    }
    
    
    const uint8_t* const parameterSetPointers[2] = { _sps, _pps };
    const size_t parameterSetSizes[2] = { _spsSize, _ppsSize };
    
    //创建decoderFormatDescription
    OSStatus status = CMVideoFormatDescriptionCreateFromH264ParameterSets(kCFAllocatorDefault,
                                                                          2, //param count
                                                                          parameterSetPointers,
                                                                          parameterSetSizes,
                                                                          4, //nal start code size
                                                                          &_decoderFormatDescription);
    
//    NSLog(@"FromH264ParameterSets Create: \t %@", (status == noErr) ? @"successful!" : @"failed...");
    
    
    //创建成功
    if(status == noErr) {
        CFDictionaryRef attrs;
        
        const void *keys[] = { kCVPixelBufferPixelFormatTypeKey };
        
        uint32_t v = kCVPixelFormatType_420YpCbCr8BiPlanarFullRange;//kCVPixelFormatType_420YpCbCr8BiPlanarFullRange;
        CFNumberRef numberV = CFNumberCreate(NULL, kCFNumberSInt32Type, &v);
        const void *values[] = { numberV };
        attrs = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
        
        VTDecompressionOutputCallbackRecord callBackRecord;
        callBackRecord.decompressionOutputCallback = didDecompress;
        callBackRecord.decompressionOutputRefCon = NULL;
        
        //创建解码session
        status = VTDecompressionSessionCreate(kCFAllocatorDefault,
                                              _decoderFormatDescription,
                                              NULL, attrs,
                                              &callBackRecord,
                                              &_deocderSession);
//        NSLog(@"Video Decompression Session Create: \t %@", (status == noErr) ? @"successful!" : @"failed...");
        CFRelease(numberV);
        CFRelease(attrs);
        
    } else {
        NSLog(@"IOS8VT: reset decoder session failed status=%d", status);
    }
    
    return YES;
}

-(void)clearH264Deocder {
    
    if(_deocderSession) {
        VTDecompressionSessionInvalidate(_deocderSession);
        CFRelease(_deocderSession);
        _deocderSession = NULL;
    }
    
    if(_decoderFormatDescription) {
        CFRelease(_decoderFormatDescription);
        _decoderFormatDescription = NULL;
    }
    
    if (_sps != NULL) {
        free(_sps);
        _sps = NULL;
    }
    if (_pps != NULL) {
        free(_pps);
        _pps = NULL;
    }
    _spsSize = _ppsSize = 0;
}

- (void)decode:(HWMediaObject *)mediaObj
{
    uint8_t *tempBuf = mediaObj.mediaData;
    int iPos = 0;
    for (int i = 0; i < mediaObj.length; ++i) {
        
        if (tempBuf[i] == 0x00 && tempBuf[i+1] == 0x00 && tempBuf[i+2] == 0x00 && tempBuf[i+3] == 0x01)
        {
            iPos = i;
            break;
        }
    }
    
    
    if (!_deocderSession) {
        NSLog(@"还没有初始化解码器...");
        return;
    }
    if (_waitKeyframe) {
        NSLog(@"等待I帧，忽略该帧 %d", (int)mediaObj.frameType);
        return;
    }
    //声明解码后的图像数据
    CVPixelBufferRef outputPixelBuffer = NULL;
    CMSampleBufferRef _samplePhotoBuffer = NULL;
    
    //声明解码前的图像数据
    if (_blockBuffer != NULL) {
        CFRelease(_blockBuffer);
        _blockBuffer = NULL;
    }
    
    //创建解码前的图像数据
    OSStatus status  = CMBlockBufferCreateWithMemoryBlock(kCFAllocatorDefault,
                                                          (void*)(mediaObj.mediaData - iPos), mediaObj.length - iPos,
                                                          kCFAllocatorNull,
                                                          NULL, 0, mediaObj.length - iPos,
                                                          0, &_blockBuffer);
//     NSLog(@"\t\t BlockBufferCreation: \t %@", (status == kCMBlockBufferNoErr) ? @"successful!" : @"failed...");

    //创建成功
    if(status == kCMBlockBufferNoErr) {
        
        //声明存放解码前的视频图像的容器
        if (_sampleBuffer != NULL) {
            CFRelease(_sampleBuffer);
            _sampleBuffer = NULL;
        }
        
        //参数sampleSizeArray
        const size_t sampleSizeArray[] = {mediaObj.length - iPos};
        
        //把解码前的视频图像存放在SampleBuffer中
        status = CMSampleBufferCreateReady(kCFAllocatorDefault,
                                           _blockBuffer,
                                           _decoderFormatDescription ,
                                           1, 0, NULL, 1, sampleSizeArray,
                                           &_sampleBuffer);
        
        //创建容器成功
        if (status == kCMBlockBufferNoErr && _sampleBuffer) {
            //硬解码参数
            VTDecodeFrameFlags flags = kVTDecodeFrame_1xRealTimePlayback;
            VTDecodeInfoFlags flagOut = 0;
            
            //开始解码
            OSStatus decodeStatus = VTDecompressionSessionDecodeFrame(_deocderSession,
                                                                      _sampleBuffer,
                                                                      flags,
                                                                      &outputPixelBuffer,
                                                                      &flagOut);
            
            if (decodeStatus != 0) {
                _waitKeyframe = YES;
                NSLog(@"开始解码失败:%d", (int)decodeStatus);//kVTInvalidSessionErr
            } else {
//                NSLog(@"开始解码成功");
            
            }
            
            _samplePhotoBuffer = _sampleBuffer;
            //释放sampleBuffer
            CFRelease(_sampleBuffer);
            _sampleBuffer = NULL;
            
        } else {
            NSLog(@"create sample buffer failed....");
        }
        
        //释放blockBuffer
        CFRelease(_blockBuffer);
        _blockBuffer = NULL;
    } else {
        NSLog(@"create block buffer failed....");
    }
   
    
    if (outputPixelBuffer && [_delegate respondsToSelector:@selector(didHardDecodePixelBuffer:SamplePhotoBuffer:forSessionID:mediaType:)]) {
        if ([_delegate didHardDecodePixelBuffer:outputPixelBuffer SamplePhotoBuffer:_samplePhotoBuffer forSessionID:_sessionID mediaType:_MediaType]) {
            CFRelease(outputPixelBuffer);
        }
    }
    
    
 // --------------------------------- 时间戳控制，解决画面卡顿的问题 -------------------------------------------
    //获取解码后结束的时间
     uint32_t endTime = (uint32_t)[[[WLSQXcloulink sharedManager] getDatetimeHaoMiaoString] integerValue];
    //获取解码所用时间差
     int sp = (int) (endTime - mediaObj.starTime);
    //获取队列个数
    NSInteger operationCount = _mediaQueue.validMediaCount;

    int needSleep = mediaObj.time - sp;
    unsigned short nFrameRate = 15;
    unsigned short nFrameTime = 5;
    unsigned short nFrameOfftime = 66;
    if (mediaObj.time > 0 && mediaObj.time< 1000)
    {
        nFrameRate = 1000/mediaObj.time;
        nFrameTime =mediaObj.time/nFrameRate;
        nFrameOfftime = mediaObj.time;
    }
//    NSLog(@"====睡眠时间:aab = %d  offtime = %d,taketime = %d,framerate = %d,\n",needSleep,mediaObj.time,sp,nFrameRate);
    
    if (needSleep > 0 && needSleep < 150) {
        
        
        /*if (operationCount < 3) {
         needSleep *= 0.9;
         
         } else */
        if (operationCount <3)
        {
            needSleep -= 0;
        }
        else if (operationCount < nFrameRate) {
            needSleep -= nFrameTime;
            
        } else if (operationCount < nFrameRate*2) {
            needSleep -= nFrameTime*2;
            
        } else if (operationCount < nFrameRate*3) {
            needSleep -= nFrameTime*3;
            
        }else if(operationCount < nFrameRate*4) {
            needSleep -= nFrameTime*4;
        }
        else {
            needSleep *= 0;
        }
        if (needSleep < 0 ) {
            usleep(nFrameOfftime * 1000);
//            NSLog(@"====睡眠时间1:%d,%ld,nFrameTime=%d",nFrameOfftime,(long)operationCount,nFrameTime);
        }
        else
        {
//            NSLog(@"====睡眠时间:%d,%ld nFrameTime = %d",needSleep,(long)operationCount,nFrameTime);
            usleep(needSleep * 1000);
        }

    }
    
//    //获取
//    int needSleep = mediaObj.time - sp;
//    
//    if (needSleep > 0 && needSleep < 150) {
//        
//        
//        /*if (operationCount < 3) {
//         needSleep *= 0.9;
//         
//         } else */if (operationCount < 15) {
//             needSleep *= 0.9;
//             
//         } else if (operationCount < 25) {
//             needSleep *= 0.7;
//             
//         } else if (operationCount < 50) {
//             needSleep *= 0.6;
//             
//         }  else {
//             needSleep *= 0;
//         }
//        //        NSLog(@"====睡眠时间:%d",needSleep * 10000);
//        usleep(needSleep * 1000);
//        
//        
//    }

    

//    NSLog(@"*************time:%u  starTime:%u endTime:%u 时间差:%d  睡眠时间:%d  队列个数:%ld  ",mediaObj.time,mediaObj.starTime,endTime,sp,needSleep,(long)operationCount);
    
}

-(void)relaseData:(uint8_t*) tmpData{
    if (NULL != tmpData)
    {
        free (tmpData);
        tmpData = NULL;
    }
}

- (void)procHardMediaPackege:(HWMediaObject *)mediaObj
{
    if(mediaObj == nil || mediaObj.length == 0) {
        return;
    }
    
    
    uint8_t *tempBuf = mediaObj.mediaData;
    int iPos = 0;
    for (int i = 0; i < mediaObj.length; ++i) {
        
        if (tempBuf[i] == 0x00 && tempBuf[i+1] == 0x00 && tempBuf[i+2] == 0x00 && tempBuf[i+3] == 0x01)
        {
            iPos = i;
            break;
        }
    }
    
    //nal的大小（字节），不包括起始00 00 00 01四个字节
    uint32_t nalSize = (uint32_t)(mediaObj.length - 4);
    
    //转换格式
    uint8_t *pNalSize = (uint8_t*)(&nalSize);
    
    //00 00 00 01 转换为数据的长度
    mediaObj.mediaData[0 + iPos] = *(pNalSize + 3 );
    mediaObj.mediaData[1 + iPos] = *(pNalSize + 2 );
    mediaObj.mediaData[2 + iPos] = *(pNalSize + 1 );
    mediaObj.mediaData[3 + iPos] = *(pNalSize );
    
//    printf("=====================0x%x 0x%x 0x%x 0x%x ====",*(pNalSize + 3 ),*(pNalSize + 2 ),*(pNalSize + 1 ),*(pNalSize + 0 ));


    //4-8位为nal单元类型
    int nalType = mediaObj.mediaData[4 + iPos]  & 0x1F;
//    char nal_Type = mediaObj.mediaData[4 + iPos];
//    NSLog(@"========nalType:%d  0x%x",nalType,nal_Type);
    switch (nalType) {
            
            //IDR：关键帧，刷新sps pps
        case 5:
//            NSLog(@"Nal type is IDR frame");
            if([self initH264Decoder]) {
                _waitKeyframe = NO;
                [self decode:mediaObj];
            }
            break;
            
            //sps
        case 7:
//            NSLog(@"Nal type is SPS");
            [self clearH264Deocder];
            _spsSize = mediaObj.length - 4 - iPos;
            _sps = (uint8_t *)malloc(_spsSize);
            memcpy(_sps, mediaObj.mediaData + 4 + iPos, _spsSize);
            break;
            
            //pps
        case 8:
//            NSLog(@"Nal type is PPS");
            _ppsSize = mediaObj.length - 4 - iPos;
            _pps = (uint8_t *)malloc(_ppsSize);
            memcpy(_pps, mediaObj.mediaData + 4 + iPos, _ppsSize);
            break;
            
            //都不是
        case 1:
//            NSLog(@"Nal type is B/P frame");
            
            [self decode:mediaObj];
            break;
        default:
            NSLog(@"Nal type is %d frame", nalType);
            break;
    }
    
}

/**
 *  将视频分辨率转换成实际的宽和高值
 *
 *  @param resolution 分辨率类型
 *  @param width      视频宽度
 *  @param height     视频高度
 */
- (void)convertResolution:(HWResolutionMode)resolution forWidth:(int *)width forHeight:(int *)height
{
    switch (resolution) {
        case HWResolutionMode_QQ720P:
            *width = 320;
            *height = 180;
            break;
        case HWResolutionMode_CIF:
            *width = 352;
            *height = 288;
            break;
        case HWResolutionMode_QVGA:
            *width = 320;
            *height = 240;
            break;
        case HWResolutionMode_Q720P:
            *width = 640;
            *height = 360;
            break;
        case HWResolutionMode_VGA:
            *width = 640;
            *height = 480;
            break;
        case HWResolutionMode_D1N:
            *width = 704;
            *height = 480;
            break;
        case HWResolutionMode_D1P:
            *width = 704;
            *height = 576;
            break;
        case HWResolutionMode_XGA:
            *width = 1024;
            *height = 768;
            break;
        case HWResolutionMode_720P:
            *width = 1280;
            *height = 720;
            break;
        case HWResolutionMode_SXGA:
            *width = 1280;
            *height = 1024;
            break;
        case HWResolutionMode_1080P:
        default:
            *width = 1920;
            *height = 1080;
            break;
    }
}

@end

