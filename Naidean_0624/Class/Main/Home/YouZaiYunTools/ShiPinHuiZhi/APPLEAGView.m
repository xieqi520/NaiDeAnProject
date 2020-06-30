//
//  APPLEAGView.m
//  XcloudlinkDemo
//
//  Created by lijiang on 17/5/4.
//  Copyright © 2017年 lijiang. All rights reserved.
//

#import "APPLEAGView.h"
#import "AAPLEAGLLayer.h"
#import "UIViewExt.h"
#import "UIView+ViewController.h"
//参考的屏幕宽度和高度 - 适配尺寸
#define referenceBoundsHeight 667.0
#define referenceBoundsWight 375.0
#define ratioHeight kScreenHeight/referenceBoundsHeight
#define ratioWidth kScreenWidth/referenceBoundsWight

#define  kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define  kScreenWidth [[UIScreen mainScreen] bounds].size.width

#define Color(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]



@implementation APPLEAGView

{
    AAPLEAGLLayer  *_aapLEAGLLaye;//视频播放
    UIImageView    *_bgImageView;//背景图片
    UIView         *_loadView;//加载动画
    UIView         *_GPRSView;//
    BOOL           _hiddenLoadView_bool;
    CGRect         _self_frame;
    
    BOOL           _isFullScreen;//是否全屏状态
}
@synthesize pixelBuffer = _pixelBuffer;



- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _self_frame = self.frame;
        
        self.backgroundColor = [UIColor blackColor];
        //初始化视频绘制
        _aapLEAGLLaye = [[AAPLEAGLLayer alloc] initWithFrame:self.bounds];
        [self.layer addSublayer:_aapLEAGLLaye];

        _bgImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _bgImageView.hidden = YES;
        [self addSubview:_bgImageView];
        
        _hiddenLoadView_bool = NO;
        _isFullScreen = NO;
        
        [self initVideoAnimationType:APPLEAGViewStateTypeLoading];
        
        
        //横屏按钮
        UIButton *heng_btu = [[UIButton alloc]initWithFrame:CGRectMake(self.width-65, self.height-75, 50, 50)];
        [heng_btu setImage:[UIImage imageNamed:@"heng_fangda"] forState:UIControlStateNormal];
        [heng_btu setImage:[UIImage imageNamed:@"heng-suoxiao"] forState:UIControlStateSelected];
        [heng_btu addTarget:self action:@selector(hengAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:heng_btu];
        heng_btu.tag = 1000;
        
        //开锁按钮
        UIButton *unlockBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.width-65 - 95, self.height-75, 80, 50)];
//        unlockBtn.backgroundColor = HEXCOLOR(0xFF7B06);
        [unlockBtn setImage:kGetImage(@"lock") forState:UIControlStateNormal];
        [unlockBtn setImage:kGetImage(@"open@2x") forState:UIControlStateSelected];
        [unlockBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        unlockBtn.titleLabel.font = [UIFont systemFontOfSize:getWidth(20)];
        unlockBtn.layer.masksToBounds = YES;
        unlockBtn.layer.cornerRadius = 25.0;
        [unlockBtn addTarget:self action:@selector(unlockBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:unlockBtn];
        unlockBtn.tag = 10086;
        unlockBtn.hidden = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        tap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tap];
    }
    
    return self;
}

#pragma mark - 点击屏幕手势触发事件
-(void)tapClick:(UITapGestureRecognizer *)gesture
{
    if(_isFullScreen){
        UIButton *unlockBtn = (UIButton *)[self viewWithTag:10086];
        unlockBtn.hidden = !unlockBtn.hidden;
        
        UIButton *heng_btu = (UIButton *)[self viewWithTag:1000];
        heng_btu.hidden = !heng_btu.hidden;
    }else{
        return;
    }
}

#pragma mark - 视频屏幕开锁按钮点击事件
-(void)unlockBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    //开锁block
    if (_unLockBlock) {
        _unLockBlock();
    }
}

#pragma mark - 全屏/半屏 放大缩小按钮点击事件
- (void)hengAction:(UIButton *)btu
{
    
    _isFullScreen = !_isFullScreen;
    btu.selected = !btu.selected;
    [UIApplication sharedApplication].statusBarHidden = btu.selected;//隐藏状态栏 在plsit加入 View controller-based status bar appearance
    [[self ViewController].navigationController setNavigationBarHidden:btu.selected animated:NO];
    
    //处于放大界面
    if (btu.selected) {
        
         CGAffineTransform rotate = CGAffineTransformMakeRotation( M_PI/2 );
         [self setTransform:rotate];
    
         self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        
         btu.frame = CGRectMake(self.height - 86 * ratioHeight,self.width- 80 ,50 , 50 );
        
//        //放大block
//        if (_fangdaBlcok) {
//            _fangdaBlcok();
//        }
        
        //当切换为全屏状态时 缩小屏幕按钮和开锁按钮默认为隐藏 点击屏幕后再显示出来
        btu.hidden = YES;
        
        UIButton *unlockBtn = (UIButton *)[self viewWithTag:10086];
        unlockBtn.hidden = YES;
        unlockBtn.frame = CGRectMake(self.height - 150 * ratioHeight,self.width- 80 ,50 , 50 );
        
    
    } else {
    
    
        CGAffineTransform rotate = CGAffineTransformMakeRotation( 0 );
        [self setTransform:rotate];
        
        self.frame = _self_frame;
 
        btu.frame = CGRectMake(self.width-65, self.height-75, 50, 50);

//        //缩小block
//        if (_suoxiaoBlock) {
//            _suoxiaoBlock();
//        }
    }

    
    _aapLEAGLLaye.frame = self.bounds;
    _bgImageView.frame = self.bounds;
    
    //动画
    _loadView.frame = CGRectMake((_bgImageView.width - 150) / 2.0,(_bgImageView.height - 150) / 2.0, 150, 150);
    _GPRSView.frame = self.bounds;


    UIImageView *load_imgview = [_loadView viewWithTag:100];
    load_imgview.frame = CGRectMake((_loadView.width - 60) / 2.0, 10, 60,60);
    UILabel *load_label = [_loadView viewWithTag:110];
    load_label.frame = CGRectMake(0, load_imgview.bottom + 10,_loadView.width, 20);
    
    
    UIButton *GPRS_btu = [_GPRSView viewWithTag:200];
    GPRS_btu.frame = CGRectMake((_GPRSView.width - 70) / 2.0, 80, 70, 70);
    UILabel *GPRS_label = [_GPRSView viewWithTag:201];
    GPRS_label.frame = CGRectMake(0,GPRS_btu.bottom + 10, _GPRSView.width , 20);
    UILabel *GPRS_label1 = [_GPRSView viewWithTag:202];
    GPRS_label1.frame = CGRectMake(0,GPRS_label.bottom + 15, _GPRSView.width , 20);


}

/**
 隐藏加载动画(默认是显示加载动画)
 */
- (void)HiddenloadView
{
    _hiddenLoadView_bool = YES;
    _GPRSView.hidden = YES;
    _loadView.hidden = YES;

}



#pragma mark -------------------- 视频加载动画 -------------------------
- (void)initVideoAnimationType:(APPLEAGViewStateType)StateType
{
   
    
    if(_loadView == nil)
    {
        _loadView = [[UIView alloc]initWithFrame:CGRectMake((self.width - 150) / 2.0,(self.height - 150) / 2.0, 150, 150)];
        _loadView.backgroundColor = [UIColor clearColor];
        _loadView.hidden = YES;
        [self addSubview:_loadView];
        
        UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake((_loadView.width - 60) / 2.0, 10, 60,60)];
        imgview.tag = 100;
        [_loadView addSubview:imgview];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, imgview.bottom + 10,_loadView.width, 20)];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15];
        label.tag = 110;
        [_loadView addSubview:label];
    
        

    }
    
    if(_GPRSView == nil)
    {
    
        _GPRSView = [[UIView alloc]initWithFrame:self.bounds];
        _GPRSView.backgroundColor = [UIColor clearColor];
        _GPRSView.hidden = YES;
        [self addSubview:_GPRSView];

        UIButton *play_btn = [[UIButton alloc]initWithFrame:CGRectMake((_GPRSView.width - 70) / 2.0, 80, 70, 70)];
        [play_btn setImage:[UIImage imageNamed:@"icon_defend_play"] forState:UIControlStateNormal];
        play_btn.titleLabel.font = [UIFont systemFontOfSize:14];
        play_btn.tag = 200;
        [play_btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [play_btn addTarget:self action:@selector(palyBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_GPRSView addSubview:play_btn];
        
        
        UILabel *notLable1 = [[UILabel alloc]initWithFrame:CGRectMake(0,play_btn.bottom + 10, _GPRSView.width , 20)];
        notLable1.font = [UIFont systemFontOfSize:15];
        notLable1.textColor = Color(254, 0, 0);
        notLable1.textAlignment = NSTextAlignmentCenter;
        notLable1.tag = 201;
        notLable1.text = @"点击播放";
        [_GPRSView addSubview:notLable1];
        
        UILabel *notLable = [[UILabel alloc]initWithFrame:CGRectMake(0,notLable1.bottom + 15, _GPRSView.width , 20)];
        notLable.font = [UIFont systemFontOfSize:15];
        notLable.textColor = [UIColor whiteColor];
        notLable.textAlignment = NSTextAlignmentCenter;
        notLable.tag = 202;
        notLable.text = @"您正在使用非Wifi网络, 播放将产生流量费用" ;
        [_GPRSView addSubview:notLable];
    
    }
    
 
    
    UIImageView *imgview = (UIImageView *)[_loadView viewWithTag:100];
    
    imgview.animationImages = [NSArray arrayWithObjects:
                               [UIImage imageNamed:@"loading-1"],
                               [UIImage imageNamed:@"loading-2"],
                               [UIImage imageNamed:@"loading-3"],
                               [UIImage imageNamed:@"loading-4"],
                               [UIImage imageNamed:@"loading-5"],
                               [UIImage imageNamed:@"loading-6"],
                               nil];
    
    // all frames will execute in 1.75 seconds
    imgview.animationDuration = 1;
    // repeat the annimation forever
    imgview.animationRepeatCount = 0;
    // start animating
    [imgview startAnimating];
    // add the animation view to the main window
    imgview.userInteractionEnabled = YES;
    
    UILabel *label = (UILabel *)[_loadView viewWithTag:110];
    
    switch (StateType) {
            
        case APPLEAGViewStateTypeNoconnect:
            
             _loadView.hidden = NO;
             _GPRSView.hidden = YES;
             imgview.hidden = YES;
             label.text = @"当前无网络";
        
            
            break;
        case APPLEAGViewStateTypeGPRS:
            
            _loadView.hidden = YES;
            _GPRSView.hidden = NO;
            label.text = @"您正在使用非Wifi网络, 播放将产生流量费用";
            break;
            
        case APPLEAGViewStateTypeWIFI:
            
            _loadView.hidden = NO;
            _GPRSView.hidden = YES;
            imgview.hidden = NO;
            label.text = @"Loading...";
            
            break;
            
        case APPLEAGViewStateTypeNotLine:
            
            _loadView.hidden = NO;
            _GPRSView.hidden = YES;
            imgview.hidden = YES;
            label.text = @"设备不在线";
           
            
            break;
       
        case APPLEAGViewStateTypeLoading:
            
            _loadView.hidden = NO;
            _GPRSView.hidden = YES;
            imgview.hidden = NO;
            label.text = @"Loading...";
            
            break;
            
        case APPLEAGViewStateTypeNotView:
            
            _loadView.hidden = NO;
            _GPRSView.hidden = YES;
            imgview.hidden = NO;
            label.text = @"";
           
            
            break;
            
        default:
            
            _loadView.hidden = NO;
            _GPRSView.hidden = YES;
            imgview.hidden = NO;
            label.text = @"";
            
            break;
    }

    if (_hiddenLoadView_bool == YES) {
        _GPRSView.hidden = YES;
        _loadView.hidden = YES;
    }
    
    
}

//点击播放按钮
- (void)palyBtnAction
{

    [self initVideoAnimationType:APPLEAGViewStateTypeLoading];
    
    if ([_delegate respondsToSelector:@selector(playAPPLEAGView)]) {
        
        [_delegate playAPPLEAGView];
        
    }

}

/**
 根据状态去显示不同提示
 
 @param StateType 提示
 */
- (void)setAPPLEAGViewStateType:(APPLEAGViewStateType)StateType
{
    
    [self initVideoAnimationType:StateType];

}


/**
 设置视频背景图片
 
 @param image 视频背景图片
 */
- (void)setbgimage:(UIImage *)image
{
    
    _bgImageView.hidden = NO;
    _bgImageView.image = image;

}


/**
 传入视频流数据
 */

-(CVPixelBufferRef) pixelBuffer
{
    return _pixelBuffer;
}

- (void)setPixelBuffer:(CVPixelBufferRef)pixBuffer
{
    _aapLEAGLLaye.pixelBuffer = pixBuffer;
    self.videoHeight = _aapLEAGLLaye.videoHeight;
    self.videoWidth = _aapLEAGLLaye.videoWidth;
    
//    NSLog(@"*********self.videoWidth %d ********%d  ******** %f ******* %f ",self.videoWidth,self.videoHeight,kScreenWidth,kScreenHeight);
    _bgImageView.hidden = YES;
    _loadView.hidden = YES;
    _GPRSView.hidden = YES;

}
@end
