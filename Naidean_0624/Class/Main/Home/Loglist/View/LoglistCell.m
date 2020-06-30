//
//  LoglistCell.m
//  Naidean
//
//  Created by xujun on 2018/1/6.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "LoglistCell.h"

@implementation LoglistCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.Userimageview.layer.masksToBounds =YES;
    self.Userimageview.layer.cornerRadius = getWidth(22);
    [self.Userimageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(getWidth(15));
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(getWidth(44), getWidth(44)));
    }];
    
    self.Methodlabel.font = kSystemFontSize(getWidth(14));
    self.Methodlabel.numberOfLines=1;
    [self.Methodlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.Userimageview.mas_right).offset(getWidth(15));
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(150, getWidth(21)));
    }];
    
    self.Datelabel.font = kSystemFontSize(getWidth(11));
    [self.Datelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(getWidth(-15));
        make.size.mas_equalTo(CGSizeMake(70, getHeight(16)));
        make.top.equalTo(self.mas_top).offset(getWidth(14));
    }];
    
    self.Timelabel.font = kSystemFontSize(getWidth(11));
    [self.Timelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.Datelabel);
       // make.right.equalTo(self.mas_right).offset(getWidth(-10));
        make.size.mas_equalTo(CGSizeMake(70, getHeight(16)));
        make.bottom.equalTo(self.mas_bottom).offset(getWidth(-14));
    }];
    
//    [self.MethodImageview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.Datelabel.mas_left).offset(getWidth(-15));
//        make.centerY.equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(getWidth(24), getWidth(28)));
//    }];
    self.MethodImageview.hidden = YES;
}

/*设置开锁类型图片*/
-(void)setUnlock:(Unlock)unlock
{
    _unlock = unlock;
    switch (unlock) {
        case fingerprint:
            self.MethodImageview.image =[UIImage imageNamed:@"img_zhiwend"];
            break;
        case password:
            self.MethodImageview.image =[UIImage imageNamed:@"btn_yuancheng-拷贝-2"];
            break;
        case remotecontrol:
            self.MethodImageview.image =[UIImage imageNamed:@"img_linshimm"];
            break;
        default:
            break;
    }
}

- (void)displayViewWithLogModel:(LockLogModel *)model{
    NSString *headPath =  NETWORK_REQUEST_URL([[UserManger sharedInstance] getHeadPortrait]);//[NSString stringWithFormat:@"%@%@",model.headPicurl];
    [self.Userimageview  sd_setImageWithURL:[NSURL URLWithString:headPath] placeholderImage:[UIImage imageNamed:@"img_morentouxiang"] options:SDWebImageCacheMemoryOnly];
//    [self.MethodImageview sd_setImageWithURL:[NSURL URLWithString:headPath] placeholderImage:[UIImage imageNamed:@"bg_shouye"]];
    NSInteger unlockType = [[UserManger sharedInstance] getUnlockType];
    NSString *text = [NSString string];
    NSString *name = model.memoName.length > 0 ? model.memoName : model.phone;
    //0 APP 1 密码开锁 2 指纹开锁 3密码+指纹 4 指纹+指纹开锁 5指纹+指纹+密码 -1关锁
//    if (unlockType == 1) {
//        text = [NSString stringWithFormat:@"%@ 使用WiFi开锁",name];
//    }else{
//        text = [NSString stringWithFormat:@"%@ 使用蓝牙开锁",name];
//    }
    NSString *opentype = @"关锁";
    switch ([model.openType integerValue]) {
        case 0:
            opentype = @"使用APP开锁";
            break;
        case 1:
            opentype = @"使用密码开锁";
            break;
        case 2:
            opentype = @"使用指纹开锁";
            break;
        case 3:
            opentype = @"使用密码+指纹";
            break;
        case 4:
            opentype = @"使用指纹+指纹开锁";
            break;
        case 5:
            opentype = @"指纹+指纹+密码";
            break;
        default:
            break;
    }
    text = [NSString stringWithFormat:@"%@ %@",name,opentype];
    self.Methodlabel.text = text;
    NSString *dateStr = [model.createTime substringToIndex:10];
    NSString *timeStr = [model.createTime substringWithRange:NSMakeRange(11, 5)];
    self.Datelabel.text = dateStr;
    self.Timelabel.text = timeStr;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
