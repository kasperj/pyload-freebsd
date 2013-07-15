# Created by: mrhanky <mrhanky@unterschicht.tv>
# $FreeBSD$

PORTNAME=	pyload
PORTVERSION=	0.4.9
CATEGORIES=	www
MASTER_SITES=	GH
DISTNAME=	${GH_ACCOUNT}-${GH_PROJECT}-${PORTVERSION}-0-g${GH_COMMIT}

MAINTAINER=	mrhanky@unterschicht.tv
COMMENT=	pyLoad is a one-click download manager written in python

USE_GITHUB=	yes
GH_ACCOUNT=	pyload
GH_PROJECT=	pyload
GH_COMMIT=	6632445
GH_TAGNAME=	stable

RUN_DEPENDS+=	${PYTHON_PKGNAMEPREFIX}django:${PORTSDIR}/www/py-django \
		${PYTHON_PKGNAMEPREFIX}beaker:${PORTSDIR}/www/py-beaker \
		${PYTHON_PKGNAMEPREFIX}imaging:${PORTSDIR}/graphics/py-imaging \
		${PYTHON_PKGNAMEPREFIX}pycrypto:${PORTSDIR}/security/py-pycrypto \
		${PYTHON_PKGNAMEPREFIX}pycurl:${PORTSDIR}/ftp/py-curl

OPTIONS_DEFINE=	GUI JSENGINE OPENSSL TESSERACT UNPACK
OPTIONS_DEFAULT=JSENGINE TESSERACT UNPACK
GUI_DESC=	Install dependencies for GUI (will be obsolete)
JSENGINE_DESC=	Install spidermonkey JS engine for Click'n'load
TESSERACT_DESC=	Image recognition provided by gocr and tesseract
UNPACK_DESC=	Install unrar and unzip to unpack downloads

.include <bsd.port.options.mk>

.if ${PORT_OPTIONS:MGUI}
RUN_DEPENDS+=	py-qt:${PORTSDIR}/x11-toolkits/py-qt
.endif

.if ${PORT_OPTIONS:MJSENGINE}
RUN_DEPENDS+=	spidermonkey:${PORTSDIR}/lang/spidermonkey17
.endif

.if ${PORT_OPTIONS:MOPENSSL}
USE_OPENSSL=	yes
RUN_DEPENDS+=	${PYTHON_PKGNAMEPREFIX}py-openssl:${PORTSDIR}/security/py-openssl
.endif

.if ${PORT_OPTIONS:MTESSERACT}
TESSERACT_LANGS=eng
RUN_DEPENDS+=	gocr:${PORTSDIR}/graphics/gocr \
		tesseract:${PORTSDIR}/graphics/tesseract \
		tesseract-data:${PORTSDIR}/graphics/tesseract-data
.endif

.if ${PORT_OPTIONS:MUNPACK}
RUN_DEPENDS+=	unrar:${PORTSDIR}/archivers/unrar
		unzip:${PORTSDIR}/archivers/unzip
.endif

NO_BUILD=	yes
USE_PYTHON=	yes
USE_RC_SUBR=	pyload

WRKSRC=		${WRKDIR}/${GH_ACCOUNT}-${GH_PROJECT}-${GH_COMMIT}
BINARY_DIR=	${PREFIX}/bin
INSTALL_DIR=	${PREFIX}/www/${PORTNAME}
INSTALL_SCRIPTS=pyLoadCli.py pyLoadCore.py pyLoadGui.py

do-install:
	${MKDIR} ${INSTALL_DIR}
	(cd ${WRKSRC} && ${COPYTREE_SHARE} \* ${INSTALL_DIR})
.for FILE in ${INSTALL_SCRIPTS}
	${LN} -fs ${INSTALL_DIR}/${FILE} ${BINARY_DIR}/${FILE}
	${CHMOD} +x ${BINARY_DIR}/${FILE}
.endfor

post-install:
	@${CAT} ${PKGMESSAGE}

.include <bsd.port.mk>
