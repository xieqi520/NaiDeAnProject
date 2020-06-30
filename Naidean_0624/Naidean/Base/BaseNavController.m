//
//  BaseNavController.m
//  Naidean
//
//  Created by xujun on 2018/1/3.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "BaseNavController.h"

@interface BaseNavController ()

@end

@implementation BaseNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏的颜色
    self.navigationBar.barTintColor = NA_BACKGROUND_COLOR;
    self.navigationBar.translucent = NO;
    //设置导航栏字体的颜色和状态栏字体的颜色
    self.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationBar.tintColor = [UIColor whiteColor]; // 设置导航栏上系统按钮以及返回按钮颜色
   // [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:kSystemFontSize(20)}];
   //   [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:kSystemFontSize(getWidth(20)),NSForegroundColorAttributeName:[UIColor whiteColor]}];

    //导航栏返回按钮图片设置
    self.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"btn_backzt"];
    self.navigationBar.backIndicatorImage = [UIImage imageNamed:@"btn_backzt"];
  
    //去掉导航栏下的黑线
    UIView * backgroundView = [self.navigationBar subviews].firstObject;
    UIView * navLine = [backgroundView subviews].firstObject;
    navLine.hidden = YES;
    
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{

    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    if (self.viewControllers.count > 0) {
//        //viewController是将要被push的控制器
//        viewController.hidesBottomBarWhenPushed = YES;
//    }
//    if (self.viewControllers.count == 1) {
//
//    }
    NSArray *views = self.viewControllers;
   [super pushViewController:viewController animated:animated];

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
