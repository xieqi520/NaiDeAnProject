//
//  SYUserHeadTableViewCell.m
//  Naidean
//
//  Created by aoxin on 2018/8/24.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "SYUserHeadTableViewCell.h"

@implementation SYUserHeadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(getWidth(15));
        make.size.mas_equalTo(CGSizeMake(40, 18));
    }];
    _titleLab.textColor = SetColor(@"#6D6D72");
    
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(getWidth(-46));
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 12;
    NSString *headPath =  [[UserManger sharedInstance] getHeadPortrait];
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:headPath] placeholderImage:[UIImage imageNamed:@"img_morentouxiang"] options:SDWebImageCacheMemoryOnly];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
