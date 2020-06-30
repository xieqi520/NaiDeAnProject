//
//  AdduserController.m
//  Naidean
//
//  Created by xujun on 2018/1/5.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "AdduserController.h"
#import "AuthCell.h"

@interface AdduserController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchTF;

@end

@implementation AdduserController
{
    UITableView *Addtableview;
    NSMutableArray *dataArr;
    BOOL select;
    NSString *userPhone;
    NSInteger Selectrow;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"添加管理员";
    UIBarButtonItem *rightBtn =[[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"搜索"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClicked)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    self.searchTF.placeholder = @"搜索账号";
    self.searchTF.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    CGFloat height = WIN_HEIGHT - 64 - self.searchTF.size.height;
    Addtableview =[[UITableView alloc] initWithFrame:CGRectMake(0, self.searchTF.size.height+1, WIN_WIDTH, height) style:(UITableViewStylePlain)];
    if (@available(iOS 11.0, *)) {   // ios11系统下 处理页面push或Pop时屏幕移动
        Addtableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    Addtableview.delegate=self;
    Addtableview.dataSource =self;
    Addtableview.rowHeight = getWidth(60);
    Addtableview.backgroundColor = SetColor(@"#F5F1F1");
    Addtableview.separatorInset = UIEdgeInsetsZero;
    [Addtableview registerNib:[UINib nibWithNibName:@"AuthCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    UIView *view =[[UIView alloc] initWithFrame:CGRectZero];
    Addtableview.tableFooterView = view;
    [self.view addSubview:Addtableview];
    
    dataArr = [NSMutableArray array];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return dataArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AuthCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary *userModel = [NSDictionary dictionary];
    userModel = dataArr[indexPath.row];
    id username = userModel[@"nickName"]?userModel[@"nickName"]:userModel[@"phone"];
    cell.Authname.text = username;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AuthCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.SelectBtn.selected = !cell.SelectBtn.selected;
    if (cell.SelectBtn.selected) {
        select = YES;
        Selectrow = indexPath.row;
    }else{
        select = NO;
        Selectrow = -1;
    }
}

-(void)rightBtnClicked
{
    NSLog(@"select:%d",select);
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"搜索"]) {
        [self searchUsers];
    }else{
        if (select) {
            NSDictionary *userModel = [NSDictionary dictionary];
            userModel = dataArr[Selectrow];
            NSArray * timeArray = @[@"08:00-10:00",@"12:00-14:00",@"17:00-19:00"];
            NSString *nickname = userModel[@"nickName"];
            NSDictionary *params = @{
                                     @"memoName":nickname?nickname:userPhone,
                                     @"userId":userModel[@"id"],
                                     @"userType":@"1",
                                     @"deviceId":self.device.id,//WiFi模块的唯一标识
                                     @"times":timeArray,
                                     @"weeks":@[@"1",@"2",@"3",@"4",@"5",@"6",@"7"],
                                     };
            DDLog(@"授权用户绑定设备:%@;params:%@",NETWORK_REQUEST_URL(BINDING_DEVICES_URL),params);
            [MBProgressHUD showActivityMessageInView:@""];
            NSString *httpUrl = [NSString stringWithFormat:@"%@/%@",NETWORK_REQUEST_URL(AUTHORIZE_DEVICES_URL),[[UserManger sharedInstance] getMemberToken]];
            [HttpTool postWithURL:httpUrl params:params success:^(id json) {
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
                [MBProgressHUD showTipMessageInView:[error localizedDescription]];
            }];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AuthManagerDidChanged" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}

- (void)searchUsers{
    //搜索用户请求
    if (![Helper isMobileNumber:self.searchTF.text]) {
        [MBProgressHUD showErrorMessage:@"请输入正确的手机号码"];
        return;
    }
    NSDictionary *params = @{@"phone":self.searchTF.text};
    DDLog(@"SEARCH_AUTHUSER_URL:%@;params:%@",NETWORK_REQUEST_URL(SEARCH_AUTHUSER_URL),params);
    [MBProgressHUD showActivityMessageInView:@""];
    NSString *httpUrl = [NSString stringWithFormat:@"%@/%@",NETWORK_REQUEST_URL(SEARCH_AUTHUSER_URL),[[UserManger sharedInstance] getMemberToken]];
    [HttpTool postWithURL:httpUrl params:params success:^(id json) {
        NSLog(@"result:%@",json);
        [MBProgressHUD hideHUD];
        int code = [json[@"code"] intValue];
        if (code == 1000) {
            [dataArr removeAllObjects];
            [dataArr addObject:json[@"data"]];
            userPhone = self.searchTF.text;
            self.navigationItem.rightBarButtonItem.title = @"完成";
            [self.searchTF resignFirstResponder];
            dispatch_async(dispatch_get_main_queue(), ^{
                [Addtableview reloadData];
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

#pragma mark UITextField代理方法

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * numberString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    // 限制手机输入位数不超过11位
    if ( numberString.length > 11) {
        return NO;
    }
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:COUNTNUM] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    if (![string isEqualToString:filtered]) {
        return NO;
    }
    return YES;
}

- (void)textFieldTextDidChange:(UITextField *)textField{
    NSLog(@"textFieldDidBeginEditing");
    self.navigationItem.rightBarButtonItem.title = @"搜索";
    [dataArr removeAllObjects];
    [Addtableview reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
