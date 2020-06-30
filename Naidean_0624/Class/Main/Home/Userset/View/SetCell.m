//
//  SetCell.m
//  Naidean
//
//  Created by xujun on 2018/1/5.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "SetCell.h"

@implementation SetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.Nextiamgeview.hidden =YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.Setname.font = kSystemFontSize(getWidth(15));
    [self.Switch setOn:NO];
    [self.Switch addTarget:self action:@selector(SwitchAction:) forControlEvents:(UIControlEventValueChanged)];
    
    [self.Nextiamgeview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).offset(getWidth(-30));
        make.size.mas_equalTo(CGSizeMake(getWidth(8), getWidth(12)));
    }];
    
    [self.Switch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(getWidth(-20));
        make.centerY.equalTo(self);
    }];
}

-(void)SwitchAction:(UISwitch*)Switch
{
    if (self.SwitchBlock) {
        self.SwitchBlock(self,self.Switch.on);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
