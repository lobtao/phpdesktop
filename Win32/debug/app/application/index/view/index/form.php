{extend name="layout" /}
{block name="title"}窗口间消息通讯{/block}

{block name="body"}
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
{/block}
