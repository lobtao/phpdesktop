<?php
// +----------------------------------------------------------------------
// | ThinkPHP [ WE CAN DO IT JUST THINK IT ]
// +----------------------------------------------------------------------
// | Copyright (c) 2006-2018 http://thinkphp.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: liu21st <liu21st@gmail.com>
// +----------------------------------------------------------------------
namespace think\worker;

use RecursiveDirectoryIterator;
use RecursiveIteratorIterator;
use think\Facade;
use think\Loader;
use Workerman\Lib\Timer;
use Workerman\Protocols\Http as WorkerHttp;
use Workerman\Worker;

/**
 * Worker http server 命令行服务类
 */
class Http extends Server
{
    protected $app;
    protected $appPath;
    protected $root;
    protected $monitor;
    protected $lastMtime;
    protected $mimetyps = [
        'html'    => 'text/html',
        'htm'     => 'text/html',
        'shtml'   => 'text/html',
        'css'     => 'text/css',
        'xml'     => 'text/xml',
        'gif'     => 'image/gif',
        'jpeg'    => 'image/jpeg',
        'jpg'     => 'image/jpeg',
        'js'      => 'application/x-javascript',
        'atom'    => 'application/atom+xml',
        'rss'     => 'application/rss+xml',
        'mml'     => 'text/mathml',
        'txt'     => 'text/plain',
        'jad'     => 'text/vnd.sun.j2me.app-descriptor',
        'wml'     => 'text/vnd.wap.wml',
        'htc'     => 'text/x-component',
        'png'     => 'image/png',
        'tif'     => 'image/tiff',
        'tiff'    => 'image/tiff',
        'wbmp'    => 'image/vnd.wap.wbmp',
        'ico'     => 'image/x-icon',
        'jng'     => 'image/x-jng',
        'bmp'     => 'image/x-ms-bmp',
        'svg'     => 'image/svg+xml',
        'svgz'    => 'image/svg+xml',
        'webp'    => 'image/webp',
        'jar'     => 'application/java-archive',
        'war'     => 'application/java-archive',
        'ear'     => 'application/java-archive',
        'hqx'     => 'application/mac-binhex40',
        'doc'     => 'application/msword',
        'pdf'     => 'application/pdf',
        'ps'      => 'application/postscript',
        'eps'     => 'application/postscript',
        'ai'      => 'application/postscript',
        'rtf'     => 'application/rtf',
        'xls'     => 'application/vnd.ms-excel',
        'ppt'     => 'application/vnd.ms-powerpoint',
        'wmlc'    => 'application/vnd.wap.wmlc',
        'kml'     => 'application/vnd.google-earth.kml+xml',
        'kmz'     => 'application/vnd.google-earth.kmz',
        '7z'      => 'application/x-7z-compressed',
        'cco'     => 'application/x-cocoa',
        'jardiff' => 'application/x-java-archive-diff',
        'jnlp'    => 'application/x-java-jnlp-file',
        'run'     => 'application/x-makeself',
        'pl'      => 'application/x-perl',
        'pm'      => 'application/x-perl',
        'prc'     => 'application/x-pilot',
        'pdb'     => 'application/x-pilot',
        'rar'     => 'application/x-rar-compressed',
        'rpm'     => 'application/x-redhat-package-manager',
        'sea'     => 'application/x-sea',
        'swf'     => 'application/x-shockwave-flash',
        'sit'     => 'application/x-stuffit',
        'tcl'     => 'application/x-tcl',
        'tk'      => 'application/x-tcl',
        'der'     => 'application/x-x509-ca-cert',
        'pem'     => 'application/x-x509-ca-cert',
        'crt'     => 'application/x-x509-ca-cert',
        'xpi'     => 'application/x-xpinstall',
        'xhtml'   => 'application/xhtml+xml',
        'zip'     => 'application/zip',
        'bin'     => 'application/octet-stream',
        'exe'     => 'application/octet-stream',
        'dll'     => 'application/octet-stream',
        'deb'     => 'application/octet-stream',
        'dmg'     => 'application/octet-stream',
        'eot'     => 'application/octet-stream',
        'iso'     => 'application/octet-stream',
        'img'     => 'application/octet-stream',
        'msi'     => 'application/octet-stream',
        'msp'     => 'application/octet-stream',
        'msm'     => 'application/octet-stream',
        'mid'     => 'audio/midi',
        'midi'    => 'audio/midi',
        'kar'     => 'audio/midi',
        'mp3'     => 'audio/mpeg',
        'ogg'     => 'audio/ogg',
        'm4a'     => 'audio/x-m4a',
        'ra'      => 'audio/x-realaudio',
        '3gpp'    => 'video/3gpp',
        '3gp'     => 'video/3gpp',
        'mp4'     => 'video/mp4',
        'mpeg'    => 'video/mpeg',
        'mpg'     => 'video/mpeg',
        'mov'     => 'video/quicktime',
        'webm'    => 'video/webm',
        'flv'     => 'video/x-flv',
        'm4v'     => 'video/x-m4v',
        'mng'     => 'video/x-mng',
        'asx'     => 'video/x-ms-asf',
        'asf'     => 'video/x-ms-asf',
        'wmv'     => 'video/x-ms-wmv',
        'avi'     => 'video/x-msvideo',
    ];

    /**
     * 架构函数
     * @access public
     * @param  string $host 监听地址
     * @param  int    $port 监听端口
     * @param  array  $context 参数
     */
    public function __construct($host, $port, $context = [])
    {
        $this->worker = new Worker('http://' . $host . ':' . $port, $context);

        // 设置回调
        foreach ($this->event as $event) {
            if (method_exists($this, $event)) {
                $this->worker->$event = [$this, $event];
            }
        }
    }

    public function setRoot($root)
    {
        $this->root = $root;
    }

    public function setAppPath($path)
    {
        $this->appPath = $path;
    }

    public function setStaticOption($name, $value)
    {
        Worker::${$name} = $value;
    }

    public function setMonitor($interval = 2, $path = [])
    {
        $this->monitor['interval'] = $interval;
        $this->monitor['path']     = (array) $path;
    }

    /**
     * 设置参数
     * @access public
     * @param  array    $option 参数
     * @return void
     */
    public function option(array $option)
    {
        // 设置参数
        if (!empty($option)) {
            foreach ($option as $key => $val) {
                $this->worker->$key = $val;
            }
        }
    }

    /**
     * onWorkerStart 事件回调
     * @access public
     * @param  \Workerman\Worker    $worker
     * @return void
     */
    public function onWorkerStart($worker)
    {
        $this->app       = new Application($this->appPath);
        $this->lastMtime = time();

        $this->app->workerman = $worker;

        // 指定日志类驱动
        Loader::addClassMap([
            'think\\log\\driver\\File' => __DIR__ . '/log/File.php',
        ]);

        Facade::bind([
            'think\facade\Cookie'     => Cookie::class,
            'think\facade\Session'    => Session::class,
            facade\Application::class => Application::class,
            facade\Http::class        => Http::class,
        ]);

        // 应用初始化
        $this->app->initialize();

        $this->app->bindTo([
            'cookie'  => Cookie::class,
            'session' => Session::class,
        ]);

        if (0 == $worker->id && $this->monitor) {
            $paths = $this->monitor['path'] ?: [$this->app->getAppPath(), $this->app->getConfigPath()];
            $timer = $this->monitor['interval'] ?: 2;

            Timer::add($timer, function () use ($paths) {
                foreach ($paths as $path) {
                    $dir      = new RecursiveDirectoryIterator($path);
                    $iterator = new RecursiveIteratorIterator($dir);

                    foreach ($iterator as $file) {
                        if (pathinfo($file, PATHINFO_EXTENSION) != 'php') {
                            continue;
                        }

                        if ($this->lastMtime < $file->getMTime()) {
                            echo '[update]' . $file . "\n";
                            posix_kill(posix_getppid(), SIGUSR1);
                            $this->lastMtime = $file->getMTime();
                            return;
                        }
                    }
                }
            });
        }
    }

    /**
     * onMessage 事件回调
     * @access public
     * @param  \Workerman\Connection\TcpConnection    $connection
     * @param  mixed                                  $data
     * @return void
     */
    public function onMessage($connection, $data)
    {
        $uri  = parse_url($_SERVER['REQUEST_URI']);
        $path = isset($uri['path']) ? $uri['path'] : '/';

        $file = $this->root . $path;

        if (!is_file($file)) {
            $this->app->worker($connection, $data);
        } else {
            $this->sendFile($connection, $file);
        }
    }

    protected function sendFile($connection, $file)
    {
        $info        = stat($file);
        $modifiyTime = $info ? date('D, d M Y H:i:s', $info['mtime']) . ' ' . date_default_timezone_get() : '';

        if (!empty($_SERVER['HTTP_IF_MODIFIED_SINCE']) && $info) {
            // Http 304.
            if ($modifiyTime === $_SERVER['HTTP_IF_MODIFIED_SINCE']) {
                // 304
                WorkerHttp::header('HTTP/1.1 304 Not Modified');
                // Send nothing but http headers..
                return $connection->close('');
            }
        }

        $mimeType = $this->getMimeType($file);

        WorkerHttp::header('HTTP/1.1 200 OK');
        WorkerHttp::header('Connection: keep-alive');

        if ($mimeType) {
            WorkerHttp::header('Content-Type: ' . $mimeType);
        } else {
            WorkerHttp::header('Content-Type: application/octet-stream');
            $fileinfo = pathinfo($file);
            $filename = isset($fileinfo['filename']) ? $fileinfo['filename'] : '';
            WorkerHttp::header('Content-Disposition: attachment; filename="' . $filename . '"');
        }

        if ($modifiyTime) {
            WorkerHttp::header('Last-Modified: ' . $modifiyTime);
        }

        WorkerHttp::header('Content-Length: ' . filesize($file));

        ob_start();
        readfile($file);
        $content = ob_get_clean();

        return $connection->send($content);
    }

    /**
     * 获取文件类型信息
     * @access public
     * @return string
     */
    public function getMimeType($filename)
    {
        //think-worker官方的解析mimetype有问题
        // $finfo = finfo_open(FILEINFO_MIME_TYPE);
        // return finfo_file($finfo, $filename);

        $arrInfo = pathinfo($filename);
        $ext = $arrInfo[ 'extension' ];
        $info = array_key_exists($ext, $this->mimetyps) ? $this->mimetyps[ $ext ] : 'text/plain';
        return $info;
    }

    /**
     * 启动
     * @access public
     * @return void
     */
    public function start()
    {
        Worker::runAll();
    }

    /**
     * 停止
     * @access public
     * @return void
     */
    public function stop()
    {
        Worker::stopAll();
    }
}
