//
//  UserInfoCell.m
//  Naidean
//
//  Created by xujun on 2018/1/5.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "UserInfoCell.h"

@implementation UserInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
     self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.InfiImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(getWidth(15));
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(getWidth(17), getWidth(17)));
    }];
    
    [self.EnterImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(getWidth(-18));
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(getWidth(8), getWidth(12)));
    }];
    
    self.InfoSet.font = kSystemFontSize(getWidth(15));
    [self.InfoSet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.InfiImageview.mas_right).offset(getWidth(18));
        make.right.equalTo(self.EnterImageview.mas_right).offset(getWidth(-18));
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
