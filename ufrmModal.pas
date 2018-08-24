unit ufrmModal;

interface

uses
  Classes, Controls, Forms,
  DynamicSkinForm, uCEFChromium,
  uframeChrome, uCEFInterfaces, uCEFTypes, SysUtils;

type
  TfrmModal = class(TForm)
    frameChrome1: TframeChrome;
    DSF: TspDynamicSkinForm;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure frameChrome1Chromium1TitleChange(Sender: TObject;
      const browser: ICefBrowser; const title: ustring);
  private
    { Private declarations }
    FUrl: string;
  protected
  public
    { Public declarations }
    procedure setInfo(Caption: string; Url: string; width, height: Integer);
  end;

var
  frmModal: TfrmModal;

implementation

uses
   unMoudle;


{$R *.dfm}
{ TfrmModel }

procedure TfrmModal.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  Action := caFree;
end;

procedure TfrmModal.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := frameChrome1.FCanClose;

  if not(frameChrome1.FClosing) then
  begin
    frameChrome1.FClosing := True;
    Visible := False;
    frameChrome1.Chromium1.CloseBrowser(True);
  end;
end;

procedure TfrmModal.FormShow(Sender: TObject);
begin
  frameChrome1.setInfo(Self, Self.FUrl);

  if fsModal in self.FormState then
     Self.FormStyle := fsNormal;
end;

procedure TfrmModal.frameChrome1Chromium1TitleChange(Sender: TObject;
  const browser: ICefBrowser; const title: ustring);
var
  tmpTitle: string;
begin
  if Self.Caption <> '' then
    Exit;

  tmpTitle := Trim(title);
  if (tmpTitle <> '') and (tmpTitle <> 'about:blank') then
    Self.Caption := tmpTitle;
end;

procedure TfrmModal.setInfo(Caption, Url: string; width, height: Integer);
begin
  Self.Caption := Trim(Caption);
  Self.width := width;
  Self.height := height;
  Self.FUrl := Url;
end;

end.
