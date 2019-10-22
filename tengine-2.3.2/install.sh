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
tar -zxvf tengine-2.3.2.tar.gz
tar -zxvf zlib-1.2.8.tar.gz
tar -zxvf jemalloc-4.0.4.tar.gz
tar -zxvf perl-5.24.0.tar.gz
tar -zxvf ngx-fancyindex-0.4.3.tar.gz
tar -zxvf libatomic_ops-7.4.2.tar.gz

yum -y install gcc gcc-c++ openssl openssl-devel

cd libatomic_ops-7.4.2
libatomic_ops_path=`pwd`
./configure --prefix=$libatomic_ops_path --enable-shared --disable-static --docdir=$libatomic_ops_path/doc/libatomic_ops-7.4.2 && make && make install
ln -s "$libatomic_ops_path/lib/libatomic_ops.a" "$libatomic_ops_path/src/"
cd ../
cd perl-5.24.0 && ./Configure -des -Dprefix=$HOME/localperl && make && make install
cd ../
cd tengine-2.3.2 && ./configure --prefix=/usr/local/nginx/ --sbin-path=/usr/local/nginx/sbin/nginx --modules-path=/usr/local/nginx/modules --conf-path=/usr/local/nginx/conf/nginx.conf --http-log-path=/usr/local/nginx/logs/access.log --error-log-path=/usr/local/nginx/logs/error.log --pid-path=/usr/local/nginx/nginx.pid --lock-path=/usr/local/nginx/nginx.lock --http-client-body-temp-path=/usr/local/nginx/client_body_temp --http-proxy-temp-path=/usr/local/nginx/proxy_temp --http-fastcgi-temp-path=/usr/local/nginx/fastcgi_temp --http-uwsgi-temp-path=/usr/local/nginx/uwsgi_temp --http-scgi-temp-path=/usr/local/nginx/scgi_temp --user=root --group=root --with-http_stub_status_module --with-http_ssl_module --with-http_gzip_static_module --with-select_module --with-poll_module --with-threads --with-file-aio --with-mail --with-mail_ssl_module --without-http_upstream_keepalive_module --add-module=./modules/mod_config --add-module=./modules/mod_dubbo --add-module=./modules/ngx_backtrace_module --add-module=./modules/ngx_debug_pool --add-module=./modules/ngx_debug_timer --add-module=./modules/ngx_http_concat_module --add-module=./modules/ngx_http_footer_filter_module --add-module=./modules/ngx_http_proxy_connect_module --add-module=./modules/ngx_http_reqstat_module --add-module=./modules/ngx_http_slice_module --add-module=./modules/ngx_http_sysguard_module --add-module=./modules/ngx_http_trim_filter_module --add-module=./modules/ngx_http_upstream_check_module --add-module=./modules/ngx_http_upstream_consistent_hash_module --add-module=./modules/ngx_http_upstream_dynamic_module --add-module=./modules/ngx_http_upstream_dyups_module --add-module=./modules/ngx_http_upstream_keepalive_module --add-module=./modules/ngx_http_upstream_session_sticky_module --add-module=./modules/ngx_http_upstream_vnswrr_module --add-module=./modules/ngx_http_user_agent_module --add-module=./modules/ngx_multi_upstream_module --add-module=./modules/ngx_slab_stat --with-pcre=../pcre-8.39 --with-zlib=../zlib-1.2.8 --with-openssl=../openssl-1.0.1t --with-jemalloc=../jemalloc-4.0.4 --with-libatomic=../libatomic_ops-7.4.2 --add-module=../ngx-fancyindex-0.4.3 --with-debug && make && make install

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
