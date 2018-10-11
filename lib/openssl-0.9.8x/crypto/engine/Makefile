#
# OpenSSL/crypto/engine/Makefile
#

DIR=	engine
TOP=	../..
CC=	cc
INCLUDES= -I.. -I$(TOP) -I../../../../include
CFLAG=-g
MAKEFILE=	Makefile
AR=		ar r

CFLAGS= $(INCLUDES) $(CFLAG)

GENERAL=Makefile
TEST= enginetest.c
APPS=

LIB=$(TOP)/libcrypto.a
LIBSRC= eng_err.c eng_lib.c eng_list.c eng_init.c eng_ctrl.c \
	eng_table.c eng_pkey.c eng_fat.c eng_all.c \
	tb_rsa.c tb_dsa.c tb_ecdsa.c tb_dh.c tb_ecdh.c tb_rand.c tb_store.c \
	tb_cipher.c tb_digest.c \
	eng_openssl.c eng_cnf.c eng_dyn.c eng_cryptodev.c eng_padlock.c
LIBOBJ= eng_err.o eng_lib.o eng_list.o eng_init.o eng_ctrl.o \
	eng_table.o eng_pkey.o eng_fat.o eng_all.o \
	tb_rsa.o tb_dsa.o tb_ecdsa.o tb_dh.o tb_ecdh.o tb_rand.o tb_store.o \
	tb_cipher.o tb_digest.o \
	eng_openssl.o eng_cnf.o eng_dyn.o eng_cryptodev.o eng_padlock.o

SRC= $(LIBSRC)

EXHEADER= engine.h
HEADER=	$(EXHEADER)

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
	rm -f *.o */*.o *.obj lib tags core .pure .nfs* *.old *.bak fluff

# DO NOT DELETE THIS LINE -- make depend depends on it.

eng_all.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
eng_all.o: ../../include/openssl/buffer.h ../../include/openssl/crypto.h
eng_all.o: ../../include/openssl/e_os.h ../../include/openssl/e_os2.h
eng_all.o: ../../include/openssl/engine.h ../../include/openssl/err.h
eng_all.o: ../../include/openssl/evp.h ../../include/openssl/fips.h
eng_all.o: ../../include/openssl/lhash.h ../../include/openssl/obj_mac.h
eng_all.o: ../../include/openssl/objects.h ../../include/openssl/opensslconf.h
eng_all.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
eng_all.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
eng_all.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
eng_all.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
eng_all.o: ../../include/openssl/x509_vfy.h ../cryptlib.h eng_all.c eng_int.h
eng_cnf.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
eng_cnf.o: ../../include/openssl/buffer.h ../../include/openssl/conf.h
eng_cnf.o: ../../include/openssl/crypto.h ../../include/openssl/e_os.h
eng_cnf.o: ../../include/openssl/e_os2.h ../../include/openssl/engine.h
eng_cnf.o: ../../include/openssl/err.h ../../include/openssl/evp.h
eng_cnf.o: ../../include/openssl/fips.h ../../include/openssl/lhash.h
eng_cnf.o: ../../include/openssl/obj_mac.h ../../include/openssl/objects.h
eng_cnf.o: ../../include/openssl/opensslconf.h ../../include/openssl/opensslv.h
eng_cnf.o: ../../include/openssl/ossl_typ.h ../../include/openssl/pkcs7.h
eng_cnf.o: ../../include/openssl/safestack.h ../../include/openssl/sha.h
eng_cnf.o: ../../include/openssl/stack.h ../../include/openssl/symhacks.h
eng_cnf.o: ../../include/openssl/x509.h ../../include/openssl/x509_vfy.h
eng_cnf.o: ../cryptlib.h eng_cnf.c eng_int.h
eng_cryptodev.o: ../../../../include/crypto/cryptodev.h
eng_cryptodev.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
eng_cryptodev.o: ../../include/openssl/bn.h ../../include/openssl/buffer.h
eng_cryptodev.o: ../../include/openssl/crypto.h ../../include/openssl/dh.h
eng_cryptodev.o: ../../include/openssl/dsa.h ../../include/openssl/e_os2.h
eng_cryptodev.o: ../../include/openssl/engine.h ../../include/openssl/err.h
eng_cryptodev.o: ../../include/openssl/evp.h ../../include/openssl/fips.h
eng_cryptodev.o: ../../include/openssl/lhash.h ../../include/openssl/obj_mac.h
eng_cryptodev.o: ../../include/openssl/objects.h
eng_cryptodev.o: ../../include/openssl/opensslconf.h
eng_cryptodev.o: ../../include/openssl/opensslv.h
eng_cryptodev.o: ../../include/openssl/ossl_typ.h ../../include/openssl/pkcs7.h
eng_cryptodev.o: ../../include/openssl/rsa.h ../../include/openssl/safestack.h
eng_cryptodev.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
eng_cryptodev.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
eng_cryptodev.o: ../../include/openssl/x509_vfy.h eng_cryptodev.c
eng_ctrl.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
eng_ctrl.o: ../../include/openssl/buffer.h ../../include/openssl/crypto.h
eng_ctrl.o: ../../include/openssl/e_os.h ../../include/openssl/e_os2.h
eng_ctrl.o: ../../include/openssl/engine.h ../../include/openssl/err.h
eng_ctrl.o: ../../include/openssl/evp.h ../../include/openssl/fips.h
eng_ctrl.o: ../../include/openssl/lhash.h ../../include/openssl/obj_mac.h
eng_ctrl.o: ../../include/openssl/objects.h ../../include/openssl/opensslconf.h
eng_ctrl.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
eng_ctrl.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
eng_ctrl.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
eng_ctrl.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
eng_ctrl.o: ../../include/openssl/x509_vfy.h ../cryptlib.h eng_ctrl.c eng_int.h
eng_dyn.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
eng_dyn.o: ../../include/openssl/buffer.h ../../include/openssl/crypto.h
eng_dyn.o: ../../include/openssl/dso.h ../../include/openssl/e_os.h
eng_dyn.o: ../../include/openssl/e_os2.h ../../include/openssl/engine.h
eng_dyn.o: ../../include/openssl/err.h ../../include/openssl/evp.h
eng_dyn.o: ../../include/openssl/fips.h ../../include/openssl/lhash.h
eng_dyn.o: ../../include/openssl/obj_mac.h ../../include/openssl/objects.h
eng_dyn.o: ../../include/openssl/opensslconf.h ../../include/openssl/opensslv.h
eng_dyn.o: ../../include/openssl/ossl_typ.h ../../include/openssl/pkcs7.h
eng_dyn.o: ../../include/openssl/safestack.h ../../include/openssl/sha.h
eng_dyn.o: ../../include/openssl/stack.h ../../include/openssl/symhacks.h
eng_dyn.o: ../../include/openssl/x509.h ../../include/openssl/x509_vfy.h
eng_dyn.o: ../cryptlib.h eng_dyn.c eng_int.h
eng_err.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
eng_err.o: ../../include/openssl/buffer.h ../../include/openssl/crypto.h
eng_err.o: ../../include/openssl/e_os2.h ../../include/openssl/engine.h
eng_err.o: ../../include/openssl/err.h ../../include/openssl/evp.h
eng_err.o: ../../include/openssl/fips.h ../../include/openssl/lhash.h
eng_err.o: ../../include/openssl/obj_mac.h ../../include/openssl/objects.h
eng_err.o: ../../include/openssl/opensslconf.h ../../include/openssl/opensslv.h
eng_err.o: ../../include/openssl/ossl_typ.h ../../include/openssl/pkcs7.h
eng_err.o: ../../include/openssl/safestack.h ../../include/openssl/sha.h
eng_err.o: ../../include/openssl/stack.h ../../include/openssl/symhacks.h
eng_err.o: ../../include/openssl/x509.h ../../include/openssl/x509_vfy.h
eng_err.o: eng_err.c
eng_fat.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
eng_fat.o: ../../include/openssl/buffer.h ../../include/openssl/conf.h
eng_fat.o: ../../include/openssl/crypto.h ../../include/openssl/e_os.h
eng_fat.o: ../../include/openssl/e_os2.h ../../include/openssl/engine.h
eng_fat.o: ../../include/openssl/err.h ../../include/openssl/evp.h
eng_fat.o: ../../include/openssl/fips.h ../../include/openssl/lhash.h
eng_fat.o: ../../include/openssl/obj_mac.h ../../include/openssl/objects.h
eng_fat.o: ../../include/openssl/opensslconf.h ../../include/openssl/opensslv.h
eng_fat.o: ../../include/openssl/ossl_typ.h ../../include/openssl/pkcs7.h
eng_fat.o: ../../include/openssl/safestack.h ../../include/openssl/sha.h
eng_fat.o: ../../include/openssl/stack.h ../../include/openssl/symhacks.h
eng_fat.o: ../../include/openssl/x509.h ../../include/openssl/x509_vfy.h
eng_fat.o: ../cryptlib.h eng_fat.c eng_int.h
eng_init.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
eng_init.o: ../../include/openssl/buffer.h ../../include/openssl/crypto.h
eng_init.o: ../../include/openssl/e_os.h ../../include/openssl/e_os2.h
eng_init.o: ../../include/openssl/engine.h ../../include/openssl/err.h
eng_init.o: ../../include/openssl/evp.h ../../include/openssl/fips.h
eng_init.o: ../../include/openssl/lhash.h ../../include/openssl/obj_mac.h
eng_init.o: ../../include/openssl/objects.h ../../include/openssl/opensslconf.h
eng_init.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
eng_init.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
eng_init.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
eng_init.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
eng_init.o: ../../include/openssl/x509_vfy.h ../cryptlib.h eng_init.c eng_int.h
eng_lib.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
eng_lib.o: ../../include/openssl/buffer.h ../../include/openssl/crypto.h
eng_lib.o: ../../include/openssl/e_os.h ../../include/openssl/e_os2.h
eng_lib.o: ../../include/openssl/engine.h ../../include/openssl/err.h
eng_lib.o: ../../include/openssl/evp.h ../../include/openssl/fips.h
eng_lib.o: ../../include/openssl/lhash.h ../../include/openssl/obj_mac.h
eng_lib.o: ../../include/openssl/objects.h ../../include/openssl/opensslconf.h
eng_lib.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
eng_lib.o: ../../include/openssl/pkcs7.h ../../include/openssl/rand.h
eng_lib.o: ../../include/openssl/safestack.h ../../include/openssl/sha.h
eng_lib.o: ../../include/openssl/stack.h ../../include/openssl/symhacks.h
eng_lib.o: ../../include/openssl/x509.h ../../include/openssl/x509_vfy.h
eng_lib.o: ../cryptlib.h eng_int.h eng_lib.c
eng_list.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
eng_list.o: ../../include/openssl/buffer.h ../../include/openssl/crypto.h
eng_list.o: ../../include/openssl/e_os.h ../../include/openssl/e_os2.h
eng_list.o: ../../include/openssl/engine.h ../../include/openssl/err.h
eng_list.o: ../../include/openssl/evp.h ../../include/openssl/fips.h
eng_list.o: ../../include/openssl/lhash.h ../../include/openssl/obj_mac.h
eng_list.o: ../../include/openssl/objects.h ../../include/openssl/opensslconf.h
eng_list.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
eng_list.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
eng_list.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
eng_list.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
eng_list.o: ../../include/openssl/x509_vfy.h ../cryptlib.h eng_int.h eng_list.c
eng_openssl.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
eng_openssl.o: ../../include/openssl/buffer.h ../../include/openssl/crypto.h
eng_openssl.o: ../../include/openssl/dh.h ../../include/openssl/dsa.h
eng_openssl.o: ../../include/openssl/dso.h ../../include/openssl/e_os.h
eng_openssl.o: ../../include/openssl/e_os2.h ../../include/openssl/engine.h
eng_openssl.o: ../../include/openssl/err.h ../../include/openssl/evp.h
eng_openssl.o: ../../include/openssl/fips.h ../../include/openssl/lhash.h
eng_openssl.o: ../../include/openssl/obj_mac.h ../../include/openssl/objects.h
eng_openssl.o: ../../include/openssl/opensslconf.h
eng_openssl.o: ../../include/openssl/opensslv.h
eng_openssl.o: ../../include/openssl/ossl_typ.h ../../include/openssl/pem.h
eng_openssl.o: ../../include/openssl/pem2.h ../../include/openssl/pkcs7.h
eng_openssl.o: ../../include/openssl/rand.h ../../include/openssl/rc4.h
eng_openssl.o: ../../include/openssl/rsa.h ../../include/openssl/safestack.h
eng_openssl.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
eng_openssl.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
eng_openssl.o: ../../include/openssl/x509_vfy.h ../cryptlib.h eng_openssl.c
eng_padlock.o: ../../include/openssl/aes.h ../../include/openssl/asn1.h
eng_padlock.o: ../../include/openssl/bio.h ../../include/openssl/buffer.h
eng_padlock.o: ../../include/openssl/crypto.h ../../include/openssl/dso.h
eng_padlock.o: ../../include/openssl/e_os2.h ../../include/openssl/engine.h
eng_padlock.o: ../../include/openssl/err.h ../../include/openssl/evp.h
eng_padlock.o: ../../include/openssl/fips.h ../../include/openssl/lhash.h
eng_padlock.o: ../../include/openssl/obj_mac.h ../../include/openssl/objects.h
eng_padlock.o: ../../include/openssl/opensslconf.h
eng_padlock.o: ../../include/openssl/opensslv.h
eng_padlock.o: ../../include/openssl/ossl_typ.h ../../include/openssl/pkcs7.h
eng_padlock.o: ../../include/openssl/rand.h ../../include/openssl/safestack.h
eng_padlock.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
eng_padlock.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
eng_padlock.o: ../../include/openssl/x509_vfy.h eng_padlock.c
eng_pkey.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
eng_pkey.o: ../../include/openssl/buffer.h ../../include/openssl/crypto.h
eng_pkey.o: ../../include/openssl/e_os.h ../../include/openssl/e_os2.h
eng_pkey.o: ../../include/openssl/engine.h ../../include/openssl/err.h
eng_pkey.o: ../../include/openssl/evp.h ../../include/openssl/fips.h
eng_pkey.o: ../../include/openssl/lhash.h ../../include/openssl/obj_mac.h
eng_pkey.o: ../../include/openssl/objects.h ../../include/openssl/opensslconf.h
eng_pkey.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
eng_pkey.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
eng_pkey.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
eng_pkey.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
eng_pkey.o: ../../include/openssl/x509_vfy.h ../cryptlib.h eng_int.h eng_pkey.c
eng_table.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
eng_table.o: ../../include/openssl/buffer.h ../../include/openssl/crypto.h
eng_table.o: ../../include/openssl/e_os.h ../../include/openssl/e_os2.h
eng_table.o: ../../include/openssl/engine.h ../../include/openssl/err.h
eng_table.o: ../../include/openssl/evp.h ../../include/openssl/fips.h
eng_table.o: ../../include/openssl/lhash.h ../../include/openssl/obj_mac.h
eng_table.o: ../../include/openssl/objects.h
eng_table.o: ../../include/openssl/opensslconf.h
eng_table.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
eng_table.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
eng_table.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
eng_table.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
eng_table.o: ../../include/openssl/x509_vfy.h ../cryptlib.h eng_int.h
eng_table.o: eng_table.c
tb_cipher.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
tb_cipher.o: ../../include/openssl/buffer.h ../../include/openssl/crypto.h
tb_cipher.o: ../../include/openssl/e_os.h ../../include/openssl/e_os2.h
tb_cipher.o: ../../include/openssl/engine.h ../../include/openssl/err.h
tb_cipher.o: ../../include/openssl/evp.h ../../include/openssl/fips.h
tb_cipher.o: ../../include/openssl/lhash.h ../../include/openssl/obj_mac.h
tb_cipher.o: ../../include/openssl/objects.h
tb_cipher.o: ../../include/openssl/opensslconf.h
tb_cipher.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
tb_cipher.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
tb_cipher.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
tb_cipher.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
tb_cipher.o: ../../include/openssl/x509_vfy.h ../cryptlib.h eng_int.h
tb_cipher.o: tb_cipher.c
tb_dh.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
tb_dh.o: ../../include/openssl/buffer.h ../../include/openssl/crypto.h
tb_dh.o: ../../include/openssl/e_os.h ../../include/openssl/e_os2.h
tb_dh.o: ../../include/openssl/engine.h ../../include/openssl/err.h
tb_dh.o: ../../include/openssl/evp.h ../../include/openssl/fips.h
tb_dh.o: ../../include/openssl/lhash.h ../../include/openssl/obj_mac.h
tb_dh.o: ../../include/openssl/objects.h ../../include/openssl/opensslconf.h
tb_dh.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
tb_dh.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
tb_dh.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
tb_dh.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
tb_dh.o: ../../include/openssl/x509_vfy.h ../cryptlib.h eng_int.h tb_dh.c
tb_digest.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
tb_digest.o: ../../include/openssl/buffer.h ../../include/openssl/crypto.h
tb_digest.o: ../../include/openssl/e_os.h ../../include/openssl/e_os2.h
tb_digest.o: ../../include/openssl/engine.h ../../include/openssl/err.h
tb_digest.o: ../../include/openssl/evp.h ../../include/openssl/fips.h
tb_digest.o: ../../include/openssl/lhash.h ../../include/openssl/obj_mac.h
tb_digest.o: ../../include/openssl/objects.h
tb_digest.o: ../../include/openssl/opensslconf.h
tb_digest.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
tb_digest.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
tb_digest.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
tb_digest.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
tb_digest.o: ../../include/openssl/x509_vfy.h ../cryptlib.h eng_int.h
tb_digest.o: tb_digest.c
tb_dsa.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
tb_dsa.o: ../../include/openssl/buffer.h ../../include/openssl/crypto.h
tb_dsa.o: ../../include/openssl/e_os.h ../../include/openssl/e_os2.h
tb_dsa.o: ../../include/openssl/engine.h ../../include/openssl/err.h
tb_dsa.o: ../../include/openssl/evp.h ../../include/openssl/fips.h
tb_dsa.o: ../../include/openssl/lhash.h ../../include/openssl/obj_mac.h
tb_dsa.o: ../../include/openssl/objects.h ../../include/openssl/opensslconf.h
tb_dsa.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
tb_dsa.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
tb_dsa.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
tb_dsa.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
tb_dsa.o: ../../include/openssl/x509_vfy.h ../cryptlib.h eng_int.h tb_dsa.c
tb_ecdh.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
tb_ecdh.o: ../../include/openssl/buffer.h ../../include/openssl/crypto.h
tb_ecdh.o: ../../include/openssl/e_os.h ../../include/openssl/e_os2.h
tb_ecdh.o: ../../include/openssl/engine.h ../../include/openssl/err.h
tb_ecdh.o: ../../include/openssl/evp.h ../../include/openssl/fips.h
tb_ecdh.o: ../../include/openssl/lhash.h ../../include/openssl/obj_mac.h
tb_ecdh.o: ../../include/openssl/objects.h ../../include/openssl/opensslconf.h
tb_ecdh.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
tb_ecdh.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
tb_ecdh.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
tb_ecdh.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
tb_ecdh.o: ../../include/openssl/x509_vfy.h ../cryptlib.h eng_int.h tb_ecdh.c
tb_ecdsa.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
tb_ecdsa.o: ../../include/openssl/buffer.h ../../include/openssl/crypto.h
tb_ecdsa.o: ../../include/openssl/e_os.h ../../include/openssl/e_os2.h
tb_ecdsa.o: ../../include/openssl/engine.h ../../include/openssl/err.h
tb_ecdsa.o: ../../include/openssl/evp.h ../../include/openssl/fips.h
tb_ecdsa.o: ../../include/openssl/lhash.h ../../include/openssl/obj_mac.h
tb_ecdsa.o: ../../include/openssl/objects.h ../../include/openssl/opensslconf.h
tb_ecdsa.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
tb_ecdsa.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
tb_ecdsa.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
tb_ecdsa.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
tb_ecdsa.o: ../../include/openssl/x509_vfy.h ../cryptlib.h eng_int.h tb_ecdsa.c
tb_rand.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
tb_rand.o: ../../include/openssl/buffer.h ../../include/openssl/crypto.h
tb_rand.o: ../../include/openssl/e_os.h ../../include/openssl/e_os2.h
tb_rand.o: ../../include/openssl/engine.h ../../include/openssl/err.h
tb_rand.o: ../../include/openssl/evp.h ../../include/openssl/fips.h
tb_rand.o: ../../include/openssl/lhash.h ../../include/openssl/obj_mac.h
tb_rand.o: ../../include/openssl/objects.h ../../include/openssl/opensslconf.h
tb_rand.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
tb_rand.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
tb_rand.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
tb_rand.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
tb_rand.o: ../../include/openssl/x509_vfy.h ../cryptlib.h eng_int.h tb_rand.c
tb_rsa.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
tb_rsa.o: ../../include/openssl/buffer.h ../../include/openssl/crypto.h
tb_rsa.o: ../../include/openssl/e_os.h ../../include/openssl/e_os2.h
tb_rsa.o: ../../include/openssl/engine.h ../../include/openssl/err.h
tb_rsa.o: ../../include/openssl/evp.h ../../include/openssl/fips.h
tb_rsa.o: ../../include/openssl/lhash.h ../../include/openssl/obj_mac.h
tb_rsa.o: ../../include/openssl/objects.h ../../include/openssl/opensslconf.h
tb_rsa.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
tb_rsa.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
tb_rsa.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
tb_rsa.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
tb_rsa.o: ../../include/openssl/x509_vfy.h ../cryptlib.h eng_int.h tb_rsa.c
tb_store.o: ../../include/openssl/asn1.h ../../include/openssl/bio.h
tb_store.o: ../../include/openssl/buffer.h ../../include/openssl/crypto.h
tb_store.o: ../../include/openssl/e_os.h ../../include/openssl/e_os2.h
tb_store.o: ../../include/openssl/engine.h ../../include/openssl/err.h
tb_store.o: ../../include/openssl/evp.h ../../include/openssl/fips.h
tb_store.o: ../../include/openssl/lhash.h ../../include/openssl/obj_mac.h
tb_store.o: ../../include/openssl/objects.h ../../include/openssl/opensslconf.h
tb_store.o: ../../include/openssl/opensslv.h ../../include/openssl/ossl_typ.h
tb_store.o: ../../include/openssl/pkcs7.h ../../include/openssl/safestack.h
tb_store.o: ../../include/openssl/sha.h ../../include/openssl/stack.h
tb_store.o: ../../include/openssl/symhacks.h ../../include/openssl/x509.h
tb_store.o: ../../include/openssl/x509_vfy.h ../cryptlib.h eng_int.h tb_store.c
