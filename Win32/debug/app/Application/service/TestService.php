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
        return $GLOBALS;
        return $params;
    }

    function curl($params){
        $curl = new Curl();
        //$iRand = rand(1,140);
        $response = $curl->setPostParams(array(
            'sqlData'=>json_encode($params['sqlData'])
        ))->post('http://127.0.0.1:46151/');
        if ($curl->errorCode === null) {
            return json_decode($response, true);
        }else{
            return array();
        }
    }
}