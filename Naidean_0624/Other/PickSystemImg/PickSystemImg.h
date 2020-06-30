//
//  PickSystemImg.h
//  Naidean
//
//  Created by xujun on 2018/1/10.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PickSystemImg : NSObject

- (void)takeImgWithController:(UIViewController *)controller;
/**获取图片后回调*/
@property(nonatomic,copy) void(^imgBlock)(UIImage *image);
/**图片选择的控制器消失的block*/
@property(nonatomic,copy) void(^dismissBlock)(void);

@end
