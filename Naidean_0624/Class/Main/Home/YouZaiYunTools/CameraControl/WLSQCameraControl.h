//
//  WLSQCameraControl.h
//  Community
//
//  Created by lijiang on 16/7/7.
//  Copyright © 2016年 李江. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"
#import "WLSQXcloulink.h"



/*
 摄像头基础控制类型
 */
typedef NS_ENUM(NSInteger, YZYCameraControlType)
{
    
    YZYCameraControlTypePTZLeft,//云台向左
    YZYCameraControlTypePTZRight,//云台向右
    YZYCameraControlTypePTZUp,//云台向上
    YZYCameraControlTypePTZDown,//云台向下
    
    YZYCameraControlTypePTZAllCruise,//云台全方位巡航与停止
    YZYCameraControlTypelFlip,//翻转
    
    YZYCameraControlTypeHighdefinition,//高清
    YZYCameraControlTypeFluent,//流畅
    YZYCameraControlTypeQualize,//均衡
    
    YZYCameraControlTypeRestart,//设备重启
    YZYCameraControlTypeRestoreSettings,//恢复出厂设置
    YZYCameraControlTypeEquipmentBasicInformation,//设备基本信息
    YZYCameraControlTypeIFBasicInformation,//App获取存储TF信息
    YZYCameraControlTypeEquipmenUpdate,//更新升级
    
    YZYCameraControlTypeTFStorageOn,//TF卡存储开
    YZYCameraControlTypeTFStorageOff,//TF卡存储关
    YZYCameraControlTypeTFStorageClear,//TF卡格式化
    
    YZYCameraControlTypeUpEquipmenTime,//更新设备时间
    YZYCameraControlTypeLoadSubEquipmen,//加载子设备
    
    YZYCameraControlTyAroundWifi,//获取设备周边可连接wifi

    
};


/*
 摄像头移动侦测
 */
typedef NS_ENUM(NSInteger, YZYMotionDetectionType)
{
    
    YZYMotionDetectionTypeHight,//移动侦测灵敏度高
    YZYMotionDetectionTypeMiddle,//移动侦测灵敏度中
    YZYMotionDetectionTypeLow,//移动侦测灵敏度低
    YZYMotionDetectionTypeOff,//关闭移动侦测
};

/*
 摄像头预制位
 */
typedef NS_ENUM(NSInteger, YZYCameraControlPresetbit)
{
    
    YZYCameraControlPresetbit_set,//设置预制位
    YZYCameraControlPresetbit_get,//查看预制位位置
 
};


@interface WLSQCameraControl : NSObject





/**
 摄像头控制
 
 @param nSID 目标设备ID
 @param device_type 目标设备类型
 @return
 */
- (id)initWithnSID:(NSString *)nSID device_type:(NSString *)device_type;

#pragma mark - 摄像机基础控制
/**
 *	@brief	摄像机云台、巡航、高清..
 *
 *	@param 	type 	YZYCameraControlType
 *  return  YES : NO;
 */
- (BOOL)cameraBasicControl:(YZYCameraControlType)type;


#pragma mark - 获取TF卡录像列表
/**
 获取TF卡录像列表
 
 @param start_datetime 开始时间  (2017-04-05 00:00:00 转换格式 20170405000000)
 @param end_datetime 结束时间    (2017-04-05 23:59:59 转换格式 20170405235959)
 @param page_size 每页个数
 @param page 页数
 @return  YES : NO;
 */
- (BOOL)cameraSDlistWithstart_datetime:(NSString *)start_datetime
                          end_datetime:(NSString *)end_datetime
                             page_size:(NSInteger)page_size
                                  page:(NSInteger)page;


#pragma mark - 移动侦测
/**
 移动侦测
 
 @param type 移动侦测类型
 @return YES : NO;
 */
- (BOOL)cameraMotionDetection:(YZYMotionDetectionType)type;


#pragma mark - 设置预置位
/**
 设置预置位

 @param type 设置或者查看
 @param number 位置索引
 @return YES : NO;
 */
- (BOOL)cameraPresetbitType:(YZYCameraControlPresetbit)type number:(int)number;


#pragma mark - 修改设备密码
/**
 修改设备密码

 @param accesspassword 密码
 @return YES : NO;
 */
- (BOOL)cameraChanceOldpassword:(NSString *)oldpassword Accesspassword:(NSString *)password;


#pragma mark - 把WiFi账号密码传给设备
/**
把WiFi账号密码传给设备

 @param ssid WiFi账号
 @param pwd WiFi密码
@return YES : NO;
 */
- (BOOL)cameraConnectWifissid:(NSString *)ssid ssidPwd:(NSString *)pwd;

@end
