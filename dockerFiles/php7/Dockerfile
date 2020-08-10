FROM centos_base:latest

env TENGINE_VERSION 2.3.0
env CURL_VERSION 7.64.1
env PHP_VERSION 7.2.18

RUN useradd -M -s /sbin/nologin www

ADD http://tengine.taobao.org/download/tengine-$TENGINE_VERSION.tar.gz /usr/local/src

RUN yum install libxslt-devel -y gd gd-devel vim git pcre pcre-devel gcc gcc-c++ autoconf automake make openssl-devel && yum clean all

WORKDIR /usr/local/src
RUN tar zxvf tengine-$TENGINE_VERSION.tar.gz

WORKDIR /usr/local/src/tengine-$TENGINE_VERSION
RUN ./configure --prefix=/usr/local/nginx --conf-path=/usr/local/nginx/nginx.conf --error-log-path=/usr/local/nginx/log/error.log --http-log-path=/usr/local/nginx/log/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --sbin-path=/usr/sbin/nginx --user=www --group=www --with-http_ssl_module --with-http_realip_module --with-http_addition_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_random_index_module --with-http_secure_link_module --with-http_stub_status_module --with-http_auth_request_module --with-mail --with-mail_ssl_module --with-ipv6 && make && make install && rm -rf /usr/local/src/tengine-$TENGINE_VERSION /usr/local/src/tengine-$TENGINE_VERSION.tar.gz

COPY ./nginx.conf /usr/local/nginx/nginx.conf
RUN mkdir /usr/local/nginx/conf

EXPOSE 80 443

#PHP7 runtime
RUN yum install epel-release -y && rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm && yum clean all

# php72w-pecl-imagick
RUN yum install -y php70w yum-plugin-replace && yum clean all
RUN yum replace -y php70w-common --replace-with=php72w-common && yum clean all 
RUN yum install -y php72w-cli php72w-fpm php72w-gd php72w-ldap php72w-mbstring php72w-mysql php72w-opcache php72w-pdo php72w-pecl-igbinary  php72w-pecl-memcached php72w-pecl-xdebug php72w-pecl-redis php72w-process php72w-soap php72w-xml php72w-xmlrpc php72w-devel php72w-bcmath composer git wget && yum clean all

COPY ./php.ini /etc/php.ini
COPY ./www.conf /etc/php-fpm.d/www.conf
#COPY opcache.ini /etc/php.d/opcache.ini

RUN chown www:www /var/lib/php/session && chown www:www /var/lib/php/wsdlcache

#CURL OPENSSL
WORKDIR /root
RUN wget https://curl.haxx.se/download/curl-$CURL_VERSION.tar.gz && tar zxvf curl-$CURL_VERSION.tar.gz

#WORKDIR /root/curl-$CURL_VERSION
RUN cd curl-$CURL_VERSION && ./configure --prefix=/usr/local/curl --without-nss --with-ssl && make && make install && rm -rf /root/curl-$CURL_VERSION.tar.gz && rm -rf /root/curl-$CURL_VERSION

WORKDIR /root
RUN wget http://hk2.php.net/get/php-$PHP_VERSION.tar.gz/from/this/mirror  && mv mirror php.tar.gz && tar zxvf php.tar.gz && cd php-$PHP_VERSION/ext/curl && phpize && ./configure --with-curl=/usr/local/curl/ && make && make install && rm -rf /root/php-$PHP_VERSION && rm -rf /root/php.tar.gz

#swoole插件
RUN yes | pecl install swoole-4.2.1
COPY ./swoole.ini /etc/php.d/swoole.ini

#安装tars扩展
COPY ./tars-extension /root/tars-extension
WORKDIR /root
RUN cd tars-extension && phpize && make && make install


#安装crontab
RUN yum -y install cronie && yum clean all
RUN sed -i '/session    required   pam_loginuid.so/c\#session    required   pam_loginuid.so' /etc/pam.d/crond

RUN /usr/sbin/crond 

CMD /usr/sbin/crond && /usr/sbin/php-fpm && /usr/sbin/sshd -p 22 && /usr/sbin/nginx -g "daemon off;"
