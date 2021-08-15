unit ufrmMain;

interface

uses
  SysUtils, Windows,Messages,
  Classes,
  Controls, Forms, SkinData, DynamicSkinForm,
  uCEFChromium,
  uframeChrome,
  Dialogs, StdCtrls;

type
  TfrmMain = class(TForm)
    frameChrome1: TframeChrome;
    DSF: TspDynamicSkinForm;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    // 加载主页，因为不能直接加载PHP，
    procedure loadMainConfig();

  protected

  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  unConfig, ufrmSplash, unMoudle, unChromeMessage, unCmdCli;

{$R *.dfm}

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := frameChrome1.FCanClose;

  if not(frameChrome1.FClosing) then
  begin
    frameChrome1.FClosing := True;
    Visible := False;
    frameChrome1.Chromium1.CloseBrowser(True);
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  frmSplash := TfrmSplash.Create(nil);
  try
    if FileExists(unConfig.FIcon) then
      Self.Icon.LoadFromFile(unConfig.FIcon);
    frmSplash.Show;

    Application.ProcessMessages;
    // 1.加载配置
    loadMainConfig();
    // 2.加载皮肤
    if FileExists(unConfig.FSkinFile) then
      dbMoudle.spSkinData1.LoadFromCompressedFile(FSkinFile);

    // 4.启动db数据服务器
//    create_db_server();
//    db_server_start(unConfig.FDataPort);
    // 5.启动ws服务器
//    create_ws_server();
//    ws_server_start(unConfig.FWsPort,unConfig.FWebPort);
    // 6.启动workerman
     cmdCli := TCmdCli.Create;
     //7. 启动检测是否最大化窗口
     if(unConfig.FStartup_Max = 1) then
      Self.WindowState := wsMaximized;

  finally
    frmSplash.Free;
  end;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  // 停止Abs数据服务器
//  db_server_stop();
//  free_db_server();
  // 停止ws服务器
//  ws_server_stop();
//  free_ws_server();
  // 停止workerman服务
   cmdCli.Free;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  frameChrome1.setInfo(Self, unConfig.FIndexUrl);

  
end;

procedure TfrmMain.loadMainConfig;
begin
  Self.Width := unConfig.FWidth;
  Self.Height := unConfig.FHeight;
  Self.Caption := unConfig.FCaption;

end;

initialization

end.
