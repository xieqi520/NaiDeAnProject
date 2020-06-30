//
//  SYPPPPTools.m
//  Naidean
//
//  Created by aoxin1 on 2020/6/24.
//  Copyright © 2020 com.saiyikeji. All rights reserved.
//

#import "SYPPPPTools.h"
#import "PPPPChannelManagement.h"

@interface SYPPPPTools()
{
    CPPPPChannelManagement *m_pPPPPChannelMgt;
}

@end


@implementation SYPPPPTools

+(SYPPPPTools*)share{
    static dispatch_once_t onceToken;
    static SYPPPPTools *tools = nil;
    dispatch_once(&onceToken, ^{
        tools = [[SYPPPPTools alloc]init];
    });
    return tools;
}
#pragma mark - other
+ (UIImage*)createImageFromColor:(UIColor*)color Rect:(CGRect)rect1
{
    CGRect rect = CGRectMake(0, 0, rect1.size.width, rect1.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
    return img;
}

-(int)SHIX_startP2P:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd{
    
    if (m_pPPPPChannelMgt==NULL) {
        m_pPPPPChannelMgt = new CPPPPChannelManagement();
    }
    if (did==NULL||user==NULL||pwd==NULL) {
        NSLog(@"SHIX_startP2P did==NULL||user==NULL||pwd==NULL");
        return 0;
    }
    
    m_pPPPPChannelMgt->Start([did UTF8String], [user UTF8String], [pwd UTF8String]);
    
    return 1;
}


-(int)SHIX_DevStatus:(NSString *)did PRO:(id)delegate{
   
    
    if (m_pPPPPChannelMgt==NULL) {
        m_pPPPPChannelMgt = new CPPPPChannelManagement();
    }
    
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->SetCameraStatusDelegate((char *)[did UTF8String], delegate);
    }else{
        return -1;
    }
    return 0;
}
-(int)SHIX_Heart:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd{
    
    
    if (m_pPPPPChannelMgt==NULL) {
        m_pPPPPChannelMgt = new CPPPPChannelManagement();
    }
    if (did==NULL||user==NULL||pwd==NULL) {
       NSLog(@"SHIX_startP2P did==NULL||user==NULL||pwd==NULL");
        return 0;
    }
    
    
    NSMutableDictionary *parameters1 = [NSMutableDictionary dictionary];
    [parameters1 setValue:@"dev_control" forKey:@"pro"];
    [parameters1 setValue:[NSNumber numberWithInt:102] forKey:@"cmd"];
    
    [parameters1 setValue:user forKey:@"user"];
    [parameters1 setValue:pwd forKey:@"pwd"];
    [parameters1 setValue:[NSNumber numberWithInt:1] forKey:@"heart"];
    
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters1 options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}

-(int)SHIX_stopP2P:(NSString *)did{
    
    
    if (m_pPPPPChannelMgt==NULL) {
        m_pPPPPChannelMgt = new CPPPPChannelManagement();
    }
    
    if (did==NULL) {
        NSLog(@"SHIX_stopP2P did==NULL");
        return 0;
    }
    
    m_pPPPPChannelMgt->Stop([did UTF8String]);
    return 1;
}
-(int)SHIX_StartPPPPLivestream:(NSString *)did Delegate:(id)delegate{
    if (m_pPPPPChannelMgt==NULL) {
        m_pPPPPChannelMgt = new CPPPPChannelManagement();
    }
    if (did==NULL) {
        NSLog(@"SHIX_StartPPPPLivestream did==NULL");
        return 0;
    }
    
    
    m_pPPPPChannelMgt->StartPPPPLivestream([did UTF8String], delegate);
    
    return 1;
}
-(int)SHIX_StopPPPPLivestream:(NSString *)did{
    if (m_pPPPPChannelMgt==NULL) {
        m_pPPPPChannelMgt = new CPPPPChannelManagement();
    }
    
    if (did==NULL) {
        NSLog(@"SHIX_StopPPPPLivestream did==NULL");
        return 0;
    }
    m_pPPPPChannelMgt->StopPPPPLivestream([did UTF8String]);
    
    return 1;
}

-(int)SHIX_StartPPPPAudio:(NSString *)did{
    NSLog(@"SHIX_StartPPPPAudio1");
    if (m_pPPPPChannelMgt==NULL) {
        m_pPPPPChannelMgt = new CPPPPChannelManagement();
    }
    
    if (did==NULL) {
       NSLog(@"SHIX_StartPPPPAudio did==NULL");
        return 0;
    }
    NSLog(@"SHIX_StartPPPPAudio2");
    m_pPPPPChannelMgt->StartPPPPAudio([did UTF8String]);
    return 1;
}
-(int)SHIX_StopPPPPAudio:(NSString *)did{
    if (m_pPPPPChannelMgt==NULL) {
        m_pPPPPChannelMgt = new CPPPPChannelManagement();
    }
    if (did==NULL) {
        NSLog(@"SHIX_StopPPPPAudio did==NULL");
        return 0;
    }
    
    m_pPPPPChannelMgt->StopPPPPAudio([did UTF8String]);
    
    return 1;
}
-(int)SHIX_StartPPPPTalk:(NSString *)did{
    if (m_pPPPPChannelMgt==NULL) {
        m_pPPPPChannelMgt = new CPPPPChannelManagement();
    }
    
    if (did==NULL) {
        NSLog(@"SHIX_StartPPPPTalk did==NULL");
        return 0;
    }
    m_pPPPPChannelMgt->StartPPPPTalk([did UTF8String]);
    
    return 1;
}
-(int)SHIX_EchoData:(NSString *)did Data:(const char *)data Len:(int)len{
    
    if (m_pPPPPChannelMgt==NULL) {
        m_pPPPPChannelMgt = new CPPPPChannelManagement();
    }
    
    if (did==NULL) {
        NSLog(@"SHIX_StartPPPPTalk did==NULL");
        return 0;
    }
    if (m_pPPPPChannelMgt!=NULL) {
        return  m_pPPPPChannelMgt->TalkAudioData([did UTF8String], data, len);
    }else{
        return 0;
    }
    return 1;
}

-(int)SHIX_StopPPPPTalk:(NSString *)did{
    if (m_pPPPPChannelMgt==NULL) {
        m_pPPPPChannelMgt = new CPPPPChannelManagement();
    }
    
    if (did==NULL) {
        NSLog(@"SHIX_StopPPPPTalk did==NULL");
        return 0;
    }
    m_pPPPPChannelMgt->StopPPPPTalk([did UTF8String]);
    return 1;
}

////////////////////////////////////////////
-(int)SHIX_TansPro:(NSString *)did PRO:(id)delegate{
    if (m_pPPPPChannelMgt==NULL) {
        m_pPPPPChannelMgt = new CPPPPChannelManagement();
    }
    
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->SetTransferDelegate((char *)[did UTF8String], delegate);
    }else{
        return 0;
    }
    return 1;
}

-(int)SHIX_SendTrans:(NSString *)did SEND:(NSString *)str{
    if (m_pPPPPChannelMgt==NULL) {
        m_pPPPPChannelMgt = new CPPPPChannelManagement();
    }
    
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}


-(int)SHIX_GetSPKMICPatmd:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd{
    if (m_pPPPPChannelMgt==NULL) {
        m_pPPPPChannelMgt = new CPPPPChannelManagement();
    }
    if (did==NULL) {
        NSLog(@"SHIX_StopPPPPTalk did==NULL");
        return 0;
    }
    NSLog(@"SHIX_GetSPKMICPatmd [%@]  [%@]",user,pwd);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"get_vol" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:134] forKey:@"cmd"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
    
}

-(int)SHIX_SetSPK:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd Value:(int)value{
    if (m_pPPPPChannelMgt==NULL) {
        return 0;
    }
    
    if (did==NULL) {
        NSLog(@"SHIX_StopPPPPTalk did==NULL");
        return 0;
    }
    NSLog(@"SHIX_GetSPKMICPatmd [%@]  [%@]",user,pwd);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"set_vol" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:135] forKey:@"cmd"];
    [parameters setValue:[NSNumber numberWithInt:value] forKey:@"outputvol"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
    
}
-(int)SHIX_SetMIC:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd Value:(int)value{
    
    if (m_pPPPPChannelMgt==NULL) {
        return 0;
    }
    
    if (did==NULL) {
        NSLog(@"SHIX_StopPPPPTalk did==NULL");
        return 0;
    }
    NSLog(@"SHIX_GetSPKMICPatmd [%@]  [%@]",user,pwd);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"set_vol" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:135] forKey:@"cmd"];
    [parameters setValue:[NSNumber numberWithInt:value] forKey:@"inputvol"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}

-(int)SHIX_GetWifiParms:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"get_wifi" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:112] forKey:@"cmd"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}

-(int)SHIX_ScanWifi:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"scan_wifi" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:113] forKey:@"cmd"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}

-(int)SHIX_GetUsers:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"get_user" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:103] forKey:@"cmd"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}
-(int)SHIX_AddUser:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd NEWUSER:(NSString *)newuser NEWPWD:(NSString *)newpwd{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"add_user" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:104] forKey:@"cmd"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    [parameters setValue:newuser forKey:@"newuser"];
    [parameters setValue:newpwd forKey:@"newpwd"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}
-(int)SHIX_DeleteUser:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd DELUSER:(NSString *)deluser{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"del_user" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:105] forKey:@"cmd"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    [parameters setValue:deluser forKey:@"deluser"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}
-(int)SHIX_EditUser:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd EDITUSER:(NSString *)edituser NEWUSER:(NSString *)newuser NEWPWD:(NSString *)newpwd{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"edit_user" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:106] forKey:@"cmd"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    [parameters setValue:edituser forKey:@"edituser"];
    [parameters setValue:newuser forKey:@"newuser"];
    [parameters setValue:newpwd forKey:@"newpwd"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}

-(int)SHIX_GetDateParms:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"get_date" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:125] forKey:@"cmd"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}

-(int)SHIX_SetDateParms:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd TZ:(int)tz UTCTIME:(int)time{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"set_date" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:126] forKey:@"cmd"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    [parameters setValue:[NSNumber numberWithInt:tz] forKey:@"tz_offset_min"];
    [parameters setValue:[NSNumber numberWithInt:time] forKey:@"utc_date_time"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}

-(int)SHIX_GetAlarmParms:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"get_alarm" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:107] forKey:@"cmd"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}

-(int)SHIX_SetAlarmParms:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd Enable:(int)enable Level:(int)level Audio_out:(int)audio_out Record:(int)record Msg_push:(int)msg_push Start_min:(int)start_min Stop_min:(int)stop_min Start_hour:(int)start_hour Stop_hour:(int)stop_hour{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"set_alarm" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:108] forKey:@"cmd"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    [parameters setValue:[NSNumber numberWithInt:enable] forKey:@"enable"];
    [parameters setValue:[NSNumber numberWithInt:level] forKey:@"level"];
    [parameters setValue:[NSNumber numberWithInt:audio_out] forKey:@"audio_out"];
    [parameters setValue:[NSNumber numberWithInt:record] forKey:@"record"];
    [parameters setValue:[NSNumber numberWithInt:msg_push] forKey:@"msg_push"];
    [parameters setValue:[NSNumber numberWithInt:start_min] forKey:@"start_min"];
    [parameters setValue:[NSNumber numberWithInt:stop_min] forKey:@"stop_min"];
    [parameters setValue:[NSNumber numberWithInt:start_hour] forKey:@"start_hour"];
    [parameters setValue:[NSNumber numberWithInt:stop_hour] forKey:@"stop_hour"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}

-(int)SHIX_GetVideoRecordParms:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"get_videorecord" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:121] forKey:@"cmd"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}
-(int)SHIX_SetVideoRecordParms:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd Enable:(int)enable   Chno:(int)chno Start_min:(int)start_min Stop_min:(int)stop_min Start_hour:(int)start_hour Stop_hour:(int)stop_hour{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"set_videorecord" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:122] forKey:@"cmd"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    [parameters setValue:[NSNumber numberWithInt:enable] forKey:@"enable"];
    [parameters setValue:[NSNumber numberWithInt:chno] forKey:@"chno"];
    [parameters setValue:[NSNumber numberWithInt:1] forKey:@"cover"];
    [parameters setValue:[NSNumber numberWithInt:start_min] forKey:@"start_min"];
    [parameters setValue:[NSNumber numberWithInt:stop_min] forKey:@"stop_min"];
    [parameters setValue:[NSNumber numberWithInt:start_hour] forKey:@"start_hour"];
    [parameters setValue:[NSNumber numberWithInt:stop_hour] forKey:@"stop_hour"];
    
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}

-(int)SHIX_GetVideoAudioParms:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"get_videoaudio" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:127] forKey:@"cmd"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}
-(int)SHIX_SetVideoAudioParms:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd Audio_input_enbale:(int)audio_input_enbale   Audio_output_enbale:(int)audio_output_enbale Main_code:(NSString *)main_code Sub_code:(NSString *)sub_code Main_current_resolution:(NSString *)main_current_resolution Sub_current_resolution:(NSString *)sub_current_resolution{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"set_videoaudio" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:128] forKey:@"cmd"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    [parameters setValue:[NSNumber numberWithInt:audio_input_enbale] forKey:@"audio_input_enbale"];
    [parameters setValue:[NSNumber numberWithInt:audio_output_enbale] forKey:@"audio_output_enbale"];
    [parameters setValue:main_code forKey:@"main_code"];
    [parameters setValue:sub_code forKey:@"sub_code"];
    
    [parameters setValue:main_current_resolution forKey:@"main_current_resolution"];
    [parameters setValue:sub_current_resolution forKey:@"sub_current_resolution"];
    
    
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}


-(int)SHIX_GetSDParms:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"get_sd" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:109] forKey:@"cmd"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}
-(int)SHIX_FormatSD:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"set_sd" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:110] forKey:@"cmd"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    [parameters setValue:[NSNumber numberWithInt:1] forKey:@"format"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}

-(int)SHIX_GetSystemParms:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"get_deviceinfo" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:101] forKey:@"cmd"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}
-(int)SHIX_SetSystem:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd Type:(int)type{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"conttrol_dev" forKey:@"pro"];
    if (type==1) {
        [parameters setValue:[NSNumber numberWithInt:132] forKey:@"cmd"];
    }else  if (type==2) {
        [parameters setValue:[NSNumber numberWithInt:131] forKey:@"cmd"];
        [parameters setValue:[NSNumber numberWithInt:1] forKey:@"reset_wifi"];
    }else{
        [parameters setValue:[NSNumber numberWithInt:131] forKey:@"cmd"];
        [parameters setValue:[NSNumber numberWithInt:0] forKey:@"reset_wifi"];
    }
    
    
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}


-(int)SHIX_GetVideoFiles:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd StartTime:(NSString *)starttime EndTime:(NSString *)endtime{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"get_videofiles" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:116] forKey:@"cmd"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    [parameters setValue:starttime forKey:@"start_time"];
    [parameters setValue:endtime forKey:@"end_time"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}
-(int)SHIX_StartVideoFiles:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd StartTime:(NSString *)starttime{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"start_videofiles" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:117] forKey:@"cmd"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    [parameters setValue:starttime forKey:@"start_time"];
    
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}
-(int)SHIX_StartVideoOffset:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd StartTime:(NSString *)starttime{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"start_videofilesOffset" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:118] forKey:@"cmd"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    [parameters setValue:starttime forKey:@"seek_time"];
    
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}
-(int)SHIX_StopVideoFiles:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"stop_videofiles" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:120] forKey:@"cmd"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}

-(int)SHIX_StartTalk:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"start_talk" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:129] forKey:@"cmd"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}
-(int)SHIX_StopTalk:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"end_talk" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:130] forKey:@"cmd"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}

-(int)SHIX_ControlVide:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd Res:(int)type{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"stream" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:111] forKey:@"cmd"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    [parameters setValue:[NSNumber numberWithInt:type] forKey:@"video"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}


-(int)SHIX_PreSet:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd Preset_num:(int)preset_num{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"ptz_contrl" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:137] forKey:@"cmd"];
    [parameters setValue:[NSNumber numberWithInt:172] forKey:@"ptz_cmd"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    [parameters setValue:[NSNumber numberWithInt:preset_num] forKey:@"preset_num"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}
-(int)SHIX_PreGet:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd Preset_num:(int)preset_num{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"ptz_contrl" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:137] forKey:@"cmd"];
    [parameters setValue:[NSNumber numberWithInt:174] forKey:@"ptz_cmd"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    [parameters setValue:[NSNumber numberWithInt:preset_num] forKey:@"preset_num"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}
-(int)SHIX_PreDel:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd Preset_num:(int)preset_num{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"ptz_contrl" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:137] forKey:@"cmd"];
    [parameters setValue:[NSNumber numberWithInt:173] forKey:@"ptz_cmd"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    [parameters setValue:[NSNumber numberWithInt:preset_num] forKey:@"preset_num"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}

-(int)SHIX_ControlPir:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd Video_mode:(int)video_mode{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"conttrol_dev" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:136] forKey:@"cmd"];
    
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    [parameters setValue:[NSNumber numberWithInt:video_mode] forKey:@"video_mode"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}
-(int)SHIX_GetCameraParms:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"get_parms" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:101] forKey:@"cmd"];
    
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}

-(int)SHIX_Control_Mirror:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"conttrol_dev" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:134] forKey:@"cmd"];
    [parameters setValue:[NSNumber numberWithInt:1] forKey:@"mirror_mode"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}
-(int)SHIX_Control_Flip:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"conttrol_dev" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:134] forKey:@"cmd"];
    [parameters setValue:[NSNumber numberWithInt:2] forKey:@"mirror_mode"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}
-(int)SHIX_Control_FlipMirror:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"conttrol_dev" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:134] forKey:@"cmd"];
    [parameters setValue:[NSNumber numberWithInt:3] forKey:@"mirror_mode"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}
-(int)SHIX_Control_CanFlipMirror:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"conttrol_dev" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:134] forKey:@"cmd"];
    [parameters setValue:[NSNumber numberWithInt:0] forKey:@"mirror_mode"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}

-(int)SHIX_Control_FD:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"ptz_contrl" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:137] forKey:@"cmd"];
    [parameters setValue:[NSNumber numberWithInt:168] forKey:@"ptz_cmd"];
    [parameters setValue:[NSNumber numberWithInt:40] forKey:@"speed"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}
-(int)SHIX_Control_SX:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"ptz_contrl" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:137] forKey:@"cmd"];
    [parameters setValue:[NSNumber numberWithInt:169] forKey:@"ptz_cmd"];
    [parameters setValue:[NSNumber numberWithInt:40] forKey:@"speed"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}
-(int)SHIX_Control_JJFD:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"ptz_contrl" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:137] forKey:@"cmd"];
    [parameters setValue:[NSNumber numberWithInt:170] forKey:@"ptz_cmd"];
    [parameters setValue:[NSNumber numberWithInt:40] forKey:@"speed"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}
-(int)SHIX_Control_JJSX:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"ptz_contrl" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:137] forKey:@"cmd"];
    [parameters setValue:[NSNumber numberWithInt:171] forKey:@"ptz_cmd"];
    [parameters setValue:[NSNumber numberWithInt:40] forKey:@"speed"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}

-(int)SHIX_Control_Stop:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"ptz_contrl" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:137] forKey:@"cmd"];
    [parameters setValue:[NSNumber numberWithInt:175] forKey:@"ptz_cmd"];
    [parameters setValue:[NSNumber numberWithInt:40] forKey:@"speed"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}


-(int)SHIX_Control_Left:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"ptz_contrl" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:137] forKey:@"cmd"];
    [parameters setValue:[NSNumber numberWithInt:162] forKey:@"ptz_cmd"];
    [parameters setValue:[NSNumber numberWithInt:40] forKey:@"speed"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}
-(int)SHIX_Control_Rigth:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"ptz_contrl" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:137] forKey:@"cmd"];
    [parameters setValue:[NSNumber numberWithInt:163] forKey:@"ptz_cmd"];
    [parameters setValue:[NSNumber numberWithInt:40] forKey:@"speed"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}
-(int)SHIX_Control_Up:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"ptz_contrl" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:137] forKey:@"cmd"];
    [parameters setValue:[NSNumber numberWithInt:160] forKey:@"ptz_cmd"];
    [parameters setValue:[NSNumber numberWithInt:40] forKey:@"speed"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}
-(int)SHIX_Control_Down:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"ptz_contrl" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:137] forKey:@"cmd"];
    [parameters setValue:[NSNumber numberWithInt:161] forKey:@"ptz_cmd"];
    [parameters setValue:[NSNumber numberWithInt:40] forKey:@"speed"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}







-(int)SHIX_SetWifi:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd Ssid:(NSString *)ssid Wifipwd:(NSString *)wifipwd Encryption:(int)encryption{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"set_wifi" forKey:@"pro"];
    [parameters setValue:[NSNumber numberWithInt:114] forKey:@"cmd"];
    [parameters setValue:user forKey:@"user"];
    [parameters setValue:pwd forKey:@"pwd"];
    [parameters setValue:[NSNumber numberWithInt:encryption] forKey:@"encryption"];
    [parameters setValue:ssid forKey:@"ssid"];
    [parameters setValue:wifipwd forKey:@"passwd"];
    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (m_pPPPPChannelMgt!=NULL) {
        m_pPPPPChannelMgt->TransferMessage((char *)[did UTF8String], (char *)[str UTF8String],0);
    }else{
        return 0;
    }
    return 1;
}
@end
