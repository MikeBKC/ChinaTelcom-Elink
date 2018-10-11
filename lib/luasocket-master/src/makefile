# luasocket src/makefile
#
# Definitions in this section can be overriden on the command line or in the
# environment.
#
# These are equivalent:
#
#    export PLAT=linux DEBUG=DEBUG LUAV=5.2 prefix=/sw
#    make
#
# and
#
#   make PLAT=linux DEBUG=DEBUG LUAV=5.2 prefix=/sw

# PLAT: linux macosx win32 mingw
# platform to build for

#CC= /opt/buildroot-gcc342/bin/mipsel-linux-uclibc-gcc
#LD= /opt/buildroot-gcc342/bin/mipsel-linux-uclibc-gcc
PLAT?=linux
LD=$(CC)
# LUAV: 5.1 5.2
# lua version to build against
LUAV?=5.3

# MYCFLAGS: to be set by user if needed
MYCFLAGS?=

# MYLDFLAGS: to be set by user if needed
MYLDFLAGS?=

# DEBUG: NODEBUG DEBUG
# debug mode causes luasocket to collect and returns timing information useful
# for testing and debugging luasocket itself
DEBUG?=NODEBUG

# LUAINC_linux:
# /usr/include/lua$(LUAV)
# /usr/local/include
# /usr/local/include/lua$(LUAV)
# where lua headers are found for linux builds
LUAINC_linux_base?=/usr/include
LUAINC_linux?=$(LUAINC_linux_base)/lua/$(LUAV)
LUAPREFIX_linux?=/usr/local
CDIR_linux?=lib/lua/$(LUAV)
LDIR_linux?=share/lua/$(LUAV)

# prefix: /usr/local /usr /opt/local /sw
# the top of the default install tree
prefix?=$(LUAPREFIX_$(PLAT))

CDIR?=$(CDIR_$(PLAT))
LDIR?=$(LDIR_$(PLAT))

# DESTDIR: (no default)
# used by package managers to install into a temporary destination
DESTDIR=

#------
# Definitions below can be overridden on the make command line, but
# shouldn't have to be.


#------
# Install directories
#

INSTALL_DIR=install -d
INSTALL_DATA=install -m644
INSTALL_EXEC=install
INSTALL_TOP=$(DESTDIR)$(prefix)

INSTALL_TOP_LDIR=$(INSTALL_TOP)/$(LDIR)
INSTALL_TOP_CDIR=$(INSTALL_TOP)/$(CDIR)

INSTALL_SOCKET_LDIR=$(INSTALL_TOP_LDIR)/socket
INSTALL_SOCKET_CDIR=$(INSTALL_TOP_CDIR)/socket
INSTALL_MIME_LDIR=$(INSTALL_TOP_LDIR)/mime
INSTALL_MIME_CDIR=$(INSTALL_TOP_CDIR)/mime

print:
	@echo PLAT=$(PLAT)
	@echo LUAV=$(LUAV)
	@echo DEBUG=$(DEBUG)
	@echo prefix=$(prefix)
	@echo LUAINC_$(PLAT)=$(LUAINC_$(PLAT))
	@echo LUALIB_$(PLAT)=$(LUALIB_$(PLAT))
	@echo INSTALL_TOP_CDIR=$(INSTALL_TOP_CDIR)
	@echo INSTALL_TOP_LDIR=$(INSTALL_TOP_LDIR)
	@echo CFLAGS=$(CFLAGS)
	@echo LDFLAGS=$(LDFLAGS)

#------
# Supported platforms
#
PLATS= linux

#------
# Compiler and linker settings
# for Linux
SO_linux=so
O_linux=o
#CC_linux=gcc
DEF_linux=-DLUASOCKET_$(DEBUG) \
	-DLUASOCKET_API='__attribute__((visibility("default")))' \
	-DUNIX_API='__attribute__((visibility("default")))' \
	-DMIME_API='__attribute__((visibility("default")))'
CFLAGS_linux= -std=gnu99 -I../../lua-5.3.4 $(DEF) -Wall -Wshadow -Wextra \
	-Wimplicit -O2 -ggdb3 -fpic 
LDFLAGS_linux= -L../../lua-5.3.4 -O -shared -fpic -o  
#LD_linux=gcc
SOCKET_linux=usocket.o

.SUFFIXES: .obj

.c.obj:
	$(CC) $(CFLAGS) //Fo"$@" //c $<

#------
# Output file names
#
SO=$(SO_$(PLAT))
O=$(O_$(PLAT))
SOCKET_V=3.0-rc1
MIME_V=1.0.3
SOCKET_SO=socket-$(SOCKET_V).$(SO)
MIME_SO=mime-$(MIME_V).$(SO)
UNIX_SO=unix.$(SO)
SERIAL_SO=serial.$(SO)
SOCKET=$(SOCKET_$(PLAT))

#------
# Settings selected for platform
#
#CC=$(CC_$(PLAT))
DEF=$(DEF_$(PLAT))
CFLAGS=$(MYCFLAGS) $(CFLAGS_$(PLAT))
LDFLAGS=$(MYLDFLAGS) $(LDFLAGS_$(PLAT))
#LD=$(LD_$(PLAT))
LUAINC= ../lua-5.3.4
LUALIB= 

#------
# Modules belonging to socket-core
#
SOCKET_OBJS= \
	luasocket.$(O) \
	timeout.$(O) \
	buffer.$(O) \
	io.$(O) \
	auxiliar.$(O) \
	compat.$(O) \
	options.$(O) \
	inet.$(O) \
	$(SOCKET) \
	except.$(O) \
	select.$(O) \
	tcp.$(O) \
	udp.$(O)

#------
# Modules belonging mime-core
#
MIME_OBJS= \
	mime.$(O) \
	compat.$(O)

#------
# Modules belonging unix (local domain sockets)
#
UNIX_OBJS=\
	buffer.$(O) \
	auxiliar.$(O) \
	options.$(O) \
	timeout.$(O) \
	io.$(O) \
	usocket.$(O) \
	unixtcp.$(O) \
	unixudp.$(O) \
	compat.$(O) \
	unix.$(O)

#------
# Modules belonging to serial (device streams)
#
SERIAL_OBJS=\
	buffer.$(O) \
	auxiliar.$(O) \
	options.$(O) \
	timeout.$(O) \
	io.$(O) \
	usocket.$(O) \
	serial.$(O)

#------
# Files to install
#
TO_SOCKET_LDIR= \
	http.lua \
	url.lua \
	tp.lua \
	ftp.lua \
	headers.lua \
	smtp.lua

TO_TOP_LDIR= \
	ltn12.lua \
	socket.lua \
	mime.lua

#------
# Targets
#
default: $(PLAT)


freebsd:
	$(MAKE) all-unix PLAT=freebsd

macosx:
	$(MAKE) all-unix PLAT=macosx

win32:
	$(MAKE) all PLAT=win32

linux:
	$(MAKE) all-unix PLAT=linux

mingw:
	$(MAKE) all PLAT=mingw
	
solaris:
	$(MAKE) all-unix PLAT=solaris

none:
	@echo "Please run"
	@echo "   make PLATFORM"
	@echo "where PLATFORM is one of these:"
	@echo "   $(PLATS)"

all: $(SOCKET_SO) $(MIME_SO)

$(SOCKET_SO): $(SOCKET_OBJS)
	$(LD) $(SOCKET_OBJS) $(LDFLAGS)$@

$(MIME_SO): $(MIME_OBJS)
	$(LD) $(MIME_OBJS) $(LDFLAGS)$@

all-unix: all $(UNIX_SO) $(SERIAL_SO)

$(UNIX_SO): $(UNIX_OBJS)
	$(LD) $(UNIX_OBJS) $(LDFLAGS)$@

$(SERIAL_SO): $(SERIAL_OBJS)
	$(LD) $(SERIAL_OBJS) $(LDFLAGS)$@

romfs:
	$(ROMFSINST)  -d $(SOCKET_SO) /usr/local/lib/lua/5.3/socket/core.so
	$(ROMFSINST)  -d $(MIME_SO) /usr/local/lib/lua/5.3/mime/core.so

install: 
	$(INSTALL_DIR) $(INSTALL_TOP_LDIR)
	$(INSTALL_DATA) $(TO_TOP_LDIR) $(INSTALL_TOP_LDIR)
	$(INSTALL_DIR) $(INSTALL_SOCKET_LDIR)
	$(INSTALL_DATA) $(TO_SOCKET_LDIR) $(INSTALL_SOCKET_LDIR)
	$(INSTALL_DIR) $(INSTALL_SOCKET_CDIR)
	$(INSTALL_EXEC) $(SOCKET_SO) $(INSTALL_SOCKET_CDIR)/core.$(SO)
	$(INSTALL_DIR) $(INSTALL_MIME_CDIR)
	$(INSTALL_EXEC) $(MIME_SO) $(INSTALL_MIME_CDIR)/core.$(SO)

install-unix: install
	$(INSTALL_EXEC) $(UNIX_SO) $(INSTALL_SOCKET_CDIR)/$(UNIX_SO)
	$(INSTALL_EXEC) $(SERIAL_SO) $(INSTALL_SOCKET_CDIR)/$(SERIAL_SO)

local:
	$(MAKE) install INSTALL_TOP_CDIR=.. INSTALL_TOP_LDIR=..

clean:
	rm -f $(SOCKET_SO) $(SOCKET_OBJS) $(SERIAL_OBJS)
	rm -f $(MIME_SO) $(UNIX_SO) $(SERIAL_SO) $(MIME_OBJS) $(UNIX_OBJS)

.PHONY: all $(PLATS) default clean echo none

#------
# List of dependencies
#
compat.$(O): compat.c compat.h
auxiliar.$(O): auxiliar.c auxiliar.h
buffer.$(O): buffer.c buffer.h io.h timeout.h
except.$(O): except.c except.h
inet.$(O): inet.c inet.h socket.h io.h timeout.h usocket.h
io.$(O): io.c io.h timeout.h
luasocket.$(O): luasocket.c luasocket.h auxiliar.h except.h \
	timeout.h buffer.h io.h inet.h socket.h usocket.h tcp.h \
	udp.h select.h
mime.$(O): mime.c mime.h
options.$(O): options.c auxiliar.h options.h socket.h io.h \
	timeout.h usocket.h inet.h
select.$(O): select.c socket.h io.h timeout.h usocket.h select.h
serial.$(O): serial.c auxiliar.h socket.h io.h timeout.h usocket.h \
  options.h unix.h buffer.h
tcp.$(O): tcp.c auxiliar.h socket.h io.h timeout.h usocket.h \
	inet.h options.h tcp.h buffer.h
timeout.$(O): timeout.c auxiliar.h timeout.h
udp.$(O): udp.c auxiliar.h socket.h io.h timeout.h usocket.h \
	inet.h options.h udp.h
unix.$(O): unix.c auxiliar.h socket.h io.h timeout.h usocket.h \
	options.h unix.h buffer.h
usocket.$(O): usocket.c socket.h io.h timeout.h usocket.h
wsocket.$(O): wsocket.c socket.h io.h timeout.h usocket.h
