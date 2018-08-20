unit unAbsDbModule;

interface

uses
  Classes, ABSMain, CnCommon,unConfig;

type
  TAbsDbModule = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FDatabase: TABSDatabase;
    FSession: TABSSession;

    FIsBusy: Boolean; //是否正在工作中
  end;

implementation

{$R *.dfm}

procedure TAbsDbModule.DataModuleCreate(Sender: TObject);
begin
  FSession := TABSSession.Create(nil);
  FSession.AutoSessionName := True;

  FDatabase := TABSDatabase.Create(nil);
  FDatabase.DatabaseName := 'database_' + CreateGuidString;
  FDatabase.DatabaseFileName := FDataBaseFile;

  FDatabase.SessionName := FSession.SessionName;
  FDatabase.MultiUser := True;
  FDatabase.Open;

  FIsBusy := False;
end;

procedure TAbsDbModule.DataModuleDestroy(Sender: TObject);
begin
  FDatabase.Free;
  FSession.Free;
end;

end.

