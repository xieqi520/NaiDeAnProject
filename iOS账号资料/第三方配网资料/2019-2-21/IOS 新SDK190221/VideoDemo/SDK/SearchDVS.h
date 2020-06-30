// SearchDVS.h: interface for the CSearchDVS class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_SEARCHDVS_H__C7BA1053_FF01_4C07_A732_0AD16CE7DB7B__INCLUDED_)
#define AFX_SEARCHDVS_H__C7BA1053_FF01_4C07_A732_0AD16CE7DB7B__INCLUDED_


#include <pthread.h>
#include <memory.h>
#include <string.h>
#include <stdio.h>
#include <sys/socket.h>
#include <netinet/tcp.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/unistd.h>
#include <sys/fcntl.h>
#include <sys/time.h>



#import "SHIXCommonProtocol.h"

#define MAX_BIND_TIME 10
#define BROADCAST_SEND_PORT			8600
#define BROADCAST_RECV_PORT			9600

///
#define STARTCODE  0x4844  //HD
#define CMD_GET  0x0101
#define CMD_GET_RESPONSE  0x0801 
#define CMD_SET  0x0102
#define CMD_SET_RESPONSE  0x0802


#define CMD_GET_RESPONSE1  0x0803

//视频参数
typedef struct tag_STRU_CAMERA_PARAM
{
    int resolution;
    int bright;
    int contrast;
    int hue;
    int saturation;
    int osdenable;
    int mode;
    int flip;
    int enc_framerate;
    int sub_enc_framerate;
}STRU_CAMERA_PARAM,*PSTRU_CAMERA_PARAM;

typedef struct _stBcastParam
{
    char            szIpAddr[16];        //IP地址
    unsigned char            szMask[16];        //子网掩码
    char            szGateway[16];        //网关
    char            szDns1[16];        //dns1
    char            szDns2[16];        //dns2
    char            szMacAddr[6];        //设备MAC地址
    unsigned short          nPort;            //设备端口
    char            dwDeviceID[32];         //platform deviceid
    char            szDevName[32];        //设备名称
    char            sysver[16];        //固件版本
    char            appver[16];        //软件版本
    char            szUserName[32];        //修改时会对用户认证
    char            szPassword[32];        //修改时会对用户认证
    char            sysmode;                //0->baby 1->HDIPCAM
    char            other[3];               //other
    char            other1[20];             //other1
    
}BCASTPARAM, *PBCASTPARAM;

class CSearchDVS  
{
public:
	CSearchDVS();
	virtual ~CSearchDVS();
    
    id<SHIXCommonProtocol> searchResultDelegate;

public:
	int Open();
	void Close();		
	int SearchDVS();
private:
        void OnMessageProc(char *pszMessage, int iBufferSize,  char *pszIp);
        void ProcMessage(short nType, unsigned short nMessageLen, char *pszMessage);
        void GetNetParam(PBCASTPARAM pstParam);
        void CloseSocket();
	

private:
	static void* ReceiveThread(void * pParam);
	void ReceiveProcess();
    
    static void* SendThread(void * pParam);
    void SendProcess();

private:
	int			m_nSocket;
	bool		m_bRecvThreadRuning;
	pthread_t 	m_RecvThreadID;
    
    int m_bSendThreadRuning;
    pthread_t m_SendThreadID;

	
};

#endif // !defined(AFX_SEARCHDVS_H__C7BA1053_FF01_4C07_A732_0AD16CE7DB7B__INCLUDED_)
