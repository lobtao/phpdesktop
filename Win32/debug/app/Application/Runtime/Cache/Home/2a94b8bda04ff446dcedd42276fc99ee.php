<?php if (!defined('THINK_PATH')) exit();?><!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta charset="UTF-8">
    <title>PHP开发桌面应用</title>

    <style type="text/css">

        * {
            padding: 0;
            margin: 0;
            /*设置文字不能被选中     以下为css样式*/
            /*-webkit-user-select: none;
            -moz-user-select: none;
            -ms-user-select: none;
            user-select: none;*/
        }

        div {
            padding: 4px 48px;
        }

        body {
            background: #fff;
            font-family: "微软雅黑";
            color: #333;
            font-size: 24px
        }

        h1 {
            font-size: 100px;
            font-weight: normal;
            margin-bottom: 12px;
        }

        p {
            line-height: 1.8em;
            font-size: 36px
        }

        a, a:hover {
            color: blue;
        }</style>

</head>
<body>

<div style="padding: 24px 48px;"><h1>:)</h1>

    <p>欢迎使用 <b>ThinkPHP</b>！</p><br/>版本 V<?php echo (THINK_VERSION); ?>
</div>

<div>
    QQ交流群：423332770 <br>
    作者QQ：137727966
</div>

<div>
    <a href="<?php echo U('index/test', array('name'=>'远思软件'));?>" target="_blank">test链接</a>
    <a href="<?php echo U('index/session', array('name'=>'远思软件'));?>">session链接</a>
    <a href="<?php echo U('index/curl');?>">数据库查询</a>
    <br>
    <a href="https://v.youku.com/v_show/id_XMzA4OTg3Njc1Mg==.html?spm=a2h0k.11417342.soresults.dtitle" target="_blank">视频1</a>
    <a href="http://haokan.baidu.com/v?pd=wisenatural&vid=2553205947188257144" target="_blank">视频2</a>
    <a href="http://music.taihe.com/song/601427388" target="_blank">音频1</a>
    <a href="http://music.show160.com/252238" target="_blank">音频2</a>
    <a href="http://html5test.com" target="_blank">HTML5</a>
    <a href="<?php echo U('index/sqlite');?>" target="_blank">sqlite</a>
    <br>
    <button onclick="show()">打开远思</button>
    <button onclick="showmodal()">Modal打开百度</button>
    <button onclick="phpinfo()">phpinfo</button>
    <button onclick="onError()">PHP异常示例</button>
    <br><br>
    <hr>
    窗口间消息通讯 <br>
    <button onclick="onMsg1()">监听消息1</button>
    <button onclick="onMsg2()">监听消息2</button>
    <button onclick="sendMsg1()">发送消息1</button>
    <button onclick="sendMsg2()">发送消息2</button>
    <button onclick="sendMsg3()">发送消息3</button>

    <div id="dRet"></div>


    <hr>
    <a href="<?php echo U('index/input');?>"  target="_blank">表单测试</a>
</div>

<div id="timer">

</div>


<script src="Public/static/jquery-1.12.4.min.js"></script>
<script src="Public/static/service.js"></script>
<script>
    var client = client('http://127.0.0.1:46150/index.php?m=home&c=service&a=index');

    function myFunction() {
        alert(app.myfunc());
    }

    function show() {
        //app.show('http://yssoft.cn', 800, 600);//
        window.open("http://yssoft.cn", "", 'width=800,height=600')
    }

    function showmodal() {
        //app.showmodal('http://baidu.com', 800, 600);//
        window.open("http://baidu.com", "百度", 'width=800,height=600');
    }

    function onError() {
        window.open('<?php echo U("error/index",array(),true,true);?>', 'PHP异常示例', 'width=800,height=600');
    }

    function phpinfo() {
        //app.showmodal( 'http://127.0.0.1:46150/index.php?m=home&c=index&a=phpinfo', 800, 600);//
        window.open("http://127.0.0.1:46150/index.php?m=home&c=index&a=phpinfo");
    }

    //取得系统当前时间
    function getTime() {
        var myDate = new Date();
        var date = myDate.toLocaleDateString();
        var hours = myDate.getHours();
        var minutes = myDate.getMinutes();
        var seconds = myDate.getSeconds();
        return date + " " + hours + ":" + minutes + ":" + seconds; //将值赋给div
    }

    var timer = setInterval(function () {
        $('#timer').html(getTime());
        //console.log(getTime());
    }, 1000);


    client.invoke('test_curl', [{
        sqlData: {
            sql: "select * from employee where EmpNo>:EmpNo",
            params: {EmpNo: 140},
            type: 0
        }
    }]).then(function (ret) {
        console.log(ret)
    });

    client.invoke('test_curl', [{
        sqlData: {
            sql: "update employee set FirstName=:FirstName  where EmpNo>:EmpNo",
            params: {FirstName: "肖滔", EmpNo: 140},
            type: 1
        }
    }]).then(function (ret) {
        console.log(ret)
    });

    function onMsg1() {
        window.open('<?php echo U("index/msg1",array(),true,true);?>', '消息1', 'width=600,height=400');
    }

    function onMsg2() {
        window.open('<?php echo U("index/msg2",array(),true,true);?>', '消息2', 'width=600,height=400');
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
        }),'');
    }

    function sendMsg3() {
        app.sendMsg(JSON.stringify({
            msgID: 3,
            msg: '啦啦，消息1来了'
        }),'iframeTest');
    }

    $(function () {
        window.onMsg = function (aMsg) {

            var jsObj = JSON.parse(aMsg);
            if(jsObj.msgID == 0){
                $('#dRet').html( aMsg + '<br>' + $('#dRet').html() );
                console.log('我是主窗口: '+jsObj.msg);
            }
        }
    })
</script>
</body>
</html>