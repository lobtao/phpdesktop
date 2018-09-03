unit unConfig;

interface

uses utils_dvalue, utils_dvalue_json, StrUtils, SysUtils, Messages,
  uCEFConstants, Forms, Windows;

const
  // APP响应消息
  YS_BROWSER_APP_SHOWDEVTOOLS = WM_APP + $101; // 显示开发工具
  YS_BROWSER_APP_HIDEDEVTOOLS = WM_APP + $102; // 隐藏开发工具
  YS_BROWSER_APP_REFRESH = WM_APP + $103; // 刷新
  YS_BROWSER_APP_SHOW = WM_APP + $104; // 显示窗口
  YS_BROWSER_APP_SHOWMODAL = WM_APP + $105; // modal显示窗口
  YS_BROWSER_APP_PHPERROR = WM_APP + $106; // php异常消息
  YS_BROWSER_APP_PHPLOG = WM_APP + $107; // 显示PHP日志
  YS_BROWSER_APP_WINDOW_MSG = WM_APP + $108; // 窗口间消息传递

  // 右键菜单发送消息
  YS_BROWSER_CONTEXTMENU_SHOWDEVTOOLS = MENU_ID_USER_FIRST + 1; // 显示开发工具
  YS_BROWSER_CONTEXTMENU_HIDEDEVTOOLS = MENU_ID_USER_FIRST + 2; // 隐藏开发工具
  YS_BROWSER_CONTEXTMENU_REFRESH = MENU_ID_USER_FIRST + 3; // 刷新
  YS_BROWSER_CONTEXTMENU_PHPLOG = MENU_ID_USER_FIRST + 4; // 显示PHP日志

  // 拓展发送消息
  YS_BROWSER_EXTENSION_SHOW = 'extension_show'; // 显示窗口
  YS_BROWSER_EXTENSION_SHOWMODAL = 'extension_showmodal'; // modal显示窗口
  YS_BROWSER_EXTENSION_WINDOW_MSG = 'windows_msg';

var
  FIndexUrl: string; // 主程序网址
  FAppPath: string; // 应用目录
  FSkinFile: string; // 皮肤文件路径
  FDataBaseFile: string; // 数据库文件路径
  FDebug: Integer; // 是否开启调试模式
  FWidth: Integer; // 主窗口宽度
  FHeight: Integer; // 主窗口高度
  FCaption: string; // 主窗口标题
  FHost: string; // 监听IP
  FDataPort: Integer; // 数据库端口
  FWebPort: Integer; // web端口
  FWsPort: Integer; // websocket服务端口
  FWsPHPUrl: string; // websocket服务处理PHP路径

  // php服务器

procedure create_php_server(); stdcall; external 'server_php.dll';

procedure php_server_start(iPort: Integer; logHandle: HWND); stdcall;
external 'server_php.dll';

procedure php_server_stop(); stdcall; external 'server_php.dll';

procedure free_php_server(); stdcall; external 'server_php.dll';

// abs数据库服务器

procedure create_db_server(); stdcall; external 'server_db.dll';

procedure db_server_start(iPort: Integer); stdcall; external 'server_db.dll';

procedure db_server_stop(); stdcall; external 'server_db.dll';

procedure free_db_server(); stdcall; external 'server_db.dll';

// websocket服务器
procedure create_ws_server(); stdcall; external 'server_ws.dll';

procedure ws_server_start(iPort: Integer;iHttpPort: Integer); stdcall; external 'server_ws.dll';

procedure ws_server_stop(); stdcall; external 'server_ws.dll';

procedure free_ws_server(); stdcall; external 'server_ws.dll';

function getWorkerman(): TDValue;

implementation

const
  jsonConfigFile: string = 'config.json';

function getValue(key: string): string;
var
  lvData, lvTmp: TDValue;
begin
  if not FileExists(jsonConfigFile) then
  begin
    Result := '';
    Exit;
  end;

  lvData := TDValue.Create();
  try
    JSONParseFromUtf8NoBOMFile(jsonConfigFile, lvData);
    lvTmp := lvData.FindByName(key);
    if Assigned(lvTmp) then
      Result := lvTmp.AsString
    else
      Result := '';
  finally
    lvData.Free;
  end;
end;

function getWorkerman(): TDValue;
var
  lvData, lvTmp: TDValue;
begin
  if not FileExists(jsonConfigFile) then
  begin
    Result := TDValue.Create(vntArray);
    Exit;
  end;

  lvData := TDValue.Create();
  try
    JSONParseFromUtf8NoBOMFile(jsonConfigFile, lvData);
    lvTmp := lvData.FindByName('workerman');
    if Assigned(lvTmp) then
      Result := lvTmp.AsArray.Clone()
    else
      Result := TDValue.Create(vntArray);
  finally
    lvData.Free;
  end;

end;

initialization

FAppPath := ExtractFilePath(Application.ExeName);
FSkinFile := FAppPath + unConfig.getValue('skin');
FDataBaseFile := FAppPath + unConfig.getValue('database');
FDebug := StrToIntDef(unConfig.getValue('debug'), 0);
FWidth := StrToIntDef(unConfig.getValue('width'), 1024);
FHeight := StrToIntDef(unConfig.getValue('height'), 800);
FCaption := unConfig.getValue('title');
FHost := unConfig.getValue('host');
FDataPort := StrToIntDef(unConfig.getValue('data_port'), 46151);
FWebPort := StrToIntDef(unConfig.getValue('web_port'), 46150);
FIndexUrl := Format('http://127.0.0.1:%d/%s',
  [FWebPort, unConfig.getValue('url')]);
FWsPort := StrToIntDef(unConfig.getValue('ws_port'), 46152);
FWsPHPUrl := unConfig.getValue('ws_php_url');

finalization

end.
