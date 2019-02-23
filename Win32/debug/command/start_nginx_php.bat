@echo off

cd ./command

set php_home=../php_7.0.9
set nginx_home=../nginx_1.14.2

REM Windows 下无效
REM set PHP_FCGI_CHILDREN=5

REM 每个进程处理的最大请求数，或设置为 Windows 环境变量
set PHP_FCGI_MAX_REQUESTS=1000

REM RunHiddenConsole.exe %php_home%/phpdesktop_php.exe init.php

echo Starting nginx...
RunHiddenConsole.exe %nginx_home%/phpdesktop_nginx.exe -p %nginx_home%

echo Starting PHP FastCGI...
RunHiddenConsole.exe phpdesktop_xxfpm.exe "%php_home%/phpdesktop_php-cgi.exe -c %php_home%/php.ini" -n 5 -i 127.0.0.1 -p 9000

cd ..

