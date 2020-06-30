//
//  WLSQCameraControl.m
//  Community
//
//  Created by lijiang on 16/7/7.
//  Copyright © 2016年 李江. All rights reserved.
//

#import "WLSQCameraControl.h"


NSString *_deviceID;
NSString *_device_type;

@implementation WLSQCameraControl

- (id)initWithnSID:(NSString *)nSID device_type:(NSString *)device_type;
{
    self = [super init];
    if (self) {
        _deviceID = nSID;
        _device_type = device_type;
    }
    return self;
}

/**
 *	@brief	摄像机云台、巡航、高清..
 *
 *	@param 	type 	YZYCameraControlType
 */
- (BOOL)cameraBasicControl:(YZYCameraControlType)type;
{
    
    
    NSString *cmd_type;
    
    id type_code;
    
    NSString *msg_type;
    
    
    if (type == YZYCameraControlTypePTZAllCruise) {
        
        cmd_type = @"ptz_control";
        type_code = @{@"ptz_direction":@"cruise"};
        msg_type = @"set";
        
        
    }
    
    if (type == YZYCameraControlTypePTZLeft) {
        
        cmd_type = @"ptz_control";
        type_code = @{@"ptz_direction":@"left"};
        msg_type = @"set";
    }
    
    if (type == YZYCameraControlTypePTZRight) {
        
        cmd_type = @"ptz_control";
        type_code = @{@"ptz_direction":@"right"};
        msg_type = @"set";
    }
    
    if (type == YZYCameraControlTypePTZUp) {
        
        cmd_type = @"ptz_control";
        type_code = @{@"ptz_direction":@"up"};
        msg_type = @"set";
    }
    
    if (type == YZYCameraControlTypePTZDown) {
        
        cmd_type = @"ptz_control";
        type_code = @{@"ptz_direction":@"down"};
        msg_type = @"set";
    }
    
    if(type == YZYCameraControlTypeHighdefinition)
    {
        
        cmd_type = @"definition";
        type_code = @{@"mode":@"high"};
        msg_type = @"set";
        
    }
    
    if(type == YZYCameraControlTypeFluent)
    {
        
        cmd_type = @"definition";
        type_code = @{@"mode":@"fluent"};
        msg_type = @"set";
        
    }
    
    if(type == YZYCameraControlTypeQualize)
    {
        
        cmd_type = @"definition";
        type_code = @{@"mode":@"qualize"};
        msg_type = @"set";
        
    }
    
    if(type == YZYCameraControlTypelFlip)
    {
        
        cmd_type = @"picture_inversion";
        type_code = @{@"":@""};
        msg_type = @"set";
        
    }
    
    if(type == YZYCameraControlTypeRestart)
    {
        
        cmd_type = @"device_restart";
        type_code = @{@"":@""};
        msg_type = @"get";
        
    }
    
    if(type == YZYCameraControlTypeRestoreSettings)
    {
        
        cmd_type = @"restore_settings";
        type_code = @"";
        msg_type = @"get";
        
    }
    
    if(type == YZYCameraControlTypeEquipmentBasicInformation)
    {
        
        cmd_type = @"get_attribute";
        type_code = @"";
        msg_type = @"get";
        
        
        
    }
    
    if(type == YZYCameraControlTypeIFBasicInformation)
    {
        
        cmd_type = @"storage";
        type_code = @"";
        msg_type = @"get";
        
    }
    
    
    
    if(type == YZYCameraControlTypeTFStorageOff)
    {
        
        cmd_type = @"storage_set";
        type_code = @"stoprec";
        msg_type = @"set";
        
    }
    
    if(type == YZYCameraControlTypeTFStorageOn)
    {
        
        cmd_type = @"storage_set";
        type_code = @"startrec";
        msg_type = @"set";
        
    }
    
    if(type == YZYCameraControlTypeTFStorageClear)
    {
        
        cmd_type = @"storage_set";
        type_code = @"clear";
        msg_type = @"set";
        
    }
    
    
    
    if(type == YZYCameraControlTypeEquipmenUpdate)
    {
        
        cmd_type = @"device_update";
        type_code = @"";
        msg_type = @"set";
        
    }
    
    if(type == YZYCameraControlTypeUpEquipmenTime)
    {
        
        //获取夏令时
        NSTimeZone *stZone = [NSTimeZone systemTimeZone];
        BOOL isDST = [stZone isDaylightSavingTime];
        
        //获取当前时区
        NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone] ;///获取当前时区信息
        NSInteger sourceGMTOffset = ([destinationTimeZone secondsFromGMTForDate:[NSDate date]] -  (isDST == YES ? 3600 : 0));///获取偏移秒数
        NSInteger  localTimeZone = sourceGMTOffset/3600;
        NSString *localTimeZoneString = [NSString stringWithFormat:@"%@",localTimeZone > 0 ? [NSString stringWithFormat:@"+%zd",localTimeZone] : [NSString stringWithFormat:@"%zd",localTimeZone]];
        NSLog(@"系统的时区 = %@",localTimeZoneString);///除以3600即可获取小时数，即为当前时区
        
        NSDictionary *dic = @{
                              @"timestamp":[[WLSQXcloulink sharedManager] getDatetimeString],
                              @"timezone":localTimeZoneString,
                              @"dst":isDST == YES ? @"on" : @"off"
                              };
        
        cmd_type = @"device_time";
        type_code = dic;
        msg_type = @"set";
        
    }
    
    if(type == YZYCameraControlTypeLoadSubEquipmen)
    {
        
        cmd_type = @"device_list";
        type_code = @{@"":@""};
        msg_type = @"get";
        
    }
    
    if(type == YZYCameraControlTyAroundWifi)
    {
        
        cmd_type = @"around_wifi";
        type_code = @{@"":@""};
        msg_type = @"get";
        
    }
    

    
    NSDictionary *servicesDic = @{cmd_type:type_code};
    
    NSDictionary *devices = @{@"device_id":_deviceID,
                              @"device_type":@([_device_type integerValue]),
                              @"services":servicesDic};
    NSArray *array = @[devices];
    
    NSDictionary *dict = @{@"msg_id":@([[[WLSQXcloulink sharedManager] getDatetimeString] integerValue]),
                           @"msg_type":msg_type,
                           @"device_id":_deviceID,
                           @"device_type":@([_device_type integerValue]),
                           @"devices":array};
    
    NSString *str = [dict JSONString];
    
    int booltype =  CDK_PostXMessage((char *)_deviceID.UTF8String, 0, (char *)str.UTF8String);
    return booltype >= 0 ? YES : NO;
}

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
                                  page:(NSInteger)page
{
    
    NSDictionary *get_video_recordDIC = @{@"start_datetime":start_datetime,
                                          @"end_datetime":end_datetime,
                                          @"page_size":@(page_size),
                                          @"page":@(page)
                                          };
    NSDictionary *servicesDic = @{@"get_video_record":get_video_recordDIC};
    
    
    NSDictionary *devices = @{@"device_id":_deviceID,
                              @"device_type":@([_device_type integerValue]),
                              @"services":servicesDic
                              };
    
    NSArray *array = @[devices];
    
    NSDictionary *dic = @{@"msg_id":@([[[WLSQXcloulink sharedManager] getDatetimeString] integerValue]),
                          @"msg_type":@"get",
                          @"device_id":_deviceID,
                          @"device_type":@([_device_type integerValue]),
                          @"devices":array
                          };
    
    NSString *str = [dic JSONString];
    
    int type =  CDK_PostXMessage((char *)_deviceID.UTF8String, 0, (char *)str.UTF8String);
    
    return  type >= 0 ? YES : NO;
    
}


/**
 移动侦测
 
 @param type 移动侦测类型
 @return YES : NO;
 */

- (BOOL)cameraMotionDetection:(YZYMotionDetectionType)type
{
    
    
    NSString *cmd_type;
    
    id type_code;
    
    NSString *msg_type;
    
    
    if (type == YZYMotionDetectionTypeHight) {
        
        cmd_type = @"motion_detection";
        type_code = @{@"on_off":@(3)};
        msg_type = @"set";
        
    }
    
    if (type == YZYMotionDetectionTypeMiddle) {
        
        cmd_type = @"motion_detection";
        type_code = @{@"on_off":@(2)};
        msg_type = @"set";
    }
    
    if (type == YZYMotionDetectionTypeLow) {
        
        cmd_type = @"motion_detection";
        type_code = @{@"on_off":@(1)};
        msg_type = @"set";
    }
    
    if (type == YZYMotionDetectionTypeOff) {
        
        cmd_type = @"motion_detection";
        type_code = @{@"on_off":@(0)};
        msg_type = @"set";
    }
    
    
    NSDictionary *servicesDic = @{cmd_type:type_code};
    
    NSDictionary *devices = @{@"device_id":_deviceID,
                              @"device_type":@([_device_type integerValue]),
                              @"services":servicesDic};
    NSArray *array = @[devices];
    
    NSDictionary *dict = @{@"msg_id":@([[[WLSQXcloulink sharedManager] getDatetimeString] integerValue]),
                           @"msg_type":msg_type,
                           @"device_id":_deviceID,
                           @"device_type":@([_device_type integerValue]),
                           @"devices":array};
    
    NSString *str = [dict JSONString];
    
    int booltype =  CDK_PostXMessage((char *)_deviceID.UTF8String, 0, (char *)str.UTF8String);
    return booltype >= 0 ? YES : NO;
    
    
}

/**
 设置预置位
 
 @param type 设置或者查看
 @param number 位置索引
 @return YES : NO;
 */
- (BOOL)cameraPresetbitType:(YZYCameraControlPresetbit)type number:(int)number;
{

    
    NSDictionary *servicesDic = @{@"preset_bit":@{@"preset_bit_number":@(number)}};
    
    NSDictionary *devices = @{@"device_id":_deviceID,
                              @"device_type":@([_device_type integerValue]),
                              @"services":servicesDic};
    NSArray *array = @[devices];
    
    NSDictionary *dict = @{@"msg_id":@([[[WLSQXcloulink sharedManager] getDatetimeString] integerValue]),
                           @"msg_type":type == YZYCameraControlPresetbit_get ? @"get" : @"set",
                           @"device_id":_deviceID,
                           @"device_type":@([_device_type integerValue]),
                           @"devices":array};
    
    NSString *str = [dict JSONString];
    
    int booltype =  CDK_PostXMessage((char *)_deviceID.UTF8String, 0, (char *)str.UTF8String);
    return booltype >= 0 ? YES : NO;

}

#pragma mark - 修改设备密码
/**
 修改设备密码
 
 @param accesspassword 密码
 @return YES : NO;
 */
- (BOOL)cameraChanceOldpassword:(NSString *)oldpassword Accesspassword:(NSString *)password
{


    NSDictionary *servicesDic = @{@"access_password":[[WLSQXcloulink sharedManager] encryptMD5String:password],
                                  @"old_access_password":[[WLSQXcloulink sharedManager] encryptMD5String:oldpassword]
                                  };
    
    NSDictionary *devices = @{@"device_id":_deviceID,
                              @"device_type":@([_device_type integerValue]),
                              @"services":servicesDic};
    NSArray *array = @[devices];
    
    NSDictionary *dict = @{@"msg_id":@([[[WLSQXcloulink sharedManager] getDatetimeString] integerValue]),
                           @"msg_type": @"set",
                           @"device_id":_deviceID,
                           @"device_type":@([_device_type integerValue]),
                           @"devices":array};
    
    NSString *str = [dict JSONString];
    
    int type =  CDK_PostXMessageEX(0, XCLOUDMSG_MESSAGE_SYSTEM, (char *)str.UTF8String);
    return type >= 0 ? YES : NO;


}

#pragma mark - 把WiFi账号密码传给设备
/**
 把WiFi账号密码传给设备
 
 @param ssid WiFi账号
 @param pwd WiFi密码
 @return YES : NO;
 */
- (BOOL)cameraConnectWifissid:(NSString *)ssid ssidPwd:(NSString *)pwd
{
    
    
    NSDictionary *servicesDic = @{@"connect_wifi": @{@"ssid":ssid,@"ssid_pwd":pwd}};
    
    NSDictionary *devices = @{@"device_id":_deviceID,
                              @"device_type":@([_device_type integerValue]),
                              @"services":servicesDic};
    NSArray *array = @[devices];
    
    NSDictionary *dict = @{@"msg_id":@([[[WLSQXcloulink sharedManager] getDatetimeString] integerValue]),
                           @"msg_type": @"set",
                           @"device_id":_deviceID,
                           @"device_type":@([_device_type integerValue]),
                           @"devices":array};
    
    NSString *str = [dict JSONString];
    
    int type =  CDK_PostXMessage((char *)_deviceID.UTF8String, 0, (char *)str.UTF8String);
    return type >= 0 ? YES : NO;
    
}


@end
