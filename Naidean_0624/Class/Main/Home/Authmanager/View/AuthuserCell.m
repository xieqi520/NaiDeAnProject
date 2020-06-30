//
//  AuthuserCell.m
//  Naidean
//
//  Created by xujun on 2018/1/5.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "AuthuserCell.h"

@implementation AuthuserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.AuthImageview.layer.masksToBounds = YES;
    self.AuthImageview.layer.cornerRadius = getWidth(17);
    self.AuthImageview.contentMode = UIViewContentModeScaleToFill;
    self.AuthImageview.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.AuthImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(getWidth(15));
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(getWidth(34), getWidth(34)));
    }];
    
    self.Authusername.font = kSystemFontSize(getWidth(17));
    [self.Authusername mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(getHeight(12));
        make.left.equalTo(self.AuthImageview.mas_right).offset(getWidth(15));
        make.size.mas_equalTo(CGSizeMake(getWidth(100), getHeight(17)));
    }];
    
    self.authPhone.font = kSystemFontSize(getWidth(13));
    [self.authPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Authusername.mas_bottom).offset(getHeight(4));
        make.left.equalTo(self.AuthImageview.mas_right).offset(getWidth(15));
        make.size.mas_equalTo(CGSizeMake(getWidth(100), getHeight(16)));
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
