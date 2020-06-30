//
//  PickSystemImg.m
//  Naidean
//
//  Created by xujun on 2018/1/10.
//  Copyright © 2018年 com.saiyikeji. All rights reserved.
//

#import "PickSystemImg.h"
#import <AVFoundation/AVFoundation.h>

//读取相册，照相
@interface PickSystemImg ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation PickSystemImg

/**
 获取图片
 
 @param controller 对应的控制器
 */
- (void)takeImgWithController:(UIViewController *)controller{
    //实例化alertController控制器
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //__weak typeof(controller) weakController = controller;
    // __weak typeof(self) weakSelf = self;
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在iPhone的“设置－隐私－相机”中允许访问相机" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureButton=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:sureButton];
        [controller presentViewController:alertController animated:YES completion:nil];
    }else{
        
        [alertController addAction: [UIAlertAction actionWithTitle: @"拍照" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //判断是否有相机
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
                [self takeAPhoto:controller];
            }else {
                [MBProgressHUD showErrorMessage:@"该设备未检测到摄像头"];
            }
        }]];
        
        [alertController addAction: [UIAlertAction actionWithTitle: @"从相册选取" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            //处理点击从相册选取
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            //设置图片源(相簿)
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //设置代理
            picker.delegate = self;
            //设置可以编辑
            picker.allowsEditing = YES;
            //打开拾取器界面
            [controller presentViewController:picker animated:YES completion:nil];
        }]];
        [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
        
        [controller presentViewController: alertController animated: YES completion: nil];
    }
}

-(void)takeAPhoto:(UIViewController*)controller{
    
    //相机权限
    AVAuthorizationStatus author = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (author ==AVAuthorizationStatusRestricted ||//此应用程序没有被授权访问的照片数据。可能是家长控制权限
        author ==AVAuthorizationStatusDenied)  //用户已经明确否认了这一照片数据的应用程序访问
    {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"相机权限被禁止啦" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 无权限 引导去开启
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [[UIApplication sharedApplication]openURL:url];
            }
        }];
        [alertC addAction:sureAction];
    }else{
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //显示工具栏
        picker.showsCameraControls=YES;
        //设置使用后置摄像头，可以使用前置摄像头
        picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        picker.cameraViewTransform = CGAffineTransformMakeScale(1.5, 1.5);
        [controller presentViewController:picker animated:YES completion:nil];
    }
}


#pragma mark UIImagePickerControllerDelegate
/**选择图片后回调的代理方法*/
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        //图片存入相册
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    //对选取的图片进行压缩
    NSData *jpgData = UIImageJPEGRepresentation(image, 1);
    //    while (jpgData.length > 300 * 1024) {
    //        jpgData = UIImageJPEGRepresentation([UIImage imageWithData:jpgData], 0.9);
    //    }
    if (self.imgBlock) {
        self.imgBlock([UIImage imageWithData:jpgData]);
    }
    if (self.dismissBlock) {
        //回调
        self.dismissBlock();
    }
}
/**取消的代理方法*/
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //对选取的图片进行压缩
    if (self.dismissBlock) {
        //回调
        self.dismissBlock();
    }
}



@end
