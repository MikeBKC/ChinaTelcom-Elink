#
# OpenSSL/crypto/x509v3/Makefile
#

DIR=	x509v3
TOP=	../..
CC=	cc
INCLUDES= -I.. -I$(TOP) -I../../include
CFLAG=-g
MAKEFILE=	Makefile
AR=		ar r

CFLAGS= $(INCLUDES) $(CFLAG)

GENERAL=Makefile README
TEST=
APPS=

LIB=$(TOP)/libcrypto.a
LIBSRC=	v3_bcons.c v3_bitst.c v3_conf.c v3_extku.c v3_ia5.c v3_lib.c \
v3_prn.c v3_utl.c v3err.c v3_genn.c v3_alt.c v3_skey.c v3_akey.c v3_pku.c \
v3_int.c v3_enum.c v3_sxnet.c v3_cpols.c v3_crld.c v3_purp.c v3_info.c \
v3_ocsp.c v3_akeya.c v3_pmaps.c v3_pcons.c v3_ncons.c v3_pcia.c v3_pci.c \
pcy_cache.c pcy_node.c pcy_data.c pcy_map.c pcy_tree.c pcy_lib.c \
v3_asid.c v3_addr.c
LIBOBJ= v3_bcons.o v3_bitst.o v3_conf.o v3_extku.o v3_ia5.o v3_lib.o \
v3_prn.o v3_utl.o v3err.o v3_genn.o v3_alt.o v3_skey.o v3_akey.o v3_pku.o \
v3_int.o v3_enum.o v3_sxnet.o v3_cpols.o v3_crld.o v3_purp.o v3_info.o \
v3_ocsp.o v3_akeya.o v3_pmaps.o v3_pcons.o v3_ncons.o v3_pcia.o v3_pci.o \
pcy_cache.o pcy_node.o pcy_data.o pcy_map.o pcy_tree.o pcy_lib.o \
v3_asid.o v3_addr.o

SRC= $(LIBSRC)

EXHEADER= x509v3.h
HEADER=	$(EXHEADER) pcy_int.h

ALL=    $(GENERAL) $(SRC) $(HEADER)

top:
	(cd ../..; $(MAKE) DIRS=crypto SDIRS=$(DIR) sub_all)

all:	lib

lib:	$(LIBOBJ)
	$(ARX) $(LIB) $(LIBOBJ)
	$(RANLIB) $(LIB) || echo Never mind.
	@touch lib

files:
	$(PERL) $(TOP)/util/files.pl Makefile >> $(TOP)/MINFO

links:
	@$(PERL) $(TOP)/util/mklink.pl ../../include/openssl $(EXHEADER)
	@$(PERL) $(TOP)/util/mklink.pl ../../test $(TEST)
	@$(PERL) $(TOP)/util/mklink.pl ../../apps $(APPS)

install:
	@[ -n "$(INSTALLTOP)" ] # should be set by top Makefile...
	@headerlist="$(EXHEADER)"; for i in $$headerlist ; \
	do  \
	(cp $$i $(INSTALL_PREFIX)$(INSTALLTOP)/include/openssl/$$i; \
	chmod 644 $(INSTALL_PREFIX)$(INSTALLTOP)/include/openssl/$$i ); \
	done;

tags:
	ctags $(SRC)

tests:

lint:
	lint -DLINT $(INCLUDES) $(SRC)>fluff

depend:
	@[ -n "$(MAKEDEPEND)" ] # should be set by upper Makefile...
	$(MAKEDEPEND) -- $(CFLAG) $(INCLUDES) $(DEPFLAG) -- $(PROGS) $(LIBSRC)

dclean:
	$(PERL) -pe 'if (/^# DO NOT DELETE THIS LINE/) {print; exit(0);}' $(MAKEFILE) >Makefile.new
	mv -f Makefile.new $(MAKEFILE)

clean:
	rm -f *.o *.obj lib tags core .pure .nfs* *.old *.bak fluff

# DO NOT DELETE THIS LINE -- make depend depends on it.

pcy_cache.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
pcy_cache.o: ../../include/openssl/buffer.h ../../include/openssl/conf.h
pcy_cache.o: ../../include/openssl/crypto.h ../../include/openssl/e_os.h
pcy_cache.o: ../../include/openssl/e_os2.h ../../include/openssl/err.h
pcy_cache.o: ../../include/openssl/evp.h ../../include/openssl/fips.h
pcy_cache.o: ../../include/openssl/lhash.h ../../include/openssl/obj_mac.h
pcy_cache.o: ../../include/openssl/objects.h
pcy_cache.o: ../../include/openssl/opensslconf.h
pcy_cache.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
pcy_cache.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
pcy_cache.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
pcy_cache.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
pcy_cache.o: ../../include/openssl/x509_vfy.h ../../include/openssl/x509v3.h
pcy_cache.o: ../cryptlib.h pcy_cache.c pcy_int.h
pcy_data.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
pcy_data.o: ../../include/openssl/buffer.h ../../include/openssl/conf.h
pcy_data.o: ../../include/openssl/crypto.h ../../include/openssl/e_os.h
pcy_data.o: ../../include/openssl/e_os2.h ../../include/openssl/err.h
pcy_data.o: ../../include/openssl/evp.h ../../include/openssl/fips.h
pcy_data.o: ../../include/openssl/lhash.h ../../include/openssl/obj_mac.h
pcy_data.o: ../../include/openssl/objects.h ../../include/openssl/opensslconf.h
pcy_data.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
pcy_data.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
pcy_data.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
pcy_data.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
pcy_data.o: ../../include/openssl/x509_vfy.h ../../include/openssl/x509v3.h
pcy_data.o: ../cryptlib.h pcy_data.c pcy_int.h
pcy_lib.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
pcy_lib.o: ../../include/openssl/buffer.h ../../include/openssl/conf.h
pcy_lib.o: ../../include/openssl/crypto.h ../../include/openssl/e_os.h
pcy_lib.o: ../../include/openssl/e_os2.h ../../include/openssl/err.h
pcy_lib.o: ../../include/openssl/evp.h ../../include/openssl/fips.h
pcy_lib.o: ../../include/openssl/lhash.h ../../include/openssl/obj_mac.h
pcy_lib.o: ../../include/openssl/objects.h ../../include/openssl/opensslconf.h
pcy_lib.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
pcy_lib.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
pcy_lib.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
pcy_lib.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
pcy_lib.o: ../../include/openssl/x509_vfy.h ../../include/openssl/x509v3.h
pcy_lib.o: ../cryptlib.h pcy_int.h pcy_lib.c
pcy_map.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
pcy_map.o: ../../include/openssl/buffer.h ../../include/openssl/conf.h
pcy_map.o: ../../include/openssl/crypto.h ../../include/openssl/e_os.h
pcy_map.o: ../../include/openssl/e_os2.h ../../include/openssl/err.h
pcy_map.o: ../../include/openssl/evp.h ../../include/openssl/fips.h
pcy_map.o: ../../include/openssl/lhash.h ../../include/openssl/obj_mac.h
pcy_map.o: ../../include/openssl/objects.h ../../include/openssl/opensslconf.h
pcy_map.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
pcy_map.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
pcy_map.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
pcy_map.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
pcy_map.o: ../../include/openssl/x509_vfy.h ../../include/openssl/x509v3.h
pcy_map.o: ../cryptlib.h pcy_int.h pcy_map.c
pcy_node.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
pcy_node.o: ../../include/openssl/buffer.h ../../include/openssl/conf.h
pcy_node.o: ../../include/openssl/crypto.h ../../include/openssl/e_os2.h
pcy_node.o: ../../include/openssl/evp.h ../../include/openssl/fips.h
pcy_node.o: ../../include/openssl/lhash.h ../../include/openssl/obj_mac.h
pcy_node.o: ../../include/openssl/objects.h ../../include/openssl/opensslconf.h
pcy_node.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
pcy_node.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
pcy_node.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
pcy_node.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
pcy_node.o: ../../include/openssl/x509_vfy.h ../../include/openssl/x509v3.h
pcy_node.o: pcy_int.h pcy_node.c
pcy_tree.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
pcy_tree.o: ../../include/openssl/buffer.h ../../include/openssl/conf.h
pcy_tree.o: ../../include/openssl/crypto.h ../../include/openssl/e_os.h
pcy_tree.o: ../../include/openssl/e_os2.h ../../include/openssl/err.h
pcy_tree.o: ../../include/openssl/evp.h ../../include/openssl/fips.h
pcy_tree.o: ../../include/openssl/lhash.h ../../include/openssl/obj_mac.h
pcy_tree.o: ../../include/openssl/objects.h ../../include/openssl/opensslconf.h
pcy_tree.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
pcy_tree.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
pcy_tree.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
pcy_tree.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
pcy_tree.o: ../../include/openssl/x509_vfy.h ../../include/openssl/x509v3.h
pcy_tree.o: ../cryptlib.h pcy_int.h pcy_tree.c
v3_addr.o: ../../include/openssl/asn1.h ../../include/openssl/asn1t.h
v3_addr.o: ../../include/openssl/bio.h ../../include/openssl/buffer.h
v3_addr.o: ../../include/openssl/conf.h ../../include/openssl/crypto.h
v3_addr.o: ../../include/openssl/e_os.h ../../include/openssl/e_os2.h
v3_addr.o: ../../include/openssl/err.h ../../include/openssl/evp.h
v3_addr.o: ../../include/openssl/fips.h ../../include/openssl/lhash.h
v3_addr.o: ../../include/openssl/obj_mac.h ../../include/openssl/objects.h
v3_addr.o: ../../include/openssl/opensslconf.h ../../include/openssl/opensslv.h
v3_addr.o: ../../include/openssl/ossl_typ.h ../../include/openssl/pkcs7.h
v3_addr.o: ../../include/openssl/safestack.h ../../include/openssl/sha.h
v3_addr.o: ../../include/openssl/stack.h ../../include/openssl/symhacks.h
v3_addr.o: ../../include/openssl/x509.h ../../include/openssl/x509_vfy.h
v3_addr.o: ../../include/openssl/x509v3.h ../cryptlib.h v3_addr.c
v3_akey.o: ../../include/openssl/asn1.h ../../include/openssl/asn1t.h
v3_akey.o: ../../include/openssl/bio.h ../../include/openssl/buffer.h
v3_akey.o: ../../include/openssl/conf.h ../../include/openssl/crypto.h
v3_akey.o: ../../include/openssl/e_os.h ../../include/openssl/e_os2.h
v3_akey.o: ../../include/openssl/err.h ../../include/openssl/evp.h
v3_akey.o: ../../include/openssl/fips.h ../../include/openssl/lhash.h
v3_akey.o: ../../include/openssl/obj_mac.h ../../include/openssl/objects.h
v3_akey.o: ../../include/openssl/opensslconf.h ../../include/openssl/opensslv.h
v3_akey.o: ../../include/openssl/ossl_typ.h ../../include/openssl/pkcs7.h
v3_akey.o: ../../include/openssl/safestack.h ../../include/openssl/sha.h
v3_akey.o: ../../include/openssl/stack.h ../../include/openssl/symhacks.h
v3_akey.o: ../../include/openssl/x509.h ../../include/openssl/x509_vfy.h
v3_akey.o: ../../include/openssl/x509v3.h ../cryptlib.h v3_akey.c
v3_akeya.o: ../../include/openssl/asn1.h ../../include/openssl/asn1t.h
v3_akeya.o: ../../include/openssl/bio.h ../../include/openssl/buffer.h
v3_akeya.o: ../../include/openssl/conf.h ../../include/openssl/crypto.h
v3_akeya.o: ../../include/openssl/e_os.h ../../include/openssl/e_os2.h
v3_akeya.o: ../../include/openssl/err.h ../../include/openssl/evp.h
v3_akeya.o: ../../include/openssl/fips.h ../../include/openssl/lhash.h
v3_akeya.o: ../../include/openssl/obj_mac.h ../../include/openssl/objects.h
v3_akeya.o: ../../include/openssl/opensslconf.h
v3_akeya.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
v3_akeya.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
v3_akeya.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
v3_akeya.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
v3_akeya.o: ../../include/openssl/x509_vfy.h ../../include/openssl/x509v3.h
v3_akeya.o: ../cryptlib.h v3_akeya.c
v3_alt.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
v3_alt.o: ../../include/openssl/buffer.h ../../include/openssl/conf.h
v3_alt.o: ../../include/openssl/crypto.h ../../include/openssl/e_os.h
v3_alt.o: ../../include/openssl/e_os2.h ../../include/openssl/err.h
v3_alt.o: ../../include/openssl/evp.h ../../include/openssl/fips.h
v3_alt.o: ../../include/openssl/lhash.h ../../include/openssl/obj_mac.h
v3_alt.o: ../../include/openssl/objects.h ../../include/openssl/opensslconf.h
v3_alt.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
v3_alt.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
v3_alt.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
v3_alt.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
v3_alt.o: ../../include/openssl/x509_vfy.h ../../include/openssl/x509v3.h
v3_alt.o: ../cryptlib.h v3_alt.c
v3_asid.o: ../../include/openssl/asn1.h ../../include/openssl/asn1t.h
v3_asid.o: ../../include/openssl/bio.h ../../include/openssl/bn.h
v3_asid.o: ../../include/openssl/buffer.h ../../include/openssl/conf.h
v3_asid.o: ../../include/openssl/crypto.h ../../include/openssl/e_os.h
v3_asid.o: ../../include/openssl/e_os2.h ../../include/openssl/err.h
v3_asid.o: ../../include/openssl/evp.h ../../include/openssl/fips.h
v3_asid.o: ../../include/openssl/lhash.h ../../include/openssl/obj_mac.h
v3_asid.o: ../../include/openssl/objects.h ../../include/openssl/opensslconf.h
v3_asid.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
v3_asid.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
v3_asid.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
v3_asid.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
v3_asid.o: ../../include/openssl/x509_vfy.h ../../include/openssl/x509v3.h
v3_asid.o: ../cryptlib.h v3_asid.c
v3_bcons.o: ../../include/openssl/asn1.h ../../include/openssl/asn1t.h
v3_bcons.o: ../../include/openssl/bio.h ../../include/openssl/buffer.h
v3_bcons.o: ../../include/openssl/conf.h ../../include/openssl/crypto.h
v3_bcons.o: ../../include/openssl/e_os.h ../../include/openssl/e_os2.h
v3_bcons.o: ../../include/openssl/err.h ../../include/openssl/evp.h
v3_bcons.o: ../../include/openssl/fips.h ../../include/openssl/lhash.h
v3_bcons.o: ../../include/openssl/obj_mac.h ../../include/openssl/objects.h
v3_bcons.o: ../../include/openssl/opensslconf.h
v3_bcons.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
v3_bcons.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
v3_bcons.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
v3_bcons.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
v3_bcons.o: ../../include/openssl/x509_vfy.h ../../include/openssl/x509v3.h
v3_bcons.o: ../cryptlib.h v3_bcons.c
v3_bitst.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
v3_bitst.o: ../../include/openssl/buffer.h ../../include/openssl/conf.h
v3_bitst.o: ../../include/openssl/crypto.h ../../include/openssl/e_os.h
v3_bitst.o: ../../include/openssl/e_os2.h ../../include/openssl/err.h
v3_bitst.o: ../../include/openssl/evp.h ../../include/openssl/fips.h
v3_bitst.o: ../../include/openssl/lhash.h ../../include/openssl/obj_mac.h
v3_bitst.o: ../../include/openssl/objects.h ../../include/openssl/opensslconf.h
v3_bitst.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
v3_bitst.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
v3_bitst.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
v3_bitst.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
v3_bitst.o: ../../include/openssl/x509_vfy.h ../../include/openssl/x509v3.h
v3_bitst.o: ../cryptlib.h v3_bitst.c
v3_conf.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
v3_conf.o: ../../include/openssl/buffer.h ../../include/openssl/conf.h
v3_conf.o: ../../include/openssl/crypto.h ../../include/openssl/e_os.h
v3_conf.o: ../../include/openssl/e_os2.h ../../include/openssl/err.h
v3_conf.o: ../../include/openssl/evp.h ../../include/openssl/fips.h
v3_conf.o: ../../include/openssl/lhash.h ../../include/openssl/obj_mac.h
v3_conf.o: ../../include/openssl/objects.h ../../include/openssl/opensslconf.h
v3_conf.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
v3_conf.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
v3_conf.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
v3_conf.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
v3_conf.o: ../../include/openssl/x509_vfy.h ../../include/openssl/x509v3.h
v3_conf.o: ../cryptlib.h v3_conf.c
v3_cpols.o: ../../include/openssl/asn1.h ../../include/openssl/asn1t.h
v3_cpols.o: ../../include/openssl/bio.h ../../include/openssl/buffer.h
v3_cpols.o: ../../include/openssl/conf.h ../../include/openssl/crypto.h
v3_cpols.o: ../../include/openssl/e_os.h ../../include/openssl/e_os2.h
v3_cpols.o: ../../include/openssl/err.h ../../include/openssl/evp.h
v3_cpols.o: ../../include/openssl/fips.h ../../include/openssl/lhash.h
v3_cpols.o: ../../include/openssl/obj_mac.h ../../include/openssl/objects.h
v3_cpols.o: ../../include/openssl/opensslconf.h
v3_cpols.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
v3_cpols.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
v3_cpols.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
v3_cpols.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
v3_cpols.o: ../../include/openssl/x509_vfy.h ../../include/openssl/x509v3.h
v3_cpols.o: ../cryptlib.h pcy_int.h v3_cpols.c
v3_crld.o: ../../include/openssl/asn1.h ../../include/openssl/asn1t.h
v3_crld.o: ../../include/openssl/bio.h ../../include/openssl/buffer.h
v3_crld.o: ../../include/openssl/conf.h ../../include/openssl/crypto.h
v3_crld.o: ../../include/openssl/e_os.h ../../include/openssl/e_os2.h
v3_crld.o: ../../include/openssl/err.h ../../include/openssl/evp.h
v3_crld.o: ../../include/openssl/fips.h ../../include/openssl/lhash.h
v3_crld.o: ../../include/openssl/obj_mac.h ../../include/openssl/objects.h
v3_crld.o: ../../include/openssl/opensslconf.h ../../include/openssl/opensslv.h
v3_crld.o: ../../include/openssl/ossl_typ.h ../../include/openssl/pkcs7.h
v3_crld.o: ../../include/openssl/safestack.h ../../include/openssl/sha.h
v3_crld.o: ../../include/openssl/stack.h ../../include/openssl/symhacks.h
v3_crld.o: ../../include/openssl/x509.h ../../include/openssl/x509_vfy.h
v3_crld.o: ../../include/openssl/x509v3.h ../cryptlib.h v3_crld.c
v3_enum.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
v3_enum.o: ../../include/openssl/buffer.h ../../include/openssl/conf.h
v3_enum.o: ../../include/openssl/crypto.h ../../include/openssl/e_os.h
v3_enum.o: ../../include/openssl/e_os2.h ../../include/openssl/err.h
v3_enum.o: ../../include/openssl/evp.h ../../include/openssl/fips.h
v3_enum.o: ../../include/openssl/lhash.h ../../include/openssl/obj_mac.h
v3_enum.o: ../../include/openssl/objects.h ../../include/openssl/opensslconf.h
v3_enum.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
v3_enum.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
v3_enum.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
v3_enum.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
v3_enum.o: ../../include/openssl/x509_vfy.h ../../include/openssl/x509v3.h
v3_enum.o: ../cryptlib.h v3_enum.c
v3_extku.o: ../../include/openssl/asn1.h ../../include/openssl/asn1t.h
v3_extku.o: ../../include/openssl/bio.h ../../include/openssl/buffer.h
v3_extku.o: ../../include/openssl/conf.h ../../include/openssl/crypto.h
v3_extku.o: ../../include/openssl/e_os.h ../../include/openssl/e_os2.h
v3_extku.o: ../../include/openssl/err.h ../../include/openssl/evp.h
v3_extku.o: ../../include/openssl/fips.h ../../include/openssl/lhash.h
v3_extku.o: ../../include/openssl/obj_mac.h ../../include/openssl/objects.h
v3_extku.o: ../../include/openssl/opensslconf.h
v3_extku.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
v3_extku.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
v3_extku.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
v3_extku.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
v3_extku.o: ../../include/openssl/x509_vfy.h ../../include/openssl/x509v3.h
v3_extku.o: ../cryptlib.h v3_extku.c
v3_genn.o: ../../include/openssl/asn1.h ../../include/openssl/asn1t.h
v3_genn.o: ../../include/openssl/bio.h ../../include/openssl/buffer.h
v3_genn.o: ../../include/openssl/conf.h ../../include/openssl/crypto.h
v3_genn.o: ../../include/openssl/e_os.h ../../include/openssl/e_os2.h
v3_genn.o: ../../include/openssl/err.h ../../include/openssl/evp.h
v3_genn.o: ../../include/openssl/fips.h ../../include/openssl/lhash.h
v3_genn.o: ../../include/openssl/obj_mac.h ../../include/openssl/objects.h
v3_genn.o: ../../include/openssl/opensslconf.h ../../include/openssl/opensslv.h
v3_genn.o: ../../include/openssl/ossl_typ.h ../../include/openssl/pkcs7.h
v3_genn.o: ../../include/openssl/safestack.h ../../include/openssl/sha.h
v3_genn.o: ../../include/openssl/stack.h ../../include/openssl/symhacks.h
v3_genn.o: ../../include/openssl/x509.h ../../include/openssl/x509_vfy.h
v3_genn.o: ../../include/openssl/x509v3.h ../cryptlib.h v3_genn.c
v3_ia5.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
v3_ia5.o: ../../include/openssl/buffer.h ../../include/openssl/conf.h
v3_ia5.o: ../../include/openssl/crypto.h ../../include/openssl/e_os.h
v3_ia5.o: ../../include/openssl/e_os2.h ../../include/openssl/err.h
v3_ia5.o: ../../include/openssl/evp.h ../../include/openssl/fips.h
v3_ia5.o: ../../include/openssl/lhash.h ../../include/openssl/obj_mac.h
v3_ia5.o: ../../include/openssl/objects.h ../../include/openssl/opensslconf.h
v3_ia5.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
v3_ia5.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
v3_ia5.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
v3_ia5.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
v3_ia5.o: ../../include/openssl/x509_vfy.h ../../include/openssl/x509v3.h
v3_ia5.o: ../cryptlib.h v3_ia5.c
v3_info.o: ../../include/openssl/asn1.h ../../include/openssl/asn1t.h
v3_info.o: ../../include/openssl/bio.h ../../include/openssl/buffer.h
v3_info.o: ../../include/openssl/conf.h ../../include/openssl/crypto.h
v3_info.o: ../../include/openssl/e_os.h ../../include/openssl/e_os2.h
v3_info.o: ../../include/openssl/err.h ../../include/openssl/evp.h
v3_info.o: ../../include/openssl/fips.h ../../include/openssl/lhash.h
v3_info.o: ../../include/openssl/obj_mac.h ../../include/openssl/objects.h
v3_info.o: ../../include/openssl/opensslconf.h ../../include/openssl/opensslv.h
v3_info.o: ../../include/openssl/ossl_typ.h ../../include/openssl/pkcs7.h
v3_info.o: ../../include/openssl/safestack.h ../../include/openssl/sha.h
v3_info.o: ../../include/openssl/stack.h ../../include/openssl/symhacks.h
v3_info.o: ../../include/openssl/x509.h ../../include/openssl/x509_vfy.h
v3_info.o: ../../include/openssl/x509v3.h ../cryptlib.h v3_info.c
v3_int.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
v3_int.o: ../../include/openssl/buffer.h ../../include/openssl/conf.h
v3_int.o: ../../include/openssl/crypto.h ../../include/openssl/e_os.h
v3_int.o: ../../include/openssl/e_os2.h ../../include/openssl/err.h
v3_int.o: ../../include/openssl/evp.h ../../include/openssl/fips.h
v3_int.o: ../../include/openssl/lhash.h ../../include/openssl/obj_mac.h
v3_int.o: ../../include/openssl/objects.h ../../include/openssl/opensslconf.h
v3_int.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
v3_int.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
v3_int.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
v3_int.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
v3_int.o: ../../include/openssl/x509_vfy.h ../../include/openssl/x509v3.h
v3_int.o: ../cryptlib.h v3_int.c
v3_lib.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
v3_lib.o: ../../include/openssl/buffer.h ../../include/openssl/conf.h
v3_lib.o: ../../include/openssl/crypto.h ../../include/openssl/e_os.h
v3_lib.o: ../../include/openssl/e_os2.h ../../include/openssl/err.h
v3_lib.o: ../../include/openssl/evp.h ../../include/openssl/fips.h
v3_lib.o: ../../include/openssl/lhash.h ../../include/openssl/obj_mac.h
v3_lib.o: ../../include/openssl/objects.h ../../include/openssl/opensslconf.h
v3_lib.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
v3_lib.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
v3_lib.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
v3_lib.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
v3_lib.o: ../../include/openssl/x509_vfy.h ../../include/openssl/x509v3.h
v3_lib.o: ../cryptlib.h ext_dat.h v3_lib.c
v3_ncons.o: ../../include/openssl/asn1.h ../../include/openssl/asn1t.h
v3_ncons.o: ../../include/openssl/bio.h ../../include/openssl/buffer.h
v3_ncons.o: ../../include/openssl/conf.h ../../include/openssl/crypto.h
v3_ncons.o: ../../include/openssl/e_os.h ../../include/openssl/e_os2.h
v3_ncons.o: ../../include/openssl/err.h ../../include/openssl/evp.h
v3_ncons.o: ../../include/openssl/fips.h ../../include/openssl/lhash.h
v3_ncons.o: ../../include/openssl/obj_mac.h ../../include/openssl/objects.h
v3_ncons.o: ../../include/openssl/opensslconf.h
v3_ncons.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
v3_ncons.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
v3_ncons.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
v3_ncons.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
v3_ncons.o: ../../include/openssl/x509_vfy.h ../../include/openssl/x509v3.h
v3_ncons.o: ../cryptlib.h v3_ncons.c
v3_ocsp.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
v3_ocsp.o: ../../include/openssl/buffer.h ../../include/openssl/conf.h
v3_ocsp.o: ../../include/openssl/crypto.h ../../include/openssl/e_os.h
v3_ocsp.o: ../../include/openssl/e_os2.h ../../include/openssl/err.h
v3_ocsp.o: ../../include/openssl/evp.h ../../include/openssl/fips.h
v3_ocsp.o: ../../include/openssl/lhash.h ../../include/openssl/obj_mac.h
v3_ocsp.o: ../../include/openssl/objects.h ../../include/openssl/ocsp.h
v3_ocsp.o: ../../include/openssl/opensslconf.h ../../include/openssl/opensslv.h
v3_ocsp.o: ../../include/openssl/ossl_typ.h ../../include/openssl/pkcs7.h
v3_ocsp.o: ../../include/openssl/safestack.h ../../include/openssl/sha.h
v3_ocsp.o: ../../include/openssl/stack.h ../../include/openssl/symhacks.h
v3_ocsp.o: ../../include/openssl/x509.h ../../include/openssl/x509_vfy.h
v3_ocsp.o: ../../include/openssl/x509v3.h ../cryptlib.h v3_ocsp.c
v3_pci.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
v3_pci.o: ../../include/openssl/buffer.h ../../include/openssl/conf.h
v3_pci.o: ../../include/openssl/crypto.h ../../include/openssl/e_os.h
v3_pci.o: ../../include/openssl/e_os2.h ../../include/openssl/err.h
v3_pci.o: ../../include/openssl/evp.h ../../include/openssl/fips.h
v3_pci.o: ../../include/openssl/lhash.h ../../include/openssl/obj_mac.h
v3_pci.o: ../../include/openssl/objects.h ../../include/openssl/opensslconf.h
v3_pci.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
v3_pci.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
v3_pci.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
v3_pci.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
v3_pci.o: ../../include/openssl/x509_vfy.h ../../include/openssl/x509v3.h
v3_pci.o: ../cryptlib.h v3_pci.c
v3_pcia.o: ../../include/openssl/asn1.h ../../include/openssl/asn1t.h
v3_pcia.o: ../../include/openssl/bio.h ../../include/openssl/buffer.h
v3_pcia.o: ../../include/openssl/conf.h ../../include/openssl/crypto.h
v3_pcia.o: ../../include/openssl/e_os2.h ../../include/openssl/evp.h
v3_pcia.o: ../../include/openssl/fips.h ../../include/openssl/lhash.h
v3_pcia.o: ../../include/openssl/obj_mac.h ../../include/openssl/objects.h
v3_pcia.o: ../../include/openssl/opensslconf.h ../../include/openssl/opensslv.h
v3_pcia.o: ../../include/openssl/ossl_typ.h ../../include/openssl/pkcs7.h
v3_pcia.o: ../../include/openssl/safestack.h ../../include/openssl/sha.h
v3_pcia.o: ../../include/openssl/stack.h ../../include/openssl/symhacks.h
v3_pcia.o: ../../include/openssl/x509.h ../../include/openssl/x509_vfy.h
v3_pcia.o: ../../include/openssl/x509v3.h v3_pcia.c
v3_pcons.o: ../../include/openssl/asn1.h ../../include/openssl/asn1t.h
v3_pcons.o: ../../include/openssl/bio.h ../../include/openssl/buffer.h
v3_pcons.o: ../../include/openssl/conf.h ../../include/openssl/crypto.h
v3_pcons.o: ../../include/openssl/e_os.h ../../include/openssl/e_os2.h
v3_pcons.o: ../../include/openssl/err.h ../../include/openssl/evp.h
v3_pcons.o: ../../include/openssl/fips.h ../../include/openssl/lhash.h
v3_pcons.o: ../../include/openssl/obj_mac.h ../../include/openssl/objects.h
v3_pcons.o: ../../include/openssl/opensslconf.h
v3_pcons.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
v3_pcons.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
v3_pcons.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
v3_pcons.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
v3_pcons.o: ../../include/openssl/x509_vfy.h ../../include/openssl/x509v3.h
v3_pcons.o: ../cryptlib.h v3_pcons.c
v3_pku.o: ../../include/openssl/asn1.h ../../include/openssl/asn1t.h
v3_pku.o: ../../include/openssl/bio.h ../../include/openssl/buffer.h
v3_pku.o: ../../include/openssl/conf.h ../../include/openssl/crypto.h
v3_pku.o: ../../include/openssl/e_os.h ../../include/openssl/e_os2.h
v3_pku.o: ../../include/openssl/err.h ../../include/openssl/evp.h
v3_pku.o: ../../include/openssl/fips.h ../../include/openssl/lhash.h
v3_pku.o: ../../include/openssl/obj_mac.h ../../include/openssl/objects.h
v3_pku.o: ../../include/openssl/opensslconf.h ../../include/openssl/opensslv.h
v3_pku.o: ../../include/openssl/ossl_typ.h ../../include/openssl/pkcs7.h
v3_pku.o: ../../include/openssl/safestack.h ../../include/openssl/sha.h
v3_pku.o: ../../include/openssl/stack.h ../../include/openssl/symhacks.h
v3_pku.o: ../../include/openssl/x509.h ../../include/openssl/x509_vfy.h
v3_pku.o: ../../include/openssl/x509v3.h ../cryptlib.h v3_pku.c
v3_pmaps.o: ../../include/openssl/asn1.h ../../include/openssl/asn1t.h
v3_pmaps.o: ../../include/openssl/bio.h ../../include/openssl/buffer.h
v3_pmaps.o: ../../include/openssl/conf.h ../../include/openssl/crypto.h
v3_pmaps.o: ../../include/openssl/e_os.h ../../include/openssl/e_os2.h
v3_pmaps.o: ../../include/openssl/err.h ../../include/openssl/evp.h
v3_pmaps.o: ../../include/openssl/fips.h ../../include/openssl/lhash.h
v3_pmaps.o: ../../include/openssl/obj_mac.h ../../include/openssl/objects.h
v3_pmaps.o: ../../include/openssl/opensslconf.h
v3_pmaps.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
v3_pmaps.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
v3_pmaps.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
v3_pmaps.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
v3_pmaps.o: ../../include/openssl/x509_vfy.h ../../include/openssl/x509v3.h
v3_pmaps.o: ../cryptlib.h v3_pmaps.c
v3_prn.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
v3_prn.o: ../../include/openssl/buffer.h ../../include/openssl/conf.h
v3_prn.o: ../../include/openssl/crypto.h ../../include/openssl/e_os.h
v3_prn.o: ../../include/openssl/e_os2.h ../../include/openssl/err.h
v3_prn.o: ../../include/openssl/evp.h ../../include/openssl/fips.h
v3_prn.o: ../../include/openssl/lhash.h ../../include/openssl/obj_mac.h
v3_prn.o: ../../include/openssl/objects.h ../../include/openssl/opensslconf.h
v3_prn.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
v3_prn.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
v3_prn.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
v3_prn.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
v3_prn.o: ../../include/openssl/x509_vfy.h ../../include/openssl/x509v3.h
v3_prn.o: ../cryptlib.h v3_prn.c
v3_purp.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
v3_purp.o: ../../include/openssl/buffer.h ../../include/openssl/conf.h
v3_purp.o: ../../include/openssl/crypto.h ../../include/openssl/e_os.h
v3_purp.o: ../../include/openssl/e_os2.h ../../include/openssl/err.h
v3_purp.o: ../../include/openssl/evp.h ../../include/openssl/fips.h
v3_purp.o: ../../include/openssl/lhash.h ../../include/openssl/obj_mac.h
v3_purp.o: ../../include/openssl/objects.h ../../include/openssl/opensslconf.h
v3_purp.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
v3_purp.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
v3_purp.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
v3_purp.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
v3_purp.o: ../../include/openssl/x509_vfy.h ../../include/openssl/x509v3.h
v3_purp.o: ../cryptlib.h v3_purp.c
v3_skey.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
v3_skey.o: ../../include/openssl/buffer.h ../../include/openssl/conf.h
v3_skey.o: ../../include/openssl/crypto.h ../../include/openssl/e_os.h
v3_skey.o: ../../include/openssl/e_os2.h ../../include/openssl/err.h
v3_skey.o: ../../include/openssl/evp.h ../../include/openssl/fips.h
v3_skey.o: ../../include/openssl/lhash.h ../../include/openssl/obj_mac.h
v3_skey.o: ../../include/openssl/objects.h ../../include/openssl/opensslconf.h
v3_skey.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
v3_skey.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
v3_skey.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
v3_skey.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
v3_skey.o: ../../include/openssl/x509_vfy.h ../../include/openssl/x509v3.h
v3_skey.o: ../cryptlib.h v3_skey.c
v3_sxnet.o: ../../include/openssl/asn1.h ../../include/openssl/asn1t.h
v3_sxnet.o: ../../include/openssl/bio.h ../../include/openssl/buffer.h
v3_sxnet.o: ../../include/openssl/conf.h ../../include/openssl/crypto.h
v3_sxnet.o: ../../include/openssl/e_os.h ../../include/openssl/e_os2.h
v3_sxnet.o: ../../include/openssl/err.h ../../include/openssl/evp.h
v3_sxnet.o: ../../include/openssl/fips.h ../../include/openssl/lhash.h
v3_sxnet.o: ../../include/openssl/obj_mac.h ../../include/openssl/objects.h
v3_sxnet.o: ../../include/openssl/opensslconf.h
v3_sxnet.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
v3_sxnet.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
v3_sxnet.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
v3_sxnet.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
v3_sxnet.o: ../../include/openssl/x509_vfy.h ../../include/openssl/x509v3.h
v3_sxnet.o: ../cryptlib.h v3_sxnet.c
v3_utl.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
v3_utl.o: ../../include/openssl/bn.h ../../include/openssl/buffer.h
v3_utl.o: ../../include/openssl/conf.h ../../include/openssl/crypto.h
v3_utl.o: ../../include/openssl/e_os.h ../../include/openssl/e_os2.h
v3_utl.o: ../../include/openssl/err.h ../../include/openssl/evp.h
v3_utl.o: ../../include/openssl/fips.h ../../include/openssl/lhash.h
v3_utl.o: ../../include/openssl/obj_mac.h ../../include/openssl/objects.h
v3_utl.o: ../../include/openssl/opensslconf.h ../../include/openssl/opensslv.h
v3_utl.o: ../../include/openssl/ossl_typ.h ../../include/openssl/pkcs7.h
v3_utl.o: ../../include/openssl/safestack.h ../../include/openssl/sha.h
v3_utl.o: ../../include/openssl/stack.h ../../include/openssl/symhacks.h
v3_utl.o: ../../include/openssl/x509.h ../../include/openssl/x509_vfy.h
v3_utl.o: ../../include/openssl/x509v3.h ../cryptlib.h v3_utl.c
v3err.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
v3err.o: ../../include/openssl/buffer.h ../../include/openssl/conf.h
v3err.o: ../../include/openssl/crypto.h ../../include/openssl/e_os2.h
v3err.o: ../../include/openssl/err.h ../../include/openssl/evp.h
v3err.o: ../../include/openssl/fips.h ../../include/openssl/lhash.h
v3err.o: ../../include/openssl/obj_mac.h ../../include/openssl/objects.h
v3err.o: ../../include/openssl/opensslconf.h ../../include/openssl/opensslv.h
v3err.o: ../../include/openssl/ossl_typ.h ../../include/openssl/pkcs7.h
v3err.o: ../../include/openssl/safestack.h ../../include/openssl/sha.h
v3err.o: ../../include/openssl/stack.h ../../include/openssl/symhacks.h
v3err.o: ../../include/openssl/x509.h ../../include/openssl/x509_vfy.h
v3err.o: ../../include/openssl/x509v3.h v3err.c
