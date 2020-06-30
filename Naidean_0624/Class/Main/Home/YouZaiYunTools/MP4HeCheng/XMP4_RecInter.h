#pragma  once
#include<stdio.h>

typedef void * XCLOUDHANDLE;
typedef struct
{
	unsigned short width;
	unsigned short height;
	double frameRate;
	unsigned int timeScale /*= 90000*/;
	int nSamplePerSec /*= 0*/;
	int nSamplePerFrame;
}XMP4_RecVideoParam;


enum XMP4_FILE_OPEN_MODEL
{
	XMP4_OPEN_MODEL_W,	//
	XMP4_OPEN_MODEL_R,	//
	XMP4_OPEN_MODEL_NA = 0xff  //
};

#ifdef __cplusplus
extern "C"
{
#endif
/******XMP4_Open函数功能介绍(指针函数)****************/
/******函数功能:创建/打开待写/读的MP4文件******************************/
/******函数参数: filename          :文件名(绝对路径文件名)**********/
/**************: mode              :保留*******/
/**************: nFileEX           :XMP4_OPEN_MODEL_W write file, XMP4_OPEN_MODEL_R read file*******/
/****函数返回值: return   XCLOUDHANDLE	   :NULL失败，成功返回句柄*****************/
XCLOUDHANDLE XMP4_Open(char *filename, unsigned short nMode, unsigned short nFileEX);

/******XMP4_RECClose函数功能介绍***********************/
/******函数功能:关闭MP4文件****************************/
/****函数返回值: return   int	   :0成功，-1失败*****************/
int  XMP4_RECClose(XCLOUDHANDLE mp4Handle);

/******XMP4_RECSetVideoParam函数功能介绍**************************/
/******函数功能：设置录像参数************/
//**************:XMP4_RecVideoParam*******/
/**************: width           :视频宽度*******/
/**************: height			 :视频高度*******/
/**************: frameRate		 :视频帧率*******/
/****函数返回值: return   int	   :0成功，-1失败*****************/
int  XMP4_RECSetVideoParam(XCLOUDHANDLE mp4Handle, XMP4_RecVideoParam *pRecParam);

int  XMP4_RECSetAudioParam(XCLOUDHANDLE mp4Handle);

unsigned int  XMP4_RECGetCurFrameIndex(XCLOUDHANDLE mp4Handle);

/******XMP4_RECWriteVideoData函数功能介绍************************/
/******函数功能：写视频数据**/
/**************: pData			:数据buffer*/
/**************: nLen			:数据长度*/
/****函数返回值: return   int	   :0成功，-1失败*****************/
int  XMP4_RECWriteVideoData(XCLOUDHANDLE mp4Handle, unsigned char *pData, unsigned int nLen);

/******XMP4_RECWriteAudioData************************/
/******函数功能：写音频数据**/
/**************: pData			:数据buffer*/
/**************: nLen			:数据长度*/
/****函数返回值: return   int	   :0成功，-1失败*****************/
int  XMP4_RECWriteAudioData(XCLOUDHANDLE mp4Handle, unsigned char *pData, unsigned int nLen);

int  XMP4_RECSetReadPos(XCLOUDHANDLE mp4Handle, unsigned int nIndex);

int  XMP4_RECReadVideoData(XCLOUDHANDLE mp4Handle, unsigned char *pFrameBuf, unsigned int *nFrameSize, int* nFrameType);

int  XMP4_RECReadAudioData(XCLOUDHANDLE mp4Handle, unsigned char *pFrameBuf, unsigned int *nFrameSize, int* nFrameType);

#ifdef __cplusplus
}
#endif
