//
//  AddDeviceController.m
//  Naidean
//
//  Created by xujun on 2018/1/8.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "AddDeviceController.h"
#import "AddHeadView.h"
#import "AddDeviceCell.h"
#import "NSString+LuAddition.h"

@interface AddDeviceController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation AddDeviceController
{
    UITableView *AddDevicetableView;
    AddHeadView *addHeadView;
    NSMutableArray *devicesAry;
}

- (void)dealloc {
    kCancelALLNotification
    [SY_BLE_MANAGER stopScanPeripherals];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"设备添加";
    
    AddDevicetableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, WIN_HEIGHT-64)];
    AddDevicetableView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f9" alpha:1];
    AddDevicetableView.delegate=self;
    AddDevicetableView.dataSource=self;
    AddDevicetableView.rowHeight = getWidth(48);
    if (@available(iOS 11.0, *)) {
        AddDevicetableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    AddDevicetableView.separatorInset = UIEdgeInsetsZero;
    [AddDevicetableView registerNib:[UINib nibWithNibName:@"AddDeviceCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    UIView *headview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, getHeight(264))];
    headview.backgroundColor=[UIColor colorWithHexString:@"#f5f5f9" alpha:1];
    addHeadView =[[NSBundle mainBundle] loadNibNamed:@"AddHeadView" owner:self options:nil].lastObject;
    addHeadView.frame =CGRectMake(0, getHeight(15), WIN_WIDTH, getHeight(234));
    addHeadView.searchBlock = ^{
        addHeadView.NotesLabel.text = @"正在搜索,请打开设备靠近手机";
        [SY_BLE_MANAGER startScanPeripherals];
    };
    [headview addSubview:addHeadView];
    AddDevicetableView.tableHeaderView = headview;
    [self.view addSubview:AddDevicetableView];
    AddDevicetableView.tableFooterView =[[UIView alloc] initWithFrame:CGRectZero];
    
    //蓝牙相关
    SYBLEManager *manager =SY_BLE_MANAGER;
    manager.deviceArr =[self.deviceArr copy];
    [self addEventObserver];
    [SY_BLE_MANAGER startScanPeripherals];
}

- (void)addEventObserver {
    kReciveNotification(@selector(bleStateChanged:), k_SY_BLE_STATE_CHANGED, nil)
    kReciveNotification(@selector(discoverDevices:), k_SY_BLE_DID_DISCOVER_DEVICE, nil)
    kReciveNotification(@selector(didUpdata), k_SY_BLE_DID_UPDATE_DATA, nil)
}

#pragma mark --- SYBLEManager not
//蓝牙状态改变
- (void)bleStateChanged:(NSNotification *)notification {
    if (!SY_BLE_MANAGER.isBLEOn) {
        [SY_BLE_MANAGER presentAlertVC];
    }else {
        [SY_BLE_MANAGER startScanPeripherals];
    }
}

//发现设备
- (void)discoverDevices:(NSNotification *)notification {
    devicesAry = [SY_BLE_MANAGER.foundDeviceModels mutableCopy];
    [AddDevicetableView reloadData];
    addHeadView.NotesLabel.text = @"点击下面蓝牙图标，搜索附近蓝牙设备";
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return devicesAry.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAK_SELF
    DeviceModel *device = devicesAry[indexPath.row];
    AddDeviceCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.DeviceNameLabel.text = [NSString stringWithFormat:@"%@",device.name];
    cell.DeviceNumberLabel.text = [NSString stringWithFormat:@"%@",device.mac];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.AddDeviceBlock = ^(AddDeviceCell *cell) {
        STRONG_SELF
        [strongSelf addDevice:device];
    };
    cell.deleteBtn.hidden = YES;
    cell.bindingBtn.hidden = YES;
    cell.AddDeviceBtn.hidden = NO;
    cell.deleteDeviceBlock = ^(AddDeviceCell *cell) {
        
        [devicesAry  removeObjectAtIndex:indexPath.row];
        [AddDevicetableView  reloadData];
    };
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (void)addDevice:(DeviceModel *)deviceModel {
    NSString *linkType = [NSString stringWithFormat:@"%zd",[[UserManger sharedInstance] getUnlockType]];
    NSString *phone = [NSString stringWithFormat:@"%@",[[UserManger sharedInstance] getUserPhone]];
//    NSDictionary *params = @{
//                             @"number":phone,
////                             @"mac":@"FE:EA:0B:0A:15:C5",
////                             @"lockName":@"测试锁",
//                             @"mac":deviceModel.mac,
//                             @"lockName":deviceModel.lockName,
//                             @"isAdmin":@"0",
//                             @"linkType":linkType,
//                             @"uid":@"",//WiFi模块的唯一标识
//                             @"password":@""//WiFi模块访问密码
//                             };
    NSDictionary *params = @{
                             @"mac":deviceModel.mac,
                             @"name":deviceModel.name,
                             @"type":linkType
                             };
    DDLog(@"授权用户绑定设备:%@;params:%@",NETWORK_REQUEST_URL(BINDING_DEVICES_URL),params);
    [MBProgressHUD showActivityMessageInView:@"正在添加设备"];
    NSString *httpUrl = [NSString stringWithFormat:@"%@/%@",NETWORK_REQUEST_URL(BINDING_DEVICES_URL),[[UserManger sharedInstance] getMemberToken]];
    WEAK_SELF
    [HttpTool postWithURL:httpUrl params:params success:^(id json) {
        STRONG_SELF
        [MBProgressHUD hideHUD];
        [MBProgressHUD showTipMessageInView:json[@"message"]];
        int code = [json[@"code"] intValue];
        if (code == 1000) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Add_Device_Success" object:nil];
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }
        else if (code == TimeOutCode)
        {
            [MBProgressHUD showTipMessageInView:json[@"登录超时，请重新登录"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_TimeOut_Login object:nil];
        }
        else
        {
            [MBProgressHUD showTipMessageInView:json[@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showTipMessageInView:[error localizedDescription]];
    }];
}

-(void)didUpdata{
    addHeadView.NotesLabel.text = @"点击下面蓝牙图标，搜索附近蓝牙设备";    
}
@end
