# $FreeBSD$

PORTNAME=	sqmail
DISTVERSION=	4.0.05
PORTREVISION=	7
CATEGORIES=	mail
DISTNAME=	sqmail-${DISTVERSION}
MASTER_SITES=	https://www.fehcom.de/sqmail/
EXTRACT_SUFX=   .tgz

PATCH_DEPENDS=	feh-ucspi-ssl>=0.11.4_1:sysutils/feh-ucspi-ssl

BUILD_DEPENDS=	fehQlibs>=14:sysutils/fehQlibs \
		feh-ucspi-ssl>=0.11.4_1:sysutils/feh-ucspi-ssl

RUN_DEPENDS=	feh-ucspi-ssl>=0.11.4_1:sysutils/feh-ucspi-ssl \
		daemontools>=0.76_18:sysutils/daemontools

WRKSRC=		${WRKDIR}/mail/sqmail/${DISTNAME}

MAINTAINER=	dl-ports@perfec.to
COMMENT=	Mail Transfer Agent based on Qmail
USES+=		qmail:vars fakeroot
LICENSE=	PD
LICENSE_FILE=	${WRKSRC}/doc/LICENSE

CONFLICTS=	qmail-ldap-[0-9]* \
		*qmail-mysql-[0-9]* \
		qmail-spamcontrol-[0-9]* \
		*qmail-tls-[0-9]* \
		qmail-vida-[0-9]* \
		qmail-[0-9]*

PREFIX?=	${QMAIL_PREFIX}

SUB_FILES=	pkg-message mailer.conf

USERS=          alias
.for usersuffix in d l p q r s
USERS+=         qmail${usersuffix}
.endfor
GROUPS=         qmail qnofiles

MAN1=		bouncesaying.1 \
		columnt.1 \
		condredirect.1 \
		except.1 \
		fastforward.1 \
		forward.1 \
		maildir2mbox.1 \
		maildirmake.1 \
		maildirwatch.1 \
		mailsubj.1 \
		matchup.1 \
		newaliases.1 \
		newinclude.1 \
		preline.1 \
		printforward.1 \
		printmaillist.1 \
		qbiff.1 \
		qreceipt.1 \
		setforward.1 \
		setmaillist.1 \
		srsforward.1 \
		srsreverse.1 \
		xqp.1 \
		xrecipient.1 \
		xsender.1

MAN3=		datetime.3

MAN5=		addresses.5 \
		dot-qmail.5 \
		envelopes.5 \
		maildir.5 \
		mbox.5 \
		qmail-control.5 \
		qmail-header.5 \
		qmail-log.5 \
		qmail-users.5 \
		tai64nfrac.5 \
		tcp-environ.5

MAN7=		forgeries.7 \
		qmail-limits.7 \
		sqmail.7

MAN8=		dnscname.8 \
		dnsfq.8 \
		dnsip.8 \
		dnsmxip.8 \
		dnsptr.8 \
		dnstxt.8 \
		hostname.8 \
		ipmeprint.8 \
		qmail-authuser.8 \
		qmail-badloadertypes.8 \
		qmail-badmimetypes.8 \
		qmail-clean.8 \
		qmail-command.8 \
		qmail-getpw.8 \
		qmail-inject.8 \
		qmail-local.8 \
		qmail-lspawn.8 \
		qmail-mfrules.8 \
		qmail-mrtg.8 \
		qmail-newmrh.8 \
		qmail-newu.8 \
		qmail-pop3d.8 \
		qmail-popup.8 \
		qmail-pw2u.8 \
		qmail-qmqpc.8 \
		qmail-qmqpd.8 \
		qmail-qmtpd.8 \
		qmail-qread.8 \
		qmail-qstat.8 \
		qmail-queue.8 \
		qmail-recipients.8 \
		qmail-remote.8 \
		qmail-rspawn.8 \
		qmail-send.8 \
		qmail-showctl.8 \
		qmail-smtpam.8 \
		qmail-smtpd.8 \
		qmail-start.8 \
		qmail-tcpok.8 \
		qmail-tcpto.8 \
		qmail-todo.8 \
		qmail-vmailuser.8 \
		spfquery.8 \
		splogger.8

SAMPLE_CONFIGS=	badloadertypes \
		badmailfrom \
		badmimetypes \
		badrcptto \
		rules.qmtpd.cdb \
		rules.qmtpd.txt \
		rules.smtpd.cdb \
		rules.smtpd.txt

SAMPLE_RUN_FILES=\
		run_log \
		run_pop3d \
		run_pop3sd \
		run_qmqpd \
		run_qmtpd \
		run_qmtpsd \
		run_send \
		run_smtpd \
		run_smtpsd \
		run_smtpsub

DOC_FILES=\
		BLURB \
		CHANGELOG \
		CHANGELOG_V3 \
		CONTRIBUTERS \
		EXTTODO \
		LICENSE \
		LOGGING \
		Old/PROPOSAL.mav \
		Old/README.djbdns \
		Old/README.mav \
		Old/README.qmq \
		Old/README.recipients \
		Old/README.wildmat \
		Qmail/BLURB \
		Qmail/FAQ \
		Qmail/INSTALL.alias \
		Qmail/INSTALL.ctl \
		Qmail/INSTALL.ids \
		Qmail/INSTALL.maildir \
		Qmail/INSTALL.mbox \
		Qmail/INSTALL.qmail \
		Qmail/INTERNALS \
		Qmail/PIC.local2alias \
		Qmail/PIC.local2ext \
		Qmail/PIC.local2local \
		Qmail/PIC.local2rem \
		Qmail/PIC.local2virt \
		Qmail/PIC.nullclient \
		Qmail/PIC.relaybad \
		Qmail/PIC.relaygood \
		Qmail/PIC.rem2local \
		Qmail/README \
		Qmail/REMOVE.binmail \
		Qmail/REMOVE.sendmail \
		Qmail/SYSDEPS \
		Qmail/TEST.deliver \
		Qmail/TEST.receive \
		Qmail/THANKS \
		Qmail/THOUGHTS \
		Qmail/TODO \
		README.clamav \
		README.smtpreply \
		TODO \
		smtpreplies

FEHQLIBS_PREFIX=	`pkg query '%p' fehQlibs || echo missing-fehQlibs`
FEH_UCSPI_SSL_PREFIX=	`pkg query '%p' feh-ucspi-ssl || echo missing-feh-ucspi-ssl`

do-configure:
	${ECHO_CMD} "${CC} ${CCFLAGS} -I${FEH_UCSPI_SSL_PREFIX}/include -I${FEHQLIBS_PREFIX}/include" > ${WRKSRC}/conf-cc
	${ECHO_CMD} "${QMAIL_PREFIX}" > ${WRKSRC}/conf-home
	${ECHO_CMD} "${CC} ${LDFLAGS} -s"  > ${WRKSRC}/conf-ld
	${REINPLACE_CMD} -e 's|sqmail|qmail|g' -e 's|nofiles|qnofiles|g' ${WRKSRC}/conf-groups
	${ECHO_CMD} "${QMAIL_PREFIX}/man" > ${WRKSRC}/conf-man
	${ECHO_CMD} "${FEHQLIBS_PREFIX}/lib" > ${WRKSRC}/conf-qlibs
	#${ECHO_CMD} "${FEH_UCSPI_SSL_PREFIX}" > ${WRKSRC}/conf-ucspissl
	${CP} "${FEH_UCSPI_SSL_PREFIX}/lib/conf-ssl" ${WRKSRC}/

do-patch:
	${CP} \
	    '${FILESDIR}/auto-uid.c' \
	    '${FILESDIR}/auto-gid.c' \
	    '${FILESDIR}/usertab.c' \
	    '${FILESDIR}/grouptab.c' \
	    '${FILESDIR}/install.c' \
	    '${FILESDIR}/gen-plist.c' \
	    '${FILESDIR}/gen-plist.sh' \
	    "${FEH_UCSPI_SSL_PREFIX}/include/ucspissl.h" \
	    "${FEH_UCSPI_SSL_PREFIX}/lib/ucspissl.a" \
	    "${FEH_UCSPI_SSL_PREFIX}/lib/ssl.lib" \
	    ${WRKSRC}/src
	${CAT} '${FILESDIR}/Makefile.append' >> ${WRKSRC}/src/Makefile

# The qmail utilities are built with conf-home set to the final install path.
# But we set conf-home for the install program to the staging path.
# We remove quto_qmail.o to force rebuild; make's timestamp resolution is only
# a second.
do-build:
	cd ${WRKSRC}/src && \
	make && \
	make gen-plist && \
	./auto-str auto_qmail "${STAGEDIR}`head -1 ../conf-home`" > auto_qmail.c && \
	rm auto_qmail.o && \
	make install instcheck
	cd ${WRKSRC}/man && \
	make \
		dot-qmail.5 \
		qmail-authuser.8 \
		qmail-badloadertypes.8 \
		qmail-badmimetypes.8 \
		qmail-control.5 \
		qmail-getpw.8 \
		qmail-limits.7 \
		qmail-mfrules.8 \
		qmail-newmrh.8 \
		qmail-newu.8 \
		qmail-pw2u.8 \
		qmail-recipients.8 \
		qmail-send.8 \
		qmail-start.8 \
		qmail-users.5 \
		qmail-vmailuser.8 \
		sqmail.7 \
		srsreverse.0
	cd ${WRKSRC}/man && mv srsreverse.0 srsreverse.1

do-install:
	cd ${WRKSRC}/src && ${FAKEROOT} ./install && ${FAKEROOT} ./instcheck
.for file_name in ${MAN1}
	${INSTALL_MAN} ${WRKSRC}/man/${file_name} ${STAGEDIR}${MANPREFIX}/man/man1/
.endfor
.for file_name in ${MAN3}
	${INSTALL_MAN} ${WRKSRC}/man/${file_name} ${STAGEDIR}${MANPREFIX}/man/man3/
.endfor
.for file_name in ${MAN5}
	${INSTALL_MAN} ${WRKSRC}/man/${file_name} ${STAGEDIR}${MANPREFIX}/man/man5/
.endfor
.for file_name in ${MAN7}
	${INSTALL_MAN} ${WRKSRC}/man/${file_name} ${STAGEDIR}${MANPREFIX}/man/man7/
.endfor
.for file_name in ${MAN8}
	${INSTALL_MAN} ${WRKSRC}/man/${file_name} ${STAGEDIR}${MANPREFIX}/man/man8/
.endfor
.for file_name in ${SAMPLE_CONFIGS}
	${INSTALL_DATA} ${WRKSRC}/ctl/${file_name} ${STAGEDIR}${QMAIL_PREFIX}/control/${file_name}.sample
.endfor
	${ECHO_CMD} ':*' > ${STAGEDIR}${QMAIL_PREFIX}/control/tlsdestinations.sample
	${MKDIR} ${STAGEDIR}${QMAIL_PREFIX}/ssl
	${INSTALL_DATA} ${WRKSRC}/service/ssl.env ${STAGEDIR}${QMAIL_PREFIX}/ssl/ssl.env.template
	${MKDIR} ${STAGEDIR}${QMAIL_PREFIX}/svc
	${MKDIR} ${STAGEDIR}${QMAIL_PREFIX}/example
.for file_name in ${SAMPLE_RUN_FILES}
	${INSTALL_DATA} ${WRKSRC}/service/${file_name} ${STAGEDIR}${QMAIL_PREFIX}/example/${file_name}
.endfor
	${INSTALL_DATA} ${WRKSRC}/package/services=d ${STAGEDIR}${QMAIL_PREFIX}/example/
	${INSTALL_DATA} ${WRKDIR}/mailer.conf ${STAGEDIR}${QMAIL_PREFIX}/example/
	${MKDIR} ${STAGEDIR}${QMAIL_PREFIX}/doc
	${MKDIR} ${STAGEDIR}${QMAIL_PREFIX}/doc/Qmail
	${MKDIR} ${STAGEDIR}${QMAIL_PREFIX}/doc/Old
.for file_name in ${DOC_FILES}
	${INSTALL_DATA} ${WRKSRC}/doc/${file_name} ${STAGEDIR}${QMAIL_PREFIX}/doc/${file_name}
.endfor

.include <bsd.port.mk>
