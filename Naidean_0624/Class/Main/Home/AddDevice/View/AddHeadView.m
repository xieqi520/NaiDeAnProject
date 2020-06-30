//
//  AddHeadView.m
//  Naidean
//
//  Created by xujun on 2018/1/8.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "AddHeadView.h"

@interface AddHeadView ()

@property (weak, nonatomic) IBOutlet UIButton *BackImgView;


//@property (weak, nonatomic) IBOutlet UIButton *ChancelBtn;

@end

@implementation AddHeadView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (IBAction)searchAction:(id)sender {
    if (self.searchBlock) {
        self.searchBlock();
    }
}



@end
