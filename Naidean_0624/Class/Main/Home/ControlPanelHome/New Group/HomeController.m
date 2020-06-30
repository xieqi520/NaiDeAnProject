//
//  HomeController.m
//  Naidean
//
//  Created by xujun on 2018/1/4.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "HomeController.h"
#import "AddDeviceView.h"
#import "AddDeviceController.h"
#import "ConnectmodeController.h"
#import "WifiConnectController.h"
#import "NSString+LuAddition.h"
#import "SYIncomingCallController.h"
#import "NDAtableviewAlert.h"

#import "SYRemoteControlVC.h"
@interface HomeController ()<DropMenuDelegate,DropMenuDataSource>
@property (nonatomic, strong) AddDeviceView *deviceView;

@property (nonatomic, copy)   NSMutableArray *deviceAry;

@property (strong, nonatomic)  UIImageView *BackImgView;
@property (strong, nonatomic)  UILabel *EnergyLabel;
@property (strong, nonatomic)  UILabel *Energy;
@property (strong, nonatomic)  UIButton *nameBtn;
@property (strong, nonatomic)  UIImageView *IconImgVIew;
@property (strong, nonatomic)  UIButton *deviceListBtn;
@property (strong, nonatomic)  UILabel *NotesLabel;
@property (strong, nonatomic)  UILabel *NotesLabel1;
@property (strong, nonatomic)  UIButton *PhotoBtn;
@property (strong, nonatomic)  UILabel *PhotoLabel;
@property (strong, nonatomic)  UIButton *AuthBtn;
@property (strong, nonatomic)  UILabel *AuthLabel;
@property (strong, nonatomic)  UIButton *RemoteBtn;
@property (strong, nonatomic)  UILabel *RemoteLabel;
@property (strong, nonatomic)  UIButton *UserSetBtn;
@property (strong, nonatomic)  UILabel *UserSetLabel;
@property (strong, nonatomic)  UIButton *LogListBtn;
@property (strong, nonatomic)  UILabel *LogListLabel;
@property (strong, nonatomic)  UIButton *UserMessageBtn;
@property (strong, nonatomic)  UILabel *UserMessageLabel;
@property (strong, nonatomic)  DeviceModel *deviceModel;
@property (strong, nonatomic) NDAtableviewAlert *alert;

@end

@implementation HomeController
{
    NSMutableArray *devicesAry;
    dispatch_source_t timer;
    NSString *linkType;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.deviceView backgroundTapped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    linkType = [NSString stringWithFormat:@"%zd",[[UserManger sharedInstance] getUnlockType]];
    if ([linkType isEqualToString:@"2"]) {
        //蓝牙模式
        [SYBLEManager sharedManager];
    }
    
    [self addEventObserver];
    
    [self loadData];
    
    [self initWithNav];
    
    [self initWithBlock];
    
    [self initWithUI];
    
    [self refreshButtonUI];

}

- (void)addEventObserver {
    kReciveNotification(@selector(bleStateChanged:), k_SY_BLE_STATE_CHANGED, nil)
    kReciveNotification(@selector(connectionBuild:), k_SY_BLE_DID_CONNECT, nil)
    kReciveNotification(@selector(connectFail:), k_SY_BLE_DID_BREAK, nil)
    kReciveNotification(@selector(connectFail:), k_SY_BLE_CONNECT_FAIL, nil)
    kReciveNotification(@selector(didUpdateData:), k_SY_BLE_DID_UPDATE_DATA, nil)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewDeviceSuccess:) name:@"Add_Device_Success" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TimeOutLogin) name:kNotification_TimeOut_Login object:nil];
    
}

- (void)addNewDeviceSuccess:(NSNotification *)userInfo{
    NSLog(@"%@",userInfo);
    [self loadData];
}


-(void)initWithNav
{
    self.title=@"控制面板";
    UIImage *rightButtonIcon = [[UIImage imageNamed:@"add"]
                               imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:rightButtonIcon style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClicked)];
    self.navigationItem.rightBarButtonItem = rightButton;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;

}

-(void)initWithUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.BackImgView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg1"]];
    self.BackImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.BackImgView.clipsToBounds = YES;
    self.BackImgView.userInteractionEnabled = YES;
    [self.view addSubview:self.BackImgView];
    [self.BackImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(getHeight(350));
    }];
    
    self.Energy =[[UILabel alloc] init];
    self.Energy.text=@"";
    self.Energy.textAlignment = NSTextAlignmentLeft;
    self.Energy.font =kSystemFontSize(getWidth(15));
    self.Energy.textColor=[UIColor whiteColor];
    [self.BackImgView addSubview:self.Energy];
    [self.Energy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(getHeight(8));
        make.right.equalTo(self.view.mas_right).offset(getWidth(-18));
        make.size.mas_equalTo(CGSizeMake(getWidth(33), getHeight(21)));
    }];
    
    self.EnergyLabel =[[UILabel alloc] init];
//    self.EnergyLabel.text=@"设备电量:";
    self.EnergyLabel.textAlignment = NSTextAlignmentRight;
    self.EnergyLabel.font =kSystemFontSize(getWidth(15));
    self.EnergyLabel.textColor =[UIColor whiteColor];
    [self.BackImgView addSubview:self.EnergyLabel];
    [self.EnergyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.Energy.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(getWidth(70), getHeight(21)));
        make.right.equalTo(self.Energy.mas_left).offset(getWidth(-5));
    }];

    self.nameBtn = [[UIButton alloc] init];
    if (!self.deviceModel) {
        self.nameBtn.userInteractionEnabled = NO;
    }
    [self.BackImgView addSubview:self.nameBtn];
    [self.nameBtn addTarget:self action:@selector(editDeviceNameBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.nameBtn setBackgroundImage:[UIImage imageNamed:@"bg_mensuobeizhu"] forState:UIControlStateNormal];
    [self.nameBtn setImage:[UIImage imageNamed:@"rename"] forState:UIControlStateNormal];
    NSDictionary *dic = [[NSUserDefaults  standardUserDefaults]  objectForKey:@"selectedLock"];
    if (dic !=nil) {
        [self refreshDeviceNameWithName:dic[@"deviceName"]];
    }else{
        [self refreshDeviceNameWithName:nil];
    }
    self.deviceListBtn = [[UIButton alloc] init];
    self.deviceListBtn.userInteractionEnabled = NO;
//    [self.deviceListBtn addTarget:self action:@selector(listBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.deviceListBtn setBackgroundImage:[UIImage imageNamed:@"bg_mensuo"] forState:UIControlStateNormal];
    [self.deviceListBtn setImage:[UIImage imageNamed:@"bt_lock"] forState:UIControlStateNormal];
    [self.BackImgView addSubview:self.deviceListBtn];
    [self.deviceListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameBtn.mas_bottom).offset(getHeight(22));
        make.centerX.equalTo(self.BackImgView);
        make.size.mas_equalTo(CGSizeMake(getWidth(180), getWidth(180)));
    }];
    
    self.NotesLabel =[[UILabel alloc] init];
    self.NotesLabel.textAlignment = NSTextAlignmentCenter;
    self.NotesLabel.text=@"无设备";
    self.NotesLabel.numberOfLines = 0;
    self.NotesLabel.font =kSystemFontSize(getWidth(15));
    self.NotesLabel.textColor=[UIColor colorWithHexString:@"#ff7b06" alpha:1];
    self.NotesLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    [self.BackImgView addSubview:self.NotesLabel];
    [self.NotesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.BackImgView);
        make.size.mas_equalTo(CGSizeMake(WIN_WIDTH, getHeight(20)));
        make.top.equalTo(self.deviceListBtn.mas_bottom).offset(getHeight(20));
    }];
    
    self.NotesLabel1 =[[UILabel alloc] init];
    self.NotesLabel1.textAlignment = NSTextAlignmentCenter;
    self.NotesLabel1.text=@"点击右上角添加设备";
    self.NotesLabel1.numberOfLines = 0;
    self.NotesLabel1.font =kSystemFontSize(getWidth(15));
    self.NotesLabel1.textColor=[UIColor colorWithHexString:@"#212121" alpha:1];
    self.NotesLabel1.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    [self.BackImgView addSubview:self.NotesLabel1];
    [self.NotesLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.BackImgView);
        make.size.mas_equalTo(CGSizeMake(WIN_WIDTH, getHeight(25)));
        make.top.equalTo(self.NotesLabel.mas_bottom).offset(getHeight(0));
    }];
    
    self.PhotoBtn=[UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.PhotoBtn setBackgroundImage:[UIImage imageNamed:@"reset_name"] forState:UIControlStateNormal];
//    self.phot
    self.PhotoBtn.userInteractionEnabled = NO;
    self.PhotoBtn.tag = 10;
    [self.PhotoBtn addTarget:self action:@selector(BtnActionCilck:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.PhotoBtn];
    [self.PhotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.BackImgView.mas_bottom).offset(getHeight(30));
        make.size.mas_equalTo(CGSizeMake(getWidth(64), getWidth(64)));
        make.left.equalTo(self.view.mas_left).offset(getWidth(47));
    }];

    self.PhotoLabel=[[UILabel alloc] init];
    self.PhotoLabel.text=@"重命名";
    self.PhotoLabel.textAlignment = NSTextAlignmentCenter;
    self.PhotoLabel.font =kSystemFontSize(getWidth(14));
    self.PhotoLabel.textColor=[UIColor colorWithHexString:@"#484b5f" alpha:1];
    [self.view addSubview:self.PhotoLabel];
    [self.PhotoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.PhotoBtn);
        make.top.equalTo(self.PhotoBtn.mas_bottom).offset(getHeight(6));
        make.size.mas_equalTo(CGSizeMake(getWidth(150), getHeight(21)));
    }];

    self.AuthBtn=[UIButton buttonWithType:(UIButtonTypeCustom)];
    self.AuthBtn.tag = 20;
    [self.AuthBtn addTarget:self action:@selector(BtnActionCilck:) forControlEvents:UIControlEventTouchUpInside];
    [self.AuthBtn setBackgroundImage:[UIImage imageNamed:@"set_authorization"] forState:UIControlStateNormal];
    self.AuthBtn.userInteractionEnabled = NO;
    [self.view addSubview:self.AuthBtn];
    [self.AuthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.BackImgView.mas_bottom).offset(getHeight(30));
        make.size.mas_equalTo(CGSizeMake(getWidth(64), getWidth(64)));
        make.centerX.equalTo(self.view);
    }];

    self.AuthLabel=[[UILabel alloc] init];
    self.AuthLabel.text=@"授权管理";
    self.AuthLabel.textAlignment = NSTextAlignmentCenter;
    self.AuthLabel.font =kSystemFontSize(getWidth(14));
    self.AuthLabel.textColor=[UIColor colorWithHexString:@"#484b5f" alpha:1];
    [self.view addSubview:self.AuthLabel];
    [self.AuthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.AuthBtn);
        make.top.equalTo(self.AuthBtn.mas_bottom).offset(getHeight(6));
        make.size.mas_equalTo(CGSizeMake(getWidth(150), getHeight(21)));
    }];

    self.RemoteBtn=[UIButton buttonWithType:(UIButtonTypeCustom)];
    self.RemoteBtn.tag = 30;
    [self.RemoteBtn addTarget:self action:@selector(BtnActionCilck:) forControlEvents:UIControlEventTouchUpInside];
    [self.RemoteBtn setBackgroundImage:[UIImage imageNamed:@"set_lock"] forState:UIControlStateNormal];
    self.RemoteBtn.userInteractionEnabled = NO;
    [self.view addSubview:self.RemoteBtn];
    [self.RemoteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.BackImgView.mas_bottom).offset(getHeight(30));
        make.size.mas_equalTo(CGSizeMake(getWidth(64), getWidth(64)));
        make.right.equalTo(self.view.mas_right).offset(getWidth(-46));
    }];

    self.RemoteLabel=[[UILabel alloc] init];
    NSInteger unlockTpye = [[UserManger sharedInstance] getUnlockType];
    if (unlockTpye == 1) {
        self.RemoteLabel.text=@"远程开锁";
    }else{
        self.RemoteLabel.text=@"开锁";
    }
    self.RemoteLabel.textAlignment = NSTextAlignmentCenter;
    self.RemoteLabel.font =kSystemFontSize(getWidth(14));
    self.RemoteLabel.textColor=[UIColor colorWithHexString:@"#484b5f" alpha:1];
    [self.view addSubview:self.RemoteLabel];
    [self.RemoteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.RemoteBtn);
        make.top.equalTo(self.RemoteBtn.mas_bottom).offset(getHeight(6));
        make.size.mas_equalTo(CGSizeMake(getWidth(150), getHeight(21)));
    }];


    self.UserSetBtn=[UIButton buttonWithType:(UIButtonTypeCustom)];
    self.UserSetBtn.tag = 40;
    [self.UserSetBtn addTarget:self action:@selector(BtnActionCilck:) forControlEvents:UIControlEventTouchUpInside];
    [self.UserSetBtn setBackgroundImage:[UIImage imageNamed:@"set_setting"] forState:UIControlStateNormal];
    self.UserSetBtn.userInteractionEnabled = NO;
    [self.view addSubview:self.UserSetBtn];
    [self.UserSetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.PhotoLabel.mas_bottom).offset(getHeight(10));
        make.size.mas_equalTo(CGSizeMake(getWidth(64), getWidth(64)));
        make.left.equalTo(self.view.mas_left).offset(getWidth(47));
    }];

    self.UserSetLabel=[[UILabel alloc] init];
    self.UserSetLabel.text=@"密码设置";
    self.UserSetLabel.textAlignment = NSTextAlignmentCenter;
    self.UserSetLabel.font =kSystemFontSize(getWidth(14));
    self.UserSetLabel.textColor=[UIColor colorWithHexString:@"#484b5f" alpha:1];
    [self.view addSubview:self.UserSetLabel];
    [self.UserSetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.UserSetBtn);
        make.top.equalTo(self.UserSetBtn.mas_bottom).offset(getHeight(6));
        make.size.mas_equalTo(CGSizeMake(getWidth(150), getHeight(21)));
    }];

    self.LogListBtn=[UIButton buttonWithType:(UIButtonTypeCustom)];
    self.LogListBtn.tag = 50;
    [self.LogListBtn addTarget:self action:@selector(BtnActionCilck:) forControlEvents:UIControlEventTouchUpInside];
    [self.LogListBtn setBackgroundImage:[UIImage imageNamed:@"set_record"] forState:UIControlStateNormal];
    self.LogListBtn.userInteractionEnabled = NO;
    [self.view addSubview:self.LogListBtn];
    [self.LogListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.AuthLabel.mas_bottom).offset(getHeight(10));
        make.size.mas_equalTo(CGSizeMake(getWidth(64), getWidth(64)));
        make.centerX.equalTo(self.view);
    }];

    self.LogListLabel=[[UILabel alloc] init];
    self.LogListLabel.text=@"开锁记录";
    self.LogListLabel.textAlignment = NSTextAlignmentCenter;
    self.LogListLabel.font =kSystemFontSize(getWidth(14));
    self.LogListLabel.textColor=[UIColor colorWithHexString:@"#484b5f" alpha:1];
    [self.view addSubview:self.LogListLabel];
    [self.LogListLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.LogListBtn);
        make.top.equalTo(self.LogListBtn.mas_bottom).offset(getHeight(6));
        make.size.mas_equalTo(CGSizeMake(getWidth(150), getHeight(21)));
    }];

    self.UserMessageBtn=[UIButton buttonWithType:(UIButtonTypeCustom)];
    self.UserMessageBtn.tag = 60;
    [self.UserMessageBtn addTarget:self action:@selector(BtnActionCilck:) forControlEvents:UIControlEventTouchUpInside];
    [self.UserMessageBtn setBackgroundImage:[UIImage imageNamed:@"set_user_ed"] forState:UIControlStateNormal];
    [self.view addSubview:self.UserMessageBtn];
    [self.UserMessageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.RemoteLabel.mas_bottom).offset(getHeight(10));
        make.size.mas_equalTo(CGSizeMake(getWidth(64), getWidth(64)));
        make.right.equalTo(self.view.mas_right).offset(getWidth(-46));
    }];

    self.UserMessageLabel=[[UILabel alloc] init];
    self.UserMessageLabel.text=@"用户信息";
    self.UserMessageLabel.textAlignment = NSTextAlignmentCenter;
    self.UserMessageLabel.font =kSystemFontSize(getWidth(14));
    self.UserMessageLabel.textColor=[UIColor colorWithHexString:@"#484b5f" alpha:1];
    [self.view addSubview:self.UserMessageLabel];
    [self.UserMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.UserMessageBtn);
        make.top.equalTo(self.UserMessageBtn.mas_bottom).offset(getHeight(6));
        make.size.mas_equalTo(CGSizeMake(getWidth(150), getHeight(21)));
    }];
}


-(void)initWithBlock  //
{
    __weak typeof(self) weakSelf = self;
    self.deviceView.AdddeviceBlock = ^{
        NSInteger unlockType = [[UserManger sharedInstance] getUnlockType];
        UIViewController *vc;
        if (unlockType == 1) {
            vc =[[WifiConnectController alloc] init];
        }else{
            vc =[[AddDeviceController alloc] init];
        }
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
}

-(void)loadData{
//    NSString *userPhone = [NSString stringWithFormat:@"%@",[[UserManger sharedInstance] getUserPhone]];
    NSDictionary *params = @{@"type":linkType};
    DDLog(@"GetDeviceAll_URL:%@,params:%@",NETWORK_REQUEST_URL(GET_DEVICE_URL),params);
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@",NETWORK_REQUEST_URL(GET_DEVICE_URL),[[UserManger sharedInstance] getMemberToken]];
    [HttpTool postWithURL:urlstr params:params success:^(id json) {
        DDLog(@"result:%@",json);
        int status = [json[@"code"] intValue];
        if (status == 1000) {
            _deviceAry = json[@"data"];
            if (_deviceAry.count !=0) {
                NSDictionary *dic =_deviceAry[0];
                NSDictionary *selectDic = [[NSUserDefaults  standardUserDefaults] objectForKey:@"selectLock"];
                if (selectDic==nil) {
                    [[NSUserDefaults  standardUserDefaults]  setObject:@{@"deviceID":dic[@"id"],@"deviceName":dic[@"name"]} forKey:@"selectLock"];
                }
                //          [[NSUserDefaults  standardUserDefaults] setObject:_deviceAry forKey:@"DeviceList"];
                [self.menuArray removeAllObjects];
                for (NSInteger i = 0; i < _deviceAry.count; i++) {
                    //                DeviceModel *device =[DeviceModel  mj_objectWithKeyValues:_deviceAry[i]]; //[[DeviceModel alloc]initWithJSON:_deviceAry[i]];
                    //                [self.menuArray addObject:device];
                    //                if ([device.mac isEqualToString:self.deviceModel.mac]) {
                    NSDictionary *dic1 = self.deviceAry[i];
                    if ([selectDic[@"id"]  isEqualToString:dic1[@"id"]]) {
                        self.deviceModel = [DeviceModel  mj_objectWithKeyValues:_deviceAry[i]];
                    }else{
                        self.deviceModel = [DeviceModel  mj_objectWithKeyValues:_deviceAry[0]];
                    }
                }
                [self refreshButtonUI];
                if (_alert) {
                    _alert.dataArr = [[NSMutableArray  alloc]initWithArray:self.deviceAry];
                    [_alert.tableview  reloadData];
                }
            }
            
        }else if (status == TimeOutCode)
        {
            [MBProgressHUD showTipMessageInView:json[@"登录超时，请重新登录"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_TimeOut_Login object:nil];
        }
        else
        {
            [MBProgressHUD showTipMessageInView:json[@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTipMessageInView:[error localizedDescription]];
    }];
}

- (void)refreshDeviceNameWithName:(NSString *)name{
    if (!name) {
        name = @"无设备";
    }
    [self.nameBtn setTitle:name forState:UIControlStateNormal];
    self.nameBtn.titleLabel.font = kSystemFontSize(getWidth(15));
    UIFont *font = self.nameBtn.titleLabel.font;
    CGSize textSize = [name sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    CGFloat btnWidth = textSize.width + 50.f;
    [self.nameBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.BackImgView);
        make.size.mas_equalTo(CGSizeMake(getWidth(btnWidth), getHeight(26)));
        make.top.equalTo(self.view.mas_top).offset(getHeight(35));
    }];
    self.nameBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -getWidth(5)-self.nameBtn.currentImage.size.width, 0, self.nameBtn.currentImage.size.width+getWidth(5));
    self.nameBtn.imageEdgeInsets = UIEdgeInsetsMake(0, getWidth(textSize.width+5)+self.nameBtn.currentImage.size.width, 0, 0);
}

- (void)editDeviceNameBtnClicked {
    if (self.deviceModel) {
        [self showInputAlertView:@"inputDN"];
    }
}

- (void)showInputAlertView:(NSString *)identifier{
    NSString *alertTitle = @"设备重命名";
    NSString *httpURL = [NSString stringWithFormat:@"%@/%@",NETWORK_REQUEST_URL(CHANGE_DEVICE_NAME_URL),[[UserManger sharedInstance] getMemberToken]];
    NSString *placeholder = @"请输入设备昵称";
    NSString *errorMessage = @"设备名称不能为空";
    if ([identifier isEqualToString:@"inputPW"]) {
        alertTitle = @"请输入开锁密码";
        httpURL = NETWORK_REQUEST_URL(LOCK_ON_URL);
        placeholder = @"请输入开锁密码";
        errorMessage = @"密码不能为空";
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
//    [alert.textFields.firstObject setKeyboardType:UIKeyboardTypeNumberPad];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alert.textFields.firstObject;

        if (textField.text.length <= 0) {
            [MBProgressHUD showTipMessageInView:errorMessage];
            return;
        }else{
            if ([linkType isEqualToString:@"2"] && [identifier isEqualToString:@"inputPW"]) {
                if ([self.deviceModel.openPwd isEqualToString:textField.text]) {
                    NSLog(@"开始开锁");
                    NSMutableString *orderStr = [NSMutableString stringWithString:@"5AA53308FFFFFFFFFFFFFFFF"];
                    //拼接校验码
                    [orderStr appendString:[Helper stylestring:orderStr]];
                    NSLog(@"%@",orderStr);
                    [MBProgressHUD showActivityMessageInView:@"正在开锁"];
                    [SY_BLE_MANAGER write:[Helper mutString:orderStr]];
                }else{
                    NSLog(@"密码错误");
                    [MBProgressHUD showTipMessageInView:@"密码错误"];
                }
                
            }else{
                NSString *idStr;
                NSDictionary *dic = [[NSUserDefaults  standardUserDefaults] objectForKey:@"selectedLock"];
                if (dic!=nil ) {
                    idStr = dic[@"deviceID"];
                }else{
                    idStr = self.deviceModel.id;
                }
                NSDictionary *params = @{
                                         @"name":textField.text,
                                         @"id":idStr,
                                         };
                if (identifier && [identifier isEqualToString:@"inputPW"]) {
                    params = @{
                               @"mac":self.deviceModel.mac,
                               @"number":[[UserManger sharedInstance] getUserPhone],
                               @"message":@""//指令
                               };
                    [MBProgressHUD showActivityMessageInView:@"正在开锁"];
                }
                DDLog(@"CHANGE_DEVICE_NAME_URL:%@;params:%@",httpURL,params);
//                httpURL = [NSString stringWithFormat:@"%@/%@",NETWORK_REQUEST_URL(CHANGE_DEVICE_NAME_URL),[[UserManger sharedInstance] getMemberToken]];
                
                [HttpTool postWithURL:httpURL params:params success:^(id json) {
                    NSLog(@"result:%@",json);
                    [MBProgressHUD hideHUD];

                    int code = [json[@"code"] intValue];
                    if (code == 1000) {
                        if (identifier && [identifier isEqualToString:@"inputPW"]) {
                            [MBProgressHUD showTipMessageInView:json[@"message"]];
                        }else{
                            self.deviceModel.name = textField.text;
                            [self refreshDeviceNameWithName:textField.text];
                        }
                    }else if (code == TimeOutCode)
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
        }
        
        
    }]];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = placeholder;
        if (identifier && [identifier isEqualToString:@"inputPW"])
        {
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)refreshButtonUI{
    if (self.deviceModel.userType == 2) {
        //如果是保姆
        self.PhotoBtn.hidden = NO;
        self.PhotoLabel.hidden = NO;
        self.AuthBtn.hidden = NO;
        self.AuthLabel.hidden = NO;
        self.UserSetBtn.hidden = NO;
        self.UserSetLabel.hidden = NO;
        self.LogListBtn.hidden = NO;
        self.LogListLabel.hidden = NO;
        
//        [self.PhotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.BackImgView.mas_bottom).offset(getHeight(30));
//            make.size.mas_equalTo(CGSizeMake(getWidth(64), getWidth(64)));
//            make.left.equalTo(self.view.mas_left).offset(getWidth(47));
//        }];
//        [self.PhotoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.PhotoBtn);
//            make.top.equalTo(self.PhotoBtn.mas_bottom).offset(getHeight(6));
//            make.size.mas_equalTo(CGSizeMake(getWidth(150), getHeight(21)));
//        }];
//
//
//        [self.RemoteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.BackImgView.mas_bottom).offset(getHeight(30));
//            make.size.mas_equalTo(CGSizeMake(getWidth(64), getWidth(64)));
//            make.right.equalTo(self.view.mas_right).offset(getWidth(-46));
//        }];
//
//        self.RemoteLabel.text = @"开锁";
//        [self.RemoteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.RemoteBtn);
//            make.top.equalTo(self.RemoteBtn.mas_bottom).offset(getHeight(6));
//            make.size.mas_equalTo(CGSizeMake(getWidth(150), getHeight(21)));
//        }];
//
//        ////////相关设置
//        [self.UserSetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.PhotoLabel.mas_bottom).offset(getHeight(10));
//            make.size.mas_equalTo(CGSizeMake(getWidth(64), getWidth(64)));
//            make.left.equalTo(self.view.mas_left).offset(getWidth(47));
//        }];
//
//
//        self.UserSetLabel.text = @"密码设置";
//        [self.UserSetLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.UserSetBtn);
//            make.top.equalTo(self.RemoteBtn.mas_bottom).offset(getHeight(6));
//            make.size.mas_equalTo(CGSizeMake(getWidth(60), getHeight(21)));
//        }];
//        //////////用户信息
//        [self.UserMessageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.RemoteLabel.mas_bottom).offset(getHeight(10));
//            make.size.mas_equalTo(CGSizeMake(getWidth(64), getWidth(64)));
//            make.right.equalTo(self.view.mas_right).offset(getWidth(-46));
//        }];
//
//        [self.UserMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.UserMessageBtn);
//            make.top.equalTo(self.UserMessageBtn.mas_bottom).offset(getHeight(6));
//            make.size.mas_equalTo(CGSizeMake(getWidth(150), getHeight(21)));
//        }];
        if (self.deviceModel) {
            [self.RemoteBtn setBackgroundImage:[UIImage imageNamed:@"set_lock_ed"] forState:UIControlStateNormal];
            self.RemoteBtn.userInteractionEnabled = YES;
            [self.UserSetBtn setBackgroundImage:[UIImage imageNamed:@"btn_shezhi"] forState:UIControlStateNormal];
            self.UserSetBtn.userInteractionEnabled = YES;
            [self.AuthBtn  setBackgroundImage:[UIImage  imageNamed:@"set_authorization"] forState:UIControlStateNormal];
            self.AuthBtn.userInteractionEnabled = NO;
            [self.LogListBtn  setBackgroundImage:[UIImage  imageNamed:@"set_record"] forState:UIControlStateNormal];
            self.LogListBtn.userInteractionEnabled = NO;
            [self.PhotoBtn  setBackgroundImage:[UIImage  imageNamed:@"reset_name_ed"] forState:UIControlStateNormal];
            self.PhotoBtn.userInteractionEnabled = YES;
            [self.UserMessageBtn  setBackgroundImage:[UIImage  imageNamed:@"set_user_ed"] forState:UIControlStateNormal];
            self.UserMessageBtn.userInteractionEnabled = YES;
        }else{
            [self.RemoteBtn setBackgroundImage:[UIImage imageNamed:@"set_lock"] forState:UIControlStateNormal];
            self.RemoteBtn.userInteractionEnabled = NO;
            [self.UserSetBtn setBackgroundImage:[UIImage imageNamed:@"set_setting"] forState:UIControlStateNormal];
            self.UserSetBtn.userInteractionEnabled = NO;
            [self.AuthBtn  setBackgroundImage:[UIImage  imageNamed:@"set_authorization"] forState:UIControlStateNormal];
            self.AuthBtn.userInteractionEnabled = NO;
            [self.LogListBtn  setBackgroundImage:[UIImage  imageNamed:@"set_record"] forState:UIControlStateNormal];
            self.LogListBtn.userInteractionEnabled = NO;
            [self.PhotoBtn  setBackgroundImage:[UIImage  imageNamed:@"reset_name"] forState:UIControlStateNormal];
            self.PhotoBtn.userInteractionEnabled = NO;
            [self.UserMessageBtn  setBackgroundImage:[UIImage  imageNamed:@"set_user_ed"] forState:UIControlStateNormal];
            self.UserMessageBtn.userInteractionEnabled = YES;
        }
    }else {
        self.PhotoBtn.hidden = NO;
        self.PhotoLabel.hidden = NO;
        self.AuthBtn.hidden = NO;
        self.AuthLabel.hidden = NO;
        self.UserSetBtn.hidden = NO;
        self.UserSetLabel.hidden = NO;
        self.LogListBtn.hidden = NO;
        self.LogListLabel.hidden = NO;
        [self.RemoteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.BackImgView.mas_bottom).offset(getHeight(30));
            make.size.mas_equalTo(CGSizeMake(getWidth(64), getWidth(64)));
            make.right.equalTo(self.view.mas_right).offset(getWidth(-46));
        }];
        [self.RemoteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.RemoteBtn);
            make.top.equalTo(self.RemoteBtn.mas_bottom).offset(getHeight(6));
            make.size.mas_equalTo(CGSizeMake(getWidth(150), getHeight(21)));
        }];
        
        [self.UserMessageBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.RemoteLabel.mas_bottom).offset(getHeight(10));
            make.size.mas_equalTo(CGSizeMake(getWidth(64), getWidth(64)));
            make.right.equalTo(self.view.mas_right).offset(getWidth(-46));
        }];
        [self.UserMessageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.UserMessageBtn);
            make.top.equalTo(self.UserMessageBtn.mas_bottom).offset(getHeight(6));
            make.size.mas_equalTo(CGSizeMake(getWidth(150), getHeight(21)));
        }];
        
        if (self.deviceModel) {
            [self.RemoteBtn setBackgroundImage:[UIImage imageNamed:@"set_lock_ed"] forState:UIControlStateNormal];
            self.RemoteBtn.userInteractionEnabled = YES;
            [self.UserSetBtn setBackgroundImage:[UIImage imageNamed:@"btn_shezhi"] forState:UIControlStateNormal];
            self.UserSetBtn.userInteractionEnabled = YES;
             [self.LogListBtn setBackgroundImage:[UIImage imageNamed:@"set_record_ed"] forState:UIControlStateNormal];
            self.LogListBtn.userInteractionEnabled = YES;
            [self.PhotoBtn  setImage:[UIImage  imageNamed:@"reset_name_ed"] forState:UIControlStateNormal];
            self.PhotoBtn.userInteractionEnabled = YES;
            NSInteger unlockType = [[UserManger sharedInstance] getUnlockType];
            if (self.deviceModel.userType == 0) {//主管理员
                [self.AuthBtn setBackgroundImage:[UIImage imageNamed:@"set_authorization_ed"] forState:UIControlStateNormal];
                self.AuthBtn.userInteractionEnabled = YES;
            }else {
                [self.AuthBtn setBackgroundImage:[UIImage imageNamed:@"set_authorization"] forState:UIControlStateNormal];
                self.AuthBtn.userInteractionEnabled = NO;
            }
            
            if (unlockType == 1) {//wifi解锁
                [self.PhotoBtn setBackgroundImage:[UIImage imageNamed:@"btn_shexiang"] forState:UIControlStateNormal];
//                self.PhotoBtn.userInteractionEnabled = YES;
            }
            self.NotesLabel.text=@"锁已关闭";
        }else{
            [self.RemoteBtn setBackgroundImage:[UIImage imageNamed:@"set_lock"] forState:UIControlStateNormal];
            self.RemoteBtn.userInteractionEnabled = NO;
            [self.UserSetBtn setBackgroundImage:[UIImage imageNamed:@"set_setting"] forState:UIControlStateNormal];
            self.UserSetBtn.userInteractionEnabled = NO;
            [self.LogListBtn setBackgroundImage:[UIImage imageNamed:@"set_record"] forState:UIControlStateNormal];
            self.LogListBtn.userInteractionEnabled = NO;
            [self.AuthBtn setBackgroundImage:[UIImage imageNamed:@"set_authorization"] forState:UIControlStateNormal];
            self.AuthBtn.userInteractionEnabled = NO;
            [self.PhotoBtn setBackgroundImage:[UIImage imageNamed:@"reset_name"] forState:UIControlStateNormal];
            self.PhotoBtn.userInteractionEnabled = NO;
            
            self.NotesLabel.text=@"无设备";
        }
    }
}

- (void) TimeOutLogin
{
    NSDictionary *params = @{
                             @"phone":[[UserManger sharedInstance] getUserPhone],
                             @"password":[[UserManger sharedInstance] getUserPassWord]
                             };
    [MBProgressHUD showActivityMessageInView:@""];
    [HttpTool postWithURL:NETWORK_REQUEST_URL(USER_LOGIN_URL) params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        NSLog(@"%@",json);
        int status = [json[@"success"] intValue];
        if (status == 1) {
            UserManger *manage = [UserManger sharedInstance];
            [manage cacheUserPhone:json[@"data"][@"phone"]];
            [manage cacheUserName:json[@"data"][@"phone"]];
            [manage cacheUserId:json[@"data"][@"id"]];
            if(![json[@"data"][@"pic"] isEqual:[NSNull null]])
            {
                [manage cacheHeadPortrait:json[@"data"][@"pic"]];
            }
            [manage cacheUserNickname:json[@"data"][@"nickName"]];
            [manage cacheMemberToken:json[@"data"][@"token"]];
            [MBProgressHUD showSuccessMessage:@"重新登录成功"];
            [self loadData];
            AppDelegate *app =(AppDelegate*)[[UIApplication sharedApplication] delegate];
            [app setTags:json[@"data"][@"id"]];
        }else{
            [MBProgressHUD showErrorMessage:json[@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showTipMessageInView:[error localizedDescription]];
    }];
}

#pragma mark -代理
-(void)menu:(AddDeviceView *)menu tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath DeviceName:(NSString *)name
{
    self.deviceModel = self.menuArray[indexPath.row];
    NSInteger unlockType = [[UserManger sharedInstance] getUnlockType];
    if (unlockType == 2) {
        if (SY_BLE_MANAGER.isBLEOn == NO) {
            [SY_BLE_MANAGER presentAlertVC];
        }else {
            if (SY_BLE_MANAGER.isConnected == NO || ![SY_BLE_MANAGER.macAddress isEqualToString:self.deviceModel.mac]) {
                [MBProgressHUD showActivityMessageInView:@"正在连接"];
                [SY_BLE_MANAGER startConnectTargetDevice:self.deviceModel.mac];
            }
        }
    }
    
    self.nameBtn.userInteractionEnabled = YES;
    [self.deviceView backgroundTapped];
    [self refreshDeviceNameWithName:name];
    self.NotesLabel.text = @"锁已关闭";
    
    [self refreshButtonUI];
    
}

-(void)tableView:(UITableView *)tableView deleteDeviceAtIndexPath:(NSIndexPath *)indexPath{
    [self.alert  removeFromSuperview];
    DeviceModel *device = [DeviceModel  mj_objectWithKeyValues:self.deviceAry[indexPath.row]];
    
    if (device.userType != 0) {
        [MBProgressHUD showWarnMessage:@"抱歉，你非超级管理员，暂无权限！"];
        return;
    }
    if ([SY_BLE_MANAGER.connectDeviceModel.mac isEqualToString:device.mac]) {
        [SY_BLE_MANAGER breakUpDeviceMacAddress:device.mac];
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"删除设备" message:@"删除设备相应的数据也会删除" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary *params = @{
                                 @"id":device.id,
                                 };
        DDLog(@"CANCEL_BINDING_URL:%@;params:%@",(CANCEL_BINDING_URL),params);
        [MBProgressHUD showActivityMessageInView:@"正在删除"];
        NSString *httpUrl = [NSString stringWithFormat:@"%@/%@",NETWORK_REQUEST_URL(Delete_Device_URL),[[UserManger sharedInstance] getMemberToken]];
        [HttpTool postWithURL:httpUrl params:params success:^(id json) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccessMessage:@"删除成功"];
            NSLog(@"result:%@",json);
            int code = [json[@"code"] intValue];
            if (code == 0) {
                [self.deviceAry removeObjectAtIndex:indexPath.row];
                if (self.deviceAry.count==0) {
                    [[NSUserDefaults  standardUserDefaults] removeObjectForKey:@"selectedLock"];
                }
                if ([self.deviceModel.mac isEqualToString:device.mac]) {
                    self.deviceModel = nil;
                    [self refreshButtonUI];
                    [self refreshDeviceNameWithName:nil];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tableView reloadData];
                });
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
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(NSMutableArray*)menu_DataArray
{
    return self.menuArray;
}

-(NSMutableArray*)menuArray
{
    if (!_menuArray) {
        _menuArray = [NSMutableArray array];
    }
    return _menuArray;
}

-(AddDeviceView *)deviceView
{
    if (!_deviceView) {
        _deviceView =[[AddDeviceView alloc] init];
        _deviceView.delegate =self;
        _deviceView.dataSource =self;
    }
    return _deviceView;
}

-(void)listBtnClicked
{
    if (!self.deviceAry.count) {
        [self loadData];
    }
    [self.deviceView menuTappedWithSuperView:self.view];
}

- (void)rightItemClicked {
    NSInteger unlockType = [[UserManger sharedInstance] getUnlockType];
//    UIViewController *ctl;
    if (unlockType == 1) {
        WifiConnectController*ctl =[[WifiConnectController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
    }else{
        AddDeviceController *ctl =[[AddDeviceController alloc] init];
        ctl.deviceArr =self.deviceAry;
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

#pragma mark 按钮点击事件
-(void)BtnActionCilck:(UIButton*)button
{
   switch (button.tag) {
       case 10:{
//           PhotolistController *vc1 =[[PhotolistController alloc] init];
//           vc1.device = self.deviceModel;
//           [self.navigationController pushViewController:vc1 animated:YES]; // 拍照相关
           
          
        [self  editDeviceNameBtnClicked];
       }
            break;
       case 20:{
           ManagerController *vc2 =[[ManagerController alloc] init];
           vc2.device = self.deviceModel;
           [self.navigationController pushViewController:vc2 animated:YES]; // 授权管理
       }
            break;
       case 30:{
           WEAK_SELF
               NSInteger unlockType = [[UserManger sharedInstance] getUnlockType];
               if (unlockType == 2) {
                   if (SY_BLE_MANAGER.isConnected == NO) {
                       _alert = [[NDAtableviewAlert  alloc]initWithFrame:self.view.window.frame];
//                       _alert.dataArr = [[NSMutableArray  alloc]initWithArray:self.deviceAry];//self.deviceAry
                       [self  loadData];
                       _alert.deleteLock = ^(NSIndexPath *index) {
                           [weakSelf  tableView:weakSelf.alert.tableview deleteDeviceAtIndexPath:index];
                       };
                       _alert.changeLock = ^(NSDictionary * _Nonnull dic) {
                           NSDictionary *selectDic =@{@"deviceID":dic[@"id"],@"deviceName":dic[@"name"]};
                           [[NSUserDefaults  standardUserDefaults]  setObject:selectDic forKey:@"selectedLock"];
                           for (NSDictionary *dic1 in weakSelf.deviceAry) {
                               if ([dic1[@"id"]  isEqualToString:dic[@"id"]]) {
                                   weakSelf.deviceModel = [DeviceModel  mj_objectWithKeyValues:dic];
                                   [[UserManger sharedInstance]cacheCaramaDid:weakSelf.deviceModel.videoId];
                                   break;
                               }
                           }
                           [MBProgressHUD showActivityMessageInView:@"正在连接设备"];
                           [SY_BLE_MANAGER startConnectTargetDevice:weakSelf.deviceModel.mac];
                           [weakSelf refreshButtonUI];
                           [weakSelf refreshDeviceNameWithName:dic[@"name"]];
                       };
                       [self.view.window  addSubview:_alert];
                   }else {
                       if ([self.deviceModel.openPwd isEqualToString:@""]) {
                           [MBProgressHUD showWarnMessage:@"密码未设，请先设置密码"];
                           return;
                       }
                       if ([self canOpenLock]) {
                           [self showInputAlertView:@"inputPW"];
                       }else {
                           [MBProgressHUD showWarnMessage:@"当前时间段没有权限开锁"];
                       }
                   }
               }else{
                   
                   _alert = [[NDAtableviewAlert  alloc]initWithFrame:self.view.window.frame];
                   //                       _alert.dataArr = [[NSMutableArray  alloc]initWithArray:self.deviceAry];//self.deviceAry
                   [self  loadData];
                   _alert.deleteLock = ^(NSIndexPath *index) {
                       [weakSelf  tableView:weakSelf.alert.tableview deleteDeviceAtIndexPath:index];
                   };
                   _alert.changeLock = ^(NSDictionary * _Nonnull dic) {
                       NSDictionary *selectDic =@{@"deviceID":dic[@"id"],@"deviceName":dic[@"name"]};
                       [[NSUserDefaults  standardUserDefaults]  setObject:selectDic forKey:@"selectedLock"];
                       for (NSDictionary *dic1 in weakSelf.deviceAry) {
                           if ([dic1[@"id"]  isEqualToString:dic[@"id"]]) {
                               weakSelf.deviceModel = [DeviceModel  mj_objectWithKeyValues:dic];
                               [[UserManger sharedInstance]cacheCaramaDid:weakSelf.deviceModel.videoId];
                               break;
                           }
                       }
                       [weakSelf refreshButtonUI];
                       [weakSelf refreshDeviceNameWithName:dic[@"name"]];
                       
                       
//                       NSLog(@"abc--%@--%@",selectDic,self.deviceModel.mj_JSONObject);
                       
                       SYRemoteControlVC *vc3 =[[SYRemoteControlVC alloc] init];
                       vc3.device = weakSelf.deviceModel;
                       [weakSelf.navigationController pushViewController:vc3 animated:YES]; // 远程开锁
                   };
                   [self.view.window  addSubview:_alert];
                   
                   
                   //               SYIncomingCallController *vc3 =[[SYIncomingCallController alloc] init];
                   //               vc3.device = self.deviceModel;
                   //               [self.navigationController pushViewController:vc3 animated:YES];
                   // 远程开锁
//                   RemotecontrolController *vc3 =[[RemotecontrolController alloc] init];
//                   self.deviceModel.videoId = @"IKB-000120-TTKGV";
//                   self.deviceModel.videoPwd = @"saiyimcu987654321";
//                   self.deviceModel.videoUser = @"D-Link_DIR-816";
//                   vc3.device = self.deviceModel;
//                   [self.navigationController pushViewController:vc3 animated:YES]; // 远程开锁
               }
           

       }
            break;
       case 40:{
           UsersetController *vc4 =[[UsersetController alloc] init];
           vc4.device = self.deviceModel;
           [self.navigationController pushViewController:vc4 animated:YES]; // 相关设置
       }
            break;
       case 50:{
           LoglistController *vc5 =[[LoglistController alloc] init];
           vc5.device = self.deviceModel;
           [self.navigationController pushViewController:vc5 animated:YES]; // 开锁记录
       }
            break;
       case 60:{
           UsermessageController *vc6 =[[UsermessageController alloc] init];
           vc6.device = self.deviceModel;
           [self.navigationController pushViewController:vc6 animated:YES]; // 用户信息
       }
            break;
        default:
            break;
    }
    
}

#pragma mark - 判断开锁时间
- (BOOL)canOpenLock {
    if (self.deviceModel.userType != 2) {
        return YES;
    }
    BOOL isNowTimeSpace = NO;
    //天
    NSArray *lockTimeList = self.deviceModel.weeks;  //[SYlockTimeModel mj_objectArrayWithKeyValuesArray:self.deviceModel.weeks];
    //时间段
    NSArray *lockPeriodList = self.deviceModel.times; //[SYLockPeriodModel mj_objectArrayWithKeyValuesArray:self.deviceModel.times];
//    NSDate *nowDate = [Helper getLocalDate];
    NSInteger today = [Helper weekday:[NSDate date]];
    for (NSString *week in lockTimeList) {
        //判断当前日期是不是今天
        if ([week integerValue] == today) {
            //判断时间段
            for (int i = 0; i<lockPeriodList.count; i++) {
                NSString *lockPeriod = lockPeriodList[i];
                if (lockPeriod.length) {
                    NSArray *periodArray =  [lockPeriod componentsSeparatedByString:@"-"];//分隔符;
                    if (periodArray.count == 2) {
                        isNowTimeSpace = [self judgeTimeByStartAndEnd:periodArray[0] withExpireTime:periodArray[1]];
                    }
                }
                if (isNowTimeSpace) {
                    break;
                }
            }
        }
    }
    return isNowTimeSpace;
}

- (BOOL)judgeTimeByStartAndEnd:(NSString *)startTime withExpireTime:(NSString *)expireTime {
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // 时间格式,此处遇到过坑,建议时间HH大写,手机24小时进制和12小时禁止都可以完美格式化
    [dateFormat setDateFormat:@"HH:mm"];
    NSString * todayStr=[dateFormat stringFromDate:today];//将日期转换成字符串
    today=[ dateFormat dateFromString:todayStr];//转换成NSDate类型。日期置为方法默认日期
    //startTime格式为 02:22   expireTime格式为 12:44
    NSDate *start = [dateFormat dateFromString:startTime];
    NSDate *expire = [dateFormat dateFromString:expireTime];
    
    if ([today compare:start] == NSOrderedDescending && [today compare:expire] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}

#pragma mark --- SYBLEManager not
//蓝牙状态改变
- (void)bleStateChanged:(NSNotification *)notification {
    [MBProgressHUD hideHUD];
    if ([linkType isEqualToString:@"2"] ) {
        [SY_BLE_MANAGER presentAlertVC];
    }
}

//设备连接成功
- (void)connectionBuild:(NSNotification *)notification {
    //连接成功之后发送校验命令
    NSMutableString *orderStr = [NSMutableString stringWithString:@"5AA53008FFFFFFFFFFFFFFFF"];
    //拼接校验码
    [orderStr appendString:[Helper stylestring:orderStr]];
    [SY_BLE_MANAGER write:[Helper mutString:orderStr]];
}

//设备连接失败
- (void)connectFail:(NSNotification *)notification {
    [MBProgressHUD hideHUD];
    [MBProgressHUD showErrorMessage:@"设备断开连接"];
}

//设备回调数据
- (void)didUpdateData:(NSNotification *)notification {
    NSData *currentData = (NSData *)notification.object;
    NSString *result = [Helper hexStringFromData:currentData];
    if (result.length >= 6) {
        NSString *order = [result substringWithRange:NSMakeRange(4, 2)];
        NSString *success = [result substringWithRange:NSMakeRange(6, 2)];
        if ([order isEqualToString:@"34"]) {
            //修改密码成功
            [self loadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BlueToothChangePassWord" object:nil];
        }
        if ([order isEqualToString:@"30"]) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccessMessage:@"设备已连接"];
            NSMutableString *orderStr = [NSMutableString stringWithString:@"5AA53208FFFFFFFFFFFFFFFF"];
            //拼接校验码
            [orderStr appendString:[Helper stylestring:orderStr]];
            //获取电量
            [SY_BLE_MANAGER write:[Helper mutString:orderStr]];
        }
        if ([order isEqualToString:@"32"] || [order isEqualToString:@"35"]) {
            //获取电量成功
            NSString *power = [result substringWithRange:NSMakeRange(8, 2)];
            float powerValue = [[Helper hexStringFromString:power] integerValue]*0.1;
            self.EnergyLabel.text = [NSString stringWithFormat:@"%.1f%@",powerValue,@"V"];
            
            if (self.deviceModel.low && powerValue < 4.5) {
                //低电量提醒
                [MBProgressHUD showWarnMessage:@"设备电量过低，请及时充电"];
            }
        }
        if ([order isEqualToString:@"33"]){//开锁成功上传开锁记录
            [MBProgressHUD hideHUD];
            NSString *openValue = [success isEqualToString:@"01"] ? @"1" : @"0";
            if ([openValue isEqualToString:@"1"]) {
                [MBProgressHUD showTipMessageInView:@"开锁成功"];
                self.NotesLabel.text = @"锁已开启";
                [self  performSelector:@selector(delayAction) withObject:nil afterDelay:5.0];
                [self.deviceListBtn setImage:[UIImage imageNamed:@"bt_unlock"] forState:UIControlStateNormal];
            }
            else
            {
                [MBProgressHUD showTipMessageInView:@"开锁失败"];
            }
            NSDictionary *dic = [[NSUserDefaults  standardUserDefaults] objectForKey:@"selectedLock"];
            NSString *idStr;
            if (dic!=nil) {
                idStr = dic[@"deviceID"];
            }else{
                idStr = self.deviceModel.id;
            }
            NSDictionary *params = @{
                                     @"deviceId":idStr,
                                     @"openType":@"0",
                                     @"openValue":openValue,
                                     @"userType":[NSString stringWithFormat:@"%ld",self.deviceModel.userType],
                                     };
            NSString *httpUrl = [NSString stringWithFormat:@"%@/%@",NETWORK_REQUEST_URL(UPLOAD_LOG_URL),[[UserManger sharedInstance] getMemberToken]];
            [HttpTool postWithURL:httpUrl params:params success:^(id json) {
                NSLog(@"上传开锁记录:%@",json);
                int code = [json[@"code"] intValue];
                if (code == TimeOutCode)
                {
                    [MBProgressHUD showTipMessageInView:json[@"登录超时，请重新登录"]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_TimeOut_Login object:nil];
                }
                else
                {
//                    [MBProgressHUD showTipMessageInView:json[@"message"]];
                }
            } failure:^(NSError *error) {
                
            }];
        }
    }
}
-(void)delayAction{
    
    self.NotesLabel.text =@"锁已关闭";
    [self.deviceListBtn setImage:[UIImage imageNamed:@"bt_lock"] forState:UIControlStateNormal];
    
}
- (void)dealloc{
    kCancelALLNotification
}

@end
