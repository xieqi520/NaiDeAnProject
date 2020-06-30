//
//  SYPPPPTools.h
//  Naidean
//
//  Created by aoxin1 on 2020/6/24.
//  Copyright © 2020 com.saiyikeji. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYPPPPTools : NSObject
+(SYPPPPTools*)share;
-(int)SHIX_startP2P:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd;
-(int)SHIX_Heart:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd;
-(int)SHIX_stopP2P:(NSString *)did;
-(int)SHIX_StartPPPPLivestream:(NSString *)did Delegate:(id)delegate;
-(int)SHIX_StopPPPPLivestream:(NSString *)did;
-(int)SHIX_StartPPPPAudio:(NSString *)did;
-(int)SHIX_StopPPPPAudio:(NSString *)did;
-(int)SHIX_StartPPPPTalk:(NSString *)did;
-(int)SHIX_EchoData:(NSString *)did Data:(const char *)data Len:(int)len;
-(int)SHIX_StopPPPPTalk:(NSString *)did;
-(int)SHIX_TansPro:(NSString *)did PRO:(id)delegate;
-(int)SHIX_SendTrans:(NSString *)did SEND:(NSString *)str;
-(int)SHIX_DevStatus:(NSString *)did PRO:(id)delegate;
@end

NS_ASSUME_NONNULL_END
