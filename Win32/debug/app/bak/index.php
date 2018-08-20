<?php

require __DIR__ . '/vendor/autoload.php';

function callFunc($func, $args) {
    $params = explode('_', $func, 2);
    if (count($params) != 2) throw new \Exception('请求参数错误');

    $svname = ucfirst($params[0]);
    $classname = 'app\\service\\' . $svname . 'Service';;
    $funcname = $params[1];
    if (!class_exists($classname)) throw new \Exception('类' . $svname . '不存在！！！');
    $object = new $classname();
    if (!method_exists($object, $funcname)) throw new \Exception($svname . '中不存在' . $funcname . '方法');
    $data = call_user_func_array(array($object, $funcname), $args);
    return $data;
}

$ret = callFunc($_GET['f'], json_decode($_GET['p'], true));
echo json_encode($ret);