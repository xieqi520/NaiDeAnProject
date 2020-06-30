//
//  ManagerController.m
//  Naidean
//
//  Created by xujun on 2018/1/4.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "ManagerController.h"
#import "AdduserController.h"
#import "AuthuserCell.h"
#import "AuthheadView.h"
#import "AuthorizedUserModel.h"
#import "SYPermissionSettingViewController.h"

@interface ManagerController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) AuthheadView * HeadView;

@end

@implementation ManagerController
{
    NSMutableArray *dataArr;
    UITableView *Authtableview;
}

- (void)loadData{
    dataArr =[NSMutableArray array];
    NSString *phone = [NSString stringWithFormat:@"%@",[[UserManger sharedInstance] getUserPhone]];
    NSString *linkType = [NSString stringWithFormat:@"%zd",[[UserManger sharedInstance] getUnlockType]];
    NSDictionary *params = @{
                             @"deviceId":self.device.id,
                             };
    DDLog(@"GET_AUTHUSER_URL:%@;\nparams:%@",NETWORK_REQUEST_URL(GET_AUTHUSER_URL),params);
    [MBProgressHUD showActivityMessageInView:@""];
     NSString *httpUrl = [NSString stringWithFormat:@"%@/%@",NETWORK_REQUEST_URL(GET_AUTHUSER_URL),[[UserManger sharedInstance] getMemberToken]];
    [HttpTool postWithURL:httpUrl params:params success:^(id json) {
        NSLog(@"restult:%@",json);
        [MBProgressHUD hideHUD];
        int code = [json[@"code"] intValue];
        if (code == 1000) {
            [dataArr removeAllObjects];
            NSArray *authUsers = json[@"data"];
            for (NSInteger i = 0; i < authUsers.count; i++) {
                AuthorizedUserModel *authorizedUser = [[AuthorizedUserModel alloc] initWithJSON:authUsers[i]];
                if (authorizedUser.times.count == 0)
                {
                    authorizedUser.times = @[@"08:00-10:00",@"12:00-14:00",@"17:00-19:00"];
                }
                [dataArr addObject:authorizedUser];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [Authtableview reloadData];
            });
            
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title=@"权限管理";
    UIBarButtonItem *rightBtn =[[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"添加"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClicked)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
   // [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kSystemFontSize(15),NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    Authtableview =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, WIN_HEIGHT-64) style:(UITableViewStylePlain)];
    [Authtableview registerNib:[UINib nibWithNibName:@"AuthuserCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    Authtableview.delegate=self;
    Authtableview.dataSource =self;
    Authtableview.backgroundColor = SetColor(@"#F5F1F1");
    if (@available(iOS 11.0, *)) {
        Authtableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    _HeadView =[[AuthheadView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, getWidth(70))];
    _HeadView.backgroundColor = [UIColor whiteColor];
    _HeadView.Authname.text = [[UserManger sharedInstance] getUserName];
    NSString *headPath = NETWORK_REQUEST_URL([[UserManger sharedInstance] getHeadPortrait]);
    [_HeadView.Authimageview sd_setImageWithURL:[NSURL URLWithString:headPath] placeholderImage:[UIImage imageNamed:@"img_morentouxiang"]];
    Authtableview.tableHeaderView = _HeadView;

    UIView *view =[[UIView alloc] initWithFrame:CGRectZero];
    Authtableview.tableFooterView = view;
    Authtableview.separatorInset = UIEdgeInsetsZero;
    
    [self.view addSubview:Authtableview];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"AuthManagerDidChanged" object:nil];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self loadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return getHeight(60);
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AuthuserCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    AuthorizedUserModel *authorizedUser = [dataArr objectAtIndex:indexPath.row];
    cell.Authusername.text = authorizedUser.memoName;
    cell.authPhone.text = authorizedUser.phone;
    NSString *headPath = NETWORK_REQUEST_URL(authorizedUser.pic);
    [cell.AuthImageview sd_setImageWithURL:[NSURL URLWithString:headPath] placeholderImage:[UIImage imageNamed:@"img_morentouxiang"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SYPermissionSettingViewController *permissionSettionVC = [[SYPermissionSettingViewController alloc] init];
    permissionSettionVC.authorizedModel = [dataArr objectAtIndex:indexPath.row];
    permissionSettionVC.device = self.device;
    [self.navigationController pushViewController:permissionSettionVC animated:YES];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *action0 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"重命名" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        tableView.editing = NO;
        NSLog(@"点击了更名");
        [self showInputAlertViewAtIndexPath:indexPath];
    }];
    action0.backgroundColor = [UIColor colorWithHexString:@"#27D321" alpha:1];    
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self showTipAlertViewAtIndexPath:indexPath];
//        [dataArr removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    action1.backgroundColor = [UIColor colorWithHexString:@"#FE3824" alpha:1];
    return @[action1, action0];
    
}

-(void)rightBtnClicked
{
    AdduserController *vc=[[AdduserController alloc] init];
    vc.device = self.device;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AuthManagerDidChanged" object:nil];
}

- (void)showInputAlertViewAtIndexPath:(NSIndexPath *)indexPath{
    NSString *alertTitle = @"授权用户重命名";
    NSString *placeholder = @"请输入用户昵称";
    NSString *errorMessage = @"用户昵称不能为空";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle message:nil preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *remarkTF = alert.textFields.firstObject;
        if (remarkTF.text.length == 0) {
            [MBProgressHUD showTipMessageInView:errorMessage];
        }else{
            AuthorizedUserModel *authUser = dataArr[indexPath.row];
//            NSString *phone = [NSString stringWithFormat:@"%@",authUser.phone];
            NSString *remark = remarkTF.text;
//            NSString *mac = [NSString stringWithFormat:@"%@",authUser.deviceId];
//            NSString *linkType = [NSString stringWithFormat:@"%zd",[[UserManger sharedInstance] getUnlockType]];
            NSDictionary * params = @{
                                      @"memoName":remark,
                                      @"id":authUser.id,//授权ID
                                      };
            
            [MBProgressHUD showActivityMessageInView:@""];
            NSString *httpUrl = [NSString stringWithFormat:@"%@/%@",NETWORK_REQUEST_URL(UPDATE_REMARK_URL),[[UserManger sharedInstance] getMemberToken]];
            DDLog(@"UPDATE_REMARK_URL:%@;params:%@",httpUrl,params);
            [HttpTool postWithURL:httpUrl params:params success:^(id json) {
                NSLog(@"result:%@",json);
                [MBProgressHUD hideHUD];
                int code = [json[@"code"] intValue];
                if (code == 1000) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"AuthManagerDidChanged" object:nil];
//                    [self.navigationController popViewControllerAnimated:YES];
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
        
    }]];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = placeholder;
        AuthorizedUserModel *authUser = dataArr[indexPath.row];
        textField.text = authUser.memoName;
        
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showTipAlertViewAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"取消授权" message:@"确定要取消对该用户的授权吗？" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        AuthorizedUserModel *authUser = dataArr[indexPath.row];

        NSDictionary *params = @{
                                 @"id":authUser.id,
                                 };
        DDLog(@"CANCEL_BINDING_URL:%@;params:%@",NETWORK_REQUEST_URL(CANCEL_BINDING_URL),params);
        [MBProgressHUD showActivityMessageInView:@""];
        NSString *httpUrl = [NSString stringWithFormat:@"%@/%@",NETWORK_REQUEST_URL(CANCEL_BINDING_URL),[[UserManger sharedInstance] getMemberToken]];
        [HttpTool postWithURL:httpUrl params:params success:^(id json) {
            NSLog(@"result:%@",json);
            [MBProgressHUD hideHUD];
            int code = [json[@"code"] intValue];
            if (code == 1000) {
                [dataArr removeObjectAtIndex:indexPath.row];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Authtableview reloadData];
                });
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
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
