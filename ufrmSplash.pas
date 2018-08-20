unit ufrmSplash;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms,
  ExtCtrls ,unConfig;

type
  TfrmSplash = class(TForm)
    imgSplash: TImage;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure RoundCorner;
  public
    { Public declarations }
  end;

var
  frmSplash: TfrmSplash;

implementation

{$R *.dfm}


procedure TfrmSplash.FormCreate(Sender: TObject);
var
  strSplashFile: string;
begin
  strSplashFile := FAppPath + 'skin\splash.jpg';
  if FileExists(strSplashFile) then
    imgSplash.Picture.LoadFromFile(strSplashFile);
end;

procedure TfrmSplash.RoundCorner;
var
  hr: thandle;
begin
  hr := createroundrectrgn(0, 0, width, height, 4, 4);
  setwindowrgn(handle, hr, True);
end;

end.
