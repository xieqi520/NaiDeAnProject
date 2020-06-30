//
//  SHIXGLController.h
//  SHIXGLController
//
//  Created by zhaogenghuai on 2016/12/27.
//  Copyright © 2016年 zhaogenghuai. All rights reserved.
//



#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>


@interface SHIXGLController : GLKViewController{
    int m_nWidth;
    int m_nHeight;
    
    Byte* m_pYUVData;
    NSCondition *m_YUVDataLock;
    
    GLuint _testTxture[3];
    
    BOOL m_bNeedSleep;
}

- (void) YUVRefresh: (Byte*) pYUV Len: (int) length width: (int)width height: (int) height;

@end
