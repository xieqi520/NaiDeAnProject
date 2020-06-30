//
//  NewRecordVoice.m
//  Community
//
//  Created by lijiang on 17/1/13.
//  Copyright © 2017年 李江. All rights reserved.
//

#import "NewRecordVoice.h"
#import <AVFoundation/AVFoundation.h>

//新版录音
#define kNumberAudioQueueBuffers 3   //定义了三个缓冲区
#define kDefaultBufferDurationSeconds 0.04//调整这个值使得录音的缓冲区大小为640bytes
#define kDefaultSampleRate 8000   //定义采样率为8000

#define MAX_BUFFER_SIZE 8000 //

#define AUDIO_BUFFER_SIZE 640 //数据区大小


//录音
AudioStreamBasicDescription _audioFormat;
AudioQueueRef                   _inputQueue;
AudioQueueRef                   _outputQueue;
AudioQueueBufferRef     _inputBuffers[kNumberAudioQueueBuffers];
AudioQueueBufferRef     _outputBuffers[kNumberAudioQueueBuffers];

void *mPCMData;
NSCondition *mAudioLock;
int mDataLen;

BOOL _isRecording;//是否开启语音
BOOL _isSounding;//是否开启声音


@implementation NewRecordVoice

- (id)initWithDelegete:(id<NewRecordVoiceDelegete>)delegete
{
    self = [super init];
    if (self) {
        _delegate = delegete;
        _isRecording = NO;
        _isSounding = NO;
        
        [self initRecording];
    }
    return self;
    
}

NewRecordVoice *g_recordingVoice = nil;
#pragma mark - 私有方法
// 设置录音格式
- (void)setupAudioFormat:(UInt32) inFormatID SampleRate:(int)sampeleRate
{
    
    g_recordingVoice = (NewRecordVoice *)self;
    //重置下
    memset(&_audioFormat, 0, sizeof(_audioFormat));
    
    //设置采样率，这里先获取系统默认的测试下 //TODO:
    //采样率的意思是每秒需要采集的帧数
    _audioFormat.mSampleRate = sampeleRate;//[[AVAudioSession sharedInstance] sampleRate];
    
    //设置通道数,这里先使用系统的测试下 //TODO:
    _audioFormat.mChannelsPerFrame = 1;//(UInt32)[[AVAudioSession sharedInstance] inputNumberOfChannels];
    
    //设置format，怎么称呼不知道。
    _audioFormat.mFormatID = inFormatID;
    
    if (inFormatID == kAudioFormatLinearPCM){
        //这个屌属性不知道干啥的。，
        _audioFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
        //每个通道里，一帧采集的bit数目
        _audioFormat.mBitsPerChannel = 16;
        //结果分析: 8bit为1byte，即为1个通道里1帧需要采集2byte数据，再*通道数，即为所有通道采集的byte数目。
        //所以这里结果赋值给每帧需要采集的byte数目，然后这里的packet也等于一帧的数据。
        //至于为什么要这样。。。不知道。。。
        _audioFormat.mBytesPerPacket = _audioFormat.mBytesPerFrame = (_audioFormat.mBitsPerChannel / 8) * _audioFormat.mChannelsPerFrame;
        _audioFormat.mFramesPerPacket = 1;
    }
}

//初始化会话
- (void)initSession
{
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;         //可在后台播放声音
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;  //设置成话筒模式
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                             sizeof (audioRouteOverride),
                             &audioRouteOverride);
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //默认情况下扬声器播放
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
}


//录音回调
void GenericInputCallback (
                           void                                *inUserData,
                           AudioQueueRef                       inAQ,
                           AudioQueueBufferRef                 inBuffer,
                           const AudioTimeStamp                *inStartTime,
                           UInt32                              inNumberPackets,
                           const AudioStreamPacketDescription  *inPacketDescs
                           )
{
    
    if (inNumberPackets > 0) {
        NSData *pcmData = [[NSData alloc] initWithBytes:inBuffer->mAudioData length:inBuffer->mAudioDataByteSize];
        //pcm数据不为空时
        if (pcmData && pcmData.length > 0 && _isRecording) {
            
            uint8_t *cipherBuffer = (uint8_t*)[pcmData bytes];
            if ([g_recordingVoice.delegate respondsToSelector:@selector(sendRecorddata:leng:)]) {
           
                [g_recordingVoice.delegate sendRecorddata:cipherBuffer leng:(unsigned int)pcmData.length];
            
            }
            
            
        }
        
    }
    AudioQueueEnqueueBuffer (inAQ,inBuffer,0,NULL);
    
}

// 输出回调
void GenericOutputCallback (
                            void                 *inUserData,
                            AudioQueueRef        inAQ,
                            AudioQueueBufferRef  inBuffer
                            )
{
    BOOL isFull = NO;
    if( mDataLen >=  AUDIO_BUFFER_SIZE)
    {
        [mAudioLock lock];
        memcpy(inBuffer->mAudioData, mPCMData, AUDIO_BUFFER_SIZE);
        mDataLen -= AUDIO_BUFFER_SIZE;
        memmove(mPCMData, mPCMData+AUDIO_BUFFER_SIZE, mDataLen);
        [mAudioLock unlock];
        isFull = YES;
    }
    
    if (!isFull) {
        memset(inBuffer->mAudioData, 0, AUDIO_BUFFER_SIZE);
    }
    
    inBuffer->mAudioDataByteSize = AUDIO_BUFFER_SIZE;
    AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
}

-(void)initRecording
{

    mPCMData = malloc(MAX_BUFFER_SIZE);
    mAudioLock = [[NSCondition alloc]init];
    
    //设置录音的参数
    [self setupAudioFormat:kAudioFormatLinearPCM SampleRate:kDefaultSampleRate];
    _audioFormat.mSampleRate = kDefaultSampleRate;//设置采样率，8000hz
    
    //创建一个录制音频队列
    AudioQueueNewInput (&(_audioFormat),GenericInputCallback,(__bridge void *)self,NULL,NULL,0,&_inputQueue);
    //创建一个输出队列
    AudioQueueNewOutput(&_audioFormat, GenericOutputCallback, (__bridge void *) self, NULL, NULL, 0,&_outputQueue);
    //设置话筒属性等
    [self initSession];
    
    NSError *error = nil;
    //设置audioSession格式 录音播放模式
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;  //设置成话筒模式
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                             sizeof (audioRouteOverride),
                             &audioRouteOverride);
    
    //计算估算的缓存区大小
    int frames = (int)ceil(kDefaultBufferDurationSeconds * _audioFormat.mSampleRate);//返回大于或者等于指定表达式的最小整数
    int bufferByteSize = frames * _audioFormat.mBytesPerFrame;//缓冲区大小在这里设置，这个很重要，在这里设置的缓冲区有多大，那么在回调函数的时候得到的inbuffer的大小就是多大。
    NSLog(@"缓冲区大小:%d",bufferByteSize);
    
    //创建录制音频队列缓冲区
    for (int i = 0; i < kNumberAudioQueueBuffers; i++) {
        AudioQueueAllocateBuffer (_inputQueue,bufferByteSize,&_inputBuffers[i]);
        
        AudioQueueEnqueueBuffer (_inputQueue,(_inputBuffers[i]),0,NULL);
    }
    
    //创建播放并分配缓冲区空间 3个缓冲区
    for(int i=0;i<kNumberAudioQueueBuffers;i++)
    {
        
        AudioQueueAllocateBuffer(_outputQueue, AUDIO_BUFFER_SIZE, &_outputBuffers[i]);
        memset(_outputBuffers[i]->mAudioData, 0, AUDIO_BUFFER_SIZE);
        _outputBuffers[i]->mAudioDataByteSize = AUDIO_BUFFER_SIZE;
        AudioQueueEnqueueBuffer(_outputQueue, _outputBuffers[i], 0, NULL);
    }
    
    Float32 gain = 1.0;                                       // 1
    // Optionally, allow user to override gain setting here 设置音量
    AudioQueueSetParameter (_outputQueue,kAudioQueueParam_Volume,gain);
    
    //开启录制队列
    AudioQueueStart(self.inputQueue, NULL);
    //开启播放队列
    AudioQueueStart(self.outputQueue,NULL);
    
    
}

////把缓冲区置空
//void makeSilent(AudioQueueBufferRef buffer)
//{
//    if (buffer != nil) {
//
//        for (int i=0; i < buffer->mAudioDataBytesCapacity; i++) {
//            buffer->mAudioDataByteSize = buffer->mAudioDataBytesCapacity;
//            UInt8 * samples = (UInt8 *) buffer->mAudioData;
//            samples[i]=0;
//        }
//    }
//
//}

-(void)clearVC
{

    
    AudioQueueStop(_inputQueue, true);
    AudioQueueStop(_outputQueue, true);
    AudioQueueDispose(_inputQueue, YES);
    AudioQueueDispose(_outputQueue, YES);
    
    for (int i = 0; i < kNumberAudioQueueBuffers; i++) {
        AudioQueueFreeBuffer(_outputQueue, _outputBuffers[i]);
    }
    free(mPCMData);
    mPCMData = nil;
    _outputQueue = nil;
    mAudioLock = nil;
}

-(void)playSound:(NSData *)data
{
    
    if (!_isSounding) {
        return;
    }
    
    [mAudioLock lock];
    int len = (int)[data length];
    if (len > 0 && len + mDataLen < MAX_BUFFER_SIZE) {
        memcpy(mPCMData+mDataLen, [data bytes],[data length]);
        mDataLen += AUDIO_BUFFER_SIZE;
    }
    [mAudioLock unlock];
    
    
}

-(void)startRecording//开始语音
{
    
    _isRecording = YES;
}
-(void)stopRecording//结束语音
{
    _isRecording = NO;
}
-(void)starSounding//开始声音
{
    
    _isSounding = YES;
}
-(void)stopSounding//结束声音
{
    _isSounding = NO;
}


@end
