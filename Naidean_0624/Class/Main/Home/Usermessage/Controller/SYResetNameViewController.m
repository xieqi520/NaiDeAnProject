//
//  SYResetNameViewController.m
//  Naidean
//
//  Created by aoxin on 2018/8/24.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "SYResetNameViewController.h"

@interface SYResetNameViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) UITextField *nameTF;
@property (strong, nonatomic) UIButton *doneBtn;

@end

@implementation SYResetNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"名字设置";
    self.view.backgroundColor = SetColor(@"#F5F1F1");
    
    _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_doneBtn setFrame:CGRectMake(0, 0, 60, 30)];
    [_doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:_doneBtn];
    [_doneBtn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = rightBtn;

    _nameTF = [[UITextField alloc] init];
    _nameTF.backgroundColor = [UIColor whiteColor];
    _nameTF.text = [[UserManger sharedInstance] getUserNickname];
    _nameTF.placeholder = @"请输入新名字";
    _nameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nameTF.delegate = self;
    [self.view addSubview:_nameTF];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 44)];
    leftView.backgroundColor = [UIColor whiteColor];
    _nameTF.leftViewMode = UITextFieldViewModeAlways;
    _nameTF.leftView = leftView;
    [_nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(getHeight(34));
        make.size.mas_equalTo(CGSizeMake(WIN_WIDTH, 44));
    }];
    
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = SetColor(@"#D9D9D9");
    [self.view addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_nameTF.mas_top);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(WIN_WIDTH, 0.5));
    }];
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = SetColor(@"#D9D9D9");
    [self.view addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameTF.mas_bottom);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(WIN_WIDTH, 0.5));
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:_nameTF];
}

- (void)rightBtnClicked{
    [_nameTF resignFirstResponder];
    NSDictionary *params = @{
                             @"nickName":_nameTF.text,
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
            [[UserManger sharedInstance] cacheUserNickname:_nameTF.text];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showTipMessageInView:json[@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showTipMessageInView:[error localizedDescription]];
    }];
    
//    NSLog(@"userId:%@",[[UserManger sharedInstance] getUserId]);
//    NSDictionary *params = @{
//                             @"userName":_nameTF.text,
//                             @"userID":[[UserManger sharedInstance] getUserId]
//                             };
//    DDLog(@"USER_UPDATE_URL:%@;params:%@",NETWORK_REQUEST_URL(USER_UPDATE_URL),params);
//    [MBProgressHUD showActivityMessageInView:@""];
//    [HttpTool getWithURL:NETWORK_REQUEST_URL(USER_UPDATE_URL) params:params success:^(id json) {
//        NSLog(@"result:%@",json);
//        [MBProgressHUD hideHUD];
//        int status = [json[@"resCode"] intValue];
//        if (status == 0) {
//            [[UserManger sharedInstance] cacheUserName:_nameTF.text];
//            [self.navigationController popViewControllerAnimated:YES];
//        }else{
//            [MBProgressHUD showTipMessageInView:json[@"resMessage"]];
//        }
//    } failure:^(NSError *error) {
//        [MBProgressHUD hideHUD];
//        [MBProgressHUD showTipMessageInView:[error localizedDescription]];
//    }];
}

- (void)textFieldDidChange:(UITextField *)textField{
    if (_nameTF.text.length > 0) {
        _doneBtn.userInteractionEnabled = YES;
        [_doneBtn setTitleColor:[UIColor colorWithWhite:1 alpha:1] forState:UIControlStateNormal];
        
    }else{
        _doneBtn.userInteractionEnabled = NO;
        [_doneBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateNormal];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_doneBtn];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
