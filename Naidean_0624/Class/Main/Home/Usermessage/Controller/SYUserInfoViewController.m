//
//  SYUserInfoViewController.m
//  Naidean
//
//  Created by aoxin on 2018/8/24.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "SYUserInfoViewController.h"
#import "SYUserHeadTableViewCell.h"
#import "PickSystemImg.h"
#import "SYResetNameViewController.h"

@interface SYUserInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) PickSystemImg *PicksystemImg;
@property(nonatomic,strong) UITableView *userInfoTableView;

@end

@implementation SYUserInfoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [_userInfoTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.userInfoTableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    _userInfoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, WIN_HEIGHT-64)];
    _userInfoTableView.delegate=self;
    _userInfoTableView.dataSource=self;
    _userInfoTableView.backgroundColor = SetColor(@"#F5F1F1");
    if (@available(iOS 11.0, *)) {   // ios 11系统下 处理页面push或Pop时屏幕移动
        _userInfoTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, getHeight(34))];
    headView.backgroundColor = SetColor(@"#F5F1F1");
    _userInfoTableView.tableHeaderView = headView;
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    _userInfoTableView.tableFooterView = view;
    _userInfoTableView.separatorInset = UIEdgeInsetsZero;
    [_userInfoTableView registerNib:[UINib nibWithNibName:@"SYUserHeadTableViewCell" bundle:nil] forCellReuseIdentifier:@"UserInfoHead"];
    [self.view addSubview:_userInfoTableView];
    
    self.PicksystemImg =[[PickSystemImg alloc]init];
    [self initWithBlock];
    
    
    
}

-(void)initWithBlock
{
    __weak typeof(self) weakSelf = self;
    //取消选择后的回调
    self.PicksystemImg.dismissBlock = ^(){
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            
        }];
    };
    // 设置个人头像
    self.PicksystemImg.imgBlock = ^(UIImage *image) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        SYUserHeadTableViewCell *cell = [weakSelf.userInfoTableView cellForRowAtIndexPath: indexPath];
        cell.headImageView.image = image;
        [weakSelf postUserHeadimage:image];
    };
}

#pragma mark 上传个人头像
-(void)postUserHeadimage:(UIImage*)image
{
    //上传头像

    DDLog(@"UPLOAD_PIC_URL:%@;",NETWORK_REQUEST_URL(UPLOAD_PIC_URL));
    [MBProgressHUD showActivityMessageInView:@"正在上传"];
    [HttpTool uploadImage:image imageName:@"file" urlString:NETWORK_REQUEST_URL(UPLOAD_PIC_URL) params:nil success:^(id json) {
        [MBProgressHUD hideHUD];
        NSLog(@"result:%@",json);
        [[UserManger sharedInstance] cacheHeadPortrait:json[@"data"]];
        [MBProgressHUD showTipMessageInView:json[@"message"]];
        
        NSLog(@"userId:%@",[[UserManger sharedInstance] getUserId]);
        NSDictionary *params = @{
                                 @"nickName":[[UserManger sharedInstance] getUserNickname],
                                 @"pic":[[UserManger sharedInstance] getHeadPortrait]
                                 };
        DDLog(@"USER_UPDATE_URL:%@;params:%@",NETWORK_REQUEST_URL(USER_UPDATE_URL),params);
        [MBProgressHUD showActivityMessageInView:@""];
        NSString *Urlstr = [NSString stringWithFormat:@"%@/%@",NETWORK_REQUEST_URL(USER_UPDATE_URL),[[UserManger sharedInstance] getMemberToken]];
        [HttpTool postWithURL:Urlstr params:params success:^(id json) {
            NSLog(@"result:%@",json);
            [MBProgressHUD hideHUD];
            int status = [json[@"success"] intValue];
            if (status == 1) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [MBProgressHUD showTipMessageInView:json[@"message"]];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInView:[error localizedDescription]];
        }];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showTipMessageInView:[error localizedDescription]];
    }];

}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        SYUserHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoHead"];
        NSString *headPath =  NETWORK_REQUEST_URL([[UserManger sharedInstance] getHeadPortrait]);
        NSLog(@"%@",headPath);
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:headPath] placeholderImage:[UIImage imageNamed:@"img_morentouxiang"]];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoName"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UserInfoName"];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = kSystemFontSize(13);
        cell.textLabel.textColor = SetColor(@"#6D6D72");
        cell.textLabel.text = @"昵称";
        cell.detailTextLabel.font = kSystemFontSize(13);
        cell.detailTextLabel.textColor = SetColor(@"#6D6D72");
        cell.detailTextLabel.text = [[UserManger sharedInstance] getUserNickname];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self.PicksystemImg takeImgWithController:self];
    }else{
        SYResetNameViewController *resetNameViewController = [[SYResetNameViewController alloc] init];
        [self.navigationController pushViewController:resetNameViewController animated:YES];
    }
}

- (void)userNameNeedRefresh{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [_userInfoTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
