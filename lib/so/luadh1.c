
#include "lua.h"
#include "lauxlib.h"

#include <stdlib.h>
#ifndef HEADER_DH_H
#include <openssl/dh.h>
#endif

#define DEBUG 0
static int lgkey (lua_State *L) {
    unsigned char pub[16]={0};
    unsigned char priv[16]={0};
    static unsigned char dh128_p[]={
        0xC5,0x0C,0x4C,0xF1,0x98,0x4D,0x3E,0x49,0x70,0x9C,0x76,0x88,
        0xAB,0x25,0xEB,0x2B,
    };
    static unsigned char dh128_g[]={
        0x05,
    };
    DH *dh;
    unsigned 	char *tmp;
    int ii=0;

    if ((dh=DH_new()) == NULL) return(NULL);
    dh->p=BN_bin2bn(dh128_p,sizeof(dh128_p),NULL);
    dh->g=BN_bin2bn(dh128_g,sizeof(dh128_g),NULL);

    DH_generate_key(dh);

#if DEBUG
    tmp=(unsigned char*)(dh->p->d);
    printf("p:\n");
    for(ii=0;ii<16;ii++)
        printf("0x%02x, ",*(tmp+ii));
    printf("\n");
#endif



    BN_bn2bin(dh->pub_key, pub);
    BN_bn2bin(dh->priv_key, priv);
#if DEBUG
    printf("1pub:\n");
    for(ii=0;ii<16;ii++)
        printf("0x%02x, ",pub[ii]);
    printf("\n");

    printf("1priv:\n");
    for(ii=0;ii<16;ii++)
        printf("0x%02x, ",priv[ii]);
    printf("\n");
#endif
    lua_pushlstring(L, dh128_p, 16L);
    lua_pushlstring(L, pub, 16L);
    lua_pushlstring(L, priv, 16L);

    if ((dh != NULL) )
    { DH_free(dh);  }
    return 3;
}

static int lgsecret (lua_State *L) {
    unsigned char sharekey1[128],sharekey2[128];
    static unsigned char dh128_p[]={
        0xC5,0x0C,0x4C,0xF1,0x98,0x4D,0x3E,0x49,0x70,0x9C,0x76,0x88,
        0xAB,0x25,0xEB,0x2B,
    };
    static unsigned char dh128_g[]={
        0x05,
    };
    DH *dh;
    size_t l;
    unsigned 	char *tmp;
    int ii=0;

    const char *pub = luaL_checklstring(L, 1, &l);
    const char *priv = luaL_checklstring(L, 2, &l);
#if DEBUG
    printf("2pub:\n");
    for(ii=0;ii<16;ii++)
        printf("0x%02x, ",pub[ii]);
    printf("\n");

    printf("2priv:\n");
    for(ii=0;ii<16;ii++)
        printf("0x%02x, ",priv[ii]);
    printf("\n");
#endif
    if ((dh=DH_new()) == NULL) return(NULL);
    dh->p=BN_bin2bn(dh128_p,sizeof(dh128_p),NULL);
    dh->g=BN_bin2bn(dh128_g,sizeof(dh128_g),NULL);

    DH_generate_key(dh);
    dh->priv_key=BN_bin2bn(priv,16,NULL);

    tmp=(unsigned char*)(dh->p->d);
#if DEBUG
    printf("p:\n");
    for(ii=0;ii<16;ii++)
        printf("0x%02x, ",*(tmp+ii));
    printf("\n");
#endif


    DH_compute_key(sharekey1,BN_bin2bn(pub,16,NULL),dh);
#if DEBUG
    printf("secret:\n");
    for(ii=0;ii<16;ii++)
        printf("0x%02x, ",sharekey1[ii]);
    printf("\n");
#endif

    lua_pushlstring(L, sharekey1, 16L);

    if ((dh != NULL) )
    { DH_free(dh);  }
    return 1;
}


static struct luaL_Reg dhlib[] = {
    {"gkey", lgkey},
    {"gsecret", lgsecret},
    {NULL, NULL}
};

int luaopen_dh1 (lua_State *L) {
    lua_newtable(L);
    luaL_setfuncs(L, dhlib, 0);
    return 1;
}
