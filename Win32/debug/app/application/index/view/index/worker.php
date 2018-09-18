{extend name="layout" /}
{block name="title"}窗口间消息通讯{/block}
{block name="body"}

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
{/block}
