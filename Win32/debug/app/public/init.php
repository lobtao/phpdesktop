<?php

$work_path           = iconv('GBK', 'utf-8', __DIR__);
$nginx_conf_path     = dirname(dirname($work_path)) . '\nginx_1.14.2\conf';
$nginx_conf_tpl_text = file_get_contents($nginx_conf_path . '\nginx.tpl');
$nginx_conf_tpl_text = str_replace('{$root}', $work_path, $nginx_conf_tpl_text);

file_put_contents($nginx_conf_path.'\nginx.conf', $nginx_conf_tpl_text);
