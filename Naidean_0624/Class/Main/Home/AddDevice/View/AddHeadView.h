//
//  AddHeadView.h
//  Naidean
//
//  Created by xujun on 2018/1/8.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddHeadView : UIView

@property (weak, nonatomic) IBOutlet UILabel *NotesLabel;

//@property (weak, nonatomic) IBOutlet UIImageView *BlueToothImgView;

@property (nonatomic ,copy) void (^searchBlock)(void);
@end
