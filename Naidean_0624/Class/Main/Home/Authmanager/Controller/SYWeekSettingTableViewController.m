//
//  SYWeekSettingTableViewController.m
//  Naidean
//
//  Created by aoxin on 2018/8/17.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "SYWeekSettingTableViewController.h"
#import "SYPermissionTableViewCell.h"

@interface SYWeekSettingTableViewController ()

@property (strong,nonatomic) NSArray *weekAry;

@property (strong, nonatomic) NSMutableArray *unlockDays;

@end

@implementation SYWeekSettingTableViewController

- (NSMutableArray *)unlockDays{
    if (!_unlockDays) {
        _unlockDays = [NSMutableArray array];
    }
    return _unlockDays;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开锁时间";
    UIBarButtonItem *rightBtn =[[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"完成"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClicked)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    [self.tableView registerNib:[UINib nibWithNibName:@"SYPermissionTableViewCell" bundle:nil] forCellReuseIdentifier:@"WeekCell"];
    self.weekAry = @[@"每周日",@"每周一",@"每周二",@"每周三",@"每周四",@"每周五",@"每周六"];
    self.tableView.backgroundColor = SetColor(@"#F5F1F1");
    UIView *view =[[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = view;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {   // ios11系统下 处理页面push或Pop时屏幕移动
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.tableView.scrollEnabled = NO;
    
//    if ([self.unlockDays containsObject:@"8"]) {
//        [self.unlockDays removeAllObjects];
////        [self.unlockDays addObjectsFromArray:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7"]];
//    }
    [self.tableView reloadData];
}

- (void)rightBtnClicked{
    //排序
//    if (self.unlockDays.count == 7 || self.unlockDays.count == 0) {
//        [self.unlockDays removeAllObjects];
//        [self.unlockDays addObject:@"8"];
//    }
    NSArray *result = self.unlockDays;
    [result sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }else if ([obj1 integerValue] < [obj2 integerValue]){
            return (NSComparisonResult)NSOrderedAscending;
        }else{
            return (NSComparisonResult)NSOrderedSame;
        }
    }];
    self.selectDaysBlock(result);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.weekAry.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYPermissionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeekCell"];
    cell.permissionLab.text = self.weekAry[indexPath.row];
    NSString *index = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    NSLog(@"%@",self.unlockDays);
    if ([self.unlockDays containsObject:index]) {
        cell.selectBtn.selected = YES;
    }else {
        cell.selectBtn.selected = NO;
    }
    [cell sharedInstanceWithMode:weekMode];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SYPermissionTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectBtn.selected = !cell.selectBtn.selected;
    if (cell.selectBtn.selected) {
        [self.unlockDays addObject:[NSString stringWithFormat:@"%zd",indexPath.row + 1]];
        NSLog(@"self.unlockDays ===%@",self.unlockDays);
    }else{
        [self.unlockDays removeObject:[NSString stringWithFormat:@"%zd",indexPath.row + 1]];
        NSLog(@"self.unlockDays ===%@",self.unlockDays);
    }
}
@end
