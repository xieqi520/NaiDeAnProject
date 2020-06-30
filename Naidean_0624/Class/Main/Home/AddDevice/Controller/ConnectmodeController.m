//
//  ConnectmodeController.m
//  Naidean
//
//  Created by xujun on 2018/1/8.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "ConnectmodeController.h"
#import "WifiConnectController.h"
#import "AddDeviceController.h"

@interface ConnectmodeController ()

@end

@implementation ConnectmodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"链接模式";
}

- (IBAction)WifiConnectAction:(id)sender {
    WifiConnectController *vc =[[WifiConnectController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}



- (IBAction)BluetoothConnectAction:(id)sender {
    AddDeviceController *vc=[[AddDeviceController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
