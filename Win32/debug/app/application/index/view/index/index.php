{extend name="layout" /}

{block name="title"}php_desktop示例{/block}

{block name="body"}
<div class="layui-side layui-bg-black">
    <div class="layui-side-scroll">
        <ul class="layui-nav layui-nav-tree layui-inline" lay-filter="user">
            <li class="layui-nav-item layui-this" data-url="<?= url('index/audio1') ?>"><a href="javascript:;"> <i
                            class="icon icon-volume-up"></i> 音频播放1 </a></li>
            <li class="layui-nav-item " data-url="<?= url('index/link') ?>"><a href="javascript:;"> <i
                            class="icon icon-underline"></i> 链接跳转 </a></li>
            <li class="layui-nav-item " data-url="<?= url('index/form') ?>"><a href="javascript:;"><i
                            class="icon icon-laptop"></i> 窗口通讯 </a></li>
            <li class="layui-nav-item " data-url="<?= url('index/worker') ?>"><a href="javascript:;"> <i
                            class="icon icon-comments-alt"></i> Workerman </a>
            </li>
            <li class="layui-nav-item " data-url="<?= url('index/file') ?>"><a href="javascript:;"> <i
                            class="layui-icon layui-icon-face-surprised"></i> Exception </a></li>
            <li class="layui-nav-item " data-url="<?= url('index/curl') ?>"><a href="javascript:;"> <i
                            class="layui-icon layui-icon-download-circle"></i> Curl测试 </a></li>
            <li class="layui-nav-item " data-url="<?= url('index/sqlite') ?>"><a href="javascript:;"> <i class="icon icon-server"></i> Sqlite </a></li>
        </ul>
    </div>
</div>

<div class="frameCls">
    <iframe class="frameContent" src="<?= url('index/audio1') ?>" frameborder="0"></iframe>
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

{/block}

