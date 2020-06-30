//
//  DeviceCell.m
//  Naidean
//
//  Created by xujun on 2018/1/8.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "DeviceCell.h"

@implementation DeviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.Devicename = [[UILabel alloc] init];
        self.Devicename.textColor=[UIColor blackColor];
        self.Devicename.font = kSystemFontSize(getWidth(15));
        self.Devicename.text=@"智能门锁";
        
        self.DeviceNumber = [[UILabel alloc] init];
        self.DeviceNumber.textColor=[UIColor blackColor];
        self.DeviceNumber.font = kSystemFontSize(getWidth(15));
        self.DeviceNumber.text=@"智能门锁";
        
        self.DelectBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [self.DelectBtn addTarget:self action:@selector(delectAction) forControlEvents:UIControlEventTouchUpInside];
        [self.DelectBtn setImage:[UIImage imageNamed:@"btn_shanchu"] forState:UIControlStateNormal];
        [self addSubview:self.DelectBtn];
        [self addSubview:self.Devicename];
        [self addSubview:self.DeviceNumber];
        
        [self.DelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self.mas_right);
            make.size.mas_equalTo(CGSizeMake(getWidth(50), getHeight(40)));
        }];
        
        [self.Devicename mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self);
            make.top.equalTo(self.mas_top).offset(getWidth(5));
            make.left.equalTo(self.mas_left).offset(getWidth(15));
            make.size.mas_equalTo(CGSizeMake(getWidth(160), getWidth(25)));
        }];
        [self.DeviceNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.centerY.equalTo(self);
            make.top.equalTo(self.Devicename.mas_bottom).offset(getWidth(5));
            make.left.equalTo(self.mas_left).offset(getWidth(15));
            make.size.mas_equalTo(CGSizeMake(getWidth(200), 25));
        }];
        
    }
    return self;
    
}

-(void)delectAction
{
    if (self.delectBlock) {
        self.delectBlock(self);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
