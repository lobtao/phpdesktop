<?php
/**
 * Created by PhpStorm.
 * User: lobtao
 * Date: 2018/8/25
 * Time: 10:33
 */

require_once __DIR__ . '/vendor/autoload.php';
use Workerman\Worker;

// #### http worker ####
$http_worker = new Worker("http://127.0.0.1:2345");

// 4 processes
$http_worker->count = 4;

// Emitted when data received
$http_worker->onMessage = function($connection, $data) use($http_worker)
{

    //print_r($_SERVER);
    print_r($_REQUEST);
    // $_GET, $_POST, $_COOKIE, $_SESSION, $_SERVER, $_FILES are available
    // var_dump($_GET, $_POST, $_COOKIE, $_SESSION, $_SERVER, $_FILES);
    // send data to client
    echo '远思软件'.PHP_EOL;
    // Worker::log('远思软件'.PHP_EOL);
    // throw  new Exception('远思软件');
    $connection->send("hello world \n");
};



// run all workers
Worker::runAll();
