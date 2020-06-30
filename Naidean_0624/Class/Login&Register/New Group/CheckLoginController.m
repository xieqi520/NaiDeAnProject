//
//  CheckLoginController.m
//  Naidean
//
//  Created by xujun on 2019/7/15.
//  Copyright © 2019 com.saiyikeji. All rights reserved.
//

#import "CheckLoginController.h"

@interface CheckLoginController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UIButton *backVCButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (weak, nonatomic) IBOutlet UIView *backTopView;

@end

@implementation CheckLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initWithUI];
    
}

/**
 初始化控件与布局
 */
-(void)initWithUI
{
    [self.backTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(getHeight(206));
    }];

    self.backVCButton.imageEdgeInsets = UIEdgeInsetsMake(0, -58, 0, 0);
    [self.backVCButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(getHeight(20));
        make.left.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(getWidth(100), getWidth(40)));
    }];

    self.headImageView.backgroundColor=[UIColor whiteColor];
    self.headImageView.layer.masksToBounds =YES;
    self.headImageView.layer.cornerRadius = getWidth(60);
//    self.headImageView.layer.cornerRadius = 60;
    self.headImageView.image = [UIImage imageNamed:@"img_morentouxiang"];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
//        make.top.equalTo(self.backTopView.mas_top).offset(getHeight(60));
        make.top.equalTo(self.view.mas_top).offset(getHeight(60));
        make.size.mas_equalTo(CGSizeMake(getWidth(120), getWidth(120)));
//        make.size.mas_equalTo(CGSizeMake(120, 120));
    }];

    
    
    self.phoneTextField.font =kSystemFontSize(getWidth(14));
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backTopView.mas_bottom).offset(getHeight(20));
        make.left.equalTo(self.view.mas_left).offset(getWidth(15));
        make.right.equalTo(self.view.mas_right).offset(getWidth(-15));
        make.height.mas_equalTo(getHeight(46));
    }];
    
    self.codeTextField.font =kSystemFontSize(getWidth(14));
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneTextField.mas_bottom).offset(getHeight(20));
        make.left.equalTo(self.view.mas_left).offset(getWidth(15));
//        make.right.equalTo(self.view.mas_right).offset(getWidth(-15));
        make.width.mas_equalTo(220);
        make.height.mas_equalTo(getHeight(46));
    }];
    
   
    
    [self.getCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneTextField.mas_bottom).offset(getHeight(20));
        make.size.mas_equalTo(CGSizeMake(getWidth(100), getWidth(46)));
        make.right.equalTo(self.view.mas_right).offset(getWidth(-15));
    }];
    
   
    
    UIColor *color = [UIColor colorWithHexString:@"#a6a6a6" alpha:1];
    self.phoneTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号码" attributes:@{NSForegroundColorAttributeName: color}];
    self.phoneTextField.text = self.phone;
    
    self.codeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"验证码" attributes:@{NSForegroundColorAttributeName: color}];
   
    
    UIView *left =[[UIView alloc] initWithFrame:CGRectMake(40, 0, 30, 30)];
    left.backgroundColor=[UIColor whiteColor];
    self.phoneTextField.leftView =left;
    self.phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    
  
    
  
    
    UIView *Codeleft =[[UIView alloc] initWithFrame:CGRectMake(getWidth(40), 0, getWidth(30), getWidth(30))];
    Codeleft.backgroundColor=[UIColor whiteColor];
    self.codeTextField.leftView =Codeleft;
    self.codeTextField.leftViewMode = UITextFieldViewModeAlways;
    
 
    
    self.phoneTextField.delegate=self;
    self.codeTextField.delegate=self;
    
    self.phoneTextField.tag =10;
    self.codeTextField.tag =40;
    
    self.phoneTextField.layer.borderColor =color.CGColor;
    self.phoneTextField.layer.borderWidth = 0.5;
 
    self.codeTextField.layer.borderColor =color.CGColor;
    self.codeTextField.layer.borderWidth = 0.5;
    
    self.sureButton.layer.masksToBounds =YES;
    self.sureButton.layer.cornerRadius = getWidth(6);
    
    self.getCodeButton.titleLabel.font = kSystemFontSize(getWidth(16));
 
}



- (IBAction)backVCAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)getCodeButtonAction:(UIButton *)sender {
    
    if (![Helper isMobileNumber:self.phoneTextField.text]) {
        [MBProgressHUD showTipMessageInView:@"请输入正确的手机号码"];
        return;
    }
    if (self.phoneTextField.text.length < 1)
    {
        [MBProgressHUD showTipMessageInView:@"请输入手机号码"];
        return;
    }
    Helper *helper = [[Helper alloc] init];
    [Helper verifyBtnAction:self.getCodeButton:helper];
    
    NSDictionary *params = @{
                             @"phone":self.phoneTextField.text,//手机号
                             //@"type":@"0"//0:注册；1:找回密码;3:更改绑定电话
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

- (IBAction)sureButtonAction:(UIButton *)sender {
    
    if (![Helper isMobileNumber:self.phoneTextField.text]) {
        
        [MBProgressHUD showTipMessageInView:@"请输入正确的手机号码"];
        return;
    }
    
    if (!self.codeTextField.text.length)
    {
        [MBProgressHUD showTipMessageInView:@"请输入验证码"];
        return;
    }
    
    NSDictionary *params = @{
                             @"code":self.codeTextField.text
                             };
    
    
    NSString *httpUrl = NETWORK_REQUEST_URL(USER_CheckLogin_URL);
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@",NETWORK_REQUEST_URL(USER_CheckLogin_URL),[[UserManger sharedInstance] getMemberToken]];
    DDLog(@"注册URL:%@;params:%@",httpUrl,params);
    [MBProgressHUD showActivityMessageInView:@""];
    [HttpTool postWithURL:urlstr params:params success:^(id json) {
        NSLog(@"data:%@",json);
        [MBProgressHUD hideHUD];
        int status = [json[@"success"] intValue];
        if (status == 1){
            UserManger *manage = [UserManger sharedInstance];
            [manage cacheUserPhone:self.phoneTextField.text];
            [self LoginRequest];
        }else{
            [MBProgressHUD showTipMessageInView:json[@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showTipMessageInView:[error localizedDescription]];
    }];
    
}

-(void)LoginRequest
{
    AppDelegate *app =(AppDelegate*)[UIApplication sharedApplication].delegate;
    [app loginFast];
}


#pragma mark UITextField代理方法

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag==10) {
        NSString * numberString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
        // 限制手机号码的输入位数
        if ( numberString.length > 11) {
            return NO;
        }
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:COUNTNUM] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        if (![string isEqualToString:filtered]) {
            return NO;
        }
    }
    if (textField.tag==20) {
        NSString * numberString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
        // 限制密码输入位数
        if ( numberString.length > 16) {
            return NO;
        }
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:PASSWORD] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        if (![string isEqualToString:filtered]) {
            return NO;
        }
    }
    if (textField.tag==30) {
        NSString * numberString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
        // 限制密码输入位数
        if ( numberString.length > 16) {
            return NO;
        }
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:PASSWORD] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        if (![string isEqualToString:filtered]) {
            return NO;
        }
    }
    if (textField.tag==40) {
        NSString * numberString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
        // 限制密码输入位数
        if ( numberString.length > 8) {
            return NO;
        }
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:COUNTNUM] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        if (![string isEqualToString:filtered]) {
            return NO;
        }
    }
    
    return YES;
}

// 点击键盘return键收起键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return  YES;
}


@end
