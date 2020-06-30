//
//  AddDeviceView.h
//  Naidean
//
//  Created by xujun on 2018/1/8.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddDeviceView;

#pragma mark  - 协议

@protocol DropMenuDelegate <NSObject>

-(void)menu:(AddDeviceView *)menu tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath DeviceName:(NSString*)name;

-(void)tableView:(UITableView *)tableView deleteDeviceAtIndexPath:(NSIndexPath *)indexPath;

@end

#pragma mark - 数据源

@protocol DropMenuDataSource <NSObject>

//防止下拉错位
//- (CGFloat)menu_updateFilterViewPosition;

- (NSMutableArray*)menu_DataArray;

@end

#pragma mark - 下拉菜单
@interface AddDeviceView : UIView

@property (nonatomic, copy) dispatch_block_t AdddeviceBlock;
@property (nonatomic, weak) id<DropMenuDataSource> dataSource;
@property (nonatomic, weak) id<DropMenuDelegate> delegate;


- (void)backgroundTapped;

// 显示或者隐藏菜单
- (void)menuTappedWithSuperView:(UIView *)view;

//-(AddDeviceView*)initWithmenuframe:(CGRect)frame;


@end
