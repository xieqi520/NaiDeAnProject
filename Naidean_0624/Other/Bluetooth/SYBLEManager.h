//
//  SYBLEManager.h
//  SYSmartSecurity
//
//  Created by Zoe on 2017/11/29.
//  Copyright © 2017年 zoe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "DeviceModel.h"

#define SY_BLE_MANAGER ([SYBLEManager sharedManager])

@interface SYBLEManager : NSObject
@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral *connectPeripheral;//当前连接的设备
@property (nonatomic, strong) NSMutableArray *foundPeripherals;//发现的设备数组
@property (nonatomic, strong) NSMutableArray *foundDeviceModels;//发现的设备模型数组
@property (nonatomic, strong) DeviceModel *connectDeviceModel;
@property (nonatomic, assign) BOOL isConnected;//当前设备是否连接
@property (nonatomic, assign) BOOL isBLEOn;//蓝牙是否打开
@property (nonatomic,strong) NSArray *deviceArr;
//外部参数
@property (nonatomic, assign) BOOL allowReconnect;//是否允许断开自动重连 默认yes
@property (nonatomic, copy  ) NSString *macAddress;//当前连接设备的mac地址

// 单例生成
+(instancetype)sharedManager;
// 开始搜索设备
-(void)startScanPeripherals;
// 停止搜索设备
-(void)stopScanPeripherals;

//通过mac地址链接目标设备
-(void)startConnectTargetDevice:(NSString *)deviceMacAddress;
//通过mac地址断开目标设备
-(void)breakUpDeviceMacAddress:(NSString *)macAddress;

//写数据
-(void)write:(NSData *)data;
//提示
-(void)presentAlertVC;
@end
