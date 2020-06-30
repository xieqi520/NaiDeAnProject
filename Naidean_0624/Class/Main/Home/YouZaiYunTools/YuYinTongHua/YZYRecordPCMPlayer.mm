//
//  YZYRecordPCMPlayer.m
//  XcloudlinkDemo
//
//  Created by lijiang on 2017/7/3.
//  Copyright © 2017年 lijiang. All rights reserved.
//

#import "YZYRecordPCMPlayer.h"
#import "CocoaPCMPlayer.h"
#import "AudioRecordController.h"

@implementation YZYRecordPCMPlayer

BOOL _isSpeaking;//是否开启语音
BOOL _isListening;//是否开启声音

CocoaPCMPlayer *_thePCMPlayer; //听
AudioRecordController _recordControl;//

- (id)initWithDelegete:(id<YZYRecordPCMPlayerDelegete>)delegete
{
    self = [super init];
    if (self) {
        
        _delegate = delegete;
        
        _isSpeaking = NO;
        _isListening = NO;
    
        //初始化听
        _thePCMPlayer = [[CocoaPCMPlayer alloc] initWithFrameSize:8192 * 2];
    
    }
    return self;
    
}

// ---------------------------------------- 说 ----------------------------------------------

/**
 *	@brief	说话到设备的回调函数
 *
 *	@param 	userData 	SurveillanceDevice *
 *	@param 	samplesBuffer 	音频数据，格式为PCM
 *	@param 	bufferSize 	音频大小
 */
static void recodeCallbackFunc(void *userData, uint8_t *samplesBuffer, uint32_t bufferSize)
{
    //NSLog(@"bufferSize:%d",bufferSize);
    YZYRecordPCMPlayer *controller = (__bridge YZYRecordPCMPlayer *)userData;
    [controller sendSpeakerAudio:samplesBuffer bufferSize:bufferSize];
    
}

- (void)sendSpeakerAudio:(uint8_t *)sampleBuffer bufferSize:(uint32_t)size
{
    if ([_delegate respondsToSelector:@selector(sendSpeakerAudio:length:)]) {
     
        if (_isSpeaking) {
            
            [_delegate sendSpeakerAudio:sampleBuffer length:size];
        
        }
       
    }
}

- (BOOL)openAudioSpeaker:(BOOL)bOpen
{
    if (bOpen) {
        //开启麦克风
        return _recordControl.start(recodeCallbackFunc, (__bridge void *)self) >= 0;
    } else {
        //关闭麦克风
        _recordControl.stop();
        return YES;
    }
}


// ---------------------------------------- 听 ----------------------------------------------

//打开手机扬声器
-(void)hk_Speaker:(bool)bOpen
{
    UInt32 route;
    OSStatus error;
    UInt32 sessionCategory = kAudioSessionCategory_PlayAndRecord;
    
    error = AudioSessionSetProperty (
                                     kAudioSessionProperty_AudioCategory,
                                     sizeof (sessionCategory),
                                     &sessionCategory
                                     );
    
    route = bOpen?kAudioSessionOverrideAudioRoute_Speaker:kAudioSessionOverrideAudioRoute_None;
    error = AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(route), &route);
    
}

- (void)playListenAudio:(uint8_t *)audio length:(uint32_t)length
{
    if (_isListening) {
        
        [_thePCMPlayer feed:audio length:length];
    }
    
}

-(void)startSpeaking//开始说
{
    _isSpeaking = YES;
    
    [self openAudioSpeaker:_isSpeaking];
}
-(void)stopSpeaking//结束说
{
    _isSpeaking = NO;
    
    [self openAudioSpeaker:_isSpeaking];
}
-(void)starListening//开始听
{
    
    _isListening = YES;
    
    [self hk_Speaker:_isListening];
}
-(void)stopListening//结束听
{
    _isListening = NO;
    
    [self hk_Speaker:_isListening];
    
}

-(void)clearVC//退出当前播放控制器一定要调用此方法
{
      _isListening = NO;
      _isSpeaking = NO;
      [self hk_Speaker:_isListening];
      [self openAudioSpeaker:_isSpeaking];
}

@end
