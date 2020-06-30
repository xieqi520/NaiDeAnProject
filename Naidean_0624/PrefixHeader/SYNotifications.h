//
//  SYNotifications.h
//  SYSmartEnergySystem
//
//  Created by Zoe on 2017/11/22.
//  Copyright © 2017年 zoe. All rights reserved.
//

#ifndef SYNotifications_h
#define SYNotifications_h

// 发送通知
#define kSendNotification(key,obj) [[NSNotificationCenter defaultCenter] postNotificationName:key object:obj];
// 接收通知
#define kReciveNotification(action,key,obj) [[NSNotificationCenter defaultCenter] addObserver:self selector:action name:key object:obj];
// 取消通知
#define kCancelNotification(key,obj) [[NSNotificationCenter defaultCenter] removeObserver:self name:key object:obj];
// 取消所有通知
#define kCancelALLNotification     [[NSNotificationCenter defaultCenter] removeObserver:self];

#define kNotification_TimeOut_Login    @"TimeOut_Login_Noti"
//蓝牙
static NSString * const k_SY_BLE_DID_CONNECT         = @"k_SY_BLE_DID_CONNECT";
static NSString * const k_SY_BLE_DID_BREAK           = @"k_SY_BLE_DID_BREAK";
static NSString * const k_SY_BLE_STATE_CHANGED       = @"k_SY_BLE_STATE_CHANGED";
static NSString * const k_SY_BLE_DID_DISCOVER_DEVICE = @"k_SY_BLE_DID_DISCOVER_DEVICE";
static NSString * const k_SY_BLE_CONNECT_FAIL        = @"k_SY_BLE_CONNECT_FAIL";
static NSString * const k_SY_BLE_DID_UPDATE_DATA     = @"k_SY_BLE_DID_UPDATE_DATA";
//设备
static NSString * const k_SY_DEVICE_DID_OPEN         = @"k_SY_DEVICE_DID_OPEN";  //开锁成功
static NSString * const k_SY_DEVICE_PASSWORD_UPDATE  = @"k_SY_DEVICE_PASSWORD_UPDATE";  //获取秘钥成功

#define TimeOutCode  2001   //超时码
#endif /* SYNotifications_h */
