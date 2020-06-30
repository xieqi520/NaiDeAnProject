//
//  SYCheckEditionController.m
//  Naidean
//
//  Created by aoxin1 on 2019/8/8.
//  Copyright © 2019 com.saiyikeji. All rights reserved.
//

#import "SYCheckEditionController.h"

@interface SYCheckEditionController ()

@end

@implementation SYCheckEditionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"查看版本";
    self.view.backgroundColor = [UIColor whiteColor];
    [self  initUI];
}
-(void)initUI{
    
    UIImageView *imageV = [[UIImageView  alloc]initWithFrame:CGRectMake((WIN_WIDTH-50)/2, WIN_HEIGHT/2-100, 60, 60)];
    imageV.image = [UIImage  imageNamed:@"AppIcon"];
    imageV.layer.cornerRadius =5;
    imageV.layer.masksToBounds = YES;
    [self.view  addSubview:imageV];
    
    UILabel *lab = [[UILabel  alloc]initWithFrame:CGRectMake((WIN_WIDTH-150)/2,CGRectGetMaxY(imageV.frame) , 150, 40)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont  systemFontOfSize:15.0];
    lab.text = @"当前版本号为：1.0";
    lab.textColor =[UIColor  grayColor];// [UIColor  colorWithRed:127 green:127 blue:127 alpha:1.0];
    [self.view  addSubview:lab];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
