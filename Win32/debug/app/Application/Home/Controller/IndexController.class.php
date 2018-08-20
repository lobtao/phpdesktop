<?php
namespace Home\Controller;

use app\service\Curl;
use app\service\TestService;
use Think\Controller;

class IndexController extends Controller
{
    public function index() {
        $this->show();
    }

    function test() {
        $test = new TestService();
        $data = $test->test(array('name' => '我是测试参数'));
        echo '<pre>';
        print_r($data);
        echo '</pre>';
    }

    function session() {
        session('name', 'yssoft');
        echo 'name='.session('name') . '<hr>';
        echo 'session_id='.session_id() . '<hr>';
        echo '<pre>';
        print_r($_GET);
        echo '</pre>';
    }

    function curl(){
        $curl = new Curl();
        //get http://example.com/
        //?{"sql":"select * from employee where EmpNo>:EmpNo","params":{"EmpNo":140}}
        //$response = $curl->get('http://127.0.0.1:9981/');
        $iRand = rand(1,140);
        $response = $curl->setPostParams(array(
            'sqlData'=>'{"sql":"select * from employee where EmpNo>:EmpNo","params":{"EmpNo":'.$iRand.'},"type":0}'
            // 'sqlData'=>'{"sql":"select * from employee where EmpNo>:EmpNo","params":{"EmpNo":140}}'
        ))->post('http://127.0.0.1:46151/');

        if ($curl->errorCode === null) {
            echo $response;
        }
    }

    function phpinfo(){
        phpinfo();
    }
}