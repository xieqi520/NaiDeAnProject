//
//  RegisterController.m
//  Naidean
//
//  Created by xujun on 2018/1/4.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "RegisterController.h"
#import "NSString+LuAddition.h"

@interface RegisterController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *Logoimageview;   //Logo图标
@property (weak, nonatomic) IBOutlet UITextField *Phonetextfield;  //电话号码输入框
@property (weak, nonatomic) IBOutlet UITextField *PStextfield;     //密码输入框
@property (weak, nonatomic) IBOutlet UITextField *SurePStextfield; //密码确认输入框
@property (weak, nonatomic) IBOutlet UITextField *Codetextfield;   //验证码输入框
@property (weak, nonatomic) IBOutlet UIButton *GetCodeBtn;         //获取验证码按钮
@property (weak, nonatomic) IBOutlet UIButton *RegisterBtn;        //注册按钮
@property (weak, nonatomic) IBOutlet UIButton *ReturnBtn;          //返回按钮
@property (weak, nonatomic) IBOutlet UIView *BackView;             //背景视图

@end

@implementation RegisterController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWithUI];
    
}

/**
初始化控件与布局
*/
-(void)initWithUI
{
    [self.BackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(getHeight(206));
    }];
    
    self.ReturnBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -58, 0, 0);
    [self.ReturnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(getHeight(20));
        make.left.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(getWidth(100), getWidth(40)));
    }];
    
    self.Logoimageview.backgroundColor=[UIColor whiteColor];
    self.Logoimageview.layer.masksToBounds =YES;
    self.Logoimageview.layer.cornerRadius = getWidth(60);
    self.Logoimageview.image = [UIImage imageNamed:@"img_morentouxiang"];
    [self.Logoimageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(getHeight(60));
        make.size.mas_equalTo(CGSizeMake(getWidth(120), getWidth(120)));
    }];
    
    self.Phonetextfield.font =kSystemFontSize(getWidth(14));
    [self.Phonetextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.BackView.mas_bottom).offset(getHeight(20));
        make.left.equalTo(self.view.mas_left).offset(getWidth(15));
        make.right.equalTo(self.view.mas_right).offset(getWidth(-15));
        make.height.mas_equalTo(getHeight(46));
    }];
    
    self.PStextfield.font =kSystemFontSize(getWidth(14));
    [self.PStextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Phonetextfield.mas_bottom).offset(getHeight(20));
        make.left.equalTo(self.view.mas_left).offset(getWidth(15));
        make.right.equalTo(self.view.mas_right).offset(getWidth(-15));
        make.height.mas_equalTo(getHeight(46));
    }];
    
    self.SurePStextfield.font =kSystemFontSize(getWidth(14));
    [self.SurePStextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.PStextfield.mas_bottom).offset(getHeight(20));
        make.left.equalTo(self.view.mas_left).offset(getWidth(15));
        make.right.equalTo(self.view.mas_right).offset(getWidth(-15));
        make.height.mas_equalTo(getHeight(46));
    }];
    
    [self.GetCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SurePStextfield.mas_bottom).offset(getHeight(20));
        make.size.mas_equalTo(CGSizeMake(getWidth(100), getWidth(46)));
        make.right.equalTo(self.view.mas_right).offset(getWidth(-15));
    }];
    
    self.Codetextfield.font =kSystemFontSize(getWidth(14));
    [self.Codetextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SurePStextfield.mas_bottom).offset(getHeight(20));
        make.left.equalTo(self.view.mas_left).offset(getWidth(15));
        make.right.equalTo(self.GetCodeBtn.mas_left).offset(getWidth(-20));
        make.height.mas_equalTo(getHeight(46));
    }];
    
    [self.RegisterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(getHeight(46));
        make.left.equalTo(self.view.mas_left).offset(getWidth(15));
        make.right.equalTo(self.view.mas_right).offset(getWidth(-15));
        make.top.equalTo(self.Codetextfield.mas_bottom).offset(getHeight(20));
    }];
    
    UIColor *color = [UIColor colorWithHexString:@"#a6a6a6" alpha:1];
    self.Phonetextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号码" attributes:@{NSForegroundColorAttributeName: color}];
    
    [self.RegisterBtn setTitle:@"注册" forState:UIControlStateNormal];
    self.PStextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入注册密码" attributes:@{NSForegroundColorAttributeName: color}];
    self.SurePStextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"再次确认密码" attributes:@{NSForegroundColorAttributeName: color}];
    self.Codetextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"验证码" attributes:@{NSForegroundColorAttributeName: color}];
    
    UIView *left =[[UIView alloc] initWithFrame:CGRectMake(40, 0, 30, 30)];
    left.backgroundColor=[UIColor whiteColor];
    self.Phonetextfield.leftView =left;
    self.Phonetextfield.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *PSleft =[[UIView alloc] initWithFrame:CGRectMake(getWidth(40), 0, getWidth(30), getWidth(30))];
    PSleft.backgroundColor=[UIColor whiteColor];
    self.PStextfield.leftView = PSleft;
    self.PStextfield.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *Sureleft =[[UIView alloc] initWithFrame:CGRectMake(getWidth(40), 0, getWidth(30), getWidth(30))];
    Sureleft.backgroundColor=[UIColor whiteColor];
    self.SurePStextfield.leftView =Sureleft;
    self.SurePStextfield.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *Codeleft =[[UIView alloc] initWithFrame:CGRectMake(getWidth(40), 0, getWidth(30), getWidth(30))];
    Codeleft.backgroundColor=[UIColor whiteColor];
    self.Codetextfield.leftView =Codeleft;
    self.Codetextfield.leftViewMode = UITextFieldViewModeAlways;
    
    self.PStextfield.secureTextEntry= YES;
    self.SurePStextfield.secureTextEntry= YES;
    
    self.Phonetextfield.delegate=self;
    self.PStextfield.delegate =self;
    self.SurePStextfield.delegate=self;
    self.Codetextfield.delegate=self;
    
    self.Phonetextfield.tag =10;
    self.PStextfield.tag =20;
    self.SurePStextfield.tag =30;
    self.Codetextfield.tag =40;
    
    self.Phonetextfield.layer.borderColor =color.CGColor;
    self.Phonetextfield.layer.borderWidth = 0.5;
    self.PStextfield.layer.borderColor =color.CGColor;
    self.PStextfield.layer.borderWidth = 0.5;
    self.SurePStextfield.layer.borderColor =color.CGColor;
    self.SurePStextfield.layer.borderWidth = 0.5;
    self.Codetextfield.layer.borderColor =color.CGColor;
    self.Codetextfield.layer.borderWidth = 0.5;
    
    self.RegisterBtn.layer.masksToBounds =YES;
    self.RegisterBtn.layer.cornerRadius = getWidth(6);
    
    self.GetCodeBtn.titleLabel.font = kSystemFontSize(getWidth(16));
    self.RegisterBtn.titleLabel.font = kSystemFontSize(getWidth(17));
}


/**
 获取验证码按钮点击事件

 @param sender 按钮
 */
- (IBAction)GetCodeaction:(UIButton*)sender {
    
    if (![Helper isMobileNumber:self.Phonetextfield.text]) {
        [MBProgressHUD showTipMessageInView:@"请输入正确的手机号码"];
        return;
    }
    if (self.Phonetextfield.text.length < 1)
    {
        [MBProgressHUD showTipMessageInView:@"请输入手机号码"];
        return;
    }
    Helper *helper = [[Helper alloc] init];
    [Helper verifyBtnAction:self.GetCodeBtn:helper];
    
    NSDictionary *params = @{
                             @"phone":self.Phonetextfield.text,//手机号
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

/**
 注册按钮点击事件
 
 @param sender 按钮
 */
- (IBAction)Registeraction:(UIButton*)sender {
    
    if (![Helper isMobileNumber:self.Phonetextfield.text]) {
        
        [MBProgressHUD showTipMessageInView:@"请输入正确的手机号码"];
        return;
    }
    if (self.PStextfield.text.length < 6)
    {
        [MBProgressHUD showTipMessageInView:@"请输入6~12位密码"];
        return;
    }
    
//    if (self.SurePStextfield.text.length < 1)
//    {
//        [MBProgressHUD showTipMessageInView:@"请输入确认密码"];
//        return;
//    }
//
//    if (![self.PStextfield.text isEqualToString:self.SurePStextfield.text])
//    {
//        [MBProgressHUD showTipMessageInView:@"请输入相同的密码"];
//        return;
//    }
    
    if (!self.Codetextfield.text.length)
    {
        [MBProgressHUD showTipMessageInView:@"请输入验证码"];
        return;
    }
    
    
    NSDictionary *params = @{
                             @"phone":self.Phonetextfield.text,
                             @"password":self.PStextfield.text ,
                             @"nickName":self.SurePStextfield.text ,
                             @"code":self.Codetextfield.text
                             };
    NSString *httpUrl = NETWORK_REQUEST_URL(USER_GEGISTER_URL);
    DDLog(@"注册URL:%@;params:%@",httpUrl,params);
    [MBProgressHUD showActivityMessageInView:@""];
    [HttpTool postWithURL:httpUrl params:params success:^(id json) {
        NSLog(@"data:%@",json);
        [MBProgressHUD hideHUD];
        int status = [json[@"success"] intValue];
        if (status == 0){
            UserManger *manage = [UserManger sharedInstance];
            [manage cacheUserPhone:self.Phonetextfield.text];
            [manage cacheUserNickname:self.SurePStextfield.text];
            [manage cacheUserPassWord:self.PStextfield.text];
//            [self LoginRequest];
//            [[ NSUserDefaults  standardUserDefaults]  setObject:@{@"userPhone":self.Phonetextfield.text,@"password":self.PStextfield.text} forKey:@"userInfo"];
            [self.navigationController  popViewControllerAnimated: YES];
        }else{
            [MBProgressHUD showTipMessageInView:json[@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showTipMessageInView:[error localizedDescription]];
    }];
    
    
    
}

//-(void)LoginRequest
//{
//    AppDelegate *app =(AppDelegate*)[UIApplication sharedApplication].delegate;
//    [app loginFast];
//}


// 返回按钮
- (IBAction)ReturnBtnaction:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
