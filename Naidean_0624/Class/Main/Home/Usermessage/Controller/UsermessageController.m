//
//  UsermessageController.m
//  Naidean
//
//  Created by xujun on 2018/1/4.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "UsermessageController.h"
#import "UserInfoHeadView.h"
#import "UserInfoCell.h"
#import "UserInfoFootView.h"
#import "PickSystemImg.h"
#import "ChangetelnumberController.h"
#import "CheckUpdateController.h"
#import "AboutUsController.h"
#import "UserHelpController.h"
#import "SYUserInfoViewController.h"
#import "SYCheckEditionController.h"


@interface UsermessageController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property(nonatomic,strong) PickSystemImg *PicksystemImg;
@property(nonatomic,strong) UITableView *Infotableview;
@property(nonatomic,strong) UserInfoHeadView *headView;
@property(nonatomic,strong) UserInfoFootView *footView;
@end

@implementation UsermessageController
{
    NSMutableArray *dataArr;
    NSMutableArray *imgArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithUI];
    [self initWithTableview];
    [self initWithBlock];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _headView.userName.text = [[UserManger sharedInstance] getUserNickname];
    _headView.userAccount.text = [NSString stringWithFormat:@"账号:%@",[[UserManger sharedInstance] getUserPhone]];
    NSString *headPath =  NETWORK_REQUEST_URL([[UserManger sharedInstance] getHeadPortrait]);
    [_headView.UserImageView sd_setImageWithURL:[NSURL URLWithString:headPath] placeholderImage:[UIImage imageNamed:@"img_morentouxiang"] options:SDWebImageCacheMemoryOnly];
}

-(void)initWithUI
{
    self.title=@"用户信息";
    dataArr =[[NSMutableArray alloc] initWithObjects:@"用户帮助",@"关于我们", nil];//@"查看更新",
    imgArr =[[NSMutableArray alloc] initWithObjects:@"iphone",@"about", nil];//@"update_icon",
    self.view.backgroundColor = SetColor(@"#F5F1F1");
    self.PicksystemImg =[[PickSystemImg alloc]init];
}

-(void)initWithBlock
{
     __weak typeof(self) weakSelf = self;
    self.headView.ChangeImgBlock = ^{
//         [weakSelf.PicksystemImg takeImgWithController:weakSelf];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.navigationController pushViewController:[SYUserInfoViewController new] animated:YES];
        });
    };
    //退出登录Block事件
    self.footView.LogoutBlock = ^{
        [weakSelf alertView];
    };
    //取消选择后的回调
    self.PicksystemImg.dismissBlock = ^(){
        [weakSelf dismissViewControllerAnimated:YES completion:^{
        }];
    };
    // 设置个人头像
    self.PicksystemImg.imgBlock = ^(UIImage *image) {
        weakSelf.headView.UserImageView.image = image;
         [weakSelf postUserHeadimage:image];
    };
}

-(void)alertView
{
    UIAlertAction *action =[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication].keyWindow.layer addAnimation:[self exitAnim] forKey:nil];
//        [[UserManger sharedInstance] destroyManager];
        [[UserManger sharedInstance] removeMemberToken];
         AppDelegate *app =(AppDelegate*)[[UIApplication sharedApplication] delegate];
        [[NSUserDefaults  standardUserDefaults]  removeObjectForKey:@"selectedLock"];//setObject: forKey:@"selectLock"];
         [app loginInFirstTime];
    }] ;
    UIAlertAction *action1 =[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认退出登录?" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:action];
    [alertVC addAction:action1];
    [self presentViewController:alertVC animated:YES completion:nil];
}

//转场动画
-(CATransition*)exitAnim{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.75f];
    animation.type = @"push";
    animation.subtype = kCATransitionFromRight;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    return animation;
}

-(void)initWithTableview
{
    _Infotableview =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, WIN_HEIGHT-64)];
    _Infotableview.delegate=self;
    _Infotableview.dataSource=self;
    _Infotableview.rowHeight = getWidth(44);
    [_Infotableview registerNib:[UINib nibWithNibName:@"UserInfoCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    _Infotableview.separatorColor =[UIColor colorWithHexString:@"#D9D9D9" alpha:1];
    _Infotableview.backgroundColor=[UIColor colorWithHexString:@"#f5f5f9" alpha:1];
    if (@available(iOS 11.0, *)) {   // ios 11系统下 处理页面push或Pop时屏幕移动
        _Infotableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    UIView *Headview =[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, getWidth(150))];
    _headView = [[NSBundle mainBundle] loadNibNamed:@"UserInfoHeadView" owner:self options:nil].lastObject;
    _headView.frame =CGRectMake(0, 0, WIN_WIDTH, getHeight(130));
//    _headView.userName.text = [[UserManger sharedInstance] getUserName];
//    _headView.userAccount.text = [NSString stringWithFormat:@"账号:%@",[[UserManger sharedInstance] getUserPhone]];
//    NSString *headPath =  NETWORK_REQUEST_URL([[UserManger sharedInstance] getHeadPortrait]);
//    [_headView.UserImageView sd_setImageWithURL:[NSURL URLWithString:headPath] placeholderImage:[UIImage imageNamed:@"img_morentouxiang"] options:SDWebImageCacheMemoryOnly];
    [Headview addSubview:_headView];
    _Infotableview.tableHeaderView = Headview;
  
    UIView *Footview =[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, WIN_HEIGHT - (getWidth(44)*4+getWidth(150))-64)];
    _footView =[[NSBundle mainBundle] loadNibNamed:@"UserInfoFootView" owner:self options:nil].lastObject;
    _footView.frame =CGRectMake(0, 0, WIN_WIDTH, WIN_HEIGHT -(getWidth(48)*4+getWidth(100))-64);
    [Footview addSubview:_footView];
    _Infotableview.tableFooterView = Footview;
    _Infotableview.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:_Infotableview];
}

#pragma mark 上传个人头像
-(void)postUserHeadimage:(UIImage*)image
{
    NSDictionary *params = @{
                             //                             @"headPicurl":image,
                             @"number":[[UserManger sharedInstance] getUserPhone]
                             };
    DDLog(@"UPLOAD_PIC_URL:%@;params:%@",NETWORK_REQUEST_URL(UPLOAD_PIC_URL),params);
    [MBProgressHUD showActivityMessageInView:@"正在上传"];
    [HttpTool uploadImage:image imageName:@"file" urlString:NETWORK_REQUEST_URL(UPLOAD_PIC_URL) params:params success:^(id json) {
        NSLog(@"result:%@",json);
        [MBProgressHUD hideHUD];
        [[UserManger sharedInstance] cacheHeadPortrait:json[@"resBody"]];
        [MBProgressHUD showTipMessageInView:json[@"resMessage"]];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showTipMessageInView:[error localizedDescription]];
    }];
}

#pragma mark tableviewDeleate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cell";
    UserInfoCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    cell.InfiImageview.image = [UIImage imageNamed:[imgArr objectAtIndex:indexPath.row]];
    cell.InfoSet.text = [dataArr objectAtIndex:indexPath.row];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // ChangetelnumberController *vc1 =[[ChangetelnumberController alloc] init];
    
     SYCheckEditionController *vc1=[[SYCheckEditionController alloc] init];
//     vc1.reset = ResetPhone;  // 更改绑定电话
    
//     CheckUpdateController *vc2 =[[CheckUpdateController alloc] init];
    
     AboutUsController *vc3 =[[AboutUsController alloc] init];
    
     UserHelpController *vc4=[[UserHelpController alloc] init];
    
    switch (indexPath.row) {
            case 0:
            [self.navigationController pushViewController:vc4 animated:YES];
                break;
            case 1:
//            [self.navigationController pushViewController:vc2 animated:YES];
//            break;
//            case 2:
//            [self.navigationController pushViewController:vc1 animated:YES];
//            break;
//            case 2:
             [self.navigationController pushViewController:vc3 animated:YES];
            break;
            default:
                break;
        }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
