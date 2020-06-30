//
//  PhotolistController.m
//  Naidean
//
//  Created by xujun on 2018/1/4.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "PhotolistController.h"
#import "PhotolistCell.h"
#import "PhotoModel.h"
#import "SYPictureViewController.h"

@interface PhotolistController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *PhotoListtableview;
@property (copy, nonatomic) NSMutableArray *dataAry;
@property (assign, nonatomic) NSInteger pageNo;
@property (assign, nonatomic) BOOL noMoreData;

@end

@implementation PhotolistController

- (NSMutableArray *)dataAry{
    if (!_dataAry) {
        _dataAry = [[NSMutableArray alloc] init];
    }
    return _dataAry;
}

- (void)loadData{

    NSDictionary *params = @{
                             @"page":[NSNumber numberWithInteger:self.pageNo],
                             @"deviceId":self.device.id,
                             @"size":@"10"
                             };
//    //假数据
//    NSDictionary *photoDemo = @{
//                                @"pictureID":@"123123",
//                                @"mac":mac,
//                                @"number":phone,
//                                @"picture":[UIImage imageNamed:@"bg1"],
//                                @"time":@"2018.07.31 00:12"
//                                };
//    PhotoModel *photo = [[PhotoModel alloc] initWithJSON:photoDemo];
//    [self.dataAry addObject:photo];
    //
    
    DDLog(@"GET_ALL_PIC_URL:%@;params:%@",NETWORK_REQUEST_URL(GET_ALL_PIC_URL),params);
    [MBProgressHUD showActivityMessageInView:@""];
    NSString *httpUrl = [NSString stringWithFormat:@"%@/%@",NETWORK_REQUEST_URL(GET_ALL_PIC_URL),[[UserManger sharedInstance] getMemberToken]];
    [HttpTool postWithURL:httpUrl params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        NSLog(@"result:%@",json);
        int code = [json[@"code"] intValue];
        if (code == 1000) {
            NSArray *pictures = [NSArray arrayWithArray:json[@"resBody"][@"list"]];
            for (NSInteger i = 0; i < pictures.count; i++) {
                PhotoModel *photo = [[PhotoModel alloc] initWithJSON:pictures[i]];
                [self.dataAry addObject:photo];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.pageNo += 1;
                [self.PhotoListtableview reloadData];
            });
        }else{
            [MBProgressHUD showTipMessageInView:json[@"resMessage"]];
        }
        [self.PhotoListtableview.mj_header endRefreshing];
        [self.PhotoListtableview.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showTipMessageInView:[error localizedDescription]];
        [self.PhotoListtableview.mj_header endRefreshing];
        [self.PhotoListtableview.mj_footer endRefreshing];
    }];
}

//下拉刷新重新加载数据
- (void)refreshData{
    self.pageNo = 1;
    self.noMoreData = NO;
    if (self.dataAry.count > 0) {
        [self.dataAry removeAllObjects];
    }
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNo = 1;
    self.noMoreData = NO;
    [self loadData];
    
    self.title = @"拍照相关";
    if (@available(iOS 11.0, *)) {
        self.PhotoListtableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } 
    self.PhotoListtableview.frame=CGRectMake(0, 0, WIN_WIDTH, WIN_HEIGHT-64);
    [self.PhotoListtableview registerNib:[UINib nibWithNibName:@"PhotolistCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.PhotoListtableview.delegate=self;
    self.PhotoListtableview.dataSource=self;
    UIView *view =[[UIView alloc] initWithFrame:CGRectZero];
    self.PhotoListtableview.tableFooterView = view;
    self.PhotoListtableview.separatorInset = UIEdgeInsetsZero;
//    self.PhotoListtableview.rowHeight = getWidth(48);
    MJRefreshStateHeader *mjHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    mjHeader.lastUpdatedTimeLabel.hidden = YES;
    self.PhotoListtableview.mj_header = mjHeader;
    
    if (self.dataAry.count > 14) {
        self.PhotoListtableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self loadData];
        }];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.dataAry.count;
    return 14;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.f;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotolistCell *cell =(PhotolistCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    PhotoModel *model = self.dataAry[0];
    cell.PhotoImageview.image = model.picture;
    cell.ShowLabel.text = [NSString stringWithFormat:@"%zd",indexPath.row];
    cell.Datelabel.text = model.time;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PhotoModel *model = self.dataAry[0];
    SYPictureViewController *pickerViewController = [[SYPictureViewController alloc]initWithImage:model.picture];
    [self.navigationController pushViewController:pickerViewController animated:YES];
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
