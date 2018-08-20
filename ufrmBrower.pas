unit ufrmBrower;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cefvcl, Vcl.StdCtrls;

type
  TfrmBrower = class(TForm)
    Chromium: TChromium;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBrower: TfrmBrower;

implementation

{$R *.dfm}

end.
