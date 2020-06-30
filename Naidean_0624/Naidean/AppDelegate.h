//
//  AppDelegate.h
//  Naidean
//
//  Created by xujun on 2018/1/3.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//




//信鸽账号：13510176618
//信鸽密码：naidean8699



#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,WLSQXcloulinkNetWorkStateDelegate>

@property (strong, nonatomic) UIWindow *window;

-(int)SHIX_StartConnect:(NSString *)did USER:(NSString *)user PWD:(NSString *)pwd;
-(int)SHIX_StoptConnect:(NSString *)did;
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
-(int)SHIX_Snapshot:(NSString *)did;
//设备别名
- (void) setTags:(NSString *) alias;
-(int)SHIX_StopAll;

-(int)SHIX_Heart:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd;
@end

