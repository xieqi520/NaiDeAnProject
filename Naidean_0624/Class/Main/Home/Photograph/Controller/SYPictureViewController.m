//
//  SYPictureViewController.m
//  Naidean
//
//  Created by aoxin on 2018/8/16.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "SYPictureViewController.h"

@interface SYPictureViewController ()

@property (strong, nonatomic)UIImage *picture;

@end

@implementation SYPictureViewController

- (instancetype)initWithImage:(UIImage *)image{
    if ([super init]) {
        self.picture = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"拍照相关";
    UIImageView *pictureImgView = [[UIImageView alloc] initWithImage:self.picture];
    [self.view addSubview:pictureImgView];
    CGSize size = self.view.bounds.size;
    [pictureImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(size);
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
