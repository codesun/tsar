DIRS = src modules lualib

DSTDIR = /
PREFIX = usr/local

all:
	for i in $(DIRS); do make -C $$i; done

clean:
	for i in $(DIRS); do cd $$i;make clean;cd ..; done

install: all
	install -d /usr/local/tsar/modules /usr/local/bin \
		/etc/tsar /etc/logrotate.d/tsar /etc/cron.d/tsar
	install modules/*.so /usr/local/tsar/modules
	install src/tsar /usr/local/bin
	install conf/tsar.conf /etc/tsar/tsar.conf
	install conf/tsar.logrotate /etc/logrotate.d/tsar
	install conf/tsar.cron /etc/cron.d/tsar
	install conf/tsar.8 /usr/local/man/man8/
	make -C lualib install

uninstall:
	#rm tsar
	rm -rf /usr/local/tsar
	rm -rf /etc/tsar/cron.d
	rm -f /etc/logrotate.d/tsar
	rm -f /etc/cron.d/tsar
	rm -f /usr/local/man/man8/tsar.8
	#rm tsar
	rm -f /usr/bin/tsar
	#rm tsardevel
	rm -f /usr/bin/tsardevel
	#rm tsarluadevel
	rm -f /usr/bin/tsarluadevel
	#backup configure file
	if [ -f /etc/tsar/tsar.conf ]; then mv /etc/tsar/tsar.conf /etc/tsar/tsar.conf.rpmsave; fi
	#backup the log data file
	if [ -f /var/log/tsar.data ]; then mv /var/log/tsar.data /var/log/tsar.data.bak; fi

tsardevel:
	mkdir -p $(DESTDIR)/usr/local/tsar/devel
	cp devel/mod_test.c $(DESTDIR)/usr/local/tsar/devel/mod_test.c
	cp devel/mod_test.conf $(DESTDIR)/usr/local/tsar/devel/mod_test.conf
	cp devel/tsar.h $(DESTDIR)/usr/local/tsar/devel/tsar.h
	cp devel/Makefile.test $(DESTDIR)/usr/local/tsar/devel/Makefile.test
	cp devel/tsardevel $(DESTDIR)/usr/bin/tsardevel

tsarluadevel:
	mkdir -p $(DESTDIR)/usr/local/tsar/luadevel
	cp luadevel/mod_lua_test.lua $(DESTDIR)/usr/local/tsar/luadevel/mod_lua_test.lua
	cp luadevel/mod_lua_test.conf $(DESTDIR)/usr/local/tsar/luadevel/mod_lua_test.conf
	cp luadevel/Makefile.test $(DESTDIR)/usr/local/tsar/luadevel/Makefile.test
	cp luadevel/tsarluadevel $(DESTDIR)/usr/bin/tsarluadevel

DSTDIR = deb
deb-pkg:
	install -d ${DSTDIR}/${PREFIX}/tsar/modules ${DSTDIR}/etc/tsar \
	       	${DSTDIR}/${PREFIX}/bin ${DSTDIR}/${PREFIX}/man/man8 \
	       	${DSTDIR}/etc/cron.d/tsar ${DSTDIR}/etc/logrotate.d/tsar
	install modules/*.so ${DSTDIR}/${PREFIX}/tsar/modules
	install src/tsar ${DSTDIR}/${PREFIX}/bin
	install conf/tsar.conf ${DSTDIR}/etc/tsar
	install conf/tsar.logrotate ${DSTDIR}/etc/logrotate.d/tsar
	install conf/tsar.cron ${DSTDIR}/etc/cron.d/tsar
	install conf/tsar.8 ${DSTDIR}/${PREFIX}/man/man8
	dpkg-deb -b deb tsar.deb

rpm-pkg:
	echo "TODO"

tags:
	ctags -R
	cscope -Rbq

.PHONY: all clean install unintall tsardevel tsarluadevel tags
