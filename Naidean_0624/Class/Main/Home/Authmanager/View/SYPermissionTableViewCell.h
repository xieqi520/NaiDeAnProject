//
//  SYPermissionTableViewCell.h
//  Naidean
//
//  Created by aoxin on 2018/8/17.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    permissionMode = 1,
    weekMode = 2
}CellType;
@interface SYPermissionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *permissionLab;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (assign,nonatomic) CellType cellType;

- (void)sharedInstanceWithMode:(CellType)mode;

@end
