{extend name="layout" /}
{block name="title"}窗口间消息通讯{/block}
{block name="body"}

<div style="padding: 20px">
    <a class="layui-btn" onclick="app.closeWin()">关闭窗口</a>
    <hr>
    监听消息2
    <div id="dRet"></div>
</div>
<script>
    $(function () {
        window.onMsg = function (aMsg) {

            var jsObj = JSON.parse(aMsg);
            if (jsObj.msgID == 2) {
                $('#dRet').html(aMsg + '<br>' + $('#dRet').html());
                console.log('我是消息2: ' + jsObj.msg);
            }
        }
    })
</script>
{/block}
