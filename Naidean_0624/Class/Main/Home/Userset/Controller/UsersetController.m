//
//  UsersetController.m
//  Naidean
//
//  Created by xujun on 2018/1/4.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "UsersetController.h"
#import "SetCell.h"
#import "ResetPSViewController.h"
#import "WifiConnectController.h"

@interface UsersetController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation UsersetController
{
    NSMutableArray *dataArr;
    UITableView *Settableview;
    NSInteger unlockType;
}

- (void)viewDidLoad {
    [super viewDidLoad];  
    self.title=@"密码设置";
    unlockType = [[UserManger sharedInstance] getUnlockType];
    dataArr =[[NSMutableArray alloc] initWithObjects:@"无人模式报警",@"防撬报警",@"低电报警",@"开锁密码设置",@"重新配网", nil];
    
    Settableview =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, WIN_HEIGHT-64)];
    [Settableview registerNib:[UINib nibWithNibName:@"SetCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    Settableview.delegate=self;
    Settableview.dataSource=self;
    Settableview.rowHeight = getWidth(52);
    if (@available(iOS 11.0, *)) {
        Settableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    Settableview.separatorColor =[UIColor colorWithHexString:@"e1e1e1" alpha:1];
    Settableview.backgroundColor=[UIColor colorWithHexString:@"#f5f5f9" alpha:1];
    UIView *view =[[UIView alloc] initWithFrame:CGRectZero];
    Settableview.tableFooterView = view;
    Settableview.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:Settableview];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((unlockType == 2 && (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 4)) || (self.device.userType == 2 && indexPath.row == 2)) {
        return 0;
    }else{
        return 60.f;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WS(weakSelf);
    SetCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.Setname.text =[dataArr objectAtIndex:indexPath.row];
    if ((unlockType == 2 && (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 4)) || (self.device.userType == 2 && indexPath.row == 2)) {
        cell.hidden = YES;
    }
    
    if (indexPath.row == 3 || indexPath.row == 4) {
        cell.Switch.hidden =YES;
        cell.Nextiamgeview.hidden = NO;
    }else{
        switch (indexPath.row) {
            case 0:{
                if (unlockType == 2) {
                    cell.hidden = YES;
                }else{
                    cell.Switch.on = self.device.unmanned;
                }
            }
                break;
            case 1:{
                if (unlockType == 2) {
                    cell.hidden = YES;
                }else{
                    cell.Switch.on = self.device.prying;
                }
            }
                break;
            case 2:
                cell.Switch.on = self.device.low;
                break;
            default:
                break;
        }
    }
    cell.SwitchBlock = ^(UITableViewCell *cell, BOOL Switch) {
          NSIndexPath *index =[tableView indexPathForCell:cell];
        [weakSelf indexpath:index Setwitch:Switch];
    };
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 3) {
        ResetPSViewController *vc=[[ResetPSViewController alloc] init];
        vc.reset = UnlockPassWord;
        vc.device = self.device;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 4){
        WifiConnectController *vc = [[WifiConnectController alloc] init];
        vc.hasBind = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

// 设置开关Switch
-(void)indexpath:(NSIndexPath*)index Setwitch:(BOOL)Switch
{
    NSString *phone = [NSString stringWithFormat:@"%@",[[UserManger sharedInstance] getUserPhone]];
    NSString *mac = [NSString stringWithFormat:@"%@",self.device.mac];
    if (index.row == 0) {
//        if (Switch) {
//            [Helper showTip:@"无人模式报警开启" withView:self.view];
//        }else
//        {
//            [Helper showTip:@"无人模式报警关闭" withView:self.view];
//        }
        
        NSString *no = [NSString stringWithFormat:@"%d",Switch];
        NSString *linkType = [NSString stringWithFormat:@"%zd",[[UserManger sharedInstance] getUnlockType]];
        NSDictionary *params = @{
                                 @"id":self.device.id,
                                 @"unmanned":no,
                                 };
        [self setDeviceAttributeWithUrl:NETWORK_REQUEST_URL(SET_NO_MODE_UEL) params:params];
    }
    if (index.row == 1) {
        if (Switch) {
           //  [Helper showTip:@"防撬报警开启" withView:self.view];
        }else
        {
           //  [Helper showTip:@"防撬报警关闭" withView:self.view];
        }
        NSString *pry = [NSString stringWithFormat:@"%d",Switch];
        NSString *linkType = [NSString stringWithFormat:@"%zd",[[UserManger sharedInstance] getUnlockType]];
        NSDictionary *params = @{
                                 @"id":self.device.id,
                                 @"prying":pry,
                                 };
        [self setDeviceAttributeWithUrl:NETWORK_REQUEST_URL(SET_PRTECT_MODE_URL) params:params];
    }
    if (index.row == 2) {
        if (Switch) {
            // [Helper showTip:@"低电报警开启" withView:self.view];
        }else
        {
            // [Helper showTip:@"低电报警关闭" withView:self.view];
        }
        NSString *low = [NSString stringWithFormat:@"%d",Switch];
        NSString *linkType = [NSString stringWithFormat:@"%zd",[[UserManger sharedInstance] getUnlockType]];
        NSDictionary *params = @{
                                 @"id":self.device.id,
                                 @"low":low,
                                 };
        [self setDeviceAttributeWithUrl:NETWORK_REQUEST_URL(SET_LOWPOWER_MODE_URL) params:params];
    }
}

- (void)setDeviceAttributeWithUrl:(NSString *)URL params:(NSDictionary *)params{
    DDLog(@"userSetUrl:%@;params:%@",URL,params);
    [MBProgressHUD showActivityMessageInView:@""];
    NSString *httpUrl = [NSString stringWithFormat:@"%@/%@",NETWORK_REQUEST_URL(SET_ALARM_REMINDER_URL),[[UserManger sharedInstance] getMemberToken]];
    [HttpTool postWithURL:httpUrl params:params success:^(id json) {
        NSLog(@"result:%@",json);
        [MBProgressHUD hideHUD];
        
        int code = [json[@"code"] intValue];
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
        [MBProgressHUD showTipMessageInWindow:[error localizedDescription]];
    }];
}

@end
