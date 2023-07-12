FROM alpine:3.11
RUN apk update && apk upgrade && apk add \
        apache2 \
        apache2-dev \
        apache2-utils \
        pcre \
        pcre-dev \
        jansson \
        jansson-dev \
        curl \
        curl-dev \
        libcurl \
        git \
        pkgconf \
        automake \
        autoconf \
        make \
        g++ \
        openssl-dev
# RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories ; \
    # apk add \
    #         cjose-dev \
    #         cjose
RUN git clone https://github.com/cisco/cjose.git \
    cd cjose \
    ./configure && make ; cd ..
		
RUN git clone -b v2.4.2.1 https://github.com/zmartzone/mod_auth_openidc.git ; \
    cd mod_auth_openidc ; ./autogen.sh ; \
    printenv ; \
    apk list ; \
    ./configure ; make ; make install ; cd ..

FROM alpine:3.11
MAINTAINER "DevOps Team <infra@clearcaptions.com>"

COPY --from=0 /usr/lib/apache2 /usr/lib/apache2

# Add basics first
RUN apk update && apk upgrade && apk add \
	bash \
	apache2 \
	apache2-utils \
	php7-apache2 \
	curl \
	ca-certificates \
	openssl \
	openssh \
	git \
	php7 \
	php7-phar \
	php7-json \
	php7-iconv \
	php7-openssl \
	tzdata \
	openntpd \
	nano

# Add Composer
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

# Setup apache and php
RUN apk add \
	php7-ftp \
	php7-xdebug \
	php7-couchbase \
	php7-mcrypt \
	php7-mbstring \
	php7-soap \
	php7-gmp \
	php7-dom \
	php7-zip \
	php7-bcmath \
	php7-gd \
	php7-gettext \
	php7-xmlreader \
	php7-xmlwriter \
	php7-tokenizer \
	php7-xmlrpc \
	php7-bz2 \
	php7-curl \
	php7-ctype \
	php7-session \
	php7-redis \
	php7-exif

# Problems installing in above stack
RUN apk add php7-simplexml
CMD tail -f /dev/null
