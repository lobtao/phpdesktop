unit unPHPModule;

interface

uses
  SysUtils, Classes, diocp_ex_httpServer, Contnrs, CnObjectPool
  , superobject, PHPCommon, php4delphi, zendAPI,
  phpAPI, PHPCustomLibrary, utils_strings, diocp_ex_httpClient;

const
  PHP_SESSIONID = 'PHPSESSID';

type
  TPHPModule = class(TDataModule)
    FPHPEngine: TPHPEngine;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure FPHPEngineScriptError(Sender: TObject; AText: AnsiString;
      AType: TPHPErrorType; AFileName: AnsiString; ALineNo: Integer);
  private
    { Private declarations }

    FHttpServer: TDiocpHttpServer;
    FDbModuleList: TObjectList;
    FCrs: TCriticalSection;

    //请求响应
    procedure OnHttpSvrRequest(pvRequest: TDiocpHttpRequest);

  public
    { Public declarations }


    procedure start(iPort: Integer);
    procedure stop();
  end;

var
  PHPModule: TPHPModule;

implementation

{$R *.dfm}

{ TDataModule1 }

procedure TPHPModule.DataModuleCreate(Sender: TObject);
begin
  FPHPEngine.StartupEngine;

  FHttpServer := TDiocpHttpServer.Create(nil);
  FHttpServer.Name := 'Ys_AppServer';
  FHttpServer.OnDiocpHttpRequest := OnHttpSvrRequest;
end;

procedure TPHPModule.DataModuleDestroy(Sender: TObject);
begin
  FHttpServer.SafeStop();
  FHttpServer.Free;

  FPHPEngine.ShutdownAndWaitFor;

end;

procedure TPHPModule.FPHPEngineScriptError(Sender: TObject; AText: AnsiString;
  AType: TPHPErrorType; AFileName: AnsiString; ALineNo: Integer);
begin
//
end;

procedure TPHPModule.OnHttpSvrRequest(pvRequest: TDiocpHttpRequest);
var
  S, tmp, sessionID: string;
  L, iCount, iStart, iStop: integer;
  FileName: string;
  FilePath: string;
  ws: UTF8String;
  fs: TStringList;
  psvPhpOne: TpsvPHP;
  i: Integer;
  lvSession: TDiocpHttpDValueSession;

  list: TStrings;

  strUrl: string;

  httpClient: TDiocpHttpClient;
begin
  if pvRequest.RequestURI = '/favicon.ico' then
    Exit;

//  pvRequest.Response.Header.ForceByName('Access-Control-Allow-Origin').AsString := '*';
//  pvRequest.Response.Header.ForceByName('Access-Control-Allow-Methods').AsString := 'POST, GET, OPTIONS, DELETE';
//  pvRequest.Response.Header.ForceByName('Access-Control-Allow-Headers').AsString := 'x-requested-with,content-type';

  FilePath := ExtractFilePath(ParamStr(0));
  if pvRequest.RequestURI = '/' then
    strUrl := '/test.php'
  else
    strUrl := pvRequest.RequestURI;

  FileName := FilePath + 'app'+strUrl;
  psvPhpOne := TpsvPHP.Create(nil);

  iCount := pvRequest.Header.Count;

  //1. 获取delphi的PHPSESSID到PHP
  with psvPhpOne.Variables.Add do
  begin
    Name := PHP_SESSIONID;
    Value := pvRequest.GetCookie(PHP_SESSIONID);
  end;

  with psvPhpOne.Variables.Add do
  begin
    Name := 'f';
    Value := 'test_test';
  end;
  try
    S := psvPhpOne.Execute(FileName);
    for i := 0 to psvPhpOne.Headers.Count - 1 do //psvPHP1.Headers.GetHeaders
      tmp := tmp + psvPhpOne.Headers[i].Header + '<br>';

    //2. 获取到PHP中的sessionID，并通过delphi到浏览器
    sessionID := psvPhpOne.Headers[2].Header;
    sessionID := GetStrValueOfName(sessionID, 'Set-Cookie', [':', ' '], [' ']); //截取变量值
    sessionID := GetStrValueOfName(sessionID, 'PHPSESSID', ['=', ' '], [';', ' ']);

    //3. 把sessionID值设置到浏览器
    with pvRequest.Response.AddCookie do
    begin
      Name := PHP_SESSIONID;
      Value := sessionID;
    end;
    tmp := tmp + pvRequest.Header.AsString + '<br>';
    tmp := tmp + sessionID + '<br>';
  finally
    psvPhpOne.Free;
  end;


  pvRequest.Response.ResponseCode := 200;
  pvRequest.Response.WriteString(s + '<hr>' + AnsiToUtf8(tmp), False); //
  pvRequest.ResponseEnd();

end;

procedure TPHPModule.start(iPort: Integer);
begin
  FHttpServer.Port := iPort;
  Self.FHttpServer.Active := True;
end;

procedure TPHPModule.stop;
begin
  Self.FHttpServer.SafeStop;
end;


end.

