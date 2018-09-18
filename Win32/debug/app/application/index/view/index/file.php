{extend name="layout" /}
{block name="title"}窗口间消息通讯{/block}

{block name="body"}
<div style="padding: 20px">

    <div>
        <form method="post" id="fform" enctype="multipart/form-data" action="#">
            <p><input id="ffile" type="file" name="ffile" multiple/></p>
            <hr>
            <input class="layui-btn"  type="submit" value="提交"/>
        </form>
    </div>

    <div id="timer">

    </div>

</div>
<script>
    var FFileName = '';
    window.onFile = function (fileName) {
        FFileName = fileName;
        console.log(fileName);
    }

    $(function () {
        $('#ffile').change(function (ret) {
            alert(FFileName);
        })
    })
</script>
{/block}
