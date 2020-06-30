//
//  webViewController.m
//  hisiconnect
//
//  Created by hi1311 on 2017/11/21.
//  Copyright © 2017年 com.huawei.hisiconnect. All rights reserved.
//

/*测试代码，用于ios11版本的中国区手机，程序运行时无法弹出对话框 允许"WLAN与蜂窝移动网”权限，导致发送报文失败，错误原因码-1*/

#import "webViewController.h"

@interface webViewController ()<UIWebViewDelegate>

@end

@implementation webViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIWebView *web = [[UIWebView alloc]initWithFrame:self.view.bounds];
    web.delegate = self;
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
    [self.view addSubview:web];
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"webViewDidStartLoad");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSLog(@"webViewDidFinishLoad");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    NSLog(@"didFailLoadWithError");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

