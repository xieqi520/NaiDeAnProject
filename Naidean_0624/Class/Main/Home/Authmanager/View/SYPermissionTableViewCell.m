//
//  SYPermissionTableViewCell.m
//  Naidean
//
//  Created by aoxin on 2018/8/17.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "SYPermissionTableViewCell.h"

@implementation SYPermissionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.permissionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(getWidth(15));
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(100, getHeight(21)));
    }];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-getWidth(15));
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(getWidth(20), getHeight(20)));
    }];
    
    self.selectBtn.userInteractionEnabled = NO;
    
}

- (void)sharedInstanceWithMode:(CellType)mode{
    UIImage *image = [UIImage imageNamed:@"btn_xuanze_weixuan"];
    UIImage *selectImg = [UIImage imageNamed:@"btn_xuanze_xuanzhong"];
    if (mode == weekMode) {
        image = nil;
        selectImg = [UIImage imageNamed:@"get"];
    }
    [self.selectBtn setImage:image forState:UIControlStateNormal];
    [self.selectBtn setImage:selectImg forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
