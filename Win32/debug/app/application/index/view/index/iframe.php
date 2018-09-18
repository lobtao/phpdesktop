{extend name="layout" /}
{block name="title"}窗口间消息通讯{/block}
{block name="body"}
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
{/block}
