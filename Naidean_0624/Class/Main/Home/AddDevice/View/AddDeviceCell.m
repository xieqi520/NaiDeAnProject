//
//  AddDeviceCell.m
//  Naidean
//
//  Created by xujun on 2018/1/8.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "AddDeviceCell.h"

@interface AddDeviceCell ()

@end

@implementation AddDeviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.DeviceNameLabel.font = kSystemFontSize(getWidth(15));
//    self.AddDeviceBtn.titleLabel.font = kSystemFontSize(getWidth(14));
//    [self.AddDeviceBtn addTarget:self action:@selector(AddDeviceClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.DeviceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(getWidth(200), getWidth(30)));
//        make.left.equalTo(self.mas_left).offset(getWidth(15));
//    }];
//
//    [self.AddDeviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(getWidth(50), getWidth(30)));
//        make.right.equalTo(self.mas_right).offset(getWidth(-15));
//    }];
    _AddDeviceBtn.layer.cornerRadius =3;
    _bindingBtn.layer.cornerRadius =3;
    _deleteBtn.layer.cornerRadius =3;
    [_AddDeviceBtn  addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    [_bindingBtn    addTarget:self action:@selector(bindingAction) forControlEvents:UIControlEventTouchUpInside];
    [_deleteBtn    addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addAction{
    self.bindingBtn.hidden = NO;
    self.deleteBtn.hidden = NO;
    self.AddDeviceBtn.hidden = YES;
}
-(void)bindingAction{
    if ( self.AddDeviceBlock) {
        self.AddDeviceBlock(self);
    }
}
-(void)deleteAction{
    if ( self.deleteDeviceBlock) {
        self.deleteDeviceBlock(self);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
