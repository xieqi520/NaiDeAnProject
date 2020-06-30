//
//  UserInfoHeadView.m
//  Naidean
//
//  Created by xujun on 2018/1/5.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "UserInfoHeadView.h"

@interface UserInfoHeadView ()

@end

@implementation UserInfoHeadView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.UserImageView.layer.masksToBounds =YES;
    self.UserImageView.layer.cornerRadius = getWidth(30);
    [self.UserImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(getWidth(60), getWidth(60)));
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).offset(getWidth(15));
    }];
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.UserImageView.mas_right).offset(getWidth(15));
        make.size.mas_equalTo(CGSizeMake(getWidth(200), getWidth(28)));
        make.top.equalTo(self.mas_top).offset(getHeight(39));
    }];
    
    [self.userAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.UserImageView.mas_right).offset(getWidth(15));
        make.size.mas_equalTo(CGSizeMake(getWidth(140), getWidth(21)));
        make.top.equalTo(self.userName.mas_bottom).offset(getHeight(3));
    }];
    
    UIView *line =[[UIView alloc] init];
    line.backgroundColor =[UIColor colorWithHexString:@"#D9D9D9" alpha:1];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(WIN_WIDTH, 0.5));
    }];
    self.userName.font = kSystemFontSize(getWidth(20));
    self.userAccount.font = kSystemFontSize(getWidth(15));
    
    [self.EnterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(getWidth(-15));
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(getWidth(8), getWidth(12)));
    }];
    
   
    
    
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapACtion)];
    [self addGestureRecognizer:tap];
    
}
- (IBAction)ChangeImgBtn:(id)sender {
    if (self.ChangeImgBlock) {
        self.ChangeImgBlock();
    }
}

-(void)tapACtion
{
    if (self.ChangeImgBlock) {
        self.ChangeImgBlock();
    }
}



@end
