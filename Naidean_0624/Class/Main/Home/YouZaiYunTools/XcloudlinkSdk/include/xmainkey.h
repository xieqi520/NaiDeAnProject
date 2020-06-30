
#import <AudioToolbox/AudioToolbox.h>

#pragma  once
typedef  int(*XCLOUDMSGCALLBACK)(unsigned short nMsg, unsigned int hParam, unsigned int lParam, char *pString, unsigned int nSize);
typedef  void(*XCLOUDMEDIACALLBACK)(unsigned int nSID, unsigned short MediaType, unsigned short hParam, unsigned short lParam, char *pBuf, unsigned int nBuflen);



typedef struct _XHOSTInfo
{
	char aryIP[255];
	unsigned short nPort;
	unsigned short hProto;

#ifdef __cplusplus
	_XHOSTInfo()
	{
		memset(aryIP, 0, sizeof(aryIP));
		nPort = 0;
		hProto = 0;
	}
#endif
} XHOSTInfo;

typedef struct _SessionFormat
{
	unsigned short MediaTpye;  //±‡¬Î¿‡–Õ
	unsigned short nOffTime;   // ±º‰≤Ó
	unsigned short FrameType;
	char *pDataBuf;
	unsigned int nBufLen;
#ifdef __cplusplus
	_SessionFormat()
	{
		pDataBuf = 0;
		nBufLen = 0;
		MediaTpye = 0;
		FrameType = 0;
	}
#endif
}SessionFormat;

enum XCLOUD_LOGINSTATUS
{
	LOGINSTATUS_CONERR = 0, // µ«¬º¡¨Ω”Õ¯¬Á≥¨ ±
	LOGINSTATUS_UNKNOWERR,
	LOGINSTATUS_DBERR,      // DB ¥ÌŒÛ
	LOGINSTATUS_PSSWDERR,   // √‹¬Î¥ÌŒÛ
	LOGINSTATUS_OK,
};
enum _XCLOUDRES_OPT
{
	_XCLOUDRES_OPT_READ = 0,
	_XCLOUDRES_OPT_WRITE,
};



enum _XCLOUDRES_TYPE
{
    _XCLOUDRES_IM = 0,
    _XCLOUDRES_PCMa = 10,
    _XCLOUDRES_PCMu,
    _XCLOUDRES_G711a,
    _XCLOUDRES_G711u,
    _XCLOUDRES_G726,
    _XCLOUDRES_G729,
    _XCLOUDRES_AAC,
    _XCLOUDRES_H264_1 = 20,
    _XCLOUDRES_H264_2,
    _XCLOUDRES_H264_3,
    _XCLOUDRES_H264_4,
    _XCLOUDRES_H264_5,
    _XCLOUDRES_H264_6,
    _XCLOUDRES_H264_7,
    _XCLOUDRES_H264_8,
    _XCLOUDRES_H265_1,
    _XCLOUDRES_H265_2,
    _XCLOUDRES_H265_3,
    _XCLOUDRES_MPEG4,
    _XCLOUDRES_MJPEG,
    _XCLOUDRES_FILE_1 = 50,
    _XCLOUDRES_FILE_2,
    _XCLOUDRES_FILE_3,
    _XCLOUDRES_FILE_4,
    _XCLOUDRES_FILE_5,
    _XCLOUDRES_FILE_6,
    _XCLOUDRES_FILE_7,
    _XCLOUDRES_FILE_JPEG,
    _XCLOUDRES_FILE_VODAUDIO,
    _XCLOUDRES_FILE_VODVIDEO,
    _XCLOUDRES_END
};


enum _XCLOUDAS_MAINCMD
{
    XCLOUDAS_HELLOXMAN = 100,
	XCLOUDAS_UPDATENATADDR,
	XCLOUDAS_UPDATELOCALADDR,
	XCLOUDAS_UPDATESTATUS,
	XCLOUDAS_JUSTTRY,
	XCLOUDAS_OPENRESOURCE,   //open session
	XCLOUDAS_CLOSERESOURCE,  //close session
	XCLOUDAS_SUBSCRIBE,
	XCLOUDAS_TRANSMISSION,
	XCLOUDAS_CONNECT,
	XCLOUDAS_CREATEROUTE,
	XCLOUDAS_DESTORYROUTE,
	XCLOUDAS_CREATEROUTEFAIL,
	XCLOUDAS_CREATEROUTESUCCESS,
	XCLOUDAS_LOGOUT,
};


enum _XCLOUDEFRM_TYPE
{
    XCLOUDEFRM_IMP = 0,
    XCLOUDEFRM_FRAMEI = 1,
    XCLOUDEFRM_FRAMEP = 2,
    XCLOUDEFRM_YLOST = 3,
};
