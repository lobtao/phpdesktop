unit unChromeMessage;

interface

uses
  Contnrs, uCEFChromium, Classes, utils_strings, SysUtils, Generics.Collections,
  Windows, utils_dvalue, unConfig, Dialogs;

type
  TWatchSubject = class(TObject)
  public
    listChome: TList<TChromium>;
    // 注册消息监听
    procedure attach(observer: TChromium);
    procedure unAttach(observer: TChromium);
    // 通知所有监听
    procedure notifyAll(aMsg, aFrameName: string);
    constructor Create; overload;
    destructor Destroy; override;
  end;

var
  subject: TWatchSubject;

implementation

{ TSubject }

procedure TWatchSubject.attach(observer: TChromium);
var
  iIndex: Integer;
begin
  iIndex := listChome.IndexOf(observer);
  if iIndex = -1 then
    listChome.Add(observer);
end;

constructor TWatchSubject.Create;
begin
  inherited;

  listChome := TList<TChromium>.Create;
end;

destructor TWatchSubject.Destroy;
begin
  listChome.Free;

  inherited;
end;

procedure TWatchSubject.notifyAll(aMsg, aFrameName: string);
var
  i: Integer;
  observer: TChromium;
  strFunc: string;
begin
  aMsg := StringReplace(aMsg, '"', '\"', [rfReplaceAll]);
  strFunc := 'if(window.onMsg) window.onMsg("' + aMsg + '")';

  for i := 0 to listChome.Count - 1 do
  begin
    observer := listChome.Items[i];
    observer.ExecuteJavaScript(strFunc,
      observer.DocumentURL, aFrameName);
  end;
end;

procedure TWatchSubject.unAttach(observer: TChromium);
var
  iIndex: Integer;
begin
  iIndex := listChome.IndexOf(observer);
  if iIndex > -1 then
    listChome.Delete(iIndex);
end;

initialization

subject := TWatchSubject.Create;

finalization

subject.Free;

end.
