//
//  LoglistController.m
//  Naidean
//
//  Created by xujun on 2018/1/4.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "LoglistController.h"
#import "LoglistCell.h"
#import "LockLogModel.h"

@interface LoglistController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) NSMutableArray *logListAry;
@property (nonatomic, copy) NSMutableArray *ignoreAry;
@property (nonatomic, assign) NSInteger pageCnt;
@end

@implementation LoglistController
{
    
    UITableView *Logtableview;
    
}

- (NSMutableArray *)logListAry{
    if (!_logListAry) {
        _logListAry = [[NSMutableArray alloc] init];
    }
    return _logListAry;
}

- (NSMutableArray *)ignoreAry{
    if (!_ignoreAry) {
        _ignoreAry = [NSMutableArray arrayWithArray:[[UserManger sharedInstance] getIgnoreIds]];
    }
    return _ignoreAry;
}

- (void)loadData{
    NSDictionary *params = @{
                             @"page":[NSString stringWithFormat:@"%ld",self.pageCnt],
                             @"deviceId":self.device.id,
                             @"size":@"10"
                             };
    DDLog(@"GetAllLogUrl:%@;params:%@",NETWORK_REQUEST_URL(GET_ALL_LOG_URL),params);
    [MBProgressHUD showActivityMessageInView:@""];
    NSString *httpUrl = [NSString stringWithFormat:@"%@/%@",NETWORK_REQUEST_URL(GET_ALL_LOG_URL),[[UserManger sharedInstance] getMemberToken]];
    [HttpTool postWithURL:httpUrl params:params success:^(id json) {
        DDLog(@"result:%@",json);
        [MBProgressHUD hideHUD];
        int code = [json[@"code"] intValue];
        if (code == 1000) {
            
//            [self.logListAry removeAllObjects];
            NSArray *dataAry = json[@"data"][@"list"];
            for (NSInteger i = 0; i < dataAry.count; i++) {
                LockLogModel *log = [[LockLogModel alloc]initWithJSON:dataAry[i]];
                if (![self.ignoreAry containsObject:log.id]) {
                    [self.logListAry addObject:log];
                }
            }
            NSUInteger totalItems = [json[@"data"][@"totalItems"] integerValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                [Logtableview reloadData];
                if (totalItems > self.ignoreAry.count) {
                    self.pageCnt++;
                }
            });
        }else if (code == TimeOutCode)
        {
            [MBProgressHUD showTipMessageInView:json[@"登录超时，请重新登录"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_TimeOut_Login object:nil];
        }
        else
        {
            [MBProgressHUD showTipMessageInView:json[@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showTipMessageInView:[error localizedDescription]];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageCnt = 1;
    [self loadData];
    
    self.title=@"开锁记录";
    UIBarButtonItem *rightBtn =[[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"清空"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClicked)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    [self Logtableview];
}

-(UITableView*)Logtableview
{
    if (!Logtableview) {
        Logtableview =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, WIN_HEIGHT - 64)];
        [Logtableview registerNib:[UINib nibWithNibName:@"LoglistCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        Logtableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [Logtableview.mj_header endRefreshing ];
            [self loadData];
        }];
        
        Logtableview.dataSource=self;
        Logtableview.delegate=self;
        Logtableview.rowHeight = getHeight(60);
        if (@available(iOS 11.0, *)) { //iOS11 解决SafeArea的问题，同时能解决pop时上级页面scrollView抖动的问题
            Logtableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        UIView *view =[[UIView alloc] initWithFrame:CGRectZero];
        Logtableview.tableFooterView = view;
        Logtableview.separatorInset = UIEdgeInsetsZero;
        Logtableview.separatorColor =[UIColor colorWithHexString:@"e1e1e1" alpha:1];
        Logtableview.backgroundColor=[UIColor colorWithHexString:@"#f5f5f9" alpha:1];
        [self.view addSubview:Logtableview];
        
    }
    return Logtableview;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.logListAry.count;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoglistCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell displayViewWithLogModel:self.logListAry[indexPath.row]];
    return cell;
    
}


-(void)rightBtnClicked
{
    if (self.logListAry.count > 0) {
        if (self.device.userType != 0) {
            [MBProgressHUD showWarnMessage:@"抱歉，你非超级管理员，暂无权限！"];
            return;
        }
        UIAlertController*alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要清空开锁记录吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"清空数据");
            for (NSInteger i = 0; i < self.logListAry.count; i++) {
                LockLogModel *logModel = self.logListAry[i];
                [self.ignoreAry addObject:logModel.id];
            }
            [[UserManger sharedInstance] cacheIgnoreIds:[self.ignoreAry copy]];
            [self.logListAry removeAllObjects];
//            NSString *deviceId = [NSString stringWithFormat:@"%@",self.device.id];
//            NSDictionary *params = @{@"deviceId":deviceId};
//            NSString *httpUrl = [NSString stringWithFormat:@"%@/%@",NETWORK_REQUEST_URL(DELETE_ALL_LOG_URL),[[UserManger sharedInstance] getMemberToken]];
//            DDLog(@"GetAllLogUrl:%@;params:%@",NETWORK_REQUEST_URL(DELETE_ALL_LOG_URL),params);
//            [HttpTool postWithURL:httpUrl params:params success:^(id json) {
//                int code = [json[@"code"] intValue];
//                if (code == 1000) {
//                    [self.logListAry removeAllObjects];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Logtableview reloadData];
                    });
//                }else if (code == TimeOutCode)
//                {
//                    [MBProgressHUD showTipMessageInView:json[@"登录超时，请重新登录"]];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_TimeOut_Login object:nil];
//                }
//                else
//                {
//                    [MBProgressHUD showTipMessageInView:json[@"message"]];
//                }
//            } failure:^(NSError *error) {
//
//            }];
        }];
        UIAlertAction*action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                       handler:nil];
        [alert addAction:action];
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        [MBProgressHUD showTipMessageInView:@"当前没有数据"];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        LockLogModel *logModel = self.logListAry[indexPath.row];
        [self.ignoreAry addObject:logModel.id];
        [[UserManger sharedInstance] cacheIgnoreIds:[self.ignoreAry copy]];
        //删除只删除本地数据
//        NSString *recordId = [NSString stringWithFormat:@"%@",logModel.id];
//        NSDictionary *params = @{@"id":recordId};
//        DDLog(@"GetAllLogUrl:%@;params:%@",NETWORK_REQUEST_URL(DELETE_LOG_URL),params);
        NSString *httpUrl = [NSString stringWithFormat:@"%@/%@",NETWORK_REQUEST_URL(DELETE_LOG_URL),[[UserManger sharedInstance] getMemberToken]];
//        [HttpTool postWithURL:httpUrl params:params success:^(id json) {
//            int code = [json[@"code"] intValue];
//            if (code == 1000) {
                [self.logListAry removeObjectAtIndex:indexPath.row];
//                dispatch_async(dispatch_get_main_queue(), ^{
                    [Logtableview reloadData];
//                });
//            }else{
//                [MBProgressHUD showInfoMessage:json[@"resMessage"]];
//            }
//        } failure:^(NSError *error) {
//
//        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
