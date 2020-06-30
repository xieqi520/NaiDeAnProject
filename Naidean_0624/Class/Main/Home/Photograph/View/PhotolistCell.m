//
//  PhotolistCell.m
//  Naidean
//
//  Created by xujun on 2018/1/4.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "PhotolistCell.h"

@implementation PhotolistCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
//    [self.PhotoImageview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self);
//        make.left.equalTo(self.mas_left).offset(getWidth(15));
//        make.size.mas_equalTo(CGSizeMake(getWidth(45), getWidth(45)));
//    }];
//    
//    self.ShowLabel.font = kSystemFontSize(getWidth(14));
//    [self.ShowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.PhotoImageview.mas_right).offset(getWidth(15));
//        make.centerY.equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(getWidth(80), getWidth(30)));
//    }];
//    
//    self.Timelabel.font =kSystemFontSize(getWidth(14));
//    [self.Timelabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.mas_right).offset(getWidth(-15));
//        make.centerY.equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(getWidth(40), getWidth(30)));
//    }];
//    
//    self.Datelabel.font = kSystemFontSize(getWidth(14));
//    [self.Datelabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.Timelabel.mas_left).offset(getWidth(-30));
//        make.centerY.equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(getWidth(80), getWidth(30)));
//    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
