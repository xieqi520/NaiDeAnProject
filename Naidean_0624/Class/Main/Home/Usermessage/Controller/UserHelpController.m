//
//  UserHelpController.m
//  Naidean
//
//  Created by xujun on 2018/1/12.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "UserHelpController.h"
#import "SYHelpInfoViewController.h"

@interface UserHelpController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *helpTableview;

@end

@implementation UserHelpController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"使用帮助";
    [self.view setBackgroundColor:SetColor(@"#F5F1F1")];
    
    _helpTableview =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, WIN_HEIGHT-64)];
    _helpTableview.delegate=self;
    _helpTableview.dataSource=self;
    _helpTableview.backgroundColor = SetColor(@"#F5F1F1");
    if (@available(iOS 11.0, *)) {   // ios 11系统下 处理页面push或Pop时屏幕移动
        _helpTableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    _helpTableview.tableFooterView = view;
    _helpTableview.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:_helpTableview];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HelpCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HelpCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = kSystemFontSize(getWidth(15));
    cell.textLabel.text = [NSString stringWithFormat:@"%zd、设备连接不上怎么办？",indexPath.row + 1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SYHelpInfoViewController *helpInfoViewController = [SYHelpInfoViewController new];
    [self.navigationController pushViewController:helpInfoViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
