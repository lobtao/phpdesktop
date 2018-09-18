<?php
// +----------------------------------------------------------------------
// | ThinkPHP [ WE CAN DO IT JUST THINK IT ]
// +----------------------------------------------------------------------
// | Copyright (c) 2006-2018 http://thinkphp.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: liu21st <liu21st@gmail.com>
// +----------------------------------------------------------------------

// +----------------------------------------------------------------------
// | Workerman设置 仅对 php think worker:server 指令有效
// +----------------------------------------------------------------------
return [
    // 扩展自身需要的配置
    'protocol'       => 'websocket', // 协议 支持 tcp udp unix http websocket text
    'host'           => '0.0.0.0', // 监听地址
    'port'           => 2346, // 监听端口
    'socket'         => '', // 完整监听地址
    'context'        => [], // socket 上下文选项
    'worker_class'   => '', // 自定义Workerman服务类名

    // 支持workerman的所有配置参数
    'name'           => 'thinkphp',
    'count'          => 4,
    'daemonize'      => false,

    // 支持事件回调
    // onWorkerStart
    'onWorkerStart'  => function ($worker) {

    },
    // onWorkerReload
    'onWorkerReload' => function ($worker) {

    },
    // onConnect
    'onConnect'      => function ($connection) {
        echo "New connection\n";
        $timer = \Workerman\Lib\Timer::add(1, function () use ($connection) {
            $connection->send(json_encode(array(
                'id'   => 1,
                'data' => date('Y-m-d H:i:s', time()),
            )));
        });
    },
    // onMessage
    'onMessage'      => function ($connection, $data) {
        // Send hello $data
        //throw  new Exception('远思软件');
        $connection->send(json_encode(array(
            'id'   => 0,
            'data' => 'hello ' . $data,
        )));
    },
    // onClose
    'onClose'        => function ($connection) {
        echo "Connection closed\n";
    },
    // onError
    'onError'        => function ($connection, $code, $msg) {
        echo "error [ $code ] $msg\n";
    },
];
