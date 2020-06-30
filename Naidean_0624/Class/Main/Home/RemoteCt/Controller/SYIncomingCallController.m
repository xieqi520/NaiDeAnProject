
//
//  SYIncomingCallController.m
//  Naidean
//
//  Created by Zoe on 2019/2/18.
//  Copyright © 2019年 com.saiyikeji. All rights reserved.
//

#import "SYIncomingCallController.h"
#import "RemotecontrolController.h"

@interface SYIncomingCallController ()
{
    SystemSoundID soundID;
}
@property (strong, nonatomic)  UIImageView *BackImgView;
@property (strong, nonatomic)  UILabel *EnergyLabel;
@property (strong, nonatomic)  UILabel *Energy;
@property (strong, nonatomic)  UIButton *HangUpBtn;
@property (strong, nonatomic)  UILabel  *HangUpLabel;
@property (strong, nonatomic)  UIButton *AnswerBtn;
@property (strong, nonatomic)  UILabel  *AnswerLabel;
@end

@implementation SYIncomingCallController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubviews];
    
    [self playSystemSoundWithName:@"doorbell" type:@"wav" isAlert:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopPlaySystemSound:soundID];
}
- (void)configSubviews {
    self.view.backgroundColor =[UIColor whiteColor];
    self.title = @"远程开锁";
    
    self.BackImgView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg1"]];
    self.BackImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.BackImgView.clipsToBounds = YES;
    [self.view addSubview:self.BackImgView];
    [self.BackImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(getWidth(423));
    }];
    
    self.Energy =[[UILabel alloc] init];
    self.Energy.text=@"100%";
    self.Energy.textAlignment = NSTextAlignmentLeft;
    self.Energy.font =kSystemFontSize(getWidth(15));
    self.Energy.textColor=[UIColor whiteColor];
    [self.BackImgView addSubview:self.Energy];
    [self.Energy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(getWidth(8));
        make.right.equalTo(self.view.mas_right).offset(getWidth(-10));
        make.size.mas_equalTo(CGSizeMake(getWidth(40), getWidth(21)));
    }];
    
    self.EnergyLabel =[[UILabel alloc] init];
    self.EnergyLabel.text=@"设备电量:";
    self.EnergyLabel.textAlignment = NSTextAlignmentRight;
    self.EnergyLabel.font =kSystemFontSize(getWidth(15));
    self.EnergyLabel.textColor =[UIColor whiteColor];
    [self.BackImgView addSubview:self.EnergyLabel];
    [self.EnergyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.Energy);
        make.size.mas_equalTo(CGSizeMake(getWidth(70), getWidth(21)));
        make.right.equalTo(self.Energy.mas_left).offset(getWidth(-5));
    }];
    
    //底部按钮
    self.HangUpBtn=[UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.HangUpBtn setBackgroundImage:[UIImage imageNamed:@"hang_up"] forState:UIControlStateNormal];
    [self.HangUpBtn addTarget:self action:@selector(hangUpBtnCilck:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.HangUpBtn];
    [self.HangUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.BackImgView.mas_bottom).offset(getHeight(35));
        make.size.mas_equalTo(CGSizeMake(getWidth(72), getWidth(72)));
        make.left.equalTo(self.view.mas_left).offset(getWidth(50));
    }];
    
    self.HangUpLabel=[[UILabel alloc] init];
    self.HangUpLabel.text=@"挂断";
    self.HangUpLabel.textAlignment = NSTextAlignmentCenter;
    self.HangUpLabel.font =kSystemFontSize(getWidth(14));
    self.HangUpLabel.textColor=[UIColor colorWithHexString:@"#484b5f" alpha:1];
    [self.view addSubview:self.HangUpLabel];
    [self.HangUpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.HangUpBtn);
        make.top.equalTo(self.HangUpBtn.mas_bottom).offset(getHeight(6));
        make.size.mas_equalTo(CGSizeMake(getWidth(150), getHeight(21)));
    }];
    
    self.AnswerBtn=[UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.AnswerBtn addTarget:self action:@selector(answerBtnActionCilck:) forControlEvents:UIControlEventTouchUpInside];
    [self.AnswerBtn setBackgroundImage:[UIImage imageNamed:@"answer"] forState:UIControlStateNormal];
    [self.view addSubview:self.AnswerBtn];
    [self.AnswerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.BackImgView.mas_bottom).offset(getHeight(35));
        make.size.mas_equalTo(CGSizeMake(getWidth(72), getWidth(72)));
        make.right.equalTo(self.view.mas_right).offset(getWidth(-50));
    }];
    
    self.AnswerLabel=[[UILabel alloc] init];
    self.AnswerLabel.text=@"接听";
    self.AnswerLabel.textAlignment = NSTextAlignmentCenter;
    self.AnswerLabel.font =kSystemFontSize(getWidth(14));
    self.AnswerLabel.textColor=[UIColor colorWithHexString:@"#484b5f" alpha:1];
    [self.view addSubview:self.AnswerLabel];
    [self.AnswerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.AnswerBtn);
        make.top.equalTo(self.AnswerBtn.mas_bottom).offset(getHeight(6));
        make.size.mas_equalTo(CGSizeMake(getWidth(150), getHeight(21)));
    }];
}

#pragma mark - event response
//挂断
- (void)hangUpBtnCilck:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//接听
- (void)answerBtnActionCilck:(UIButton*)sender {
    // 远程开锁
    RemotecontrolController *vc =[[RemotecontrolController alloc] init];
    vc.device = self.deviceModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (SystemSoundID)playSystemSoundWithName:(NSString *)name type:(NSString *)type isAlert:(BOOL)isAlert {
    // 获取文件路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:type];
    // 加载音效文件，得到对应的音效ID
    soundID = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)[NSURL fileURLWithPath:filePath], &soundID);
    // 播放音效
    if (isAlert) {
        AudioServicesPlayAlertSound(soundID);
    } else {
        AudioServicesPlaySystemSound(soundID);
    }
//    AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, NULL, NULL,((SystemSoundID soundID, void* clientData) {
//        AudioServicesPlayAlertSound(soundID);
//                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
//        AudioServicesPlaySystemSound(SystemSoundID)
//
//    };), NULL);
   AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, NULL, NULL, systemAudioCallback, NULL);


    return soundID;
}

void systemAudioCallback (SystemSoundID soundID, void* clientData) {
    AudioServicesPlayAlertSound(soundID);
}
- (void)stopPlaySystemSound:(SystemSoundID)soundID {
    //把需要销毁的音效文件的ID传递给它既可销毁
    AudioServicesRemoveSystemSoundCompletion(soundID);
    AudioServicesDisposeSystemSoundID(soundID);
}

@end
