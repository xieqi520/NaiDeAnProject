//
//  SYTimePickerView.m
//  Naidean
//
//  Created by aoxin on 2018/8/18.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "SYTimePickerView.h"

@implementation SYTimePickerView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *toolView = [[UIView alloc] init];
        [self addSubview:toolView];
        [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(frame.size.width, 44));
        }];
        
        UIView *line =[[UIView alloc] init];
        [toolView addSubview:line];
        line.backgroundColor=SetColor(@"#dcdcdc");
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(toolView);
            make.centerX.equalTo(toolView);
            make.size.mas_equalTo(CGSizeMake(WIN_WIDTH, 0.5));
        }];

        UIButton *cancelBtn = [[UIButton alloc] init];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancelBtn addTarget:self action:@selector(cancelBtnDidClicked) forControlEvents:UIControlEventTouchUpInside];
        [toolView addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(toolView.mas_left).offset(15);
            make.centerY.equalTo(toolView);
            make.size.mas_equalTo(CGSizeMake(40, 21));
        }];
        
        UIButton *doneBtn = [UIButton new];
        [doneBtn setTitle:@"保存" forState:UIControlStateNormal];
        [doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        doneBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [doneBtn addTarget:self action:@selector(doneBthDidClicked) forControlEvents:UIControlEventTouchUpInside];
        [toolView addSubview:doneBtn];
        [doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(toolView.mas_right).offset(-15);
            make.centerY.equalTo(toolView);
            make.size.mas_equalTo(CGSizeMake(40, 21));
        }];
        
        _startTimePK = [[UIDatePicker alloc] init];
        [self addSubview:_startTimePK];
        _startTimePK.datePickerMode = UIDatePickerModeTime;
        [_startTimePK mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(toolView.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(frame.size.width/2, frame.size.height-44));
        }];
        
        _endTimePK = [[UIDatePicker alloc] init];
        [self addSubview:_endTimePK];
        _endTimePK.datePickerMode = UIDatePickerModeTime;
        [_endTimePK mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(toolView.mas_bottom);
            make.right.equalTo(self.mas_right);
            make.size.mas_equalTo(CGSizeMake(frame.size.width/2, frame.size.height-44));
        }];
        [_endTimePK addTarget:self action:@selector(startDatePickerDidChanged:) forControlEvents:UIControlEventValueChanged];
        
    }
    return self;
}

- (void)cancelBtnDidClicked{
    if ([_delegate respondsToSelector:@selector(timePickerViewCancelBtnClick)]) {
        [_delegate timePickerViewCancelBtnClick];
        self.hidden= YES;
    }
}

- (void)doneBthDidClicked{
    if ([_delegate respondsToSelector:@selector(timePickerViewSaveBtnClick:)]) {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"HH:mm"];
        NSString *startTime = [format stringFromDate:_startTimePK.date];
        NSString *endTime = [format stringFromDate:_endTimePK.date];
        NSString *timeStr = [NSString stringWithFormat:@"%@-%@",startTime,endTime];
        [_delegate timePickerViewSaveBtnClick:timeStr];
        self.hidden= YES;
    }
}

- (void)setDefaultDateWithString:(NSString *)string{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"HH:mm"];
    
    NSArray *timeAry = [string componentsSeparatedByString:@"-"];
    NSDate *timeDate = [format dateFromString:timeAry[0]];
    _startTimePK.date = timeDate;
    _endTimePK.minimumDate = _startTimePK.date;
    timeDate = [format dateFromString:timeAry[1]];
    _endTimePK.date = timeDate;
    
}

- (void)startDatePickerDidChanged:(UIDatePicker *)sender{
    sender.minimumDate = _startTimePK.date;
}

@end
