//
//  DeviceInfoCell.m
//  Naidean
//
//  Created by aoxin1 on 2019/8/8.
//  Copyright © 2019 com.saiyikeji. All rights reserved.
//

#import "DeviceInfoCell.h"

@implementation DeviceInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (NSDictionary *)replacedKeyFromPropertyName{
    
    return @{@"idStr":@"id"};
}
@end
