//
//  SYTimeSettingTableViewCell.m
//  Naidean
//
//  Created by aoxin on 2018/8/17.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "SYTimeSettingTableViewCell.h"

@implementation SYTimeSettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.firstBtn.layer.cornerRadius =3;
//    self.firstBtn.layer.borderColor = [UIColor  colorWithRed:138 green:138 blue:138 alpha:1.0].CGColor;
//    self.firstBtn.layer.borderWidth = 1;
    self.firstBtn.backgroundColor = SYColor(138, 138, 138);//[UIColor  colorWithRed:228 green:228 blue:228 alpha:1.0];
    
    self.secondBtn.layer.cornerRadius =3;
//    self.secondBtn.layer.borderColor = [UIColor  colorWithRed:138 green:138 blue:138 alpha:1.0].CGColor;
//    self.secondBtn.layer.borderWidth = 1;
    self.secondBtn.backgroundColor = SYColor(138, 138, 138);//[UIColor  colorWithRed:228 green:228 blue:228 alpha:1.0];
    
    self.thirdBtn.layer.cornerRadius =3;
    //self.thirdBtn.layer.borderColor = SYColor(138, 138, 138);//[UIColor  colorWithRed:138 green:138 blue:138 alpha:1.0].CGColor;
//    self.thirdBtn.layer.borderWidth = 1;
    self.thirdBtn.backgroundColor = SYColor(138, 138, 138);//[UIColor  colorWithRed:228 green:228 blue:228 alpha:1.0];
//    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(getWidth(15));
//        make.top.equalTo(self.mas_top).offset(getHeight(13));
//        make.size.mas_equalTo(CGSizeMake(70, getHeight(21)));
//    }];
//
//    [self.secondTF mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top).offset(getHeight(61));
//        make.centerX.equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(100, getHeight(30)));
//    }];
//    self.secondTF.adjustsFontSizeToFitWidth = YES;
//
//    CGFloat space = (WIN_WIDTH - 300)/4;
//    [self.firstTF mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.secondTF.mas_left).offset(-space);
//        make.top.equalTo(self.titleLab.mas_bottom).offset(getHeight(27));
//        make.size.mas_equalTo(CGSizeMake(100, getHeight(30)));
//    }];
//    self.firstTF.adjustsFontSizeToFitWidth = YES;
//
//    [self.thirdTF mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.secondTF.mas_right).offset(space);
//        make.centerY.equalTo(self.secondTF);
//        make.size.mas_equalTo(CGSizeMake(100, getHeight(30)));
//    }];
//    self.thirdTF.adjustsFontSizeToFitWidth = YES;
    
    
    
}

- (void)displayWithTimePicker:(SYTimePickerView *)timePicker AuthorizedUserModel:(AuthorizedUserModel *)model{
////    self.firstTF.inputView = timePicker;
//    self.firstBtn.titleLabel.text = model.times[0] ? model.times[0]:@"08:00-10:00";
////    self.secondTF.inputView = timePicker;
//    self.secondBtn.titleLabel.text = model.times[1] ? model.times[1]:@"12:00-14:00";
////    self.thirdTF.inputView = timePicker;
//    self.thirdBtn.titleLabel.text = model.times[2] ? model.times[2]:@"17:00-19:00";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
