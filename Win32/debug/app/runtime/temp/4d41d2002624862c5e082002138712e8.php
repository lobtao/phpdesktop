<?php /*a:2:{s:79:"C:\work\niu_new_workerman\Win32\debug\app\application\index\view\index\form.php";i:1537280432;s:75:"C:\work\niu_new_workerman\Win32\debug\app\application\index\view\layout.php";i:1537279401;}*/ ?>
<!doctype html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>窗口间消息通讯</title>

    <link rel="stylesheet" type="text/css" href="/static/layui/css/layui.css">
    <link rel="stylesheet" type="text/css" href="/static/zui_fonts/zenicon.css">
    <script type="text/javascript" src="/static/jquery-1.12.0.min.js"></script>
    <script type="text/javascript" src="/static/layui/layui.all.js"></script>

    <style>
        * {
            /*设置文字不能被选中     以下为css样式*/
            -webkit-user-select: none;
            -moz-user-select: none;
            -ms-user-select: none;
            user-select: none;
        }

        .layui-nav {
            border-radius: 0;
        }

        .layui-side {
            top: 0;
            width: 200px;
            overflow-x: hidden;
            background-color: #333 !important;
        }

        .layui-side-scroll {
            position: relative;
            width: 220px;
            height: 100%;
            overflow-x: hidden;
        }

        .frameCls{
            position: fixed;
            left: 200px;
            top: 0;
            bottom: 0;
            right: 0;
            z-index: 999;
        }

        .frameContent{
            height: 100%;
            width: 100%;
        }
        .layui-nav-tree .layui-nav-child dd.layui-this, .layui-nav-tree .layui-nav-child dd.layui-this a, .layui-nav-tree .layui-this, .layui-nav-tree .layui-this>a, .layui-nav-tree .layui-this>a:hover {
            background-color: #4974A4;
            color: #fff;
        }
    </style>
</head>
<body>


<div style="padding: 20px">
    <a class="layui-btn" onclick="onMsg1()">监听消息1</a>
    <a class="layui-btn" onclick="onMsg2()">监听消息2</a>
    <a class="layui-btn" onclick="sendMsg1()">发送消息1</a>
    <a class="layui-btn" onclick="sendMsg2()">发送消息2</a>
    <a class="layui-btn" onclick="sendMsg3()">发送消息3</a>
</div>


<script>
    function onMsg1() {
        window.open('<?=url("index/msg1",array(),true,true);?>', '消息1', 'width=600,height=400');
    }

    function onMsg2() {
        window.open('<?=url("index/msg2",array(),true,true);?>', '消息2', 'width=600,height=400');
    }

    function sendMsg1() {
        app.sendMsg(JSON.stringify({
            msgID: 1,
            msg: '啦啦，消息1来了'
        }), '');
    }

    function sendMsg2() {
        app.sendMsg(JSON.stringify({
            msgID: 2,
            msg: '啦啦，消息1来了'
        }), '');
    }

    function sendMsg3() {
        app.sendMsg(JSON.stringify({
            msgID: 3,
            msg: '啦啦，消息1来了'
        }), 'iframeTest');
    }

</script>


</body>
</html>
