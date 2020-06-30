
//
//  APConnectController.m
//  Naidean
//
//  Created by Zoe on 2019/2/22.
//  Copyright © 2019年 com.saiyikeji. All rights reserved.
//

#import "APConnectController.h"
#import "APDeviceSearchController.h"

#import "GCDAsyncSocket.h"

static int TIMER_MULTICAST_TIMEOUT   = 60;//60s
static  NSString * hostIp            = @"192.168.43.1";
static const uint16_t hostPort       = 11111;
//handler message
static const int MSG_ONLINE_RECEIVED      = 0;
static const int MSG_MULTICAST_TIMEOUT    = 1;
static const int MSG_AP_RECEIVED_ACK      = 2;
static const int MSG_CONNECTED_APMODE     = 3;
static const int MSG_APMODE_TIMEOUT       = 4;

@interface APConnectController ()<GCDAsyncSocketDelegate>
@property (strong, nonatomic) GCDAsyncSocket * clientSocket;
@property (nonatomic, strong) NSTimer *sendTimeOutTimer;
@property (nonatomic, strong) NSString *deviceID;

@end

@implementation APConnectController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubViews];
}

- (void)configSubViews {
    self.title = @"连接设备热点";
}

#pragma mark - event response
- (IBAction)confirmAction:(UIButton *)sender {
    [self startConnectServerSocket];
}

/*创建线程监听上线消息*/
- (void)startConnectServerSocket
{
    [MBProgressHUD showActivityMessageInView:@"正在建立连接..."];
    /*add time out timer*/
    self.sendTimeOutTimer  = [NSTimer scheduledTimerWithTimeInterval:TIMER_MULTICAST_TIMEOUT target:self selector:@selector(multiCastTimerOutProcess) userInfo:nil repeats:NO];
    // 1.与服务器通过三次握手建立连接
    //创建一个socket对象
    self.clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    //连接
    NSError *error = nil;
    [self.clientSocket connectToHost:hostIp onPort:hostPort error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    NSLog(@"createServerSocket,error:%@",error);
}

/*停止监听*/
- (void)stopServerSocket
{
    if (self.clientSocket) {
        [self.clientSocket disconnect];
        self.clientSocket = nil;
    }
}

//停止计时
- (void)stopTimer {
    if (self.sendTimeOutTimer) {
        [self.sendTimeOutTimer invalidate];
        self.sendTimeOutTimer = nil;
    }
}

//超时
- (void)multiCastTimerOutProcess {
    [self handleMessage:[NSNumber numberWithInteger:MSG_MULTICAST_TIMEOUT]];
}

- (void)handleMessage:(NSNumber *)status {
    int value = [status intValue];
    switch(value){
        case MSG_ONLINE_RECEIVED:
            NSLog(@"process notification MSG_ONLINE_RECEIVED");
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccessMessage:@"获取设备信息成功"];
            //停止接收上线包
            [self stopServerSocket];
            [self stopTimer];
            [self go2ApDeviceSearch];
            
            break;
        case MSG_MULTICAST_TIMEOUT:
            [MBProgressHUD hideHUD];
            [MBProgressHUD showErrorMessage:@"配置失败，请确认一下内容\n 1. 手机已连接家中的Wi-Fi.\n 2. 输入的密码正确.\n 3. 家中的路由器工作在2.4G模式下.\n 若重试后仍然失败，请尝试点击AP模式关联."];
            [self stopServerSocket];
            [self stopTimer];
            break;
            
            //AP 收到单播信息
        case MSG_AP_RECEIVED_ACK:
            break;
        case MSG_CONNECTED_APMODE:
            break;
        case MSG_APMODE_TIMEOUT:
            break;
        default:
            break;
    }
}

- (void)go2ApDeviceSearch {
    APDeviceSearchController *vc = [[APDeviceSearchController alloc] init];
    vc.deviceID = self.deviceID;
    vc.wifiName = self.wifiName;
    vc.wifiPass = self.wifiPass;
    vc.hasBind = self.hasBind;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark- GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    
    NSLog(@"连接成功,host:%@,port:%d",host,port);
    [self.clientSocket readDataWithTimeout:-1 tag:0];
    //写入wifi数据
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"set_wifi" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:114] forKey:@"cmd"];
    [parameters setValue:@"admin" forKey:@"user"];
    [parameters setValue:@"123456" forKey:@"pwd"];
    [parameters setValue:self.wifiName forKey:@"wifissid"];
    [parameters setValue:self.wifiPass forKey:@"wifipwd"];
    NSData *data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    [self.clientSocket writeData:data withTimeout:-1 tag:0];
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showActivityMessageInView:@"正在写入WIFI配置数据..."];
    });
    NSLog(@"$$$$$$$tcp server didWriteData:%@",data);
    
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
//    NSString * receive = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"收到消息：%@",receive);
//IKB-000113-VZHDT
//IKB-000000-MMEEC
//
    NSDictionary *receive = [NSJSONSerialization JSONObjectWithData:data
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:nil];
    NSString *deviceId = [NSString stringWithFormat:@"%@",receive[@"did"]];
    NSLog(@"收到消息：%@",deviceId);
    self.deviceID = deviceId;
    if (deviceId.length) {
        [self performSelectorOnMainThread:@selector(handleMessage:) withObject:[NSNumber numberWithInteger:MSG_ONLINE_RECEIVED] waitUntilDone:NO];
    }

}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err;
{
    //断线重连写在这...
    NSLog(@"tcp server socketDidDisconnect,err:%@",err);
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"写的回调,tag:%ld",tag);
}

- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag
                 elapsed:(NSTimeInterval)elapsed
               bytesDone:(NSUInteger)length
{
    if (elapsed <= TIMER_MULTICAST_TIMEOUT)
    {
        NSString *warningMsg = @"Are you still there?\r\n";
        NSData *warningData = [warningMsg dataUsingEncoding:NSUTF8StringEncoding];
        
        [self.clientSocket writeData:warningData withTimeout:-1 tag:0];
        return 0;
    }
    
    return 0;
}


@end
