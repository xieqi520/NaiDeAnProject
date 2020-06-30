//
//  ChooseLockTypeViewController.m
//  Naidean
//
//  Created by aoxin on 2018/8/13.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "ChooseLockTypeViewController.h"
#import "LoginController.h"
@interface ChooseLockTypeViewController ()

@end

@implementation ChooseLockTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开锁方式选择";
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated {
    UserManger *manage = [UserManger sharedInstance];
    NSString *uuid = [manage getDeviceIDWithUUID];
    
    NSDictionary *params = @{
                             @"phoneId":uuid
                             };
    [MBProgressHUD showActivityMessageInView:@""];
    NSString *memberToken = [[UserManger sharedInstance] getMemberToken];
    NSString *httpUrl = [NSString stringWithFormat:@"%@/%@",NETWORK_REQUEST_URL(USER_AutoLogin_URL),memberToken];
    
    [HttpTool postWithURL:httpUrl params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        NSLog(@"%@",json);
        int code = [json[@"code"] intValue];
        if (code == 2003) {
            AppDelegate *app =(AppDelegate*)[[UIApplication sharedApplication] delegate];
            [app loginInFirstTime];
        }else{
        
            [MBProgressHUD showErrorMessage:json[@"message"]];
            
//            AppDelegate *app =(AppDelegate*)[[UIApplication sharedApplication] delegate];
//            [app loginFast];
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showTipMessageInView:[error localizedDescription]];
    }];
    
}


- (IBAction)wifiBtnDidClicked:(id)sender {
    [[UserManger sharedInstance] cacheUnlockType:1];
    [self.navigationController pushViewController:[HomeController new] animated:YES];
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"该功能还在开发中,敬请期待..." preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
//    [alert addAction:defaultAction];
//    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)btBtnDidClicked:(id)sender {
    [[UserManger sharedInstance] cacheUnlockType:2];
    [self.navigationController pushViewController:[HomeController new] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
