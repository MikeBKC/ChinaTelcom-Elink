C_DIR=$(shell pwd)
CFLAGS =
LD_OPT =

SRCS = $(wildcard $(C_DIR)/lib/*.c )
OBJS=$(SRCS:.c=.o)
CFLAGS += -I$(ROOTDIR)/uttShareHead/config 
CFLAGS += -I$(ROOTDIR)/$(LINUXDIR)/include -I$(ROOTDIR)/lib/libconfig/cliConfig
CFLAGS += -I$(ROOTDIR)/lib/libconfig/profacc -I$(ROOTDIR)/lib/libconfig/mib -I$(ROOTDIR)/lib/libconfig/cli 
CFLAGS += -I$(ROOTDIR)/config
CFLAGS += -fPIC -shared 
CFLAGS += -I../lua-5.3.4
CFLAGS += -I./ 
LDFLAGS = -L$(ROOTDIR)/lib/lib 
LIBS = -lconfig

.PHONY: all romfs clean 
all:
	cd $(C_DIR)/lib ;make all 

romfs:
	cd $(C_DIR)/lib; make romfs
	$(ROMFSINST)  /usr/bin/elink.lua
	$(ROMFSINST)  /usr/bin/elink_test.lua
	$(ROMFSINST)  -d /usr/local/lib/lua/5.3/base64.lua
	$(ROMFSINST)  -d /usr/local/lib/lua/5.3/set.lua
	$(ROMFSINST)  -d /usr/local/lib/lua/5.3/get.lua
	$(ROMFSINST)  -d /usr/local/lib/lua/5.3/elink_config.lua
	$(ROMFSINST)  -d /etc_ro/Wireless/default5g.dat
	$(ROMFSINST)  -d /etc_ro/Wireless/default2g.dat

clean:
	cd $(C_DIR)/lib; make clean
