<?php

$app_dir             = dirname(iconv('GBK', 'utf-8', __DIR__));
$nginx_conf_path     = $app_dir . '\nginx_1.14.2\conf';
$nginx_conf_tpl_text = file_get_contents($nginx_conf_path . '\nginx.tpl');

$config_file         = $app_dir . '\config.json';
$config_content      = file_get_contents($config_file);
$arr_config          = json_decode($config_content, true);
$work_path           = $app_dir . '\\' . $arr_config['app_path'];

$nginx_conf_tpl_text = str_replace('{$root}', $work_path, $nginx_conf_tpl_text);

$nginx_config_file = $nginx_conf_path . '\nginx.conf';
if(file_exists($nginx_config_file)) unlink($nginx_config_file);
file_put_contents($nginx_config_file, $nginx_conf_tpl_text);