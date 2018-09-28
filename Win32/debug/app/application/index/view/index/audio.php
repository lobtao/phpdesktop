{extend name="layout" /}
{block name="title"}Flash播放音频{/block}

{block name="body"}

<div style="padding: 15px">
    <blockquote class="layui-elem-quote">
        <p>音频示例：<em>Flash播放音频</em></p>
    </blockquote>
<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="300" height="20"
        codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab">
    <param name="movie" value="EasyMp3Player.swf?file=http://rm.sina.com.cn/wm/VZ2010050511043310440VK/music/MUSIC1005051622027270.mp3&autoStart=true&backColor=000000
&frontColor=ffffff&songVolume=90" />
    <param name="wmode" value="transparent" />
    <embed wmode="transparent" width="300" height="20" src="__STATIC__/player/EasyMp3Player.swf?file=http://rm.sina.com.cn/wm/VZ2010050511043310440VK/music/MUSIC1005051622027270.mp3&autoStart=true&backColor=000000
&frontColor=ffffff&songVolume=90"
           type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
</object>
</div>
{/block}
