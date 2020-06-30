//
//  AddDeviceView.m
//  Naidean
//
//  Created by xujun on 2018/1/8.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "AddDeviceView.h"
#import "DeviceCell.h"
@interface AddDeviceView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,assign)BOOL show;
@property(nonatomic,strong) NSMutableArray *menuArray;
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UIView *backGroundView;
@property(nonatomic,strong)UITableView *Devicetableview;
@property(nonatomic,strong) UIButton *addDeviceBtn;
@end

@implementation AddDeviceView


-(NSMutableArray*)menuArray
{
    if (!_menuArray) {
        _menuArray =[[NSMutableArray alloc] init];
    }
    _menuArray =[self.dataSource  menu_DataArray];
    return _menuArray;
}

//-(AddDeviceView*)initWithmenuframe:(CGRect)frame
//{
//    self =[self initWithFrame:frame];
//    if (self) {
//       // [self SetDeviceView:frame];
//    }
//    return self;
//}


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self SetDeviceView];
    }
    return self;
}

-(void)SetDeviceView
{
     self.frame = CGRectMake(0, 0, WIN_WIDTH, WIN_HEIGHT);
   // self.backgroundColor =[UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:0.4];

    _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _backGroundView.backgroundColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:0.4];
    _backGroundView.opaque = NO;
    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped)];
    [_backGroundView addGestureRecognizer:gesture];
    [self addSubview:_backGroundView];
    
    _backView=[[UIView alloc] initWithFrame:CGRectMake(getWidth(20), getHeight(100), WIN_WIDTH-getWidth(40), getWidth(200))];
    _backView.layer.masksToBounds = YES;
    _backView.layer.cornerRadius = getWidth(8);
    [self addSubview:_backView];
    
    _Devicetableview =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH-getWidth(40), getWidth(140))];
    _Devicetableview.delegate =self;
    _Devicetableview.dataSource=self;
    _Devicetableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_backView addSubview:_Devicetableview];
    
    
    UIView *footview=[[UIView alloc] initWithFrame:CGRectMake(0, getWidth(140), WIN_WIDTH-getWidth(40), getWidth(60))];
    footview.backgroundColor=[UIColor colorWithHexString:@"#f5f1f1" alpha:1];
    _addDeviceBtn =[UIButton buttonWithType:(UIButtonTypeCustom)];
    [_addDeviceBtn setUserInteractionEnabled:NO];
    [_addDeviceBtn setImage:[UIImage imageNamed:@"Add_device"] forState:(UIControlStateNormal)];
    [footview addSubview:_addDeviceBtn];
    [_addDeviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(footview);
        make.size.mas_equalTo(CGSizeMake(getWidth(40), getWidth(40)));
        make.left.equalTo(footview.mas_left).offset(getWidth(15));
    }];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addDeviceAction)];
    [footview addGestureRecognizer:tapGesture];
    UILabel *lab=[[UILabel alloc] init];
    lab.font=kSystemFontSize(getWidth(15));
    lab.text= @"添加新设备";
    lab.textColor=[UIColor colorWithHexString:@"#3f424e" alpha:1];
    [footview addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(footview);
        make.size.mas_equalTo(CGSizeMake(getWidth(100), getWidth(30)));
        make.left.equalTo(self.addDeviceBtn.mas_right).offset(getWidth(10));
    }];
    [_backView addSubview: footview];
   // Devicetableview.tableFooterView =footview;
     _backView.alpha = 0;
}

-(void)addDeviceAction
{
    if (self.AdddeviceBlock) {
        self.AdddeviceBlock();
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return getHeight(40);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuArray.count;
//    return 4;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    DeviceCell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell =[[DeviceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    DeviceModel *device = self.menuArray[indexPath.row];
    cell.delectBlock = ^(DeviceCell *cell) {
        NSLog(@"点击了删除");
        if ([self.delegate respondsToSelector:@selector(tableView:deleteDeviceAtIndexPath:)]) {
            [self.delegate tableView:tableView deleteDeviceAtIndexPath:indexPath];
        }
        
    };
    cell.DeviceNumber.text = device.id;
    cell.Devicename.text = device.name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DeviceModel *device = self.menuArray[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(menu:tableView:didSelectRowAtIndexPath:DeviceName:)]) {
        [self.delegate menu:self tableView:tableView didSelectRowAtIndexPath:indexPath DeviceName:device.name];
        
    }
    
}

- (void)menuTappedWithSuperView:(UIView *)view
{
    if (!_show) {
        [UIView animateWithDuration:0.2 animations:^{
            [view addSubview:self];
             _backView.transform = CGAffineTransformMakeTranslation(0, 0);
             _backGroundView.backgroundColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:0.4];
             _backView.alpha = 1;
        } completion:^(BOOL finished) {
           
        }];
    }else
    {
        [UIView animateWithDuration:0.2 animations:^{
            _backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
            _backView.transform = CGAffineTransformMakeTranslation(0, -200);
            _backView.alpha = 0 ;
        } completion:^(BOOL finished) {
           [self removeFromSuperview];
        }];
    }
    _show = !_show;
}

-(void)backgroundTapped
{
    if (_show) {
        [UIView animateWithDuration:0.2 animations:^{
            _backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
            _backView.transform = CGAffineTransformMakeTranslation(0, -200);
             _backView.alpha = 0;
        } completion:^(BOOL finished) {
             _show = !_show;
             _backView.alpha = 1;
            [self removeFromSuperview];
        }];
    }
}

@end
