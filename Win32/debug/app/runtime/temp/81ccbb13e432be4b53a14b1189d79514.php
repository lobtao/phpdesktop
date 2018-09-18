<?php /*a:2:{s:81:"C:\work\niu_new_workerman\Win32\debug\app\application\index\view\index\worker.php";i:1537280808;s:75:"C:\work\niu_new_workerman\Win32\debug\app\application\index\view\layout.php";i:1537279401;}*/ ?>
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

    <a class="layui-btn" type="button" id="btHttp">http通讯</a>
    <a class="layui-btn" type="button" id="btWebsocket">WebSocket通讯</a>
    <hr>
    <div id="dResult"></div>
</div>
<script>
    $(function () {
        // http测试

        $('#btHttp').click(function () {
            $.get('<?=url('index/http');?>').then(function (ret) {
                console.log(ret);
                alert(ret)
            })
        });

        // websocket测试
        ws = new WebSocket("ws://127.0.0.1:2346");
        ws.onopen = function () {
            console.log("连接成功");
        };
        ws.onmessage = function (e) {
            console.log("收到WS服务端的消息：" + e.data);
            //
            var result = JSON.parse(e.data);
            switch (result.id) {
                case 0:
                    alert("收到WS服务端的消息：" + result.data);
                    break;
                case 1:
                    $('#dResult').prepend(result.data + '<br/>');
                    //$('#dResult').append(result.data+'<br/>');
                    //$('#dResult').html(result.data+'<br/>');
                    break;
            }
        };

        $('#btWebsocket').click(function () {
            ws.send('发送一个测试消息');
        })
    })
</script>


</body>
</html>
