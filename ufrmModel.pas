unit ufrmModel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DynamicSkinForm, ExtCtrls, uCEFChromium, uCEFWindowParent,uCEFInterfaces;

type
  TfrmModal = class(TForm)
    spDynamicSkinForm1: TspDynamicSkinForm;
    CEFWindowParent1: TCEFWindowParent;
    Chromium1: TChromium;
    DevTools: TCEFWindowParent;
    Splitter1: TSplitter;
    Timer1: TTimer;
    procedure Chromium1BeforeContextMenu(Sender: TObject;
      const browser: ICefBrowser; const frame: ICefFrame;
      const params: ICefContextMenuParams; const model: ICefMenuModel);
    procedure Chromium1ContextMenuCommand(Sender: TObject;
      const browser: ICefBrowser; const frame: ICefFrame;
      const params: ICefContextMenuParams; commandId: Integer;
      eventFlags: Cardinal; out Result: Boolean);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure ShowDevTools(aPoint: TPoint); overload;
    procedure ShowDevTools; overload;
    procedure HideDevTools;
  public
    { Public declarations }
    constructor Create(caption: string; width: Integer; height: Integer); overload;
  end;

var
  frmModal: TfrmModal;

implementation

uses
  ufrmMain, unConfig;

{$R *.dfm}

{ TfrmModel }

procedure TfrmModal.Chromium1BeforeContextMenu(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame;
  const params: ICefContextMenuParams; const model: ICefMenuModel);
begin
  // 非调试模式下，无右键菜单
  if StrToIntDef(unConfig.getValue('debug'), 0) = 0 then
  begin
    model.Clear;
    Exit;
  end;

  model.AddSeparator;
  if DevTools.Visible then
    model.AddItem(MINIBROWSER_CONTEXTMENU_HIDEDEVTOOLS, '关闭开发工具')
  else
    model.AddItem(MINIBROWSER_CONTEXTMENU_SHOWDEVTOOLS, '显示开发工具');
  model.AddItem(CUSTOMMENUCOMMAND_REFRESH, '刷新(&R)');
end;

procedure TfrmModal.Chromium1ContextMenuCommand(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame;
  const params: ICefContextMenuParams; commandId: Integer; eventFlags: Cardinal;
  out Result: Boolean);
var
  TempParam: WParam;
begin
  Result := false;
  case commandId of
    MINIBROWSER_CONTEXTMENU_HIDEDEVTOOLS:
      PostMessage(Handle, MINIBROWSER_HIDEDEVTOOLS, 0, 0);

    MINIBROWSER_CONTEXTMENU_SHOWDEVTOOLS:
      begin
        TempParam := ((params.XCoord and $FFFF) shl 16) or
          (params.YCoord and $FFFF);
        PostMessage(Handle, MINIBROWSER_SHOWDEVTOOLS, TempParam, 0);
      end;
    CUSTOMMENUCOMMAND_REFRESH:
      PostMessage(Handle, MINIBROWSER_REFRESH, 0, 0);
  end;

end;

constructor TfrmModal.Create(caption: string; width, height: Integer);
begin
  inherited create(nil);

  Self.Caption := caption;
  Self.Width := width;
  Self.Height := height;

end;

procedure TfrmModal.FormShow(Sender: TObject);
begin
  if not (Chromium1.CreateBrowser(CEFWindowParent1, '')) then
    Timer1.Enabled := True;
end;

procedure TfrmModal.HideDevTools;
begin
  Chromium1.CloseDevTools(DevTools);
  Splitter1.Visible := false;
  DevTools.Visible := false;
  DevTools.Width := 0;
end;

procedure TfrmModal.ShowDevTools(aPoint: TPoint);
begin
  Splitter1.Visible := True;
  DevTools.Visible := True;
  DevTools.Width := Width div 4;
  Chromium1.ShowDevTools(aPoint, DevTools);
end;

procedure TfrmModal.ShowDevTools;
var
  TempPoint: TPoint;
begin
  TempPoint.x := low(Integer);
  TempPoint.y := low(Integer);
  ShowDevTools(TempPoint);

end;

procedure TfrmModal.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := false;
  if not (Chromium1.CreateBrowser(CEFWindowParent1, '')) and not
    (Chromium1.Initialized) then
    Timer1.Enabled := True;
end;

end.
