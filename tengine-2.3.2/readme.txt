Tengine�����Ա��������Web��������Ŀ������Nginx�Ļ����ϣ���Դ��������վ����������˺ܶ�߼����ܺ����ԡ�Tengine�����ܺ��ȶ����Ѿ��ڴ��͵���վ���Ա�������è�̳ǵȵõ��˺ܺõļ��顣��������Ŀ���Ǵ���һ����Ч���ȶ�����ȫ�����õ�Webƽ̨��



��2011��12�¿�ʼ��Tengine��Ϊһ����Դ��Ŀ��Tengine�Ŷ��ڻ����ؿ�����ά��������Tengine�Ŷӵĺ��ĳ�Ա�������Ա����ѹ��Ȼ�������ҵ��Tengine�����������ĳɹ������ǻ�ӭ��Ҳ������У������Լ���������
Tengine��ȫ����Nginx����˿��Բ���Nginx�ķ�ʽ������Tengine��

Nginx�ļܹ�����չ�ԣ�
һ�������̺Ͷ���������̣����������Է���Ȩ�û����У�
֧�ֵ��¼����ƣ�kqueue��FreeBSD 4.1+����epoll��Linux 2.6+����rt signals��Linux 2.2.19+����/dev/poll��Solaris 7 11/99+����event ports��Solaris 10����select�Լ�poll��
�ڶ�֧�ֵ�kqueue���԰���EV_CLEAR��EV_DISABLE����ʱ��ֹ�¼�����NOTE_LOWAT��EV_EOF���������ݵ�������������룻
֧��sendfile��FreeBSD 3.1+, Linux 2.2+, Mac OS X 10.5+����sendfile64��Linux 2.4.21+����sendfilev��Solaris 8 7/01+����
�ļ�AIO��FreeBSD 4.3+, Linux 2.6.22+����
DIRECTIO (FreeBSD 4.4+, Linux 2.4+, Solaris 2.6+, Mac OS X);
֧��Accept-filters��FreeBSD 4.1+, NetBSD 5.0+���� TCP_DEFER_ACCEPT��Linux 2.4+����
10000���ǻ�Ծ��HTTP keep-alive���ӽ�ռ��Լ2.5M�ڴ棻
�����ܱ������ݿ���������



Tengine�̳�Nginx-1.8.1���������ԣ�����Nginx�����ã�

Tengine������⣺
1����̬ģ����أ�DSO��֧�֡�����һ��ģ�鲻����Ҫ���±�������Tengine��
���ģ����Ҫ����������ʱ��̬����ģ�飬������ÿ�ζ�Ҫ���±���Tengine.
�������Ҫ����ٷ�ģ��Ϊ��̬ģ�飬����Ҫ��configure��ʱ���������������ָ��(--with-http_xxx_module),./configure --help���Կ��������ϸ��.
���ֻ��Ҫ��װ�ٷ�ģ��Ϊ��̬ģ��(����װNginx)����ô��ֻ��Ҫconfigure֮��ִ�� make dso_install����.
��̬����ģ��ĸ�������Ϊ128��.
����Ѿ����صĶ�̬ģ�����޸ģ���ô��������Tengine�Ż���Ч.
ֻ֧��HTTPģ��.
ģ�� ��Linux/FreeeBSD/MacOS�²��Գɹ�.
������http://tengine.taobao.org/document_cn/dso_cn.html


2��֧��HTTP/2Э�飬HTTP/2ģ�����SPDYģ�飻
Tengine��SPDYģ������SPDY/3Э���֧�֡�
������http://tengine.taobao.org/document_cn/ngx_http_spdy_module_cn.html


3����ʽ�ϴ���HTTP��˷�������FastCGI���������������ٻ�����I/Oѹ����
����﷨��client_body_postpone_size
����proxy_request_buffering��fastcgi_request_bufferingָ�
���ò���������body������ʱ��tengineÿ�����ܵ�����client_body_postpone_size��С�����ݻ����������󶼷�����ϣ�
�Ż�����˷������ݡ�����Լ������˷�����������������������������IO�Ĵ�����


4������ǿ��ĸ��ؾ�������������һ����hashģ�顢�Ự����ģ�飬�����ԶԺ�˵ķ�������������������飬���ݷ�����״̬�Զ��������ߣ��Լ���̬����upstream�г��ֵ�������
һ����hashģ�飺
���ģ���ṩһ����hash��Ϊ���ؾ����㷨��
��ģ��ͨ��ʹ�ÿͻ�����Ϣ(�磺$ip, $uri, $args�ȱ���)��Ϊ������ʹ��һ����hash�㷨���ͻ���ӳ�䵽��˻���
�����˻���崻���������ᱻǨ�Ƶ���������
server id �ֶΣ��������id�ֶΣ���ʹ��id�ֶ���Ϊserver��ʶ������ʹ��server ip�Ͷ˿���Ϊserver��ʶ��
ʹ��id�ֶο����ֶ�����server�ı�ʶ������һ̨������ip���߶˿ڱ仯��id��Ȼ���Ա�ʾ��̨������ʹ��id�ֶ�
���Լ�������������ʱhash�Ĳ�����
server weight �ֶΣ���ΪserverȨ�أ���Ӧ����ڵ���Ŀ
�����㷨����ÿ��server�����n���ڵ㣬���ȷֲ���hash���ϣ�ÿ�����󣬸������õĲ��������һ��hashֵ����hash��
�ϲ��������hash���������ڵ㣬��Ӧ��server��Ϊ�ô�����ĺ�˻�����
��ģ����Ը������ò�����ȡ��ͬ�ķ�ʽ���������ӳ�䵽��˻��������磺
consistent_hash $remote_addr�����Ը��ݿͻ���ipӳ��
consistent_hash $request_uri�� ���ݿͻ��������uriӳ��
consistent_hash $args�����ݿͻ���Я���Ĳ�������ӳ��
������http://tengine.taobao.org/document_cn/http_upstream_consistent_hash_cn.html


�Ự����ģ�飺
ngx_http_upstream_session_sticky_module
��ģ����һ�����ؾ���ģ�飬ͨ��cookieʵ�ֿͻ������˷������ĻỰ����, ��һ�������¿��Ա�֤ͬһ���ͻ��˷��ʵĶ���ͬһ����˷�������
����﷨��session_sticky ��session_sticky_hide_cookie?
������http://tengine.taobao.org/document_cn/http_upstream_session_sticky_cn.html


�������ģ�飺
ngx_http_upstream_check_module
��ģ�����ΪTengine�ṩ����ʽ��˷������������Ĺ��ܡ�
��ģ����Tengine-1.4.0�汾��ǰû��Ĭ�Ͽ����������������ñ���ѡ���ʱ������
./configure --with-http_upstream_check_module
����﷨��check��check_keepalive_requests ��check_http_send ��check_http_expect_alive?
check_shm_size ��check_status ��
������http://tengine.taobao.org/document_cn/http_upstream_check_cn.html


��̬��������ģ�飺
ngx_http_upstream_dynamic_module
��ģ���ṩ��������ʱ��̬����upstream��server�����Ĺ��ܡ�
����﷨��dynamic_resolve?
������http://tengine.taobao.org/document_cn/http_upstream_dynamic_cn.html




5���������������֧�֡�ͨ��ʹ�����ֻ���WebӦ�÷���ǽ�ı�д��Ϊ���㣻




6��֧������proxy��memcached��fastcgi��scgi��uwsgi�ں��ʧ��ʱ�����Դ���
����ÿ������Ժ�˷��������ʵ�����Դ�����֧��proxy��memcached��fastcgi��scgi��uwsgiģ�顣
����﷨��fastcgi_upstream_tries ��proxy_upstream_tries ��memcached_upstream_tries ��
scgi_upstream_tries ��uwsgi_upstream_tries?
������http://tengine.taobao.org/document_cn/ngx_limit_upstream_tries_cn.html




7����̬�ű�����Lua֧�֡���չ���ܷǳ���Ч�򵥣�
��v0.5.0rc32�汾��ʼ������*_by_lua_file����ָ���content_by_lua_file����֧��ֱ�Ӽ���Lua 5.1��LuaJIT 2.0 / 2.1ԭʼ�ֽ����ļ���


��ע�⣬LuaJIT 2.0 / 2.1ʹ�õ��ֽ����ʽ���׼Lua 5.1��������ʹ�õ��ֽ����ʽ�����ݡ���ˣ����ʹ��LuaJIT 2.0 / 2.1��ngx_lua�����������LuaJIT���ݵ��ֽ����ļ�
/ path / to / luajit / bin / luajit -b /path/to/input_file.lua /path/to/output_file.luac

��-bgѡ������ڽ�������Ϣ������LuaJIT�ֽ����ļ��У�
/ path / to / luajit / bin / luajit -bg /path/to/input_file.lua /path/to/output_file.luac

-b�й���ϸ��Ϣ������Ĺٷ�LuaJIT�ĵ���
http://luajit.org/running.html#opt_b


���⣬LuaJIT 2.1���ɵ��ֽ����ļ���LuaJIT 2.0 �����ݣ���֮��Ȼ����ngx_lua v0.9.3���״�����˶�LuaJIT 2.1�ֽ����֧�֡�
���Ƶأ����ʹ�ô���ngx_lua�ı�׼Lua 5.1�������������ʹ��luac������ʵ�ó�������Lua�����ֽ����ļ���������ʾ��
luac -o /path/to/output_file.luac /path/to/input_file.lua

��LuaJIT��ͬ��Ĭ������£�������Ϣ�����ڱ�׼Lua 5.1�ֽ����ļ��С������ͨ��ָ��-s��ʾ��ѡ�������������
luac -s -o /path/to/output_file.luac /path/to/input_file.lua


���Խ���׼Lua 5.1�ֽ����ļ����ص����ӵ�LuaJIT 2.0 / 2.1��ngx_luaʵ���У���֮��Ȼ��������һ��������Ϣ�������ģ���¼��Nginx error.log�ļ��У�
[error] 13909#0: *1 failed to load Lua inlined code: bad byte-code header in /path/to/test_file.luac
ͨ��Luaԭ������ֽ����ļ���require����dofileӦ�����ǰ�Ԥ�ڹ�����


8��֧�ְ�ָ���ؼ���(������url��)�ռ�Tengine����״̬��
����״̬ģ�飺
ngx_http_reqstat_module
���ģ����㶨��ı��������ݱ���ֵ�ֱ�ͳ��Tengine������״����
���Լ��ӵ�����״���У�����������������������Ӧ�뷶Χ�����������������������rt��upstream���ʵȡ�
����ָ����ȡ���м�ؽ������һ���ּ�ؽ����
���ñ�������Զ�����״̬���ܵļ��״̬������Ϊ50����
���չ��ڵļ�����ݡ�
���������ʽ
�������󣬲����ڲ���ת��Ӱ��
��Ҫʹ������Ӧ��صı�����Ϊ����������"$status"
����﷨��req_status_zone ��req_status��req_status_show��req_status_show_field��
req_status_zone_add_indecator��req_status_zone_key_length��req_status_zone_recycle
������http://tengine.taobao.org/document_cn/http_reqstat_cn.html




9����϶��CSS��JavaScript�ļ��ķ���������һ������
�ϲ�����ģ�飺
ngx_http_concat_module
��ģ��������apache�е�mod_concatģ�飬���ںϲ�����ļ���һ����Ӧ�����С�
����﷨��concat ��concat_types ��concat_unique ��concat_max_files ��concat_delimiter ��
concat_ignore_file_error ��
������http://tengine.taobao.org/document_cn/http_concat_cn.html


10���Զ�ȥ���հ��ַ���ע�ʹӶ���Сҳ������
trim ģ��
��ģ������ɾ�� html����Ƕ javascript �� css �е�ע���Լ��ظ��Ŀհ׷���
����﷨��trim ��trim_js ��trim_css ��trim_types ��
������http://tengine.taobao.org/document_cn/http_trim_filter_cn.html


11���Զ�����CPU��Ŀ���ý��̸����Ͱ�CPU��Ե�ԣ�


12�����ϵͳ�ĸ��غ���Դռ�ôӶ���ϵͳ���б�����
���ģ�飻
ngx_http_sysguard_module
��swap��ʣ��ٷֱȣ�ʣ�µ��ڴ棬loadֵ��ƽ����Ӧʱ�䵽�趨��ֵʱ���ͻ���ת��action��ָ����url��
����﷨��sysguard ��sysguard_load ��sysguard_mem ��sysguard_rt ��sysguard_mode ��
sysguard_interval ��sysguard_log_level?
������http://tengine.taobao.org/document_cn/http_sysguard_cn.html


13����ʾ����ά��Ա���Ѻõĳ�����Ϣ�����ڶ�λ���������
ģ�飺
ngx_http_footer_filter_module
���������Ӧĩβ���һ�����ݡ�������ݿ����ã���֧����Ƕ������
����﷨��footer footer_types?
������http://tengine.taobao.org/document_cn/http_footer_filter_cn.html


14����ǿ��ķ������������ٶ����ƣ�ģ�飻
����ģ�飺
ngx_http_limit_req_module
����﷨��
limit_req_log_level����Nginx��ͬ��
limit_req_zone����ԭnginx֧�ֶ��������֧�ֶ��limit_req_zone���ã�
limit_req��֧�ֿ��أ�Ĭ���Ǵ�״̬������һ��location֧�ֶ��limit_reqָ����ж��limit_reqָ��Ļ���
��Щָ���ǻ�Ĺ�ϵ��Ҳ���ǵ���������һ�����Ʊ���������ִ�ж�Ӧ��limit_req��
forbid_action��ʾ������������ʱ��nginx��Ҫִ�еĶ�����֧��name location��ҳ��(/)��Ĭ���Ƿ���503����
limit_req_whitelist ����������
������http://tengine.taobao.org/document_cn/http_limit_req_cn.html


15��������������в��������г������ģ���б�֧�ֵ�ָ��ȣ�
'-m' ѡ��
��ʾ���б����ģ�飬��1.4.0������Tengine֧�ֶ�̬ģ�飬static��ʾ��̬���룬shared��ʾ��̬����(����ӵ��Ƕ�̬ģ��İ汾)��
'-l' ѡ��
��ʾ����֧�ֵ�ָ�
'-d' ѡ��
��������ļ������ݣ�����'include'�����ݣ�
������http://tengine.taobao.org/document_cn/commandline_cn.html


16�����Ը��ݷ����ļ��������ù���ʱ�䣻
