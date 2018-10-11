


CC           ?= gcc
CFLAGS       ?= -Wall -Os 
#CFLAGS      += -Wl,-Map,test.map
CFLAGS      += -fPIC -shared 
CFLAGS 		+=-I../lua-5.3.4
CFLAGS		+=-I../openssl-0.9.8x/openssl-0.9.8x/include

LDFLAGS     +=-L../openssl-0.9.8x/openssl-0.9.8x/

LIBS    += -lssl -lcrypto

curdir = $(shell pwd)
all:dh1 aess

dh1:
	$(CC) $(CFLAGS) -c -o luadh1.o luadh1.c
	$(CC) $(CFLAGS) $(LDFLAGS) $(LIBS)   luadh1.o -o dh1.so

aess:
	$(CC) $(CFLAGS) -c -o luaaes.o luaaes.c
	$(CC) $(CFLAGS) $(LDFLAGS) $(LIBS) luaaes.o -o aes.so
clean:
	rm -f *.OBJ *.LST *.o *.gch *.out *.hex *.map *.so

romfs:
	cp -fpR $(curdir)/*.so  $(ROOTDIR)/romfs/usr/local/lib/lua/5.3/

