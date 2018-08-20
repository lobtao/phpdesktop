<?php
// $arr = array(
//     'name' => '肖滔',
//     'sex'  => '男'
// );
// var_dump($arr);
// echo '<hr>GET：';
// var_dump($_GET);
// echo '<hr>SERVER：';
// var_dump($_SERVER);
// echo '<hr>';
// echo 'hello，远思软件' . rand(100, 999);
// echo '<hr>';



require __DIR__ .'/Curl.php';

use lobtao\tp5helper\Curl;

$curl = new Curl();
//get http://example.com/
//?{"sql":"select * from employee where EmpNo>:EmpNo","params":{"EmpNo":140}}
//$response = $curl->get('http://127.0.0.1:9981/');
$iRand = rand(1,140);
$response = $curl->setPostParams(array(
    'sqlData'=>'{"sql":"select * from employee where EmpNo>:EmpNo","params":{"EmpNo":'.$iRand.'}}'
    // 'sqlData'=>'{"sql":"select * from employee where EmpNo>:EmpNo","params":{"EmpNo":140}}'
))->post('http://127.0.0.1:9036/');

if ($curl->errorCode === null) {
    echo $response;
}

// $_SERVER['name'] = '我是server';

//在session开启前制定当前sessionID
// if (!empty($_GET['PHPSESSID']))
//     session_id($_GET['PHPSESSID']);
// session_start();
// $_SESSION['name'] = '我是远思软件1';
// $_SESSION['sex'] = '男1';

// $_COOKIE['name'] = '我是cookie';

// echo calc(1,2);
echo '<hr>hello<hr>';
// echo open('{"sql":"select * from employee where EmpNo>:EmpNo","params":{"EmpNo":140}}');