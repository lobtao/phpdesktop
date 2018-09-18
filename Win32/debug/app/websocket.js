// 假设服务端ip为127.0.0.1
ws = new WebSocket("ws://127.0.0.1:2346");
ws.onopen = function() {
    console.log("连接成功");
    ws.send('tom');
    console.log("给服务端发送一个字符串：tom");
};
ws.onmessage = function(e) {
    console.log("收到服务端的消息：" + e.data);
};