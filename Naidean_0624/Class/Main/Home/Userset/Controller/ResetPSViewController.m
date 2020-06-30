//
//  ResetPSViewController.m
//  Naidean
//
//  Created by xujun on 2018/1/15.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "ResetPSViewController.h"
#import "NSString+LuAddition.h"


@interface ResetPSViewController ()

@property (strong, nonatomic)  UITextField *phoneTF;
@property (strong, nonatomic)  UITextField *verifyTF;
@property (strong, nonatomic)  UITextField *passwordTF;
@property (strong, nonatomic)  UITextField *confirmPasswordTF;
@property (strong, nonatomic)  UIButton *getCodeBtn;
@property (strong, nonatomic)  UIButton *confirmBtn;
@property (strong, nonatomic)  UIButton *nextBtn;
@property (strong, nonatomic) dispatch_source_t timer;
@end

@implementation ResetPSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    
    [self.view setBackgroundColor:SetColor(@"#F5F1F1")];
    self.phoneTF = [self creatTextField];
    [self.view addSubview:self.phoneTF];
    
    self.verifyTF = [self creatTextField];
    [self.view addSubview:self.verifyTF];
    
    self.passwordTF = [self creatTextField];
    self.passwordTF.secureTextEntry = YES;
    [self.view addSubview:self.passwordTF];
    
    self.confirmPasswordTF = [self creatTextField];
    self.confirmPasswordTF.secureTextEntry = YES;
    [self.view addSubview:self.confirmPasswordTF];
    
    self.getCodeBtn = [UIButton new];
    [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.getCodeBtn.titleLabel.font = kSystemFontSize(getWidth(15));
    [self.getCodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.getCodeBtn.backgroundColor = [UIColor whiteColor];
    self.getCodeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;;
    [self.view addSubview:self.getCodeBtn];
    [self.getCodeBtn addTarget:self action:@selector(getVerifyCode) forControlEvents:UIControlEventTouchUpInside];
    
    self.confirmBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmBtn.backgroundColor =[UIColor colorWithHexString:@"#FF7B06" alpha:1];
    [self.confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.view addSubview:self.confirmBtn];
    self.confirmBtn.layer.masksToBounds = YES;
    self.confirmBtn.layer.cornerRadius = 4;
    self.confirmBtn.titleLabel.font = kSystemFontSize(getWidth(20));
    [self.confirmBtn addTarget:self action:@selector(ChangePSBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.nextBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    self.nextBtn.backgroundColor =[UIColor colorWithHexString:@"#FF7B06" alpha:1];
    [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.view addSubview:self.nextBtn];
    self.nextBtn.layer.masksToBounds = YES;
    self.nextBtn.layer.cornerRadius = 4;
    self.nextBtn.titleLabel.font = kSystemFontSize(getWidth(20));
    [self.nextBtn addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    
    [self layoutSubviews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BlueToothChangePassWordSuccessed) name:@"BlueToothChangePassWord" object:nil];
}

- (void)layoutSubviews{
    NSString *title = @"";
    NSString *phonePH = @"";
    NSString *passwordPH = @"";
    NSString *cPasswordPH = @"";
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(getHeight(-86));
        make.left.equalTo(self.view.mas_left).offset(getWidth(15));
        make.right.equalTo(self.view.mas_right).offset(getWidth(-15));
        make.height.mas_equalTo(getHeight(44));
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(getHeight(-86));
        make.left.equalTo(self.view.mas_left).offset(getWidth(15));
        make.right.equalTo(self.view.mas_right).offset(getWidth(-15));
        make.height.mas_equalTo(getHeight(44));
    }];
    
    self.nextBtn.hidden = YES;
    if (_reset == ForgetPassWord) {
        title = @"忘记密码";
        phonePH = @"请输入手机号";
        passwordPH = @"请输入6-20位新密码";
        cPasswordPH = @"请再次输入新密码";
        [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(getHeight(34));
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.height.mas_equalTo(getWidth(44));
        }];
        
        [self addLineViewBehindView:self.phoneTF];
        
        [self.getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.phoneTF.mas_bottom);
            make.right.equalTo(self.view.mas_right);
            make.size.mas_equalTo(CGSizeMake(getWidth(94), getHeight(44)));
        }];
        [self addLineViewBehindView:self.getCodeBtn];
        
        [self.verifyTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.phoneTF.mas_bottom);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.getCodeBtn.mas_left);
            make.height.mas_equalTo(getWidth(44));
        }];
        
        [self.passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.verifyTF.mas_bottom);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.height.mas_equalTo(getWidth(44));
        }];
        [self addLineViewBehindView:self.passwordTF];
        
        [self.confirmPasswordTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.passwordTF.mas_bottom);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.height.mas_equalTo(getWidth(44));
        }];
        
    }else if (_reset == UnlockPassWord){
        title = @"开锁密码";
        phonePH = @"请输入旧密码";
        passwordPH = @"请输入新密码";
        cPasswordPH = @"请再次输入新密码";
        self.phoneTF.text = [[UserManger sharedInstance] getUserPhone];
        self.phoneTF.userInteractionEnabled = NO;
        [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(getHeight(34));
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.height.mas_equalTo(getWidth(44));
        }];
        
        [self addLineViewBehindView:self.phoneTF];
        
        [self.getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.phoneTF.mas_bottom);
            make.right.equalTo(self.view.mas_right);
            make.size.mas_equalTo(CGSizeMake(getWidth(94), getHeight(44)));
        }];
        [self addLineViewBehindView:self.getCodeBtn];
        
        [self.verifyTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.phoneTF.mas_bottom);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.getCodeBtn.mas_left);
            make.height.mas_equalTo(getWidth(44));
        }];
        
        [self.passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.verifyTF.mas_bottom);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.height.mas_equalTo(getWidth(44));
        }];
        [self addLineViewBehindView:self.passwordTF];
        
        [self.confirmPasswordTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.passwordTF.mas_bottom);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.height.mas_equalTo(getWidth(44));
        }];
        
    }else{
        title = @"更改绑定电话";
        phonePH = @"请输入当前手机号";
        passwordPH = @"请输入当前账户密码";
        self.phoneTF.text = [[UserManger sharedInstance] getUserPhone];
        self.phoneTF.userInteractionEnabled = NO;
        [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(getHeight(34));
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.height.mas_equalTo(getWidth(44));
        }];
        
        [self addLineViewBehindView:self.phoneTF];
        
        [self.getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.phoneTF.mas_bottom);
            make.right.equalTo(self.view.mas_right);
            make.size.mas_equalTo(CGSizeMake(getWidth(94), getHeight(44)));
        }];
        [self addLineViewBehindView:self.getCodeBtn];
        
        [self.verifyTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.phoneTF.mas_bottom);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.getCodeBtn.mas_left);
            make.height.mas_equalTo(getWidth(44));
        }];
        
        [self.passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.verifyTF.mas_bottom);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.height.mas_equalTo(getWidth(44));
        }];
        
        self.nextBtn.hidden = NO;
        self.confirmBtn.hidden = YES;
    }
    self.title = title;
    self.phoneTF.placeholder = phonePH;
    self.verifyTF.placeholder = @"请输入验证码";
    self.passwordTF.placeholder = passwordPH;
    self.confirmPasswordTF.placeholder = cPasswordPH;
}

-(void)setReset:(Reset)reset
{
    _reset = reset;
}

- (void)getVerifyCode{
    if (self.phoneTF.text.length < 1)
    {
        [MBProgressHUD showTipMessageInView:@"请输入手机号码"];
        return;
    }
    if (![Helper isMobileNumber:self.phoneTF.text]) {
        [MBProgressHUD showTipMessageInView:@"请输入正确的手机号码"];
        return;
    }
    Helper *helper = [[Helper alloc] init];
    [Helper verifyBtnAction:self.getCodeBtn:helper];
    __weak typeof(self) weakSelf = self;
    helper.verifyblock = ^(dispatch_source_t timer){
        weakSelf.timer = timer;
    } ;
    NSString *type = @"";
    if (_reset == ResetPhone) {
        type = @"3";
    }else if (_reset == ForgetPassWord){
        type = @"1";
    }
    
    NSDictionary *params = @{
                             @"phone":self.phoneTF.text,//手机号
                             //@"type":type//0:注册；1:找回密码;3:更改绑定电话
                             };
    DDLog(@"httpURL:%@,params:%@",NETWORK_REQUEST_URL(GET_CODE_URL),params);
    [MBProgressHUD showActivityMessageInView:@""];
    [HttpTool postWithURL:NETWORK_REQUEST_URL(GET_CODE_URL) params:params success:^(id json) {
        NSLog(@"getCode:%@",json);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showTipMessageInView:json[@"message"]];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showErrorMessage:[error localizedDescription]];
    }];
}

- (void)nextStep{
    if (![Helper isMobileNumber:self.phoneTF.text]) {
        
        [MBProgressHUD showTipMessageInView:@"请输入正确的手机号码"];
        return;
    }
    if (!self.passwordTF.text.length)
    {
        [MBProgressHUD showTipMessageInView:@"请输入账户密码"];
        return;
    }
    if (!self.verifyTF.text.length)
    {
        [MBProgressHUD showTipMessageInView:@"请输入验证码"];
        return;
    }
    if (![self.passwordTF.text isEqualToString:self.confirmPasswordTF.text])
    {
        [MBProgressHUD showTipMessageInView:@"两次输入密码不同"];
        return;
    }
    
    NSDictionary *params = @{
                             @"phone":self.phoneTF.text,
                             @"code":self.verifyTF.text,
                             @"password":self.passwordTF.text
                             };
    NSString *httpUrl = [NSString stringWithFormat:@"%@/%@",NETWORK_REQUEST_URL(VERIFY_USER_ACCOUNT),[[UserManger sharedInstance] getMemberToken]];
    DDLog(@"注册URL:%@;params:%@",httpUrl,params);
    [MBProgressHUD showActivityMessageInView:@""];
    [HttpTool postWithURL:httpUrl params:params success:^(id json) {
        NSLog(@"data:%@",json);
        [MBProgressHUD hideHUD];
        int status = [json[@"success"] intValue];
        if (status == 1) {
            self.nextBtn.hidden = YES;
            self.confirmBtn.hidden = NO;
            self.phoneTF.placeholder = @"请输入新手机号";
            self.phoneTF.userInteractionEnabled = YES;
            self.phoneTF.text = @"";
            self.verifyTF.text = @"";
//            [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            self.passwordTF.hidden = YES;
            dispatch_source_cancel(self.timer);
            //主线程设置按钮样式
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                [self.getCodeBtn setUserInteractionEnabled:YES];
            });
        }else{
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
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showTipMessageInView:[error localizedDescription]];
        
    }];
}

-(void)ChangePSBtnAction
{
    switch (_reset) {
        case 0:{
            // 忘记密码
            if (![Helper isMobileNumber:self.phoneTF.text]) {
                
                [MBProgressHUD showTipMessageInView:@"请输入正确的手机号码"];
                return;
            }
            if (self.passwordTF.text.length < 6)
            {
                [MBProgressHUD showTipMessageInView:@"请输入6~12位密码"];
                return;
            }
            
            if (!self.confirmPasswordTF.text.length)
            {
                [MBProgressHUD showTipMessageInView:@"请输入确认密码"];
                return;
            }
            
            if (![self.passwordTF.text isEqualToString:self.confirmPasswordTF.text])
            {
                [MBProgressHUD showTipMessageInView:@"两次输入密码不同"];
                return;
            }
            
            if (!self.verifyTF.text.length)
            {
                [MBProgressHUD showTipMessageInView:@"请输入验证码"];
                return;
            }
            
            NSDictionary *params = @{
                                     @"phone":self.phoneTF.text,
                                     @"password":self.passwordTF.text,
                                     @"code":self.verifyTF.text
                                     };
            NSString *httpUrl = NETWORK_REQUEST_URL(FIND_PSWORD_URL);
            DDLog(@"注册URL:%@;params:%@",httpUrl,params);
            [MBProgressHUD showActivityMessageInView:@""];
            [HttpTool postWithURL:httpUrl params:params success:^(id json) {
                NSLog(@"data:%@",json);
                [MBProgressHUD hideHUD];
                [MBProgressHUD showTipMessageInView:@"密码重置成功,请重新登录"];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showTipMessageInView:[error localizedDescription]];
            }];
        }
            break;
        case 1:{
            // 设置开锁密码
            if (self.phoneTF.text.length < 6)
            {
                [MBProgressHUD showTipMessageInView:@"无法获取手机号"];
                return;
            }
            
            if (self.passwordTF.text.length < 6)
            {
                [MBProgressHUD showTipMessageInView:@"请输入6~12位密码"];
                return;
            }
            
            if (!self.verifyTF.text.length)
            {
                [MBProgressHUD showTipMessageInView:@"请输入验证码"];
                return;
            }

            
//            NSInteger unlockType = [[UserManger sharedInstance] getUnlockType];
//            if (unlockType == 2 && !BTManager.connectPeripheral) {//蓝牙未连接
//                [MBProgressHUD showTipMessageInView:@"请先连接设备。。。"];
//                return;
//            }
            NSString *bindingID = [NSString stringWithFormat:@"%@",self.device.id];
            NSDictionary *params = @{
                                     @"id":bindingID,
                                     @"code":self.verifyTF.text,
                                     @"openPwd":self.passwordTF.text,
                                     };
            DDLog(@"SET_DEVICE_PSWORD_URL:%@;params:%@",NETWORK_REQUEST_URL(SET_DEVICE_PSWORD_URL),params);
            [MBProgressHUD showActivityMessageInView:@""];
            
            NSString *httpUrl = [NSString stringWithFormat:@"%@/%@",NETWORK_REQUEST_URL(SET_DEVICE_PSWORD_URL),[[UserManger sharedInstance] getMemberToken]];
            
            [HttpTool postWithURL:httpUrl params:params success:^(id json) {
                NSLog(@"result:%@",json);
                [MBProgressHUD hideHUD];
                [MBProgressHUD showTipMessageInView:json[@"message"]];
                int code = [json[@"code"] intValue];
                if (code == 1000) {
//                    if (unlockType == 2 && self.device.isAdmin == 1) {//主管理员才发送蓝牙指令
//                        NSMutableString *orderStr = [NSMutableString stringWithString:@"5AA53408"];
//                        NSString *str = [[self.confirmPasswordTF.text md5] substringWithRange:NSMakeRange(8, 16)];
//                        [orderStr appendString:str];
//                        //拼接校验码
//                        [orderStr appendString:[Helper stylestring:orderStr]];
//                        [BTManager writeDataWithPeripheral:self.peripheral withDataString:[Helper mutString:orderStr]];
//                    }else{
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Add_Device_Success" object:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                        [MBProgressHUD showTipMessageInView:json[@"message"]];
//                    }
                }
                else if (code == TimeOutCode)
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
             break;
        default:{
            //修改绑定电话
            if (![Helper isMobileNumber:self.phoneTF.text]) {
                
                [MBProgressHUD showTipMessageInView:@"请输入正确的手机号码"];
                return;
            }
            if (!self.verifyTF.text.length)
            {
                [MBProgressHUD showTipMessageInView:@"请输入验证码"];
                return;
            }
            
            NSDictionary *params = @{
                                     @"phone":self.phoneTF.text,
                                     @"code":self.verifyTF.text
                                     };
            NSString *httpUrl = [NSString stringWithFormat:@"%@/%@",NETWORK_REQUEST_URL(REBINDING_USER_PHONE),[[UserManger sharedInstance] getMemberToken]];
            DDLog(@"注册URL:%@;params:%@",httpUrl,params);
            [MBProgressHUD showActivityMessageInView:@""];
            [HttpTool postWithURL:httpUrl params:params success:^(id json) {
                NSLog(@"data:%@",json);
                [MBProgressHUD hideHUD];
                int code = [json[@"code"] intValue];
                if (code == TimeOutCode)
                {
                    [MBProgressHUD showTipMessageInView:json[@"登录超时，请重新登录"]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_TimeOut_Login object:nil];
                }
                else
                {
                    UserManger *manage = [UserManger sharedInstance];
                    [manage cacheUserPhone:self.phoneTF.text];
                    [manage cacheUserName:self.phoneTF.text];
                     [self.navigationController popViewControllerAnimated:nil];
                    [MBProgressHUD showTipMessageInView:json[@"message"]];
                }
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showTipMessageInView:[error localizedDescription]];
            }];
        }
            break;
    }
    
}

- (void)BlueToothChangePassWordSuccessed{
    [MBProgressHUD showTipMessageInWindow:@"密码修改成功"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITextField *)creatTextField{
    UITextField *textField = [[UITextField alloc] init];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.font =kSystemFontSize(getWidth(15));
    textField.backgroundColor = [UIColor whiteColor];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    //设置TextField文字左边距
    UIView *left =[[UIView alloc] initWithFrame:CGRectMake(0, 0, getWidth(18), 0)];
    left.backgroundColor=[UIColor whiteColor];
    textField.leftView =left;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    return textField;
}

- (void)addLineViewBehindView:(UIView *)view{
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.26];
    [view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(getWidth(18));
        make.top.equalTo(view.mas_bottom).offset(getHeight(-0.5));
        make.right.equalTo(self.view.mas_right).offset(-getWidth(18));
        make.height.mas_equalTo(getHeight(0.5));
    }];
}
@end
