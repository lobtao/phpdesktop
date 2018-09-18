{extend name="layout" /}
{block name="title"}窗口间消息通讯{/block}
{block name="body"}
<div style="padding: 20px">
    监听消息1
    <div id="dRet"></div>

    <iframe src='<?= url("index/iframe", array(), true, true); ?>' frameborder="1" name="iframeTest" height="300"
            width="300"></iframe>
</div>
<script>
    $(function () {
        window.onMsg = function (aMsg) {

            var jsObj = JSON.parse(aMsg);
            if (jsObj.msgID == 1) {
                $('#dRet').html(aMsg + '<br>' + $('#dRet').html());
                console.log('我是消息1: ' + jsObj.msg);
            }
        }
    })
</script>
{/block}
