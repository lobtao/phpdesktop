<?php

namespace app\index\controller;

use think\Config;
use think\Controller;
use think\Db;
use think\exception\HttpException;

class Index extends Controller
{
    public function index() {
//        U('index/index');
        return $this->fetch('index', [
            'name' => 'hello 远思软件1',
            'sex'  => '男',
        ]);
    }

    function audio1() {
        return $this->fetch('audio');
    }

    function audio2() {
        $this->redirect('http://www.kugou.com/song/70n9db.html?frombaidu#hash=089B020FBCCE50716835341067B91EAA&album_id=0');
    }

    function video1() {
        return $this->fetch('video');
    }

    function video2() {
        $this->redirect('http://haokan.baidu.com/v?pd=wisenatural&vid=2553205947188257144');
    }

    function link() {
        return $this->fetch();
    }

    function form() {
        return $this->fetch();
    }

    function worker() {
        return $this->fetch();
    }

    function file() {
        //die('test');//会导致当前进程重启
        throw new \Exception("出错了，兄弟");//在php7.0+会抛出异常，php7.0以下，会导致进程重启        
        return $this->fetch();
    }

    public function msg1() {
        return $this->fetch();
    }

    function msg2() {
        return $this->fetch();
    }

    function iframe() {
        return $this->fetch();
    }

    function http() {
        return 'http返回字符串';
    }

    function sqlite_data() {
        $page       = input('page', 1);
        $limit      = input('limit', 3);
        $iCount     = Db::table('Employees')->count();
        $iPageCount = ceil($iCount / $limit);
        $page       = $page > $iPageCount && $iPageCount > 0 ? $iPageCount : $page;
        $ds         = Db::table('Employees')->field('EmployeeID,FirstName,LastName,Title,BirthDate,City')->page($page, $limit)->cache(10)->select();
        //$ds = Db::query('select EmployeeID,FirstName,LastName,Title,BirthDate,City from Employees');
        $data = [
            "code"  => 0,
            "msg"   => "",
            "count" => $iCount,
            "data"  => $ds,
        ];
        return json($data, JSON_UNESCAPED_UNICODE);
    }

    function sqlite() {
        return $this->fetch('index/sqlite');
    }

    /**
     * 测试curl是否启用
     * @return string
     */
    function curl() {
        // 1. 初始化
        $ch = curl_init();
        // 2. 设置选项，包括URL
        curl_setopt($ch, CURLOPT_URL, "http://www.baidu.com");
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_HEADER, 0);
        // 3. 执行并获取HTML文档内容
        $output = curl_exec($ch);
        if ($output === FALSE) {
            return "CURL Error:" . curl_error($ch);
        } else {
            return htmlspecialchars($output);
        }
        // 4. 释放curl句柄
        curl_close($ch);
    }

    function delay() {
        sleep(20);
        return 'sleep over';
    }

    function iswait() {
        return 'no wait';
    }


}
