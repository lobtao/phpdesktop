{extend name="layout" /}
{block name="title"}链接示例{/block}

{block name="body"}
<div style="padding: 20px">
    <a class="layui-btn" href="javascript:window.open('http://baidu.com', '', 'width=900,height=700')" target="_blank">新窗口打开链接</a>
    <a class="layui-btn" href="http://baidu.com">当前窗口打开链接</a>
</div>
{/block}
