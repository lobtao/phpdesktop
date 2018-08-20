<?php
namespace app\service;
/**
 * Created by PhpStorm.
 * User: lobtao
 * Date: 2018-07-18
 * Time: 16:36
 */
class TestService
{
    function test($params) {
        $params['sex'] = '男';
        $params['rand'] = rand(100, 200);
        return $params;
    }
}