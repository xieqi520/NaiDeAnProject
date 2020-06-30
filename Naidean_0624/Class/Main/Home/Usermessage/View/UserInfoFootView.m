//
//  UserInfoFootView.m
//  Naidean
//
//  Created by xujun on 2018/1/5.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "UserInfoFootView.h"

@implementation UserInfoFootView

-(void)awakeFromNib
{
    [super awakeFromNib];
    UIView *topLine =[[UIView alloc] init];
    UIView *bottomLine = [[UIView alloc] init];
    topLine.backgroundColor=[UIColor colorWithHexString:@"#D9D9D9" alpha:1];
    [self addSubview:topLine];
    bottomLine.backgroundColor=[UIColor colorWithHexString:@"#D9D9D9" alpha:1];
    [self addSubview:bottomLine];
    self.backgroundColor =[UIColor colorWithHexString:@"#f5f5f9" alpha:1];
//    self.LogoutBtn.layer.masksToBounds =YES;
//    self.LogoutBtn.layer.cornerRadius = getWidth(6);
    self.LogoutBtn.titleLabel.font =kSystemFontSize(getWidth(15));
    [self.LogoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(getWidth(44));
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom).offset(getWidth(-83));
    }];
    
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.LogoutBtn.mas_centerX);
        make.bottom.equalTo(self.LogoutBtn.mas_top);
        make.size.mas_equalTo(CGSizeMake(WIN_WIDTH, 0.5));
    }];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.LogoutBtn.mas_centerX);
        make.top.equalTo(self.LogoutBtn.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(WIN_WIDTH, 0.5));
    }];
}

- (IBAction)LogoutAction:(id)sender {
    
    if (self.LogoutBlock) {
        self.LogoutBlock();
    }
}


@end
