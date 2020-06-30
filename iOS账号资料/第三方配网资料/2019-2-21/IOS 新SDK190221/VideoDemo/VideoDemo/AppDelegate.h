//
//  AppDelegate.h
//  VideoDemo
//
//  Created by zhaogenghuai on 2018/12/24.
//  Copyright © 2018年 zhaogenghuai. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(int)SHIX_StartConnect:(NSString *)did USER:(NSString *)user PWD:(NSString *)pwd;
-(int)SHIX_DevStatus:(NSString *)did PRO:(id)delegate;
-(int)SHIX_Video:(NSString *)did PRO:(id)delegate;
-(int)SHIX_StopVideo:(NSString *)did;

-(int)SHIX_StartAudio:(NSString *)did;
-(int)SHIX_StopAudio:(NSString *)did;

-(int)SHIX_StartTalk:(NSString *)did;
-(int)SHIX_StopTalk:(NSString *)did;

-(int)SHIX_TansPro:(NSString *)did PRO:(id)delegate;
-(int)SHIX_SendTrans:(NSString *)did SEND:(NSString *)str;

-(int)SHIX_WillEchoData:(NSString *)did LEN:(int)len Data:(void *)data;
-(int)SHIX_EchoData:(NSString *)did Data:(const char *)data Len:(int)len;



@end

