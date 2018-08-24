unit unMoudle;

interface

uses
  SysUtils, Classes, SkinData;

type
  TdbMoudle = class(TDataModule)
    spSkinData1: TspSkinData;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dbMoudle: TdbMoudle;

implementation

{$R *.dfm}

end.
