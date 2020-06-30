//
//  SYHelpInfoViewController.m
//  Naidean
//
//  Created by aoxin on 2018/8/30.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "SYHelpInfoViewController.h"

@interface SYHelpInfoViewController ()

@end

@implementation SYHelpInfoViewController
{
    UITextView *textView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"使用帮助";
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, WIN_HEIGHT - 64)];
    textView.textAlignment = NSTextAlignmentLeft;
    textView.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
    textView.editable = NO;
    NSMutableParagraphStyle *titleParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    titleParagraphStyle.lineSpacing = 20.f;
    NSDictionary *titleAttributes = @{
                                 NSFontAttributeName:kSystemFontSize(18),
                                 NSForegroundColorAttributeName:[UIColor blackColor],
                                 NSParagraphStyleAttributeName:titleParagraphStyle
                                 };
    NSMutableParagraphStyle *bodyParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    bodyParagraphStyle.lineSpacing = 15.f;
    bodyParagraphStyle.paragraphSpacing = 10.f;
    bodyParagraphStyle.firstLineHeadIndent = 30.f;
    bodyParagraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary *bodyAttributes = @{
                                     NSFontAttributeName:kSystemFontSize(15),
                                     NSForegroundColorAttributeName:[UIColor blackColor],
                                     NSParagraphStyleAttributeName:bodyParagraphStyle
                                     };
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"1、蓝牙开锁\n请检查手机蓝牙是否开启、检查设备是否电量过低。\n2、WIFI开锁\n请检查手机WIFI是否开启、密码账号是否正确。"];;
    [title addAttributes:titleAttributes range:NSMakeRange(0, title.length)];
    
//    NSMutableAttributedString *textBody = [[NSMutableAttributedString alloc] initWithString: @""];
//    [textBody addAttributes:bodyAttributes range:NSMakeRange(0, textBody.length)];
//    NSMutableAttributedString *title1 = [[NSMutableAttributedString alloc] initWithString:@"2、WIFI开锁\n"];;
//    [title addAttributes:titleAttributes range:NSMakeRange(0, title.length)];
//    NSMutableAttributedString *textBody1 = [[NSMutableAttributedString alloc] initWithString: @"请检查手机WIFI是否开启、密码账号是否正确。"];
//    [textBody1 addAttributes:bodyAttributes range:NSMakeRange(0, textBody.length)];
//
//    [title appendAttributedString:textBody];
//    [title1 appendAttributedString:textBody1];
//    [title appendAttributedString:title1];
    textView.attributedText = title;
    [self.view addSubview:textView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
