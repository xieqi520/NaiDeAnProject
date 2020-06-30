//
//  SYPermissionSettingViewController.m
//  Naidean
//
//  Created by aoxin on 2018/8/17.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "SYPermissionSettingViewController.h"
#import "SYPermissionTableViewCell.h"
#import "SYUnlockTimeTableViewCell.h"
#import "SYTimeSettingTableViewCell.h"
#import "SYWeekSettingTableViewController.h"
#import "SYTimePickerView.h"

@interface SYPermissionSettingViewController ()<UITableViewDelegate,UITableViewDataSource,SYTimePickerViewDelegate,UITextFieldDelegate>

@property (strong, nonatomic)SYTimePickerView *timePicker;
@property (copy, nonatomic)NSArray *unlockDays;

@end

@implementation SYPermissionSettingViewController
{
    UITableView *permissionTableView;
    BOOL isNurse;
    UIButton *currentBtn;
    BOOL _firstSelect;
    BOOL _secondSelect;
    BOOL _thirdSelect;
}

- (NSArray *)unlockDays{
    if (!_unlockDays) {
        _unlockDays = [NSArray array];
        _unlockDays = _authorizedModel.weeks.count > 0 ? _authorizedModel.weeks:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
    }
    return _unlockDays;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    UIBarButtonItem *rightBtn =[[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"完成"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClicked)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    permissionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, WIN_HEIGHT - 64) style:UITableViewStyleGrouped];
    permissionTableView.delegate = self;
    permissionTableView.dataSource = self;
    permissionTableView.backgroundColor = SetColor(@"#F5F1F1");
    permissionTableView.separatorInset = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {   // ios11系统下 处理页面push或Pop时屏幕移动
        permissionTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [permissionTableView registerNib:[UINib nibWithNibName:@"SYPermissionTableViewCell" bundle:nil] forCellReuseIdentifier:@"PermissionCell"];
    [permissionTableView registerNib:[UINib nibWithNibName:@"SYUnlockTimeTableViewCell" bundle:nil] forCellReuseIdentifier:@"UnlockCell"];
    [permissionTableView registerNib:[UINib nibWithNibName:@"SYTimeSettingTableViewCell" bundle:nil] forCellReuseIdentifier:@"TimeSettingCell"];
    UIView *view =[[UIView alloc] initWithFrame:CGRectZero];
    permissionTableView.tableFooterView = view;
    permissionTableView.scrollEnabled = NO;
    [self.view addSubview:permissionTableView];
    
    isNurse = self.authorizedModel.userType == 2;
    
    self.timePicker = [[SYTimePickerView alloc] initWithFrame:CGRectMake(0, WIN_HEIGHT-250, WIN_WIDTH, 250)];
    self.timePicker.delegate = self;
    [self.view   addSubview:self.timePicker];
    self.timePicker.hidden = YES;
    
    
    _firstSelect =0;
    _secondSelect =0;
    _thirdSelect =0;
}

-(void)rightBtnClicked{
    NSDictionary *params = nil;
    if (isNurse) {
        //权限修改为保姆 || 修改保姆属性
        NSLog(@"权限修改为保姆%@",self.unlockDays);
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
        NSMutableArray *lockDaysAry = [NSMutableArray array];
        NSUInteger aryCount = self.unlockDays.count;
        
        for (NSInteger i = 0; i < aryCount; i++) {
            [lockDaysAry addObject:self.unlockDays[i]];
        }
        
        SYTimeSettingTableViewCell *cell = [permissionTableView cellForRowAtIndexPath:indexPath];
        NSMutableArray *lockPeriodList = [[NSMutableArray  alloc]init];
        if (_firstSelect) {
            [lockPeriodList  addObject:cell.firstBtn.titleLabel.text];
        }
        if (_secondSelect) {
            [lockPeriodList  addObject:cell.secondBtn.titleLabel.text];
        }
        if (_thirdSelect) {
            [lockPeriodList  addObject:cell.thirdBtn.titleLabel.text];
        }
        if (lockPeriodList.count==0) {
            [MBProgressHUD  showWarnMessage:@"请选择开锁时间"];
            return;
        }
        params = @{
                   @"memoName":self.authorizedModel.memoName,
                   @"userType":@"2",
                   @"id":self.authorizedModel.id,//授权ID
                   @"week":[lockDaysAry copy],      //开锁天数（[{"lockTime":1},{"lockTime":2}]，周日为1，周一为2......周六为7，每天为8）
                   @"times":lockPeriodList    //开锁时段 格式："lockPeriodList":[{"lockPeriod":"8:00-10:00","lockPeriod":"12:00-14:00","lockPeriod":"17:00-19:00"}]）
                   };
        DDLog(@"ADD_NURSE_URL:%@;params:%@",NETWORK_REQUEST_URL(ADD_NURSE_URL),params);
        
    }else if (!isNurse){
        //权限修改为普通管理员
        NSLog(@"权限修改为普通管理员");
        params = @{
                   @"memoName":self.authorizedModel.memoName,
                   @"userType":@"1",
                   @"id":self.authorizedModel.id,//授权ID
                   @"weeks":@[@"1",@"2",@"3",@"4",@"5",@"6",@"7"],
                   };
        DDLog(@"权限修改为普通管理员:%@;params:%@",NETWORK_REQUEST_URL(BINDING_DEVICES_URL),params);
    }
    [MBProgressHUD showActivityMessageInView:@""];
    NSString *httpUrl = [NSString stringWithFormat:@"%@/%@",NETWORK_REQUEST_URL(ADD_NURSE_URL),[[UserManger sharedInstance] getMemberToken]];
    [HttpTool postWithURL:httpUrl params:params success:^(id json) {
        NSLog(@"result:%@",json);
        [MBProgressHUD hideHUD];
        int code = [json[@"code"] intValue];
        if (code == 1000) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AuthManagerDidChanged" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
        if (code == TimeOutCode)
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

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger num;
    if (isNurse) {
        num = 2;
    }else{
        num = 1;
    }
    return num;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 60.f;
    }else{
        if (indexPath.row == 0) {
            return 44.f;
        }else{
            return 60.f;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        SYPermissionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PermissionCell"];
        if (indexPath.row == 0) {
            cell.permissionLab.text = @"普通管理员";
            if (!isNurse) {
                cell.selectBtn.selected = YES;
            }else{
                cell.selectBtn.selected = NO;
            }
        }else{
            cell.permissionLab.text = @"临时管理员";
            if (isNurse) {
                cell.selectBtn.selected = YES;
            }else{
                cell.selectBtn.selected = NO;
            }
        }
        [cell sharedInstanceWithMode:permissionMode];
        return cell;
    }else {
        if (indexPath.row == 0) {
            SYUnlockTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UnlockCell"];
            cell.titleLab.text = @"开锁时间";
            cell.subTitleLab.text = [self getSubTitleStringWithArray:self.unlockDays];
            return cell;
        }else{
            SYTimeSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeSettingCell"];
            [cell.firstBtn  addTarget:self action:@selector(firstBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.secondBtn  addTarget:self action:@selector(secondBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.thirdBtn  addTarget:self action:@selector(thirdBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            //            [cell displayWithTimePicker:self.timePicker AuthorizedUserModel:self.authorizedModel];
            //            cell.firstTF.delegate = self;
            //            cell.secondTF.delegate = self;
            //            cell.thirdTF.delegate = self;
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            isNurse = YES;
        }else{
            isNurse = NO;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableView reloadData];
        });
    }else{
        if (indexPath.row == 0) {
            SYWeekSettingTableViewController *weekSettingVC = [[SYWeekSettingTableViewController alloc] init];
            //            weekSettingVC.unlockDays = [NSMutableArray arrayWithArray:self.unlockDays];
            MJWeakSelf
            weekSettingVC.selectDaysBlock = ^(NSArray *days){
                weakSelf.unlockDays = days;
                SYUnlockTimeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.subTitleLab. text = [self getSubTitleStringWithArray:days];
            };
            [self.navigationController pushViewController:weekSettingVC animated:YES];
        }
    }
}

- (NSString *)getSubTitleStringWithArray:(NSArray *)ary{
    NSString *string = @"";
    if (ary.count == 7){//([ary containsObject:@"8"]) {
        string = @"每天";
    }else{
        NSMutableString *subTitle = [[NSMutableString alloc] init];
        for (NSInteger i = 0; i < ary.count; i++) {
            switch ([ary[i] integerValue]) {
                case 1:
                    [subTitle appendString:@"日、"];
                    break;
                case 2:
                    [subTitle appendString:@"一、"];
                    break;
                case 3:
                    [subTitle appendString:@"二、"];
                    break;
                case 4:
                    [subTitle appendString:@"三、"];
                    break;
                case 5:
                    [subTitle appendString:@"四、"];
                    break;
                case 6:
                    [subTitle appendString:@"五、"];
                    break;
                case 7:
                    [subTitle appendString:@"六、"];
                    break;
                default:
                    break;
            }
        }
        string = [subTitle stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
    }
    return string;
}

#pragma mark - SYTimePickerViewDelegate

- (void)timePickerViewSaveBtnClick:(NSString *)timer{
    currentBtn.titleLabel.text = timer;
    //    [currentTF resignFirstResponder];
}

- (void)timePickerViewCancelBtnClick{
    //    SYTimeSettingTableViewCell *cell = [permissionTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    
    //    [currentTF resignFirstResponder];
}

//#pragma mark - UITextFieldDelegate
//- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    currentBtn = textField;
//    [self.timePicker setDefaultDateWithString:textField.text];
//}
-(void)firstBtnAction:(UIButton *)firstBtn{
    _firstSelect=!_firstSelect;
    currentBtn = firstBtn;
    if (_firstSelect ==0) {
        firstBtn.backgroundColor = SYColor(138, 138, 138);//[UIColor  colorWithRed:138 green:138 blue:138 alpha:1.0];
    }else{
        firstBtn.backgroundColor = SYColor(255, 111, 9);//[UIColor  colorWithRed:255 green:111 blue:9 alpha:1.0];
        [self.timePicker setDefaultDateWithString:firstBtn.titleLabel.text];
        self.timePicker.hidden = NO;
    }
    
}
-(void)secondBtnAction:(UIButton *)secondBtn{
    _secondSelect=!_secondSelect;
    currentBtn = secondBtn;
    if (_secondSelect ==0) {
        secondBtn.backgroundColor = SYColor(138, 138, 138);//[UIColor  colorWithRed:138 green:138 blue:138 alpha:1.0];
    }else{        
        secondBtn.backgroundColor =  SYColor(255, 111, 9);//[UIColor  colorWithRed:255 green:111 blue:9 alpha:1.0];
        [self.timePicker setDefaultDateWithString:secondBtn.titleLabel.text];
        self.timePicker.hidden = NO;
    }

    
}
-(void)thirdBtnAction:(UIButton *)thirdBtn{
    _thirdSelect = !_thirdSelect;
    currentBtn = thirdBtn;
    if (_thirdSelect ==0) {
        thirdBtn.backgroundColor = SYColor(138, 138, 138);//[UIColor  colorWithRed:138 green:138 blue:138 alpha:1.0];
    }else{
        thirdBtn.backgroundColor =  SYColor(255, 111, 9);//[UIColor  colorWithRed:255 green:111 blue:9 alpha:1.0];
        [self.timePicker setDefaultDateWithString:thirdBtn.titleLabel.text];
        self.timePicker.hidden = NO;
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
