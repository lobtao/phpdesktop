<?php /*a:2:{s:80:"C:\work\niu_new_workerman\Win32\debug\app\application\index\view\index\index.php";i:1537279562;s:75:"C:\work\niu_new_workerman\Win32\debug\app\application\index\view\layout.php";i:1537279401;}*/ ?>
<!doctype html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>php_desktop示例</title>

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


<div class="layui-side layui-bg-black">
    <div class="layui-side-scroll">
        <ul class="layui-nav layui-nav-tree layui-inline" lay-filter="user">
            <li class="layui-nav-item" data-url="<?= url('index/audio1') ?>"><a href="javascript:;"> <i
                            class="icon icon-volume-up"></i> 音频播放1 </a></li>
            <li class="layui-nav-item layui-this" data-url="<?= url('index/audio2') ?>"><a href="javascript:;"> <i
                            class="icon icon-volume-up"></i> 音频播放2 </a></li>
            <li class="layui-nav-item" data-url="<?= url('index/video1') ?>"><a href="javascript:;"> <i
                            class="icon icon-film"></i> 视频播放1 </a>
            </li>
            <li class="layui-nav-item" data-url="<?= url('index/video2') ?>"><a href="javascript:;"> <i
                            class="icon icon-film"></i> 视频播放2 </a>
            </li>
            <li class="layui-nav-item " data-url="<?= url('index/link') ?>"><a href="javascript:;"> <i
                            class="icon icon-underline"></i> 链接跳转 </a></li>
            <li class="layui-nav-item " data-url="<?= url('index/form') ?>"><a href="javascript:;"><i
                            class="icon icon-laptop"></i> 窗口通讯 </a></li>
            <li class="layui-nav-item " data-url="<?= url('index/worker') ?>"><a href="javascript:;"> <i
                            class="icon icon-comments-alt"></i> Workerman </a>
            </li>
            <li class="layui-nav-item " data-url="<?= url('index/file') ?>"><a href="javascript:;"> <i
                            class="icon icon-copy"></i> 本地文件 </a></li>
        </ul>
    </div>
</div>

<div class="frameCls">
    <iframe class="frameContent" src="<?= url('index/audio2') ?>" frameborder="0"></iframe>
</div>

<script>

    var layer = layui.layer, form = layui.form;

    layer.msg('Hello World');

    $('.layui-nav li').click(function (event) {
        $('.layui-nav li').removeClass('layui-this');
        $(this).addClass('layui-this');
        $('.frameContent').attr('src', $(this).data('url'));
    });
</script>



</body>
</html>
