{extend name="layout" /}
{block name="title"}查询Employees表{/block}

{block name="body"}

<div style="padding: 15px">
    <blockquote class="layui-elem-quote">
        <p>Sqlite示例：<em>查询Employees表</em></p>
    </blockquote>
    <table class="layui-hide" id="test"></table>
</div>
<script>
    var table = layui.table;

    table.render({
        elem: '#test'
        , url: '<?=url('index/sqlite_data')?>'
        , cellMinWidth: 80 //全局定义常规单元格的最小宽度，layui 2.2.1 新增
        , size: 'sm'
        , even: true
        , height: 'full-125'
        , limits: [3, 6, 9]
        , limit: 3
        , page: true //开启分页
        , cols: [[
            {field: 'EmployeeID', width: 120, title: 'EmployeeID', sort: true},
            {field: 'FirstName', width: 120, title: 'FirstName', sort: true},
            {field: 'LastName', width: 120, title: 'LastName', sort: true},
            {field: 'Title', width: 150, title: 'Title', sort: true},
            {field: 'BirthDate', width: 150, title: 'BirthDate', sort: true},
            {field: 'City', width: 150, title: 'City', sort: true},
        ]]
    });
</script>
{/block}
