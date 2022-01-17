ARG VERSION=alpine
FROM nginx:${VERSION} as builder

RUN  apk add --virtual .build-deps \
    gcc \
    libc-dev \
    make \
    openssl-dev \
    pcre-dev \
    zlib-dev \
    linux-headers \
    libxslt-dev \
    gd-dev \
    geoip-dev \
    perl-dev \
    libedit-dev \
    mercurial \
    bash \
    alpine-sdk \
    findutils \
    git

RUN wget "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -O nginx.tar.gz
RUN git clone "https://github.com/fdintino/nginx-upload-module.git" /usr/src/extra_module/upload-module


SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

RUN rm -rf /usr/src/nginx && mkdir -p /usr/src/nginx && \
    tar -zxC /usr/src/nginx -f nginx.tar.gz

WORKDIR /usr/src/nginx/nginx-${NGINX_VERSION}

RUN CONFARGS=$(nginx -V 2>&1 | sed -n -e 's/^.*arguments: //p') && \
    sh -c "./configure --with-compat $CONFARGS --add-dynamic-module=/usr/src/extra_module/*/" && make modules


COPY default.conf /usr/src/nginx/nginx-1.21.5/conf/nginx.conf