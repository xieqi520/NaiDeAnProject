//
//  NDAtableviewAlert.m
//  Naidean
//
//  Created by aoxin1 on 2019/8/8.
//  Copyright © 2019 com.saiyikeji. All rights reserved.
//

#import "NDAtableviewAlert.h"
#import "DeviceCell.h"
@interface NDAtableviewAlert()
@end
@implementation NDAtableviewAlert

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor  blackColor]colorWithAlphaComponent:0.3];
        [self  creatUI];
//        UITapGestureRecognizer *tap =[[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(tapAction)];
//        [self  addGestureRecognizer:tap];
    }
    return self;
}
-(void)creatUI{
    _tableview = [[UITableView  alloc]initWithFrame:CGRectMake(0, 0, 250, 350) style: UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.center = self.center;
    _tableview.dataSource = self;
//    _tableview.layer.cornerRadius =5;
   
//    _tableview.tableFooterView =button;
//    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.tableFooterView= [[UIView  alloc]initWithFrame:CGRectZero];
//    _tableview.tableFooterView.frame =CGRectMake(0, 0, 250, 30);
    [_tableview  registerClass:[DeviceCell class] forCellReuseIdentifier:@"DeviceCell"];
    [self  addSubview:_tableview];
    
    UIButton *button = [UIButton  buttonWithType:UIButtonTypeCustom];
    [button  setTitle:@"关闭" forState:UIControlStateNormal];
    [button  setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font =[UIFont  systemFontOfSize:15.0];
    [button  addTarget:self action:@selector(footAction) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor colorWithHexString:@"#ff7b06" alpha:1];
    button.frame =CGRectMake(CGRectGetMinX(_tableview.frame),CGRectGetMaxY(_tableview.frame), 250, 30);
    [self addSubview:button];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DeviceCell *cell =[tableView  dequeueReusableCellWithIdentifier:@"DeviceCell"];
    NSDictionary *dic =self.dataArr[indexPath.row];
    cell.Devicename.text = dic[@"name"];
    cell.DeviceNumber.text = dic[@"mac"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    if (cell.delectBlock) {
//        cell.delectBlock((DeviceCell*)[tableView  cellForRowAtIndexPath:indexPath]);
//    }
    cell.delectBlock = ^(DeviceCell *cell) {
        if (self.deleteLock) {
            self.deleteLock(indexPath);
        }
    };
    cell.idStr = dic[@"id"];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.changeLock) {
        self.changeLock(self.dataArr[indexPath.row]);
        [self  removeFromSuperview];
    }
}
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//
//    UIButton *button = [UIButton  buttonWithType:UIButtonTypeCustom];
//    [button  setTitle:@"关闭" forState:UIControlStateNormal];
//    [button  setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
//    button.titleLabel.font =[UIFont  systemFontOfSize:15.0];
//    [button  addTarget:self action:@selector(footAction) forControlEvents:UIControlEventTouchUpInside];
//    button.backgroundColor = [UIColor colorWithHexString:@"#484b5f" alpha:1];
//    button.frame =CGRectMake(0, 0, self.frame.size.width, 30);
//    return button;
//}

-(void)footAction{
    
    [self  removeFromSuperview];
}
@end
