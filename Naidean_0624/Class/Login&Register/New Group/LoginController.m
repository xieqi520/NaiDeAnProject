//
//  LoginController.m
//  Naidean
//
//  Created by xujun on 2018/1/4.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "LoginController.h"
#import "UnlockPSController.h"
#import "RegisterController.h"
#import "NSString+LuAddition.h"
#import "ResetPSViewController.h"
#import "CheckLoginController.h"
@interface LoginController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *LogoIamgeView;//Logo图标
@property (weak, nonatomic) IBOutlet UITextField *PhoneTextfield;//电话号码输入框
@property (weak, nonatomic) IBOutlet UITextField *PSTextfield;//密码输入框
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;//登录按钮
@property (weak, nonatomic) IBOutlet UIButton *RegisterBtn;//注册按钮
@property (weak, nonatomic) IBOutlet UIButton *ForgetPSBtn;//忘记密码按钮
@property (weak, nonatomic) IBOutlet UIView *BackView;// 背景视图

@end



@implementation LoginController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    UserManger *manage = [UserManger sharedInstance];
    self.PhoneTextfield.text =[manage  getUserPhone];//userInfo[@"userPhone"];
    self.PSTextfield.text = [manage  getUserPassWord];//userInfo[@"password"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWithUI];
    
    [self dataInit];
}


/**
 登陆按钮的点击事件
 @param sender 按钮
 */
- (IBAction)Loginaction:(UIButton*)sender {
    
    if (![Helper isMobileNumber:self.PhoneTextfield.text]) {
        [MBProgressHUD showErrorMessage:@"请输入正确的手机号码"];
        return;
    }

    if (self.PSTextfield.text.length < 6) {
        [MBProgressHUD showTipMessageInView:@"请输入6-12位密码"];
        return;
    }
    UserManger *manage = [UserManger sharedInstance];
    NSString *uuid = [manage getDeviceIDWithUUID];

    
    NSDictionary *params = @{
                             @"phone":self.PhoneTextfield.text,
//                             @"password":[self.PSTextfield.text md5]
                             @"password":self.PSTextfield.text,
                             @"phoneId":uuid
                             };
    [MBProgressHUD showActivityMessageInView:@""];
    [HttpTool postWithURL:NETWORK_REQUEST_URL(USER_LOGIN_URL) params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        NSLog(@"%@",json);
        int status = [json[@"success"] intValue];
        if (status == 1) {
            UserManger *manage = [UserManger sharedInstance];
            [manage cacheUserPhone:self.PhoneTextfield.text];
            [manage cacheUserName:json[@"data"][@"phone"]];
            [manage cacheUserId:json[@"data"][@"id"]];
            if(![json[@"data"][@"pic"] isEqual:[NSNull null]])
            {
                [manage cacheHeadPortrait:json[@"data"][@"pic"]];
            }
            [manage cacheUserPassWord:self.PSTextfield.text];
            [manage cacheUserNickname:json[@"data"][@"nickName"]];
            [manage cacheMemberToken:json[@"data"][@"token"]];
            NSInteger isCheck = [json[@"data"][@"isCheck"] integerValue];
            if (isCheck == 0) {
                AppDelegate *app =(AppDelegate*)[[UIApplication sharedApplication] delegate];
                [app loginFast];
                NSString *aliaId = json[@"data"][@"id"];
                [app setTags:aliaId];
                [manage cacheAliaId:aliaId];
            }
            else {
                CheckLoginController *vc = [[CheckLoginController alloc] init];
                vc.phone = self.PhoneTextfield.text;
                [self.navigationController pushViewController:vc animated:YES];
            }
        
            
//            AppDelegate *app =(AppDelegate*)[[UIApplication sharedApplication] delegate];
//            [app loginFast];
//            [app setTags:json[@"data"][@"id"]];
            
        }else{
            [MBProgressHUD showErrorMessage:json[@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showTipMessageInView:[error localizedDescription]];
    }];
//    AppDelegate *app =(AppDelegate*)[[UIApplication sharedApplication] delegate];
//    [app loginFast];
    
}

/**
 注册按钮的点击事件
 @param sender 按钮
 */
- (IBAction)Registeraction:(UIButton*)sender {
    
    RegisterController *vc =[[RegisterController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

/**
 忘记密码按钮的点击事件
 @param sender 按钮
 */
- (IBAction)ForgetPSaction:(UIButton*)sender {
    
//    UnlockPSController *vc =[[UnlockPSController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
    ResetPSViewController *vc =[[ResetPSViewController alloc] init];
    vc.reset = ForgetPassWord;
    [self.navigationController pushViewController:vc animated:YES];
}


/**
 初始化数据
 */
- (void)dataInit{

    self.PhoneTextfield.text = [[UserManger sharedInstance] getUserName];
    self.PSTextfield.text =[[UserManger sharedInstance] getUserPassWord];
}


/**
 初始化控件与布局
 */
-(void)initWithUI
{
    [_BackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(getHeight(260));
    }];
    
    _LogoIamgeView.backgroundColor=[UIColor whiteColor];
    _LogoIamgeView.layer.masksToBounds =YES;
    _LogoIamgeView.layer.cornerRadius = getWidth(60);
    _LogoIamgeView.image = [UIImage imageNamed:@"img_morentouxiang"];
    [_LogoIamgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(getHeight(72));
        make.size.mas_equalTo(CGSizeMake(getWidth(120), getWidth(120)));
    }];
    
    _PhoneTextfield.delegate = self;
    _PhoneTextfield.tag = 90;
    [_PhoneTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_BackView.mas_bottom).offset(getHeight(22));
        make.left.equalTo(self.view).offset(getWidth(15));
        make.right.equalTo(self.view).offset(getWidth(-15));
        make.height.mas_equalTo(getHeight(48));
    }];
    
    _PSTextfield.delegate = self;
    _PSTextfield.tag = 100;
    _PSTextfield.secureTextEntry= YES;
    [_PSTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_PhoneTextfield.mas_bottom).offset(getHeight(22));
        make.left.equalTo(self.view).offset(getWidth(15));
        make.right.equalTo(self.view).offset(getWidth(-15));
        make.height.mas_equalTo(getHeight(48));
    }];
    
    UIColor *color = [UIColor colorWithHexString:@"#a6a6a6" alpha:1];
    self.PhoneTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号码" attributes:@{NSForegroundColorAttributeName: color}];
    self.PSTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入登录密码" attributes:@{NSForegroundColorAttributeName: color}];
    
    UIView *left =[[UIView alloc] initWithFrame:CGRectMake(getWidth(40), 0, getWidth(30), getWidth(30))];
    left.backgroundColor=[UIColor whiteColor];
    self.PhoneTextfield.leftView =left;
    self.PhoneTextfield.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *PSleft =[[UIView alloc] initWithFrame:CGRectMake(getWidth(40), 0, getWidth(30), getWidth(30))];
    PSleft.backgroundColor=[UIColor whiteColor];
    self.PSTextfield.leftView = PSleft;
    self.PSTextfield.leftViewMode = UITextFieldViewModeAlways;
    
    self.PhoneTextfield.layer.borderColor =color.CGColor;
    self.PhoneTextfield.layer.borderWidth = 0.5;
    self.PSTextfield.layer.borderColor =color.CGColor;
    self.PSTextfield.layer.borderWidth = 0.5;
    
    self.LoginBtn.layer.masksToBounds =YES;
    self.LoginBtn.layer.cornerRadius =4;
    self.RegisterBtn.layer.masksToBounds =YES;
    self.RegisterBtn.layer.cornerRadius =4;
    
    self.LoginBtn.titleLabel.font = kSystemFontSize(getWidth(17));
    self.RegisterBtn.titleLabel.font = kSystemFontSize(getWidth(17));
    self.ForgetPSBtn.titleLabel.font = kSystemFontSize(getWidth(17));
    
    [self.LoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_PSTextfield.mas_bottom).offset(getHeight(22));
        make.left.equalTo(self.view).offset(getWidth(15));
        make.right.equalTo(self.view).offset(getWidth(-15));
        make.height.mas_equalTo(getHeight(48));
    }];
    
    [self.RegisterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_LoginBtn.mas_bottom).offset(getHeight(22));
        make.left.equalTo(self.view).offset(getWidth(15));
        make.right.equalTo(self.view).offset(getWidth(-15));
        make.height.mas_equalTo(getHeight(48));
    }];
    
    [self.ForgetPSBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(getHeight(-40));
        make.left.equalTo(self.view).offset(getWidth(60));
        make.right.equalTo(self.view).offset(getWidth(-60));
        make.height.mas_equalTo(getHeight(48));
    }];
}

#pragma mark UITextField代理方法

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 90) {
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
    }else if (textField.tag == 100)
    {
        NSString * numberString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
        // 限制输入位数不超过11位
        if ( numberString.length > 16) {
            return NO;
        }
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:PASSWORD] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        if (![string isEqualToString:filtered]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return  YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


@end
