//
//  AboutUsController.m
//  Naidean
//
//  Created by xujun on 2018/1/12.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "AboutUsController.h"

@interface AboutUsController ()

@end

@implementation AboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    self.view.backgroundColor =SetColor(@"#F5F1F1");
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-20"]];
    logoImageView.backgroundColor = SetColor(@"#FF7B06");
    logoImageView.layer.masksToBounds = YES;
    logoImageView.layer.cornerRadius = getWidth(15);
    [self.view addSubview:logoImageView];
    
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(getHeight(75));
        make.size.mas_equalTo(CGSizeMake(getWidth(70), getWidth(70)));
    }];
    
    UILabel *versionLab = [[UILabel alloc] init];
    versionLab.textAlignment = NSTextAlignmentCenter;
    versionLab.font = kSystemFontSize(getWidth(15));
//    versionLab.text = [NSString stringWithFormat:@"V%@",[self getCurrentVersion]];
    [self.view addSubview:versionLab];
    [versionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(logoImageView.mas_bottom).offset(getHeight(10));
        make.size.mas_equalTo(CGSizeMake(getWidth(50), getHeight(21)));
    }];
    
    UILabel *appNameLab = [[UILabel alloc]init];
    appNameLab.textAlignment = NSTextAlignmentCenter;
    appNameLab.font = kSystemFontSize(getWidth(15));
    appNameLab.text = @"智能门锁";
    [self.view addSubview:appNameLab];
    [appNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(versionLab.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(getWidth(100), getHeight(21)));
    }];
    
    UILabel *copyrightLab = [[UILabel alloc]init];
    copyrightLab.textAlignment = NSTextAlignmentCenter;
    copyrightLab.font = kSystemFontSize(getWidth(13));
    copyrightLab.text = @"copyright©️2018耐得安门锁";
    [self.view addSubview:copyrightLab];
    [copyrightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(getHeight(-20));
        make.size.mas_equalTo(CGSizeMake(getWidth(200), getHeight(21)));
    }];
}

- (NSString *)getCurrentVersion{
    //获取当前APP的版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    NSString *currentVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return currentVersion;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
