#!/bin/sh

if [ -d "/usr/local/nginx/" ];then
	echo "/usr/local/nginx 已经存在，判定为已经安装完成"
	exit 1
else
    echo "开始安装nginx"
	sleep 2
fi

tar -zxvf openssl-1.0.1t.tar.gz
tar -zxvf pcre-8.39.tar.gz
tar -zxvf tengine-2.1.2.tar.gz
tar -zxvf zlib-1.2.8.tar.gz
tar -jxvf jemalloc-4.0.4.tar.bz2
tar -zxvf perl-5.24.0.tar.gz

yum -y install gcc gcc-c++ openssl openssl-devel

cd perl-5.24.0 && ./Configure -des -Dprefix=$HOME/localperl && make && make install

cd ../tengine-2.1.2 && ./configure --prefix=/usr/local/nginx/ --with-pcre=../pcre-8.39 --with-zlib=../zlib-1.2.8 --with-openssl=../openssl-1.0.1t --with-http_stub_status_module --with-http_ssl_module --with-http_gzip_static_module --with-jemalloc=../jemalloc-4.0.4 && make && make install

if [ -d "/usr/local/nginx/" ];then
	ln -s /usr/local/nginx/sbin/nginx /usr/bin/
	if [ -f "/usr/local/nginx/conf/nginx.conf" ];then
		cp -rf /usr/local/nginx/conf/nginx.conf /usr/local/nginx/conf/nginx.conf_bak
	fi
	echo "" >> /etc/rc.local
	echo "#nginx start" >> /etc/rc.local
	echo "/usr/local/nginx/sbin/nginx" >> /etc/rc.local
	/usr/local/nginx/sbin/nginx -V
	echo "nginx 安装成功，且已经设置开机自启"
	echo "启动命令：/usr/local/nginx/sbin/nginx"
	echo "停止命令：/usr/local/nginx/sbin/nginx -s stop"
	echo "重启命令：/usr/local/nginx/sbin/nginx -s reload"
	echo "查看命令：ps -ef | grep nginx | grep -v grep"
	sleep 10
else
    echo "nginx 安装失败"
fi