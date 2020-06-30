//
//  UnlockPSController.m
//  Naidean
//
//  Created by xujun on 2018/1/6.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "UnlockPSController.h"

@interface UnlockPSController ()
@property (weak, nonatomic) IBOutlet UITextField *Passwordlabel;

@property (weak, nonatomic) IBOutlet UITextField *Passwordlabel2;
@property (weak, nonatomic) IBOutlet UIButton *ChangePSBtn;

@end

@implementation UnlockPSController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"忘记密码";
    UIColor *color = [UIColor colorWithHexString:@"#a6a6a6" alpha:1];
    self.Passwordlabel.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"新密码" attributes:@{NSForegroundColorAttributeName: color}];
    self.Passwordlabel2.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"再次输入密码" attributes:@{NSForegroundColorAttributeName: color}];
    
    UIView *left =[[UIView alloc] initWithFrame:CGRectMake(getWidth(40), 0, getWidth(30), getWidth(30))];
    left.backgroundColor=[UIColor whiteColor];
    self.Passwordlabel.leftView =left;
    self.Passwordlabel.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *PSleft =[[UIView alloc] initWithFrame:CGRectMake(getWidth(40), 0, getWidth(30), getWidth(30))];
    PSleft.backgroundColor=[UIColor whiteColor];
    self.Passwordlabel2.leftView = PSleft;
    self.Passwordlabel2.leftViewMode = UITextFieldViewModeAlways;
    
    self.Passwordlabel.layer.borderColor =color.CGColor;
    self.Passwordlabel.layer.borderWidth = 0.5;
    self.Passwordlabel2.layer.borderColor =color.CGColor;
    self.Passwordlabel2.layer.borderWidth = 0.5;
    
    self.ChangePSBtn.layer.masksToBounds = YES;
    self.ChangePSBtn.layer.cornerRadius = 4;
    self.ChangePSBtn.titleLabel.font = kSystemFontSize(getWidth(17));
    
    [self.Passwordlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(getWidth(20)+64);
        make.left.equalTo(self.view.mas_left).offset(getWidth(15));
        make.right.equalTo(self.view.mas_right).offset(getWidth(-15));
        make.height.mas_equalTo(getWidth(48));
    }];
    
    [self.Passwordlabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Passwordlabel.mas_bottom).offset(getWidth(20));
        make.left.equalTo(self.view.mas_left).offset(getWidth(15));
        make.right.equalTo(self.view.mas_right).offset(getWidth(-15));
        make.height.mas_equalTo(getWidth(48));
    }];
    
    [self.ChangePSBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Passwordlabel2.mas_bottom).offset(getWidth(20));
        make.left.equalTo(self.view.mas_left).offset(getWidth(15));
        make.right.equalTo(self.view.mas_right).offset(getWidth(-15));
        make.height.mas_equalTo(getWidth(48));
    }];
    
}

- (IBAction)ReturnBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)ChangePSBtn:(id)sender {
    
    
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
