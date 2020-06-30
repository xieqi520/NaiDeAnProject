//
//  SYUnlockTimeTableViewCell.m
//  Naidean
//
//  Created by aoxin on 2018/8/17.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "SYUnlockTimeTableViewCell.h"

@implementation SYUnlockTimeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(getWidth(15));
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(70, getHeight(21)));
    }];
    self.titleLab.textAlignment = NSTextAlignmentLeft;
    
    [self.subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).offset(-getWidth(30));
        make.size.mas_equalTo(CGSizeMake(175, getHeight(21)));
    }];
    self.subTitleLab.textAlignment = NSTextAlignmentRight;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
