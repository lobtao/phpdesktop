<?php
/**
 * Created by PhpStorm.
 * User: lobtao
 * Date: 2018/9/3
 * Time: 10:38
 */

namespace Home\Controller;

use app\service\Curl;
use app\service\TestService;
use Think\Controller;

class WsController extends Controller{
    public function index(){
        //echo 'hello websocket，远思软件欢迎您！'.I('data');
        //echo '收到消息:'.I('data');
        print_r($_SERVER);
//        echo file_get_contents("php://input");
    }
}