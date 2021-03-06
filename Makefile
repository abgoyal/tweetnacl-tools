# cross-compile example:
# CC=arm-linux-gnueabi-gcc make
# compile for 32-bit x86 on 64-bit host
# CFLAGS=-m32

CC?=gcc
CFLAGS+=-O3 -std=c99 -D_POSIX_C_SOURCE=1
TWEETNACLC=randombytes.c tools.c tweetnacl.c
TWEETNACL=$(TWEETNACLC) randombytes.h tools.h tweetnacl.h

all: tweetnacl-decrypt tweetnacl-encrypt tweetnacl-keypair \
     tweetnacl-sigpair tweetnacl-sign tweetnacl-verify

bin: ;
	mkdir bin

clean: ;
	rm -rf bin

tweetnacl-decrypt: bin $(TWEETNACL) tweetnacl-decrypt.c
	$(CC) $(CFLAGS) $(TWEETNACLC) tweetnacl-decrypt.c \
		-o bin/tweetnacl-decrypt

tweetnacl-encrypt: bin $(TWEETNACL) tweetnacl-encrypt.c
	$(CC) $(CFLAGS) $(TWEETNACLC) tweetnacl-encrypt.c \
		-o bin/tweetnacl-encrypt

tweetnacl-keypair: bin $(TWEETNACL) tweetnacl-keypair.c
	$(CC) $(CFLAGS) $(TWEETNACLC) tweetnacl-keypair.c \
		-o bin/tweetnacl-keypair

tweetnacl-sigpair: bin $(TWEETNACL) tweetnacl-sigpair.c
	$(CC) $(CFLAGS) $(TWEETNACLC) tweetnacl-sigpair.c \
		-o bin/tweetnacl-sigpair

tweetnacl-sign: bin $(TWEETNACL) tweetnacl-sign.c
	$(CC) $(CFLAGS) $(TWEETNACLC) tweetnacl-sign.c \
		-o bin/tweetnacl-sign

tweetnacl-verify: bin $(TWEETNACL) tweetnacl-verify.c
	$(CC) $(CFLAGS) $(TWEETNACLC) tweetnacl-verify.c \
		-o bin/tweetnacl-verify

test: ;
	mkdir tmp
	bin/tweetnacl-keypair tmp/a.pub tmp/a.sec
	bin/tweetnacl-keypair tmp/b.pub tmp/b.sec
	echo 'Secret message!' > tmp/msg01
	bin/tweetnacl-encrypt tmp/a.sec tmp/b.pub tmp/msg01 tmp/encrypted
	bin/tweetnacl-decrypt tmp/a.pub tmp/b.sec tmp/encrypted -
	bin/tweetnacl-sigpair tmp/s.pub tmp/s.sec
	echo 'Verified message!' > tmp/msg02
	bin/tweetnacl-sign tmp/s.sec tmp/msg02 tmp/signed
	bin/tweetnacl-verify tmp/s.pub tmp/signed -
	rm -rf tmp
