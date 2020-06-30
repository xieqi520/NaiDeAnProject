//
//  AuthheadView.m
//  Naidean
//
//  Created by xujun on 2018/1/5.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "AuthheadView.h"

@implementation AuthheadView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
       
        self.Authimageview =[[UIImageView alloc] init];
        self.Authimageview.image=[UIImage imageNamed:@"bg1"];
        self.Authimageview.contentMode = UIViewContentModeScaleToFill;
        self.Authimageview.layer.masksToBounds =YES;
        self.Authimageview.layer.cornerRadius = getWidth(27);
        [self addSubview:self.Authimageview];
        [self.Authimageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(getWidth(15));
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(getWidth(54), getWidth(54)));
        }];
        
        UILabel *lab=[[UILabel alloc] init];
        lab.text=@"管理员";
        lab.textColor=[UIColor colorWithHexString:@"#23293e" alpha:1];
        lab.font =kSystemFontSize(getWidth(15));
        lab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.Authimageview.mas_right).offset(getWidth(15));
            make.size.mas_equalTo(CGSizeMake(getWidth(100), getHeight(21)));
            make.top.equalTo(self.mas_top).offset(getHeight(14));
        }];
        
        self.Authname = [[UILabel alloc] init];
        self.Authname.font =kSystemFontSize(getWidth(13));
        self.Authname.text=@"大佬";
        self.Authname.textAlignment = NSTextAlignmentLeft;
        self.Authname.textColor=[UIColor colorWithHexString:@"#a1a1a1" alpha:1];
        [self addSubview:self.Authname];
        [self.Authname mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.Authimageview.mas_right).offset(getWidth(15));
            make.size.mas_equalTo(CGSizeMake(getWidth(100), getHeight(18)));
            make.top.equalTo(lab.mas_bottom).offset(getHeight(5));
        }];
    }
    return self;
}


@end
