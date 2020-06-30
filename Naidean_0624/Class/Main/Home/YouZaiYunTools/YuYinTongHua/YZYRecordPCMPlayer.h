//
//  YZYRecordPCMPlayer.h
//  XcloudlinkDemo
//
//  Created by lijiang on 2017/7/3.
//  Copyright © 2017年 lijiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YZYRecordPCMPlayerDelegete <NSObject>

@optional
/**
 *	@brief	传递对讲语音数据给设备
 *
 *	@param 	audio 	uint8_t *
 *	@param 	length 	uint32_t
 */
- (void)sendSpeakerAudio:(uint8_t *)audio length:(uint32_t)length;


@end

@interface YZYRecordPCMPlayer : NSObject


- (id)initWithDelegete:(id<YZYRecordPCMPlayerDelegete>)delegete;

-(void)startSpeaking;//开始说

-(void)stopSpeaking;//结束说

-(void)starListening;//开始听

-(void)stopListening;//结束听

-(void)clearVC; //退出当前播放控制器一定要调用此方法

- (void)playListenAudio:(uint8_t *)audio length:(uint32_t)length;


@property (nonatomic,weak) id<YZYRecordPCMPlayerDelegete> delegate;

@end
