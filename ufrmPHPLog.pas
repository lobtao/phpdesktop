unit ufrmPHPLog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DynamicSkinForm, ExtCtrls, unConfig, utils_dvalue,
  utils_dvalue_json;

type
  TfrmPHPLog = class(TForm)
    Memo1: TMemo;
    DSF: TspDynamicSkinForm;
    Panel1: TPanel;
  private
    { Private declarations }
    procedure PHP_ERROR(var aMessage: TMessage); message YS_BROWSER_APP_PHPERROR;
  public
    { Public declarations }
  end;

var
  frmPHPLog: TfrmPHPLog;

implementation

uses
  unMoudle;
{$R *.dfm}
{ TfrmPHPLog }

procedure TfrmPHPLog.PHP_ERROR(var aMessage: TMessage);
var
  strTmp: string;
  dValue: TDValue;
  AType: Integer;
  AText: string;
  ALineNo: string;
  AFileName: string;
begin
  strTmp := StrPas(PChar(aMessage.WParam));
  dValue := TDValue.Create(vntObject);
  JSONParser(strTmp, dValue);
  try
    AType := dValue.FindByPath('AType').AsInteger;
    AText := '描述：' + dValue.FindByPath('AText').AsString;
    ALineNo := '行数：' + dValue.FindByPath('ALineNo').AsString;
    AFileName := dValue.FindByPath('AFileName').AsString;

    strTmp := AFileName + #13#10 + ALineNo + #13#10 + AText + #13#10;
    strTmp := strTmp + '时间：' + FormatDateTime('YYYY-MM-dd HH:mm:ss', Now) + #13#10;
    // Memo1.Lines.Insert(0,AFileName);
    // Memo1.Lines.Insert(0,ALineNo);
    // Memo1.Lines.Insert(0,AText);
    Memo1.Lines.Insert(0, strTmp);
  finally
    dValue.Free;
  end;
end;

end.
