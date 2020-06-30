//
//  PhotolistCell.h
//  Naidean
//
//  Created by xujun on 2018/1/4.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotolistCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *PhotoImageview;
@property (weak, nonatomic) IBOutlet UILabel *Datelabel;
@property (weak, nonatomic) IBOutlet UILabel *ShowLabel;

@end
