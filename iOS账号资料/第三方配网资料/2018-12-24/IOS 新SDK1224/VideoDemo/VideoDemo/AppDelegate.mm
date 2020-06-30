//
//  AppDelegate.m
//  VideoDemo
//
//  Created by zhaogenghuai on 2018/12/24.
//  Copyright © 2018年 zhaogenghuai. All rights reserved.
//

#import "AppDelegate.h"
#import "PPPPChannelManagement.h"
@interface AppDelegate ()
{
      CPPPPChannelManagement *m_pPPPPChannelMgt;
}
@end

@implementation AppDelegate

 
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
      m_pPPPPChannelMgt = new CPPPPChannelManagement();
    return YES;
}

-(int)SHIX_StartConnect:(NSString *)did USER:(NSString *)user PWD:(NSString *)pwd{
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->Start([did UTF8String], [user UTF8String], [pwd UTF8String]);
    }else{
        return -1;
    }
    return 0;
}

-(int)SHIX_DevStatus:(NSString *)did PRO:(id)delegate{
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->SetCameraStatusDelegate((char *)[did UTF8String], delegate);
    }else{
        return -1;
    }
    return 0;
}

-(int)SHIX_TansPro:(NSString *)did PRO:(id)delegate{
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->SetTransferDelegate((char *)[did UTF8String], delegate);
    }else{
        return -1;
    }
    return 0;
}

-(int)SHIX_SendTrans:(NSString *)did SEND:(NSString *)str{
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return -1;
    }
    return 0;
}

-(int)SHIX_Video:(NSString *)did PRO:(id)delegate{
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->StartPPPPLivestream((char *)[did UTF8String], delegate);
    }else{
        return -1;
    }
    return 0;
}

-(int)SHIX_StopVideo:(NSString *)did{
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->StopPPPPLivestream((char *)[did UTF8String]);
    }else{
        return -1;
    }
    return 0;
}





- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
