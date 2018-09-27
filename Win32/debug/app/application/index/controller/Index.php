<?php

namespace app\index\controller;

use think\Controller;
use think\exception\HttpException;

class Index extends Controller {
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
        $this->redirect('http://web.kugou.com/');
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

    function http(){
        return 'http返回字符串';
    }
}
