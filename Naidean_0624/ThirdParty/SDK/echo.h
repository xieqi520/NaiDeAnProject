//
//  echo.h
//  echo
//
//  Created by zhaogenghuai on 16/7/26.
//  Copyright © 2016年 zhaogenghuai. All rights reserved.
//

//#ifndef echo_H
//#define echo_H

#import <Foundation/Foundation.h>


@protocol  EchoDelegate<NSObject>
-(void)EchoData:(const char *)data Len:(int)len;
-(int)WillEchoData:(int)len Data:(void *)data;
@end
@interface echo : NSObject
@property(nonatomic,assign) id<EchoDelegate> echoDelegate;



- (id)initWithContext:(id)deletage PCMBufferSize:(int)size LOG:(BOOL)islog;
-(int)writePcmToBuffer:(void* ) buf Size:(int) size;



- (id)initWithContext:(id)deletage LOG:(BOOL)islog;

-(int)initEcho;
-(int)unInitEcho;

- (int) startEcho:(int)controlType;
- (int) startEcho;
-(void) stopEcho;

-(void)ControlAudioType:(int)type;

+(int) process_v16:(short *)pindata LEN:(long )nlen TYPE:(int) type;

@end

//#endif

