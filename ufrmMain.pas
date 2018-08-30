unit ufrmMain;

interface

uses
  SysUtils, Windows,
  Classes,
  Controls, Forms, SkinData, DynamicSkinForm,
  uCEFChromium,
  uframeChrome,
  Dialogs;

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
  unConfig, ufrmSplash, ufrmPHPLog, unMoudle, unChromeMessage, unCmdCli;

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
    frmSplash.Show;

    if unConfig.FDebug = 1 then
      frmPHPLog := TfrmPHPLog.Create(Application);

    Application.ProcessMessages;
    // 1.加载配置
    loadMainConfig();
    // 2.加载皮肤
    if FileExists(unConfig.FSkinFile) then
      dbMoudle.spSkinData1.LoadFromCompressedFile(FSkinFile);
    // 3.启动服务器
    create_php_server();
    php_server_start(unConfig.FWebPort, frmPHPLog.Handle);
    create_db_server();
    db_server_start(unConfig.FDataPort);
    // 4.启动workerman服务
//    cmdCli := TCmdCli.Create;

  finally
    frmSplash.Free;
  end;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  // 停止PHP服务器
  php_server_stop();
  free_php_server();
  // 停止Abs数据服务器
  db_server_stop();
  free_db_server();
  // 停止workerman服务
//  cmdCli.Free;
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
