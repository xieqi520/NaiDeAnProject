#ifndef _X_FFCODEC_H_
#define _X_FFCODEC_H_

#include <stdint.h>
#import "XDecoder.h"

/*
 * VideoDecoder
 */

typedef enum {
    XCODEC_ID_H264 = 1,
    XCODEC_ID_MPEG4 = 2,
    XCODEC_ID_MJPEG = 3,
} _XCodeID;


typedef struct {
	_XCodeID codeID; // 视频类型 对应_XCodeID ，其他参数可以忽略
	uint32_t frameWidth;
	uint32_t frameHeight;
	uint32_t frameRate;
} VideoDecoderCreateParam;

typedef struct {
	uint8_t *bitstream;//解码前数据
	uint32_t bitstreamLength;//解码前数据长度
	uint8_t *frameBuffer;//解码后数据，
	uint32_t bufferSize;	// [IN/OUT]
	uint32_t frameWidth;	// [OUT]
	uint32_t frameHeight;	// [OUT]
	uint32_t decodedLength;	// [OUT]
} VideoDecodeParam;

/*
 * XCodeDecoder
 */

/*
 1、创建 解码对象
 VideoDecCreateParam createParam;
 createParam.codeID = XCODEC_ID_H264;
 XCodeDecoder *pXVideoDecoder = new XCodeDecoder(&createParam);
 
 2、开始解码
 VideoDecParam videoParam;
 赋值解码数据
 pXVideoDecoder->decode(&videoParam);//  > 0 解码成功
 videoParam.frameBuffer;
 */

//class XCodeDecoder
//{
//public:
//	static XCodeDecoder *factory();
//	VideoDecoder *create(VideoDecoderCreateParam *createParam);
//private:
//    XCodeDecoder() {}
//    ~XCodeDecoder() {}
//	static XCodeDecoder *_factory;
//};
#ifdef __cplusplus


//1、lawflag 0 表示 alaw ; 1表示 ulaw;一般请用 0
//2、返回编码或解码后的数据长度
extern "C"
{
#endif
	int G711XEncoder(short *inpcm, unsigned char *outcode, int size, int lawflag);
	int G711XDecoder(unsigned char *incode, short *outpcm, int size, int lawflag);
#ifdef __cplusplus	
}
#endif
#endif//_X_FFCODEC_H_
