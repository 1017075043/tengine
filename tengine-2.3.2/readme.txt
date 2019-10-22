Tengine是由淘宝网发起的Web服务器项目。它在Nginx的基础上，针对大访问量网站的需求，添加了很多高级功能和特性。Tengine的性能和稳定性已经在大型的网站如淘宝网，天猫商城等得到了很好的检验。它的最终目标是打造一个高效、稳定、安全、易用的Web平台。



从2011年12月开始，Tengine成为一个开源项目，Tengine团队在积极地开发和维护着它。Tengine团队的核心成员来自于淘宝、搜狗等互联网企业。Tengine是社区合作的成果，我们欢迎大家参与其中，贡献自己的力量。
Tengine完全兼容Nginx，因此可以参照Nginx的方式来配置Tengine。

Nginx的架构和扩展性：
一个主进程和多个工作进程，工作进程以非特权用户运行；
支持的事件机制：kqueue（FreeBSD 4.1+）、epoll（Linux 2.6+）、rt signals（Linux 2.2.19+）、/dev/poll（Solaris 7 11/99+）、event ports（Solaris 10）、select以及poll；
众多支持的kqueue特性包括EV_CLEAR、EV_DISABLE（临时禁止事件）、NOTE_LOWAT、EV_EOF，可用数据的数量，错误代码；
支持sendfile（FreeBSD 3.1+, Linux 2.2+, Mac OS X 10.5+）、sendfile64（Linux 2.4.21+）和sendfilev（Solaris 8 7/01+）；
文件AIO（FreeBSD 4.3+, Linux 2.6.22+）；
DIRECTIO (FreeBSD 4.4+, Linux 2.4+, Solaris 2.6+, Mac OS X);
支持Accept-filters（FreeBSD 4.1+, NetBSD 5.0+）和 TCP_DEFER_ACCEPT（Linux 2.4+）；
10000个非活跃的HTTP keep-alive连接仅占用约2.5M内存；
尽可能避免数据拷贝操作。



Tengine继承Nginx-1.8.1的所有特性，兼容Nginx的配置；

Tengine特性详解：
1、动态模块加载（DSO）支持。加入一个模块不再需要重新编译整个Tengine；
这个模块主要是用来运行时动态加载模块，而不用每次都要重新编译Tengine.
如果你想要编译官方模块为动态模块，你需要在configure的时候加上类似这样的指令(--with-http_xxx_module),./configure --help可以看到更多的细节.
如果只想要安装官方模块为动态模块(不安装Nginx)，那么就只需要configure之后，执行 make dso_install命令.
动态加载模块的个数限制为128个.
如果已经加载的动态模块有修改，那么必须重起Tengine才会生效.
只支持HTTP模块.
模块 在Linux/FreeeBSD/MacOS下测试成功.
样例：http://tengine.taobao.org/document_cn/dso_cn.html


2、支持HTTP/2协议，HTTP/2模块替代SPDY模块；
Tengine对SPDY模块增加SPDY/3协议的支持。
样例：http://tengine.taobao.org/document_cn/ngx_http_spdy_module_cn.html


3、流式上传到HTTP后端服务器或FastCGI服务器，大量减少机器的I/O压力；
相关语法：client_body_postpone_size
当打开proxy_request_buffering或fastcgi_request_buffering指令，
设置不缓存请求body到磁盘时，tengine每当接受到大于client_body_postpone_size大小的数据或者整个请求都发送完毕，
才会往后端发送数据。这可以减少与后端服务器建立的连接数，并减少网络IO的次数。


4、更加强大的负载均衡能力，包括一致性hash模块、会话保持模块，还可以对后端的服务器进行主动健康检查，根据服务器状态自动上线下线，以及动态解析upstream中出现的域名；
一致性hash模块：
这个模块提供一致性hash作为负载均衡算法。
该模块通过使用客户端信息(如：$ip, $uri, $args等变量)作为参数，使用一致性hash算法将客户端映射到后端机器
如果后端机器宕机，这请求会被迁移到其他机器
server id 字段，如果配置id字段，则使用id字段作为server标识，否则使用server ip和端口作为server标识，
使用id字段可以手动设置server的标识，比如一台机器的ip或者端口变化，id仍然可以表示这台机器。使用id字段
可以减低增减服务器时hash的波动。
server weight 字段，作为server权重，对应虚拟节点数目
具体算法，将每个server虚拟成n个节点，均匀分布到hash环上，每次请求，根据配置的参数计算出一个hash值，在hash环
上查找离这个hash最近的虚拟节点，对应的server作为该次请求的后端机器。
该模块可以根据配置参数采取不同的方式将请求均匀映射到后端机器，比如：
consistent_hash $remote_addr：可以根据客户端ip映射
consistent_hash $request_uri： 根据客户端请求的uri映射
consistent_hash $args：根据客户端携带的参数进行映射
样例：http://tengine.taobao.org/document_cn/http_upstream_consistent_hash_cn.html


会话保持模块：
ngx_http_upstream_session_sticky_module
该模块是一个负载均衡模块，通过cookie实现客户端与后端服务器的会话保持, 在一定条件下可以保证同一个客户端访问的都是同一个后端服务器。
相关语法：session_sticky 、session_sticky_hide_cookie?
样例：http://tengine.taobao.org/document_cn/http_upstream_session_sticky_cn.html


健康监测模块：
ngx_http_upstream_check_module
该模块可以为Tengine提供主动式后端服务器健康检查的功能。
该模块在Tengine-1.4.0版本以前没有默认开启，它可以在配置编译选项的时候开启：
./configure --with-http_upstream_check_module
相关语法：check、check_keepalive_requests 、check_http_send 、check_http_expect_alive?
check_shm_size 、check_status 、
样例：http://tengine.taobao.org/document_cn/http_upstream_check_cn.html


动态解析域名模块：
ngx_http_upstream_dynamic_module
此模块提供了在运行时动态解析upstream中server域名的功能。
相关语法：dynamic_resolve?
样例：http://tengine.taobao.org/document_cn/http_upstream_dynamic_cn.html




5、输入过滤器机制支持。通过使用这种机制Web应用防火墙的编写更为方便；




6、支持设置proxy、memcached、fastcgi、scgi、uwsgi在后端失败时的重试次数
限制每个请求对后端服务器访问的最大尝试次数，支持proxy、memcached、fastcgi、scgi和uwsgi模块。
相关语法：fastcgi_upstream_tries 、proxy_upstream_tries 、memcached_upstream_tries 、
scgi_upstream_tries 、uwsgi_upstream_tries?
样例：http://tengine.taobao.org/document_cn/ngx_limit_upstream_tries_cn.html




7、动态脚本语言Lua支持。扩展功能非常高效简单；
从v0.5.0rc32版本开始，所有*_by_lua_file配置指令（如content_by_lua_file）都支持直接加载Lua 5.1和LuaJIT 2.0 / 2.1原始字节码文件。


请注意，LuaJIT 2.0 / 2.1使用的字节码格式与标准Lua 5.1解释器所使用的字节码格式不兼容。因此，如果使用LuaJIT 2.0 / 2.1与ngx_lua，则必须生成LuaJIT兼容的字节码文件
/ path / to / luajit / bin / luajit -b /path/to/input_file.lua /path/to/output_file.luac

该-bg选项可用于将调试信息包含在LuaJIT字节码文件中：
/ path / to / luajit / bin / luajit -bg /path/to/input_file.lua /path/to/output_file.luac

-b有关详细信息，请参阅官方LuaJIT文档：
http://luajit.org/running.html#opt_b


此外，LuaJIT 2.1生成的字节码文件与LuaJIT 2.0 不兼容，反之亦然。在ngx_lua v0.9.3中首次添加了对LuaJIT 2.1字节码的支持。
类似地，如果使用带有ngx_lua的标准Lua 5.1解释器，则必须使用luac命令行实用程序生成Lua兼容字节码文件，如下所示：
luac -o /path/to/output_file.luac /path/to/input_file.lua

与LuaJIT不同，默认情况下，调试信息包含在标准Lua 5.1字节码文件中。这可以通过指定-s所示的选项进行条带化：
luac -s -o /path/to/output_file.luac /path/to/input_file.lua


尝试将标准Lua 5.1字节码文件加载到链接到LuaJIT 2.0 / 2.1的ngx_lua实例中，反之亦然，将导致一个错误消息（如下文）登录到Nginx error.log文件中：
[error] 13909#0: *1 failed to load Lua inlined code: bad byte-code header in /path/to/test_file.luac
通过Lua原语加载字节码文件，require并且dofile应该总是按预期工作。


8、支持按指定关键字(域名，url等)收集Tengine运行状态；
运行状态模块：
ngx_http_reqstat_module
这个模块计算定义的变量，根据变量值分别统计Tengine的运行状况。
可以监视的运行状况有：连接数、请求数、各种响应码范围的请求数、输入输出流量、rt、upstream访问等。
可以指定获取所有监控结果或者一部分监控结果。
利用变量添加自定义监控状态。总的监控状态最大个数为50个。
回收过期的监控数据。
设置输出格式
跟踪请求，不受内部跳转的影响
不要使用与响应相关的变量作为条件，比如"$status"
相关语法：req_status_zone 、req_status、req_status_show、req_status_show_field、
req_status_zone_add_indecator、req_status_zone_key_length、req_status_zone_recycle
样例：http://tengine.taobao.org/document_cn/http_reqstat_cn.html




9、组合多个CSS、JavaScript文件的访问请求变成一个请求；
合并请求模块：
ngx_http_concat_module
该模块类似于apache中的mod_concat模块，用于合并多个文件在一个响应报文中。
相关语法：concat 、concat_types 、concat_unique 、concat_max_files 、concat_delimiter 、
concat_ignore_file_error 、
样例：http://tengine.taobao.org/document_cn/http_concat_cn.html


10、自动去除空白字符和注释从而减小页面的体积
trim 模块
该模块用于删除 html，内嵌 javascript 和 css 中的注释以及重复的空白符。
相关语法：trim 、trim_js 、trim_css 、trim_types 、
样例：http://tengine.taobao.org/document_cn/http_trim_filter_cn.html


11、自动根据CPU数目设置进程个数和绑定CPU亲缘性；


12、监控系统的负载和资源占用从而对系统进行保护；
监控模块；
ngx_http_sysguard_module
当swap的剩余百分比，剩下的内存，load值或平均响应时间到设定的值时，就会跳转到action所指定的url。
相关语法：sysguard 、sysguard_load 、sysguard_mem 、sysguard_rt 、sysguard_mode 、
sysguard_interval 、sysguard_log_level?
样例：http://tengine.taobao.org/document_cn/http_sysguard_cn.html


13、显示对运维人员更友好的出错信息，便于定位出错机器；
模块：
ngx_http_footer_filter_module
在请求的响应末尾输出一段内容。输出内容可配置，并支持内嵌变量。
相关语法：footer footer_types?
样例：http://tengine.taobao.org/document_cn/http_footer_filter_cn.html


14、更强大的防攻击（访问速度限制）模块；
限速模块：
ngx_http_limit_req_module
相关语法：
limit_req_log_level（和Nginx相同）
limit_req_zone（比原nginx支持多个变量，支持多个limit_req_zone设置）
limit_req（支持开关，默认是打开状态。并且一个location支持多个limit_req指令，当有多个limit_req指令的话，
这些指令是或的关系，也就是当其中任意一个限制被触发，则执行对应的limit_req。
forbid_action表示当条件被触发时，nginx所要执行的动作，支持name location和页面(/)，默认是返回503。）
limit_req_whitelist （白名单）
样例：http://tengine.taobao.org/document_cn/http_limit_req_cn.html


15、更方便的命令行参数，如列出编译的模块列表、支持的指令等；
'-m' 选项
显示所有编译的模块，自1.4.0以来，Tengine支持动态模块，static表示静态编译，shared表示动态编译(后面接的是动态模块的版本)。
'-l' 选项
显示所有支持的指令：
'-d' 选项
输出配置文件的内容，包括'include'的内容：
样例：http://tengine.taobao.org/document_cn/commandline_cn.html


16、可以根据访问文件类型设置过期时间；
