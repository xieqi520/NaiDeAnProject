//
//  NewRecordVoice.h
//  Community
//
//  Created by lijiang on 17/1/13.
//  Copyright © 2017年 李江. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@protocol NewRecordVoiceDelegete <NSObject>

- (void)sendRecorddata:(uint8_t *)data leng:(int)leng;

@end

@interface NewRecordVoice : NSObject

@property (nonatomic,weak) id<NewRecordVoiceDelegete> delegate;

@property (assign, nonatomic) AudioQueueRef                 inputQueue;
@property (assign, nonatomic) AudioQueueRef                 outputQueue;


- (id)initWithDelegete:(id<NewRecordVoiceDelegete>)delegete;

-(void)startRecording;//开始语音

-(void)stopRecording;//结束语音

-(void)starSounding;//开始声音

-(void)stopSounding;//结束声音

-(void)playSound:(NSData *)data;//传入声音数据

-(void)clearVC; //退出当前播放控制器一定要调用此方法

@end
