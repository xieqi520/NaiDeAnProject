//
//  AuthCell.m
//  Naidean
//
//  Created by xujun on 2018/1/5.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "AuthCell.h"

@implementation AuthCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.Authimageview.layer.masksToBounds =YES;
    self.Authimageview.layer.cornerRadius = getWidth(18);
    [self.Authimageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(getWidth(15));
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(getWidth(36), getWidth(36)));
    }];
    
    self.Authname.font=kSystemFontSize(getWidth(14));
    [self.Authname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.Authimageview.mas_right).offset(getWidth(10));
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(getWidth(200), getWidth(30)));
    }];
   
    [self.SelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(getWidth(-16));
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(getWidth(40), getWidth(40)));
    }];
    
    self.SelectBtn.userInteractionEnabled = NO;
    [self.SelectBtn addTarget:self action:@selector(SelectAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}

-(void)SelectAction:(UIButton*)sender
{
    NSLog(@"点击选择");
    if (self.SelectOrNoBlock) {
        self.SelectOrNoBlock(sender.selected);
    }
    sender.selected = !sender.selected;
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
