{extend name="layout" /}

{block name="title"}php_desktop示例{/block}

{block name="body"}
<div class="layui-side layui-bg-black">
    <div class="layui-side-scroll">
        <ul class="layui-nav layui-nav-tree layui-inline" lay-filter="user">
            <li class="layui-nav-item" data-url="<?= url('index/audio1') ?>"><a href="javascript:;"> <i
                            class="icon icon-volume-up"></i> 音频播放1 </a></li>
            <li class="layui-nav-item layui-this" data-url="http://music.taihe.com/song/537201076?pst=sug"><a href="javascript:;"> <i
                            class="icon icon-volume-up"></i> 音频播放2 </a></li>
            <li class="layui-nav-item" data-url="<?= url('index/video1') ?>"><a href="javascript:;"> <i
                            class="icon icon-film"></i> 视频播放1 </a>
            </li>
            <li class="layui-nav-item" data-url="https://www.bilibili.com/video/av11539082/"><a href="javascript:;"> <i
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
            <li class="layui-nav-item " data-url="<?= url('index/sqlite') ?>"><a href="javascript:;"> <i class="icon icon-server"></i> Sqlite </a></li>
        </ul>
    </div>
</div>

<div class="frameCls">
    <iframe class="frameContent" src="http://music.taihe.com/song/537201076?pst=sug" frameborder="0"></iframe>
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

