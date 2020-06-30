//
//  SYTimePickerView.h
//  Naidean
//
//  Created by aoxin on 2018/8/18.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYTimePickerViewDelegate <NSObject>

/**
 保存按钮代理方法
 
 @param timer 选择的数据
 */
- (void)timePickerViewSaveBtnClick:(NSString *)timer;

/**
 取消按钮代理方法
 */
- (void)timePickerViewCancelBtnClick;

@end


@interface SYTimePickerView : UIView

@property (strong, nonatomic)UIDatePicker *startTimePK;
@property (strong, nonatomic)UIDatePicker *endTimePK;

@property (weak, nonatomic) id <SYTimePickerViewDelegate> delegate;

- (void)setDefaultDateWithString:(NSString *)string;

@end
