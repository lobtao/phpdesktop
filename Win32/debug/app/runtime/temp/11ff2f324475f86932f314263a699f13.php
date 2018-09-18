<?php /*a:2:{s:81:"C:\work\niu_new_workerman\Win32\debug\app\application\index\view\index\iframe.php";i:1537280365;s:75:"C:\work\niu_new_workerman\Win32\debug\app\application\index\view\layout.php";i:1537279401;}*/ ?>
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
    我是iframe，在监听消息3
    <div id="dRet"></div>
</div>
<script>
    $(function () {
        window.onMsg = function (aMsg) {

            var jsObj = JSON.parse(aMsg);
            if (jsObj.msgID == 3) {
                $('#dRet').html(aMsg + '<br>' + $('#dRet').html());
                console.log('我是消息3: ' + jsObj.msg);
            }
        }
    })
</script>


</body>
</html>
