CUR_DIR=$(shell pwd)

CC_OPT =
LD_OPT =

CC_OPT += -I$(ROOTDIR)/uttShareHead/config 
CC_OPT += -I$(ROOTDIR)/$(LINUXDIR)/include -I$(ROOTDIR)/lib/libconfig/cliConfig
CC_OPT += -I$(ROOTDIR)/lib/libconfig/profacc -I$(ROOTDIR)/lib/libconfig/mib -I$(ROOTDIR)/lib/libconfig/cli 
CC_OPT += -I$(ROOTDIR)/config
CC_OPT += -fPIC -shared 
CC_OPT += -I../../lua-5.3.4
CC_OPT += -I./ 
LD_OPT += -L$(ROOTDIR)/lib/lib -lconfig

TEST_CC_OPT = 
TEST_LD_OPT =

.PHONY: all romfs clean process wifista libaes upgradeTool testTool

#all:process wifista libaes upgradeTool testTool
all:wifista 

libaes:
	$(CC) $(CC_OPT) -c -o aes256.o aes256/aes256.c
	$(CC) $(CC_OPT) $(LD_OPT) aes256.o -o aes256.so

testTool:
	$(CC) $(CC_OPT) $(TEST_CC_OPT) -c -o testTool.o testTool.c
	$(CC) $(LD_OPT) $(TEST_LD_OPT) testTool.o -o testTool

upgradeTool:
	$(CC) $(CC_OPT) -c -o upgradeTool.o upgradeTool.c
	$(CC) $(LD_OPT) upgradeTool.o -o upgradeTool

process:
	$(CC) $(CC_OPT) -DUTT_HWMODEL=\"$(UTTHWMODEL)\" -c -o process.o process.c
	$(CC) $(CC_OPT) $(LD_OPT) process.o -o process.so

wifista:
	$(CC) $(CC_OPT) -c -o wifista.o wifista.c
	$(CC) $(CC_OPT) $(LD_OPT) wifista.o -o wifista.so

clean:
	-rm -rf *.o *.so upgradeTool testTool

romfs:
	#$(ROMFSINST)  /usr/local/lib/lua/5.3/process.so
	$(ROMFSINST)  /usr/local/lib/lua/5.3/wifista.so
	#$(ROMFSINST)  /usr/local/lib/lua/5.3/aes256.so
