
#ifndef __AVRECORD_H__
#define __AVRECORD_H__

#include "libavformat/avformat.h"
#include "libavcodec/avcodec.h"
#include "libswscale/swscale.h"

//#include "IPCAM_Export.h"

#ifdef __cplusplus
extern "C"
{
#endif

#define FORMAT_MOV					0
#define FORMAT_3GP					1
#define FORMAT_AVI					2
#define FORMAT_ERROR				3

typedef enum _VIDEO_CODEC
{
    MJPG_MOV,
    H264_MOV,
    MP4S_MOV
}VIDEO_CODEC;
        
typedef enum _AUDIO_CODEC
{
    PCM_MOV     = 0,
    ADPCM_MOV   = 1,
}AUDIO_CODEC;

typedef struct _AUDIO_CHUNK
{
    unsigned int tick;
    uint8_t *data;
    //char data[3000];
    //char data[5*640];
    int len;
    int sample;
    int index;
    AUDIO_CODEC codec;
}AUDIO_CHUNK;

typedef struct _VIDEO_FRAME
{
    VIDEO_CODEC codec;
    unsigned char *data;
    //unsigned char data[50000];
    //unsigned char data[256*1024];
    unsigned int len;
    unsigned short keyframe;
    unsigned int tick;
    short resolution;
}VIDEO_FRAME;

typedef struct tagAVRecordContext
{
    AVFormatContext *oc;

    AVStream *audio_st, *video_st;

    int is_video_first;

	unsigned int first_tick;
	unsigned int video_tick;
	unsigned int audio_tick;
	int first_video;

	unsigned int format;
	
	int video;
	VIDEO_CODEC v_codec;
	unsigned long width;
	unsigned long height;
	unsigned long bitrate;

	int audio;
    
	int avc_extradata_len;
	void* avc_extradata;
	int check_avc_extradata;
} AV_RECORD_CONTEXT;


/*** inner funcs ***/
void av_record_lib_init();

//	0 ok, < 0 failed
int av_record_set_format(AV_RECORD_CONTEXT *c, unsigned int format);

//	0 ok, < 0 failed
int av_record_video_init(AV_RECORD_CONTEXT *c, VIDEO_CODEC codec, unsigned long width, unsigned long height, unsigned long bitrate);

//	0 ok, < 0 failed
int av_record_audio_init(AV_RECORD_CONTEXT *c);

//	0 ok, < 0 failed; is_video_first: is video frame as the first frame of file
int av_record_create_file(AV_RECORD_CONTEXT *c, const char * filename, int is_video_first);

//	0 ok, < 0 failed, 1 should end record
int av_record_write_video(AV_RECORD_CONTEXT *c, VIDEO_FRAME *frame);

//	0 ok, < 0 failed, 1 should end record
int av_record_write_audio(AV_RECORD_CONTEXT *c, AUDIO_CHUNK *chunk);

void av_record_close(AV_RECORD_CONTEXT *c);


/**Public Functions**/
int Mov_Record_Init(unsigned int iWidth, unsigned int iHeight, unsigned int framerate, unsigned int audio);
int Mov_Record_Open(const char *pFilePath);
int Mov_Record_Write_Video(unsigned char *pVData, unsigned int nDataLen, int isIFrame);
int Mov_Record_Write_Audio(unsigned char *pAData, unsigned int nDataLen, int AudioEncType);
int Mov_Record_Close(void);

#ifdef __cplusplus
}
#endif

#endif

