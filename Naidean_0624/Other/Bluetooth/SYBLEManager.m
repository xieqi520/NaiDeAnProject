//
//  SYBLEManager.m
//  SYSmartSecurity
//
//  Created by Zoe on 2017/11/29.
//  Copyright © 2017年 zoe. All rights reserved.
//

#import "SYBLEManager.h"
#import "Hexadecimal.h"

static NSString * const kHeartBlueToothName                = @"BT_LOCK";
static NSString * const kHeartServiceUUIDString            = @"0000FF00-0000-1000-8000-00805F9B34FB";
static NSString * const kHeartReadUUIDString               = @"0000FF01-0000-1000-8000-00805F9B34FB";
static NSString * const kHeartWriteDataUUIDString          = @"0000FF01-0000-1000-8000-00805F9B34FB";
static NSString * const kHeartNoticeDataUUIDString         = @"0000FF01-0000-1000-8000-00805F9B34FB";
static NSString * const kWNotificationCharacteristicUUIDTwo  = @"00004323-0006-0005-0004-ffeeddccbbaa";//通知：发送其他信息
static SYBLEManager *bleManager = nil;

@interface SYBLEManager ()<CBCentralManagerDelegate,CBPeripheralDelegate>
@property (nonatomic, strong) CBCharacteristic *readCharacteristic;
@property (nonatomic, strong) CBCharacteristic *writeCharacteristic;
@property (nonatomic, strong) CBCharacteristic *notificationCharacteristic;
@property (nonatomic, strong) CBService *readWriteService;
@property (nonatomic, strong) CBUUID *readUUID;
@property (nonatomic, strong) CBUUID *writeUUID;
@property (nonatomic, strong) CBUUID *notifiUUID;
@property (nonatomic, strong) CBUUID *notifiUUIDTwo;
@property (nonatomic, strong) CBUUID *seviceUUID;//服务id

@property (nonatomic, strong) NSString *blueToothName;//广播名
@property (nonatomic, strong) NSTimer *timer;//蓝牙连接定时
@property (nonatomic, assign) NSInteger passWord;//当前秘钥
@end

@implementation SYBLEManager
+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bleManager = [[SYBLEManager alloc] init];
    });
    return bleManager;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        dispatch_queue_t queue = dispatch_get_main_queue();
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:queue options:@{CBCentralManagerOptionShowPowerAlertKey:@YES}];
        _foundPeripherals = [NSMutableArray arrayWithCapacity:0];
        _foundDeviceModels = [NSMutableArray arrayWithCapacity:0];
        _writeUUID = [CBUUID UUIDWithString:kHeartWriteDataUUIDString];
        _readUUID = [CBUUID UUIDWithString:kHeartReadUUIDString];
        _notifiUUID = [CBUUID UUIDWithString:kHeartNoticeDataUUIDString];
        _notifiUUIDTwo = [CBUUID UUIDWithString:kWNotificationCharacteristicUUIDTwo];

        _seviceUUID = [CBUUID UUIDWithString:kHeartServiceUUIDString];
        _blueToothName = kHeartBlueToothName;
    }
    return self;
}

#pragma mark - CBCentralManagerDelegate
//1.判断蓝牙是否打开
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    self.isBLEOn = central.state == CBCentralManagerStatePoweredOn ? YES : NO;
    if (self.isBLEOn) {
//        [self presentAlertVC];
//        //开始扫描外设
//        [self startScanPeripherals];
    }else {
        //蓝牙关闭
        [self resetBLEProperties];
    }
    //蓝牙状态改变通知
    kSendNotification(k_SY_BLE_STATE_CHANGED, @(self.isBLEOn))
}

//2.当扫描到外设会调用该方法 发现符合要求的外设，回调
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
    NSData *macData = [advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
    NSString *localName = [advertisementData objectForKey:@"kCBAdvDataLocalName"];
    NSLog(@"=====localName:%@",localName);
    if ([localName containsString:self.blueToothName] && macData) {
        NSString *macStrReceived = [NSString stringWithFormat:@"%@",macData];
        NSString *macStr = [Hexadecimal changeUtfEncodeToNsstringWithStr:macStrReceived];
        NSLog(@"=====mac地址:%@",macStr);
        if ([self.macAddress isEqualToString:macStr]) {
            //连接设备
            [self connectPeripheral:peripheral];
        }
        if (![self.foundPeripherals containsObject:peripheral]) {
            [self.foundPeripherals addObject:peripheral];
            DeviceModel *deviceModel = [DeviceModel new];
            deviceModel.mac = macStr;
            deviceModel.name = peripheral.name;
            if (self.deviceArr.count !=0) {
                for (NSDictionary *dic1 in self.deviceArr) {
                    NSLog(@"ssssss==%@",dic1[@"mac"]);
                    NSLog(@"SearchResult=%@",deviceModel.mac);
                    if ([dic1[@"mac"] isEqualToString:deviceModel.mac]) {
                        break;
                    }else{
                        [self.foundDeviceModels addObject:deviceModel];
                    }
                }
            }else
                 [self.foundDeviceModels addObject:deviceModel];
            }
            //扫描发现蓝牙设备通知
            kSendNotification(k_SY_BLE_DID_DISCOVER_DEVICE, peripheral)
        }
}

//3.1 连接成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    NSLog(@"连接成功，连接外设的名字为%@",peripheral.name);
    //连接成功
    self.isConnected = YES;
    self.connectPeripheral = peripheral;
    
    // 设置代理
    peripheral.delegate = self;
    // 根据UUID来寻找服务
    [self startDiscoverService];
    dispatch_async(dispatch_get_main_queue(), ^{
        // 可以停止扫描
        [self stopScanPeripherals];
    });
    
//    //蓝牙设备连接成功通知
//    kSendNotification(k_SY_BLE_DID_CONNECT, peripheral)
    
}

//3.2 连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"连接失败");
    //重置属性
    [self resetBLEProperties];
    
//    [MBProgressHUD showErrorMessage:@"设备连接失败"];
    //蓝牙连接失败通知
    kSendNotification(k_SY_BLE_CONNECT_FAIL, peripheral)
    
}

//3.3 断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    NSLog(@"断开连接，外设的名字为%@",peripheral.name);
    self.isConnected = NO;
    //当非手动断开设备 设置重连
    if (self.allowReconnect) {
        [self reconnectAction];
    }else {
        self.connectPeripheral = nil;
        self.macAddress = nil;
    }
    
//    [GSProgressHUD showErrorWithStatus:@"设备已断开连接"];
    //蓝牙断开连接通知
    kSendNotification(k_SY_BLE_DID_BREAK, peripheral)
}

#pragma mark CBPeripheralDelegate
//4.开始搜索服务
- (void)startDiscoverService {
    NSArray *seviceArr = [NSArray arrayWithObjects:self.seviceUUID, nil];
    [self.connectPeripheral discoverServices:seviceArr];
}

//5.发现服务后回调方法
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSArray *seviceArr = nil;
    NSArray *uuids = [NSArray arrayWithObjects:self.readUUID,self.writeUUID,self.notifiUUID, nil];
    if (peripheral != self.connectPeripheral)
    {
        return;
    }
    if (error != nil)
    {
        return;
    }
    //获取所有的服务
    seviceArr = [peripheral services];
    
    if (!seviceArr||![seviceArr count])
    {
        return;
    }
    
    self.readWriteService = nil;
    for (CBService *curService in seviceArr)
    {
        NSLog(@"[curService UUID] ==%@",[curService UUID]);
        if ([[curService UUID] isEqual:self.seviceUUID])
        {
            self.readWriteService = curService;
            [peripheral discoverCharacteristics:uuids forService:self.readWriteService];
            break;
        }
    }
    
}

//6 已经发现特征服务
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSArray *characteristics = [service characteristics];
    CBCharacteristic *characteristic;
    if (peripheral != self.connectPeripheral)
    {
        return;
    }
    if (service != self.readWriteService)
    {
        return;
    }
    if (error != nil)
    {
        return;
    }
    for (characteristic in characteristics)
    {
        if ([[characteristic UUID] isEqual:self.writeUUID])
        {
            self.writeCharacteristic = characteristic;
            [self.connectPeripheral setNotifyValue:YES forCharacteristic:self.writeCharacteristic];
            
        }else if ([[characteristic UUID] isEqual:self.readUUID])
        {
            self.readCharacteristic = characteristic;
            [self.connectPeripheral setNotifyValue:YES forCharacteristic:self.readCharacteristic];
        }else if ([[characteristic UUID] isEqual:self.notifiUUID] || [[characteristic UUID] isEqual:self.notifiUUIDTwo])
        {
            self.notificationCharacteristic = characteristic;
            [self.connectPeripheral setNotifyValue:YES forCharacteristic:self.notificationCharacteristic];
        }
    }
    //蓝牙设备连接成功通知
    kSendNotification(k_SY_BLE_DID_CONNECT, peripheral)
}

//7.与外设做数据交互（读数据）蓝牙返回数据
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) return;
    NSData *data = characteristic.value;
    if (data) {
        //处理数据
        [self assembleDatawithData:data];
        kSendNotification(k_SY_BLE_DID_UPDATE_DATA, data)
    }
    
}

//8.写数据  数据发送失败
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) NSLog(@"writeError = %@",error);
}

#pragma mark - ActionOutside
// 开始搜索设备
- (void)startScanPeripherals {
    if (!self.isBLEOn) {
        //蓝牙提示
        [self presentAlertVC];
        return;
    }
    
    if (self.connectPeripheral) {
        [self breakUpDeviceMacAddress:nil];
    }
    
    //开始扫描
    [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    //将装外设的数组腾空
    [self.foundPeripherals removeAllObjects];
    [self.foundDeviceModels removeAllObjects];

}

// 停止搜索设备
- (void)stopScanPeripherals {
    [self.centralManager stopScan];
}

// 开始连接设备
- (void)connectPeripheral:(CBPeripheral *)peripheral {
    [self.centralManager connectPeripheral:peripheral
                                   options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
}

// 通过mac地址连接目标设备
- (void)startConnectTargetDevice:(NSString *)deviceMacAddress {
    [self startTimer];
    self.macAddress = deviceMacAddress;
    [self startScanPeripherals];
}

// 断开连接设备
- (void)breakUpDeviceMacAddress:(NSString *)macAddress {
    //停止扫描
    [self stopScanPeripherals];
    
    if (!self.connectPeripheral)  {return;}
    //断开连接
    [self.centralManager cancelPeripheralConnection:self.connectPeripheral];
    //重置属性
    [self resetBLEProperties];
}

// 写数据
- (void)write:(NSData *)data
{
    if (self.isConnected) {
        [self.connectPeripheral writeValue:data forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
    }else {
        [MBProgressHUD showErrorMessage:@"设备已断开连接，请重新连接"];
    }
}

#pragma mark - private
// 清空标志值
- (void)resetBLEProperties {
    self.isConnected = NO;
    self.connectPeripheral = nil;
    self.macAddress = nil;
    self.connectDeviceModel = nil;
    self.passWord = 0;
    [self.foundPeripherals removeAllObjects];
    [self.foundDeviceModels removeAllObjects];
    [self stopTimer];
}

// 断开重连
- (void)reconnectAction {
    if (self.connectPeripheral && self.isBLEOn) {
        [self connectPeripheral:self.connectPeripheral];
    }
}

#pragma mark - 连接定时器
//开始倒计时
- (void)startTimer {
    [self stopTimer];
    NSInteger timeInterval = 15;
    self.timer = [NSTimer timerWithTimeInterval:timeInterval target:self selector:@selector(timerOutAction) userInfo:nil repeats:NO];
    // 加入RunLoop中
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

//倒计时结束
- (void)timerOutAction {
    //执行超时 失败处理
    [self breakUpDeviceMacAddress:self.macAddress];
    [MBProgressHUD showErrorMessage:@"开锁超时"];
    //蓝牙连接超时
    kSendNotification(k_SY_BLE_CONNECT_FAIL, nil)
}

//销毁定时器
- (void)stopTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark ---------------------------- 解析返回数据
- (void)assembleDatawithData:(NSData *)data {
    NSLog(@"蓝牙数据=====%@",data);
    Byte *dataByte = (Byte *)[data bytes];
    if (dataByte[2] == 0x30) {
        //停止计时
        [self stopTimer];
    }
//
//    if (dataByte[3] == 0x32) {
//        //电量
//        
//    }
//    
//    if (dataByte[2] == 0x03) {
//        //停止计时
//        [self stopTimer];
//        //开锁成功
//        BOOL success = dataByte[3] == 0 ? YES : NO;
//        //开锁通知
//        kSendNotification(k_SY_DEVICE_DID_OPEN, @(success))
//    }
}

#pragma mark - alert
- (void)presentAlertVC {
    UINavigationController *naviVC = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    if (self.isBLEOn) {
        if (naviVC.presentedViewController) {
            [naviVC dismissViewControllerAnimated:NO completion:nil];
        }
    }else {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请打开蓝牙设备" message:@"此设备需要打开手机的蓝牙功能支持" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self go2SysterSettingVC];
        }]];
        
        void(^presentCompletion)(void) = ^{
            [naviVC.topViewController presentViewController:alertController animated:YES completion:nil];
        };
        
        if (naviVC.presentedViewController) {
            [naviVC.topViewController dismissViewControllerAnimated:NO completion:presentCompletion];
        }else {
            presentCompletion();
        }
    }
}

#pragma mark - push
- (void)go2SysterSettingVC {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}
@end

