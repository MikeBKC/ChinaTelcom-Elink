#include <netinet/in.h>
#include <arpa/inet.h> 
#include <string.h> 
#include <assert.h> 
#include <linux/sockios.h> 
#include "stdlib.h"
#include "stdio.h"
#include "lua.h"
#include "lauxlib.h"
#include "uttMachine.h"
#include "typedef.h"
#include "mib.h" 
#include "profacce.h"
#include <linux/wireless.h> 
#include <user_oid.h>
#include "wireless_copy.h"

#define USHORT unsigned short
#define SHORT  short
#define UCHAR unsigned char
#define CHAR char
#define UINT32 unsigned int
#define ULONG unsigned int
#define MAC_ADDR_LEN  6
#define MAX_NUMBER_OF_MAC 64

#if 1
typedef struct _RT_802_11_MAC_ENTRY {
#if defined(CONFIG_RALINK_RT5350) || defined(CONFIG_RALINK_MT7620) || defined(CONFIG_RALINK_MT7621) || defined(CONFIG_RALINK_MT7628)
	unsigned char            ApIdx;
#endif
	unsigned char            Addr[6];
	unsigned char            Aid;
	unsigned char            Psm;     // 0:PWR_ACTIVE, 1:PWR_SAVE
	unsigned char            MimoPs;  // 0:MMPS_STATIC, 1:MMPS_DYNAMIC, 3:MMPS_Enabled
	char                     AvgRssi0;
	char                     AvgRssi1;
	char                     AvgRssi2;
	unsigned int             ConnectedTime;
	MACHTTRANSMIT_SETTING    TxRate;
	unsigned int LastRxRate;
	short StreamSnr[3];
	short SoundingRespSnr[3];
} RT_802_11_MAC_ENTRY;

typedef struct _RT_802_11_MAC_TABLE {
	unsigned long            Num;
#if defined(CONFIG_BOARD_MTK7621_F) || defined(CONFIG_RALINK_MT7612E)
	RT_802_11_MAC_ENTRY      Entry[116]; //MAX_LEN_OF_MAC_TABLE = 32
#else
	RT_802_11_MAC_ENTRY      Entry[64]; //MAX_LEN_OF_MAC_TABLE = 32
#endif
} RT_802_11_MAC_TABLE;
#endif

typedef struct _UTT_GET_STA_FLOW_TABLE_ENTRY {
    UCHAR ApIdx;
    UCHAR Addr[MAC_ADDR_LEN]; 
    ULONG txBytes; 
    ULONG rxBytes; 
}UTT_GET_STA_FLOW_TABLE_ENTRY; 
typedef struct _UTT_GET_STA_FLOW_TABLE { 
    ULONG Num; 
#if defined(CONFIG_BOARD_MTK7621_F) || defined(CONFIG_RALINK_MT7612E)
    UTT_GET_STA_FLOW_TABLE_ENTRY Entry[116]; 
#else
    UTT_GET_STA_FLOW_TABLE_ENTRY Entry[64]; 
#endif
}UTT_GET_STA_FLOW_TABLE;

#define RTPRIV_IOCTL_GET_STA_FLOW (SIOCIWFIRSTPRIV+0x1E)


#define MODE_CCK  0
#define MODE_OFDM   1
#define MODE_HTMIX  2
#define MODE_HTGREENFIELD 3
#define MODE_VHT  4

int  getRate(HTTRANSMIT_SETTING HTSetting)
{
	int MCSMappingRateTable[] =
	{2,  4,   11,  22, /* CCK*/
		12, 18,   24,  36, 48, 72, 96, 108, /* OFDM*/
		13, 26,   39,  52,  78, 104, 117, 130, 26,  52,  78, 104, 156, 208, 234, 260, /* 20MHz, 800ns GI, MCS: 0 ~ 15*/
		39, 78,  117, 156, 234, 312, 351, 390,  /* 20MHz, 800ns GI, MCS: 16 ~ 23*/
		27, 54,   81, 108, 162, 216, 243, 270, 54, 108, 162, 216, 324, 432, 486, 540, /* 40MHz, 800ns GI, MCS: 0 ~ 15*/
		81, 162, 243, 324, 486, 648, 729, 810,  /* 40MHz, 800ns GI, MCS: 16 ~ 23*/
		14, 29,   43,  57,  87, 115, 130, 144, 29, 59, 87, 115, 173, 230, 260, 288, /* 20MHz, 400ns GI, MCS: 0 ~ 15*/
		43, 87,  130, 173, 260, 317, 390, 433,  /* 20MHz, 400ns GI, MCS: 16 ~ 23*/
		30, 60,   90, 120, 180, 240, 270, 300, 60, 120, 180, 240, 360, 480, 540, 600, /* 40MHz, 400ns GI, MCS: 0 ~ 15*/
		90, 180, 270, 360, 540, 720, 810, 900,
		13, 26,   39,  52,  78, 104, 117, 130, 156, /* 11ac: 20Mhz, 800ns GI, MCS: 0~8 */
		27, 54,   81, 108, 162, 216, 243, 270, 324, 360, /*11ac: 40Mhz, 800ns GI, MCS: 0~9 */
		59, 117, 176, 234, 351, 468, 527, 585, 702, 780, /*11ac: 80Mhz, 800ns GI, MCS: 0~9 */
		14, 29,   43,  57,  87, 115, 130, 144, 173, /* 11ac: 20Mhz, 400ns GI, MCS: 0~8 */
		30, 60,   90, 120, 180, 240, 270, 300, 360, 400, /*11ac: 40Mhz, 400ns GI, MCS: 0~9 */
		65, 130, 195, 260, 390, 520, 585, 650, 780, 867 /*11ac: 80Mhz, 400ns GI, MCS: 0~9 */
	};

	int rate_count = sizeof(MCSMappingRateTable)/sizeof(int);
	int rate_index = 0;
	int value = 0;

	if (HTSetting.field.MODE >= MODE_HTMIX)
	{
		rate_index = 12 + ((UCHAR)HTSetting.field.BW *24) + ((UCHAR)HTSetting.field.ShortGI *48) + ((UCHAR)HTSetting.field.MCS);
	}
	else
		if (HTSetting.field.MODE == MODE_OFDM)
			rate_index = (UCHAR)(HTSetting.field.MCS) + 4;
		else if (HTSetting.field.MODE == MODE_CCK)
			rate_index = (UCHAR)(HTSetting.field.MCS);

	if (rate_index < 0)
		rate_index = 0;

	if (rate_index >= rate_count)
		rate_index = rate_count-1;

	value = (MCSMappingRateTable[rate_index] * 5)/10;
	return (ULONG)value;
}

static int stainfo (lua_State *L) {
	char *ifName[] = {"ra0", "rai0"};
	char *radioType[] = {"2.4G", "5G"};
	int s,i,m,y;
	int k;
	struct iwreq iwr;
	unsigned char macaddr[32] = {0}, buf[32] = {0}, ssid[32] = {0};
	RT_802_11_MAC_TABLE table = {0};
	MibProfileType mibType = MIB_PROF_WIRELESS;
	WirelessProfile *prof= NULL;
	UTT_GET_STA_FLOW_TABLE table_flow;

	lua_pop(L, lua_gettop(L));
	lua_newtable(L);

	ProfInit();
	s = socket(AF_INET, SOCK_DGRAM, 0);
	if (s >= 0)
	{

		y = 1;
		for (m = 0; m < 2; m++) 
		{
#if 0
			memset(&table_flow, 0, sizeof(table_flow));
			memset(&iwr, 0, sizeof(iwr));
			strncpy(iwr.ifr_name, ifName[m], IFNAMSIZ);
			iwr.u.data.pointer = (caddr_t) &table_flow;
			if (ioctl(s, RTPRIV_IOCTL_GET_STA_FLOW, &iwr) >= 0)
			{
#endif
					prof = (WirelessProfile *)ProfGetInstPointByIndex(MIB_PROF_WIRELESS, m);
				memset(&table, 0, sizeof(table));
				memset(&iwr, 0, sizeof(iwr));
				strncpy(iwr.ifr_name, ifName[m], IFNAMSIZ);
				iwr.u.data.pointer = (caddr_t) &table;

				if (ioctl(s, RTPRIV_IOCTL_GET_MAC_TABLE, &iwr) >= 0)
				{
					for (i = 0; i < table.Num; i++) {
						lua_pushinteger(L, y);
						lua_newtable(L);
						y++;

						/* SSIDIndex */
						lua_pushstring(L,"SSIDIndex");
						sprintf(buf, "%d", table.Entry[i].ApIdx);
						lua_pushstring(L, buf);
						lua_settable(L, -3); 

                        /* SSID*/
                        lua_pushstring(L,"SSID");
                        switch(table.Entry[i].ApIdx)
                        {
                            case 0:
                                {
                                    snprintf(ssid,sizeof(ssid),"%s",prof->mBaseCf.SSID1);
                                    break;
                                }
                            case 1:
                                {
                                    snprintf(ssid,sizeof(ssid),"%s",prof->mBaseCf.SSID2);
                                }
                            default:
                                {
                                    sprintf(ssid,"%s","");
                                }
                        }
                        lua_pushstring(L,ssid);
                        lua_settable(L,-3);

						/* Mac */
						lua_pushstring(L,"MAC");
						sprintf(macaddr,"%02X:%02X:%02X:%02X:%02X:%02X",table.Entry[i].Addr[0],table.Entry[i].Addr[1],
								table.Entry[i].Addr[2],table.Entry[i].Addr[3],table.Entry[i].Addr[4],table.Entry[i].Addr[5]);
						lua_pushstring(L, macaddr);//设置值
						lua_settable(L, -3); 

						/* PowerLevel */
						lua_pushstring(L, "PowerLevel");
						sprintf(buf,"%d",table.Entry[i].AvgRssi0);
						lua_pushstring(L, buf);
						lua_settable(L, -3);

						/* ConnectInterface */
						lua_pushstring(L, "ConnectInterface");
						sprintf(buf,"SSID%d", table.Entry[i].ApIdx+1u);
						lua_pushstring(L, buf);
						lua_settable(L, -3);

						/* OnlineTime */
						lua_pushstring(L, "OnlineTime");
						sprintf(buf,"%d",table.Entry[i].ConnectedTime);
						lua_pushstring(L, buf);
						lua_settable(L, -3);

						/* RadioType */
						lua_pushstring(L, "RadioType");
						lua_pushstring(L, radioType[m]);
						lua_settable(L, -3);

						/* RxRate */
						lua_pushstring(L, "RxRate");
						sprintf(buf,"%d",getRate((HTTRANSMIT_SETTING)table.Entry[i].TxRate.word));
						lua_pushstring(L, buf);
						lua_settable(L, -3);

						/* TxRate */
						lua_pushstring(L, "TxRate");
						lua_pushstring(L, buf);
						lua_settable(L, -3);
#if 0
						for (k = 0; k < table_flow.Num; k++) {
							if (memcmp(table_flow.Entry[k].Addr, table.Entry[i].Addr, 6) == 0) {
								lua_pushstring(L, "UsStats");
								sprintf(buf,"%lu", table_flow.Entry[k].rxBytes);
								lua_pushstring(L, buf);
								lua_settable(L, -3);

								lua_pushstring(L, "DsStats");
								sprintf(buf,"%lu", table_flow.Entry[k].txBytes);
								lua_pushstring(L, buf);
								lua_settable(L, -3);
								break;
							}
						}
#endif

						lua_settable(L, -3);
					}
				}
#if 0
			}
#endif
		}
		close(s);
	}
	ProfDetach();
	return 1;
}


static char *ChnRange24[] = {
	"1,2,3,4,5,6,7,8,9,10,11",
	"1,2,3,4,5,6,7,8,9,10,11,12,13",
	"10,11",
	"10,11,12,13",
	"14",
	"1,2,3,4,5,6,7,8,9,10,11,12,13,14",
	"3,4,5,6,7,8,9",
	"5,6,7,8,9,10,11,12,13",
};

static char *ChnRange5[] = {
	"36,40,44,48,52,56,60,64,149,153,157,161,165",
	"36,40,44,48,52,56,60,64,100,104,108,112,116,120,124,128,132,136,140",
	"36,40,44,48,52,56,60,64",
	"52,56,60,64,149,153,157,161",
	"149,153,157,161,165",
	"149,153,157,161",
	"36,40,44,48",
	"36,40,44,48,52,56,60,64,100,104,108,112,116,120,124,128,132,136,140,149,153,157,161,165",
	"52,56,60,64",
	"36,40,44,48,52,56,60,64,100,104,108,112,116,132,136,140,149,153,157,161,165",
	"36,40,44,48,149,153,157,161,165",
	"36,40,44,48,52,56,60,64,100,104,108,112,116,120,149,153,157,161",
};

static int wifiinfo (lua_State *L) {
	ProfInit();
	FILE *fp;
	MibProfileType mibType = MIB_PROF_WIRELESS;
	WirelessProfile *prof= NULL;
	int i,max,min, index = 0;
	int count = 1;
	char *ifName[] = {"ra", "rai"};
	char *radioType[] = {"2.4G", "5G"};
	char buf[128] = {0};
	char data[128] = {0};
	int tmpnum;

	lua_pop(L, lua_gettop(L));
	lua_newtable(L);

	prof = (WirelessProfile *)ProfGetInstPointByIndex(mibType, 0);
	if (prof && prof->head.active == TRUE) {
		lua_pushstring(L, "true");
	} else {
		lua_pushstring(L, "false");
	}
	
	lua_setfield(L, -2, "HardwareSwitch2.5G");
#if (WIRELESS_5G == FYES)
	prof = (WirelessProfile *)ProfGetInstPointByIndex(mibType, 1);
	if (prof && prof->head.active == TRUE) {
		lua_pushstring(L, "true");
	} else {
		lua_pushstring(L, "false");
	}
	lua_setfield(L, -2, "HardwareSwitch5G");
#endif
#if 1
	lua_newtable(L);
	ProfInstLowHigh(mibType, &max, &min);
	for (i = min; i < max; i++){
		prof = (WirelessProfile *)ProfGetInstPointByIndex(mibType, i);
		if (prof && strcmp(prof->head.name, "")) {
			char *ssid[2];
			ssid[0] = prof->mBaseCf.SSID1;
			ssid[1] = prof->mBaseCf.SSID2;
			char *pwd[2];
			pwd[0] = prof->mSafeCf.ap.AuthMode.pskPsswd;
			//pwd[1] = prof->mSafeCf.ap.AuthMode_2.pskPsswd;
			char *authMode[2];
			authMode[0] = prof->mSafeCf.SelAuthMode;
			//authMode[1] = prof->mSafeCf.SelAuthMode_2;
			int ssidBroadCastEn[2];
			ssidBroadCastEn[0] = prof->mBaseCf.SSIDBroadCastEn;
			//ssidBroadCastEn[1] = prof->mBaseCf.SSIDBroadCastEn2;
			int enable[2];
			//enable[0] = prof->mBaseCf.ssid1En;
			//enable[1] = prof->mBaseCf.ssid2En;

			for (index = 0; index < 2; index++) {
				//if (strcmp(ssid[index], "") == 0) continue;
				lua_pushinteger(L, count);
				lua_newtable(L);

				/* SSIDIndex */
				lua_pushstring(L,"SSIDIndex");
				sprintf(buf, "%u", index + ( i * 4) + 1);
				lua_pushstring(L, buf);
				lua_settable(L, -3);

				/* SSID */
				lua_pushstring(L,"SSID");
				if (strcmp(ssid[index], "") == 0) {
					enable[index] = 0;
					sprintf(buf, "AP_%s_%d", radioType[i], index+1);
					lua_pushstring(L, buf);
				} else {
					lua_pushstring(L, ssid[index]);
				}
				lua_settable(L, -3);

				/* PWD */
				lua_pushstring(L,"PWD");
				lua_pushstring(L, pwd[index]);
				lua_settable(L, -3);

				/* ENCRYPT */
				lua_pushstring(L,"ENCRYPT");
				if (strcmp(authMode[index], "WPAPSK") == 0) {
					sprintf(buf, "3");
				} else if (strcmp(authMode[index], "WPA2PSK") == 0) {
					sprintf(buf, "4");
				} else if (strcmp(authMode[index], "WPAPSKWPA2PSK") == 0) {
					sprintf(buf, "5");
				} else {
					sprintf(buf, "1");
				}
				lua_pushstring(L, buf);
				lua_settable(L, -3);

				/* PowerLevel */
				lua_pushstring(L,"PowerLevel");
				sprintf(buf, "%d", prof->mBaseCf.TxPower);
				lua_pushstring(L, buf);
				lua_settable(L, -3);

				/* Channel */
				lua_pushstring(L,"Channel");
				snprintf(buf, sizeof(buf), "iwconfig %s%d|grep Channel|awk -F 'Channel=' '{print $2}'|awk '{print $1}'", 
					ifName[i], index);
				memset(data, 0, sizeof(data));
				fp = popen(buf, "r");
				if (fp != NULL) {
					fgets(data, sizeof(data), fp);
					if (data[strlen(data)-1] == '\n') {
						data[strlen(data)-1] = '\0';
					}
					pclose(fp);
				}
				if (data[0] == '\0' || (data[0] < '0' && data[0] > '9')) {
					sprintf(data, "1");
				}
				lua_pushstring(L, data);
				lua_settable(L, -3);
				

				/* Enable */
				lua_pushstring(L,"Enable");
				lua_pushstring(L, enable[index]?"1":"0");
				lua_settable(L, -3);

				/* Standard */
				lua_pushstring(L,"Standard");
				switch (prof->mBaseCf.WirelessMode) {
					case 4:
						sprintf(buf, "11g");
						break;
					case 6:
						sprintf(buf, "11n");
						break;
					case 9:
						sprintf(buf, "11bgn");
						break;
					case 2:
						sprintf(buf, "11a");
						break;
					case 8:
						sprintf(buf, "11na");
						break;
					case 14:
						sprintf(buf, "11ac");
						break;
					case 15:
						sprintf(buf, "11ac");
						break;
					default:
						sprintf(buf, i==0?"11bgn":"11ac");
						break;
				}
				lua_pushstring(L, buf);
				lua_settable(L, -3);

				/* RadioType */
				lua_pushstring(L,"RadioType");
				lua_pushstring(L, radioType[i]);
				lua_settable(L, -3);

				/* SSIDAdvertisementEnabled */
				lua_pushstring(L,"SSIDAdvertisementEnabled");
				lua_pushstring(L, ssidBroadCastEn[index]?"TRUE":"FALSE");
				lua_settable(L, -3); 

				/* AutoChannelEnable */
				lua_pushstring(L,"AutoChannelEnable");
				lua_pushstring(L, prof->mBaseCf.AutoChannelSelect?"TRUE":"FALSE");
				lua_settable(L, -3);

				if (i == 0) {
					/* ChannelsInUse */
					lua_pushstring(L,"ChannelsInUse");
					if (prof->mBaseCf.CountryRegion > 7) {
						lua_pushstring(L, ChnRange24[5]);
					} else {
						lua_pushstring(L, ChnRange24[prof->mBaseCf.CountryRegion]);
					}
					lua_settable(L, -3);
				} else {
					/* ChannelsInUse */
					lua_pushstring(L,"ChannelsInUse");
					if (prof->mBaseCf.CountryRegionABand > 11) {
						lua_pushstring(L, ChnRange5[7]);
					} else {
						lua_pushstring(L, ChnRange5[prof->mBaseCf.CountryRegionABand]);
					}
					lua_settable(L, -3);

					/* FrequencyWidth */
					lua_pushstring(L,"FrequencyWidth");
					if (prof->mBaseCf.ChanWidth == 0) {
						lua_pushstring(L, "20M");
					} else {
						if (prof->mBaseCf.HT_BSSCoexistence == 0) {
							lua_pushstring(L, "40M");
						} else {
							if (prof->mBaseCf.VChanWidth == 0) {
								lua_pushstring(L, "Auto20M40M");
							} else {
								lua_pushstring(L, "Auto20M40M80M");
							}
						}
					}
					lua_settable(L, -3);
				}

				lua_settable(L, -3);
				count++;
			}
		}
	}
	lua_setfield(L, -2, "List");
#endif
	ProfDetach();
	return 1;
}

#define UTT_MAX_BUF_LEN 256
char *getField(lua_State *L, const char *key, char *data) 
{
	char *result;
	lua_getfield(L, -1, key);
    result = (char *)lua_tostring(L, -1);
	if (result == NULL) {
		lua_pop(L, 1);
		return NULL;
	} else {
		memset(data, 0, UTT_MAX_BUF_LEN);
		strncpy(data, result, UTT_MAX_BUF_LEN - 1);
	}
    lua_pop(L, 1);
    return data;
}


static int wifiset (lua_State *L)
{
	MibProfileType mibType = MIB_PROF_WIRELESS;
	WirelessProfile *prof= NULL;
	struProfAlloc *profhead = NULL;

	char buf[UTT_MAX_BUF_LEN] = {0};
	int index, idx, profIndex;
	int valInt;

	int *_ssidBroadCastEn[2];
	int *_enable[2];

	char *_ssid[2];
	char *_selAuthMode[2];
	struct st_AuthMode_prof *_authMode[2];

	lua_getglobal(L, "wifiInfo");

	if (getField(L, "SSIDIndex", buf) == NULL) {
		return 0;
	}
	index = strtol(buf, NULL, 10);

	if (index < 5) {
		profIndex = 0;
		idx = index - 1;
	} else {
		profIndex = 1;
		idx = index - 5;
	}
	if (idx > 1 || idx < 0) {
		return 0;
	}

	//printf("idx=%d, profIdx=%d\n", idx, profIndex);

	ProfInit();

	prof = (WirelessProfile *)ProfGetInstPointByIndex(mibType, profIndex);
	ProfBackupByIndex(mibType, PROF_CHANGE_EDIT, profIndex, &profhead);
	
	if (prof != NULL && strcmp(prof->head.name, "")) {
		_ssid[0] = prof->mBaseCf.SSID1;
		_ssid[1] = prof->mBaseCf.SSID2;
		_selAuthMode[0] = prof->mSafeCf.SelAuthMode;
		//_selAuthMode[1] = prof->mSafeCf.SelAuthMode_2;
		_authMode[0] = &prof->mSafeCf.ap.AuthMode;
		//_authMode[1] = &prof->mSafeCf.ap.AuthMode_2;
		_ssidBroadCastEn[0] = &prof->mBaseCf.SSIDBroadCastEn;
		//_ssidBroadCastEn[1] = &prof->mBaseCf.SSIDBroadCastEn2;
		//_enable[0] = &prof->mBaseCf.ssid1En;
		//_enable[1] = &prof->mBaseCf.ssid2En;

		if (getField(L, "SSID", buf)) {
			snprintf(_ssid[idx], sizeof(prof->mBaseCf.SSID1), buf);
			//printf("SSID = %s\n", buf);
		}
		if (getField(L, "PWD", buf)) {
			snprintf( _authMode[idx]->pskPsswd, sizeof(_authMode[idx]->pskPsswd), buf);
			//printf("PWD = %s\n", buf);
		}
		if (getField(L, "ENCRYPT", buf)) {
			valInt = strtol(buf, NULL, 10);
			switch (valInt) {
				case 1:
				case 2:
					snprintf(_selAuthMode[idx], sizeof(prof->mSafeCf.SelAuthMode), "OPEN");
					snprintf(_authMode[idx]->EncrypType, sizeof(_authMode[idx]->EncrypType), "NONE");
					_authMode[idx]->IEEE8021X = 0;
					break;
				case 3:
					snprintf(_selAuthMode[idx], sizeof(prof->mSafeCf.SelAuthMode), "WPAPSK");
					snprintf(_authMode[idx]->EncrypType, sizeof(_authMode[idx]->EncrypType), "TKIPAES");
					_authMode[idx]->IEEE8021X = 0;
					break;
				case 4:
					snprintf(_selAuthMode[idx], sizeof(prof->mSafeCf.SelAuthMode), "WPA2PSK");
					snprintf(_authMode[idx]->EncrypType, sizeof(_authMode[idx]->EncrypType), "TKIPAES");
					_authMode[idx]->IEEE8021X = 0;
					break;
				case 5:
					snprintf(_selAuthMode[idx], sizeof(prof->mSafeCf.SelAuthMode), "WPAPSKWPA2PSK");
					snprintf(_authMode[idx]->EncrypType, sizeof(_authMode[idx]->EncrypType), "TKIPAES");
					_authMode[idx]->IEEE8021X = 0;
					break;
			}
		}
		if (getField(L, "PowerLevel", buf)) {
			prof->mBaseCf.TxPower = strtoul(buf, NULL, 10);
		}
		if (getField(L, "AutoChannelEnable", buf)) {
			if (strcmp(buf, "TRUE") == 0) {
				prof->mBaseCf.AutoChannelSelect = 2;
				prof->mBaseCf.Channel = 0;
			} else {
				prof->mBaseCf.AutoChannelSelect = 0;
				if (getField(L, "Channel", buf)) {
					prof->mBaseCf.Channel = strtoul(buf, NULL, 10);
				}
			}
		} else if (getField(L, "Channel", buf)) {
			prof->mBaseCf.AutoChannelSelect = 0;
			prof->mBaseCf.Channel = strtoul(buf, NULL, 10);
		}
		//printf("---------- set Channel : %s, result : %d\n", buf, prof->mBaseCf.Channel);
		if (getField(L, "Enable", buf)) {
			valInt = strtol(buf, NULL, 10);
			if (valInt) {
				*_enable[idx] = 1;
			} else {
				*_enable[idx] = 0;
			}
		}
		if (getField(L, "SSIDAdvertisementEnabled", buf)) {
			if (strcmp(buf, "TRUE") == 0) {
				*_ssidBroadCastEn[idx] = 1;
			} else {
				*_ssidBroadCastEn[idx] = 0;
			}
		}
		if (getField(L, "Standard", buf)) {
			if (profIndex == 0) {
				if (strcmp(buf, "11g") == 0) {
					prof->mBaseCf.WirelessMode = 4;
				} else if (strcmp(buf, "11n") == 0) {
					prof->mBaseCf.WirelessMode = 6;
				} else if (strcmp(buf, "11bgn") == 0) {
					prof->mBaseCf.WirelessMode = 9;
				} else {
					prof->mBaseCf.WirelessMode = 9;
				}
			} else {
				if (strcmp(buf, "11a") == 0) {
					prof->mBaseCf.WirelessMode = 2;
				} else if (strcmp(buf, "11na") == 0) {
					prof->mBaseCf.WirelessMode = 8;
				} else if (strcmp(buf, "11ac") == 0) {
					prof->mBaseCf.WirelessMode = 14;
				} else {
					prof->mBaseCf.WirelessMode = 14;
				}
			}
		}
		if (getField(L, "FrequencyWidth", buf) && profIndex == 1) {
			if (strcmp(buf, "20M") == 0) {
				prof->mBaseCf.ChanWidth = 0;
				prof->mBaseCf.HT_BSSCoexistence = 0;
				prof->mBaseCf.VChanWidth = 0;
			} else if (strcmp(buf, "40M") == 0) {
				prof->mBaseCf.ChanWidth = 1;
				prof->mBaseCf.HT_BSSCoexistence = 0;
				prof->mBaseCf.VChanWidth = 0;
			} else if (strcmp(buf, "Auto20M40M") == 0) {
				prof->mBaseCf.ChanWidth = 1;
				prof->mBaseCf.HT_BSSCoexistence = 1;
				prof->mBaseCf.VChanWidth = 0;
			} else if (strcmp(buf, "Auto20M40M80M") == 0) {
				prof->mBaseCf.ChanWidth = 1;
				prof->mBaseCf.HT_BSSCoexistence = 1;
				prof->mBaseCf.VChanWidth = 1;
			}

		}

	}

	ProfUpdate(profhead);
	ProfFreeAllocList(profhead);
	nvramWriteCommit();

	ProfDetach();
	return 1;
}

static struct luaL_Reg R[] = {
	{"stainfo",		stainfo},
	{"wifiinfo",	wifiinfo},
	{"wifiset",		wifiset},
	{NULL,			NULL}
};

int luaopen_wifista (lua_State *L) {
	lua_newtable(L);
	luaL_setfuncs(L, R, 0);
	return 1;
}
