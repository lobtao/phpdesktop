unit uframeChrome;

{
关闭窗口的DoubleBuffered可解决子窗口快速移除窗外带来了黑屏问题
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  ExtCtrls, uCEFChromium, uCEFWindowParent, uCEFInterfaces, uCEFConstants,
  unConfig, uCEFTypes, Dialogs;

type
  TframeChrome = class(TFrame)
    CEFWindowParent1: TCEFWindowParent;
    Chromium1: TChromium;
    Splitter1: TSplitter;
    DevTools: TCEFWindowParent;
    Timer1: TTimer;
    procedure Chromium1AfterCreated(Sender: TObject;
      const browser: ICefBrowser);
    procedure Chromium1BeforeContextMenu(Sender: TObject;
      const browser: ICefBrowser; const frame: ICefFrame;
      const params: ICefContextMenuParams; const model: ICefMenuModel);
    procedure Timer1Timer(Sender: TObject);
    procedure Chromium1BeforeClose(Sender: TObject; const browser: ICefBrowser);
    procedure Chromium1Close(Sender: TObject; const browser: ICefBrowser;
      out Result: Boolean);
    procedure Chromium1ProcessMessageReceived(Sender: TObject;
      const browser: ICefBrowser; sourceProcess: TCefProcessId;
      const message: ICefProcessMessage; out Result: Boolean);
    procedure Chromium1ContextMenuCommand(Sender: TObject;
      const browser: ICefBrowser; const frame: ICefFrame;
      const params: ICefContextMenuParams; commandId: Integer;
      eventFlags: Cardinal; out Result: Boolean);
    procedure Chromium1BeforePopup(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; const targetUrl, targetFrameName: ustring;
      targetDisposition: TCefWindowOpenDisposition; userGesture: Boolean;
      const popupFeatures: TCefPopupFeatures;
      var windowInfo: TCefWindowInfo; var client: ICefClient;
      var settings: TCefBrowserSettings; var noJavascriptAccess,
      Result: Boolean);
    procedure Chromium1BeforeBrowse(Sender: TObject;
      const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest; isRedirect: Boolean; out Result: Boolean);
  private
    { Private declarations }
    FCaption: string;
    FUrl: string;
    FHeight: Integer;
    FWidth: Integer;

    FParentForm: TForm;

    procedure BrowserCreatedMsg(var aMessage: TMessage);
      message CEF_AFTERCREATED;
    procedure ShowDevToolsMsg(var aMessage: TMessage);
      message YS_BROWSER_APP_SHOWDEVTOOLS;
    procedure HideDevToolsMsg(var aMessage: TMessage);
      message YS_BROWSER_APP_HIDEDEVTOOLS;
    procedure RefreshBrowse(var aMessage: TMessage);
      message YS_BROWSER_APP_REFRESH;

    procedure ShowForm(var aMessage: TMessage); message YS_BROWSER_APP_SHOW;
    procedure ShowModalForm(var aMessage: TMessage);
      message YS_BROWSER_APP_SHOWMODAL;
    procedure ShowPHPLog(var aMessage: TMessage); message YS_BROWSER_APP_PHPLOG;

    procedure BrowserDestroyMsg(var aMessage: TMessage); message CEF_DESTROY;

  protected
    procedure ShowDevTools(aPoint: TPoint); overload;
    procedure ShowDevTools; overload;
    procedure HideDevTools;
  public
    { Public declarations }
    FClosing: Boolean; // Set to True in the CloseQuery event.
    FCanClose: Boolean; // Set to True in TChromium.OnBeforeClose

    procedure setInfo(parentForm: TForm; url: string);
  end;

implementation

{$R *.dfm}
{ TframeChrome }

uses
  ufrmModal, ufrmPHPLog;

procedure TframeChrome.BrowserCreatedMsg(var aMessage: TMessage);
begin
  Chromium1.LoadUrl(Self.FUrl);
end;

procedure TframeChrome.BrowserDestroyMsg(var aMessage: TMessage);
begin
  CEFWindowParent1.Free;
end;

procedure TframeChrome.Chromium1AfterCreated(Sender: TObject;
  const browser: ICefBrowser);
begin
  if Chromium1.IsSameBrowser(browser) then
    PostMessage(Handle, CEF_AFTERCREATED, 0, 0)
  else
    SendMessage(browser.Host.WindowHandle, WM_SETICON, 1,
      application.Icon.Handle);
end;

procedure TframeChrome.Chromium1BeforeBrowse(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame;
  const request: ICefRequest; isRedirect: Boolean; out Result: Boolean);
begin
  // ShowMessage(request.Url);
end;

procedure TframeChrome.Chromium1BeforeClose(Sender: TObject;
  const browser: ICefBrowser);
begin
  FCanClose := True;
  PostMessage(Self.FParentForm.Handle, WM_CLOSE, 0, 0);
end;

procedure TframeChrome.Chromium1BeforeContextMenu(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame;
  const params: ICefContextMenuParams; const model: ICefMenuModel);
begin
  // 非调试模式下，无右键菜单
  if unConfig.FDebug = 0 then
  begin
    model.Clear;
    Exit;
  end;

  model.AddSeparator;
  if DevTools.Visible then
    model.AddItem(YS_BROWSER_CONTEXTMENU_HIDEDEVTOOLS, '关闭前端调试')
  else
    model.AddItem(YS_BROWSER_CONTEXTMENU_SHOWDEVTOOLS, '显示前端调试');
  model.AddItem(YS_BROWSER_CONTEXTMENU_PHPLOG, '显示PHP日志');
  model.AddItem(YS_BROWSER_CONTEXTMENU_REFRESH, '刷新(&R)');
end;

procedure TframeChrome.Chromium1BeforePopup(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame; const targetUrl,
  targetFrameName: ustring; targetDisposition: TCefWindowOpenDisposition;
  userGesture: Boolean; const popupFeatures: TCefPopupFeatures;
  var windowInfo: TCefWindowInfo; var client: ICefClient;
  var settings: TCefBrowserSettings; var noJavascriptAccess, Result: Boolean);
begin
  // 拦截链接行为，弹出新窗口
  Self.FCaption := targetFrameName;
  Self.FUrl := targetUrl;
  if popupFeatures.widthSet = 1 then
    Self.FWidth := popupFeatures.width
  else
    Self.FWidth := unConfig.FWidth;
  if popupFeatures.heightSet = 1 then
    Self.FHeight := popupFeatures.height
  else
    Self.FHeight := unConfig.FHeight;

  if popupFeatures.dialog = 1 then // 弹出窗口
    PostMessage(Handle, YS_BROWSER_APP_SHOWMODAL, 0, 0)
  else
    PostMessage(Handle, YS_BROWSER_APP_SHOW, 0, 0);

  Result := True;
end;

procedure TframeChrome.Chromium1Close(Sender: TObject;
  const browser: ICefBrowser; out Result: Boolean);
begin
  PostMessage(Handle, CEF_DESTROY, 0, 0);
  Result := True;
end;

procedure TframeChrome.Chromium1ContextMenuCommand(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame;
  const params: ICefContextMenuParams; commandId: Integer;
  eventFlags: Cardinal; out Result: Boolean);
var
  TempParam: WParam;
begin
  // 右键菜单响应
  Result := false;
  case commandId of
    YS_BROWSER_CONTEXTMENU_HIDEDEVTOOLS:
      PostMessage(Handle, YS_BROWSER_APP_HIDEDEVTOOLS, 0, 0);

    YS_BROWSER_CONTEXTMENU_SHOWDEVTOOLS:
      begin
        TempParam := ((params.XCoord and $FFFF) shl 16) or
          (params.YCoord and $FFFF);
        PostMessage(Handle, YS_BROWSER_APP_SHOWDEVTOOLS, TempParam, 0);
      end;
    YS_BROWSER_CONTEXTMENU_REFRESH:
      PostMessage(Handle, YS_BROWSER_APP_REFRESH, 0, 0);
    YS_BROWSER_CONTEXTMENU_PHPLOG:
      PostMessage(Handle, YS_BROWSER_APP_PHPLOG, 0, 0);
  end;

end;

procedure TframeChrome.Chromium1ProcessMessageReceived(Sender: TObject;
  const browser: ICefBrowser; sourceProcess: TCefProcessId;
  const message: ICefProcessMessage; out Result: Boolean);
begin
  // 拓展消息响应
  FUrl := message.ArgumentList.GetString(0);
  FWidth := message.ArgumentList.GetInt(1);
  FHeight := message.ArgumentList.GetInt(2);

  if (message.Name = YS_BROWSER_EXTENSION_SHOW) then
    PostMessage(Handle, YS_BROWSER_APP_SHOW, 0, 0)
  else if (message.Name = YS_BROWSER_EXTENSION_SHOWMODAL) then
    PostMessage(Handle, YS_BROWSER_APP_SHOWMODAL, 0, 0);
end;

procedure TframeChrome.HideDevTools;
begin
  Chromium1.CloseDevTools(DevTools);
  Splitter1.Visible := false;
  DevTools.Visible := false;
  DevTools.width := 0;

end;

procedure TframeChrome.HideDevToolsMsg(var aMessage: TMessage);
begin
  HideDevTools;
end;

procedure TframeChrome.RefreshBrowse(var aMessage: TMessage);
begin
  Chromium1.ReloadIgnoreCache;
end;

procedure TframeChrome.setInfo(parentForm: TForm; url: string);
begin
  Self.FParentForm := parentForm;
  Self.FUrl := url;
  Self.FCanClose := false;
  Self.FClosing := false;
  if not(Chromium1.CreateBrowser(CEFWindowParent1, '')) then
    Timer1.Enabled := True;
end;

procedure TframeChrome.ShowDevTools;
var
  TempPoint: TPoint;
begin
  TempPoint.x := low(Integer);
  TempPoint.y := low(Integer);
  ShowDevTools(TempPoint);

end;

procedure TframeChrome.ShowDevTools(aPoint: TPoint);
begin
  Splitter1.Visible := True;
  DevTools.Visible := True;
  DevTools.width := width div 4;
  Chromium1.ShowDevTools(aPoint, DevTools);

end;

procedure TframeChrome.ShowDevToolsMsg(var aMessage: TMessage);
var
  TempPoint: TPoint;
begin
  TempPoint.x := (aMessage.WParam shr 16) and $FFFF;
  TempPoint.y := aMessage.WParam and $FFFF;
  ShowDevTools(TempPoint);
end;

procedure TframeChrome.ShowForm(var aMessage: TMessage);
begin
  frmModal := TfrmModal.Create(nil);
  frmModal.setInfo(Self.FCaption, Self.FUrl, Self.FWidth, Self.FHeight);
  frmModal.Show;
end;

procedure TframeChrome.ShowModalForm(var aMessage: TMessage);
var
  frmModal1: TfrmModal;
begin
  frmModal1 := TfrmModal.Create(nil);
  frmModal.setInfo(Self.FCaption, Self.FUrl, Self.FWidth, Self.FHeight);
  frmModal1.ShowModal;
  frmModal1.Free;
end;

procedure TframeChrome.ShowPHPLog(var aMessage: TMessage);
begin
  if (unConfig.FDebug = 1) and (Assigned(frmPHPLog)) then
    frmPHPLog.Show;
end;

procedure TframeChrome.Timer1Timer(Sender: TObject);
begin
  TTimer(Sender).Enabled := false;
  if not(Chromium1.CreateBrowser(CEFWindowParent1, '')) and not
    (Chromium1.Initialized) then
    TTimer(Sender).Enabled := True;
end;

end.
