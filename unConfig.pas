unit unConfig;

interface

uses utils_dvalue, utils_dvalue_json, StrUtils, SysUtils, Messages,
  uCEFConstants, Forms;

const
  // APP响应消息
  YS_BROWSER_APP_SHOWDEVTOOLS = WM_APP + $101; // 显示开发工具
  YS_BROWSER_APP_HIDEDEVTOOLS = WM_APP + $102; // 隐藏开发工具
  YS_BROWSER_APP_REFRESH = WM_APP + $103; // 刷新
  YS_BROWSER_APP_SHOW = WM_APP + $104; // 显示窗口
  YS_BROWSER_APP_SHOWMODAL = WM_APP + $105; // modal显示窗口
  YS_BROWSER_APP_PHPERROR = WM_APP + $106; // php异常消息
  YS_BROWSER_APP_PHPLOG = WM_APP + $107; // 显示PHP日志

  // 右键菜单发送消息
  YS_BROWSER_CONTEXTMENU_SHOWDEVTOOLS = MENU_ID_USER_FIRST + 1; // 显示开发工具
  YS_BROWSER_CONTEXTMENU_HIDEDEVTOOLS = MENU_ID_USER_FIRST + 2; // 隐藏开发工具
  YS_BROWSER_CONTEXTMENU_REFRESH = MENU_ID_USER_FIRST + 3; // 刷新
  YS_BROWSER_CONTEXTMENU_PHPLOG = MENU_ID_USER_FIRST + 4; // 显示PHP日志

  // 拓展发送消息
  YS_BROWSER_EXTENSION_SHOW = 'extension_show'; // 显示窗口
  YS_BROWSER_EXTENSION_SHOWMODAL = 'extension_showmodal'; // modal显示窗口

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

implementation

const
  jsonFile: string = 'config.json';

function getValue(key: string): string;
var
  lvData, lvTmp: TDValue;
begin
  if not FileExists('config.json') then
  begin
    Result := '';
    Exit;
  end;

  lvData := TDValue.Create();
  try
    JSONParseFromUtf8NoBOMFile('config.json', lvData);
    lvTmp := lvData.FindByPath(key);
    Result := IfThen(Assigned(lvTmp), lvTmp.AsString, '');
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

finalization

end.
