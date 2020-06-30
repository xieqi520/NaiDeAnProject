//
//  SHIXCommonProtocol.h
//  icbbell
//
//  Created by zhaogenghuai on 2018/12/18.
//  Copyright © 2018年 zhaogenghuai. All rights reserved.
//

#ifndef SHIXCommonProtocol_h
#define SHIXCommonProtocol_h
#import <Foundation/Foundation.h>

//msgtype
#define SHIX_MSG_NOTIFY_TYPE_PPPP_STATUS 0   /*P2P连接状态 */
#define SHIX_MSG_NOTIFY_TYPE_PPPP_MODE 1   /* P2P模式 */


#define SHIX_PPPP_STATUS_CONNECTING 0 /* 连接中 */
#define SHIX_PPPP_STATUS_INITIALING 1 /* 未初始化 */
#define SHIX_PPPP_STATUS_ON_LINE 2 /* 在线 */
#define SHIX_PPPP_STATUS_CONNECT_FAILED 3 /* 连接失败 */
#define SHIX_PPPP_STATUS_DISCONNECT 4 /*断线，等待连接*/
#define SHIX_PPPP_STATUS_INVALID_ID 5 /* 无效ID*/
#define SHIX_PPPP_STATUS_DEVICE_NOT_ON_LINE 6/* 设备不在线*/
#define SHIX_PPPP_STATUS_CONNECT_TIMEOUT 7 /* 连接超时 */
#define SHIX_PPPP_STATUS_INVALID_USER_PWD 8 /* 用户或密码错误 */
#define SHIX_PPPP_STATUS_USER_LOGIN 9 /* 其它用户已连接 */
#define SHIX_PPPP_STATUS_PWD_CUO 10 /* 用户或密码错误 */
#define SHIX_PPPP_STATUS_UNKNOWN 0xffffff /* 未知状态 */

@protocol SHIXCommonProtocol <NSObject>
@optional

#pragma mark--  摄像机状态回调
- (void) PPPPStatus: (NSString*)strDID
         statusType:(NSInteger)statusType
             status:(NSInteger) status;

#pragma mark--  解码后的数据回调
- (void) YUVNotify: (Byte*) yuv
            length:(int)length
             width: (int) width
            height:(int)height
         timestamp:(unsigned int)timestamp
               DID:(NSString *)did;

#pragma mark--  原始数据回调
- (void) H264Data: (Byte*) h264Frame
           length: (int) length
             type: (int) type
        timestamp: (NSInteger) timestamp
              DID:(NSString *)did;


#pragma mark--音频数据回调  PCM
-(void)AudioDataBack:(Byte*)data
              Length:(int)len
              DID:(NSString *)did;

#pragma mark--  透传数据回调
- (void) JsonData: (NSString *) json
               DID:(NSString *)did;

#pragma mark--  局域网搜索设备回调
- (void) SearchCameraResult:(NSString *)mac Name:(NSString *)name Addr:(NSString *)addr Port:(NSString *)port DID:(NSString*)did;

@end

#endif /* SHIXCommonProtocol_h */
