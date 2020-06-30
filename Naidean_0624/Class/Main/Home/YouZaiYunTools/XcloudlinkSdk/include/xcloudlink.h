#pragma  once
#include "xmainkey.h"

#ifdef __cplusplus
extern "C"
{
#endif
    int  CDK_InitXCloudLink(unsigned short nOpt, XCLOUDMSGCALLBACK  xMsgCallBack, XCLOUDMEDIACALLBACK  xMediaCallBack);
    void CDK_UNInitXCloudLink();
    
    //œµÕ≥»œ÷§
    int  CDK_LogIn(char strDstID[], char strPsw[], XHOSTInfo hostInfo[], unsigned short nhostCount);
    int  CDK_LogOut();
    
    //∑¢ÀÕ ˝æ› -1 ∑¢ÀÕ ß∞‹
    int  CDK_PostXMessage(char strDstID[], unsigned short nMessage, char pString[]);
    
    int  CDK_PostBMessage(unsigned int nDstID, unsigned short nMessage, const char *pBuffer,unsigned short nSize);
    
    int  CDK_PostXMessageEX(unsigned int nDstID, unsigned short nMessage, const char *pString);
    
    int  CDK_PostBMessageEX(unsigned int nDstID, unsigned short nMessage, const char *pBinBuffer, unsigned short nBinSize);
    
    //∂©‘ƒ“‘º∞»œ÷§
    int  CDK_Subscribe(char strDstID[], char strAuth[], unsigned int nOption);
    
    // -1 ∑¢ÀÕ ß∞‹£¨ > 0 ∑µªÿª∫¥Ê ˝æ›¥Û–°
    int  CDK_SendMediaData(unsigned int nSID, unsigned short nResType, unsigned char iFreamType, unsigned short lparam, char *pMediaBuffer, unsigned int nMediaBufferSize);
    
    int  CDK_SetSessionOption(unsigned int nSID, unsigned short nOpt, unsigned int nVal);
    
    // ¡¨Ω”
    int CDK_HelloXMan(char strDstID[]);
    // Õ®π˝ªÿµ˜∑µªÿsession id  //// enum XMediaType
    
    unsigned int CDK_OpenSession(char strDstID[], unsigned short nResType,unsigned short nRW);
    unsigned int CDK_CloseSession(unsigned int nSID, unsigned short nResType);
    
    
    int CDK_XBroadcastOpen(unsigned short nRecPort,unsigned short nSndPort );
    int CDK_XBroadcast(char *pBcastAddr, char *pBData,unsigned short nDataLen);
    int CDK_XBroadcastClose();
    
    
    unsigned int CDK_OpenXCloudFile(const char *strDstID,const char *strFilename,
                                    unsigned short nResType, unsigned short nRW);
    int CDK_CloseXCloudFile(unsigned int nSessionID, unsigned short nResType);
    
    
    int XMSGEncode(unsigned char* _inbyte, int _inlen, char* _outstr);
    
    int CDK_GetCompanyByID( char *pID,unsigned int nReserve);// 返回 2 是优载云ID  查询
    
    int CDK_GetDevNameByID( unsigned int nID,char aryNameID[]);//转换ID
    
#ifdef __cplusplus
}
#endif
