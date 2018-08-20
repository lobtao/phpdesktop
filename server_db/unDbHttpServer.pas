unit unDbHttpServer;

interface

uses
  Classes, diocp_ex_httpServer, Contnrs, CnObjectPool, unAbsDbModule, ABSMain,
   SysUtils, Windows, unConfig, utils_dvalue, utils_dvalue_json;

type
  TDbHttpServer = class

  private
    FHttpServer: TDiocpHttpServer;
    FDbModuleList: TObjectList;
    FCrs: TCriticalSection;

    // 获取空闲数据处理模块
    function getFreeAbs(): TAbsDbModule;

    // 请求响应
    procedure OnHttpSvrRequest(pvRequest: TDiocpHttpRequest);

    procedure responseEmpty(pvRequest: TDiocpHttpRequest);
  public
    // 创建http监听
    constructor Create(); overload;
    // 释放对象
    destructor Destroy; override;

    procedure start(iPort: Integer);
    procedure stop();
  end;

var
  dbServer: TDbHttpServer;

implementation

{ THttpServer }

function GetCPUCount: Integer;
{$IFDEF MSWINDOWS}
var
  si: SYSTEM_INFO;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  GetSystemInfo(si);
  Result := si.dwNumberOfProcessors;
{$ELSE} // Linux,MacOS,iOS,Andriod{POSIX}
{$IFDEF POSIX}
  Result := sysconf(_SC_NPROCESSORS_ONLN);
{$ELSE} // unkown system, default 1
  Result := 1;
{$ENDIF !POSIX}
{$ENDIF !MSWINDOWS}
end;

constructor TDbHttpServer.Create();
var
  i: Integer;
begin
  inherited Create;

  FHttpServer := TDiocpHttpServer.Create(nil);
  FHttpServer.Name := 'db_Server';
  FHttpServer.OnDiocpHttpRequest := OnHttpSvrRequest;

  // 对象列表
  FDbModuleList := TObjectList.Create;
  // 自动释放内存
  FDbModuleList.OwnsObjects := True;
  for i := 0 to GetCPUCount - 1 do
    FDbModuleList.Add(TAbsDbModule.Create(nil));

  // 同步对象
  FCrs := TCriticalSection.Create;
end;

destructor TDbHttpServer.Destroy;
begin
  FHttpServer.SafeStop();
  FHttpServer.Free;

  // 释放对象列表
  FDbModuleList.Free;

  // 释放同步对象
  FCrs.Free;

  inherited Destroy;
end;

function TDbHttpServer.getFreeAbs: TAbsDbModule;
var
  i: Integer;
  tmpMd: TAbsDbModule;
begin
  Result := nil;
  // 获取空闲的数据模块
  FCrs.Enter;
  for i := 0 to FDbModuleList.Count - 1 do
  begin
    tmpMd := TAbsDbModule(FDbModuleList.Items[i]);
    if not tmpMd.FIsBusy then
    begin
      tmpMd.FIsBusy := True;
      Result := tmpMd;
      Break;
    end;
  end;

  // 如果没有空闲的数据模块，新创建一个
  if not Assigned(Result) then
  begin
    tmpMd := TAbsDbModule.Create(nil);
    FDbModuleList.Add(tmpMd);
    Result := tmpMd;
  end;

  FCrs.Leave;
end;

procedure TDbHttpServer.OnHttpSvrRequest(pvRequest: TDiocpHttpRequest);
var
  strSql, strData, strResult: string;
  jsRequestData, jsData, jsTmp, jsParams, jsResult: TDValue;
  fCount: Integer;

  query: TABSQuery;
  i, iCount, iType: Integer;

  tmpMd: TAbsDbModule;

  listMM: TStringList;
begin
  // 忽略favicon.ico请求
  if pvRequest.RequestURI = '/favicon.ico' then
    Exit;

  tmpMd := Self.getFreeAbs;
  query := TABSQuery.Create(nil);
  query.SessionName := tmpMd.FSession.SessionName;
  query.DatabaseName := tmpMd.FDatabase.DatabaseName;

  listMM := TStringList.Create();

  jsRequestData := TDValue.Create();
  jsData := TDValue.Create();
  jsResult := TDValue.Create();
  try
    JSONParser('{}', jsResult);
    pvRequest.DecodeURLParam(True);

    pvRequest.DecodePostDataParam({$IFDEF UNICODE} TEncoding.UTF8 {$ELSE} True
      {$ENDIF});

      try
        // 获取传入参数
        if pvRequest.ContentLength > 0 then
        begin
          strData := pvRequest.GetRequestParam('sqlData');
          JSONParser(strData, jsRequestData);
        end
        else
        begin
          responseEmpty(pvRequest);
          Exit;
        end;

        strSql := jsRequestData.FindByName('sql').AsString;
        jsParams := jsRequestData.FindByName('params');
        iType := jsRequestData.FindByName('type').AsInteger;

        // 执行sql
        query.SQL.Text := strSql;
        iCount := jsParams.Count;
        for i := 0 to iCount - 1 do
        begin
          jsTmp := jsParams.Items[i];
          query.ParamByName(jsTmp.Name.AsString).AsString := jsTmp.Value.AsString;
        end;
        if iType = 0 then//查询
        begin
          query.Open;

          // 获取结果
          query.First;
          JSONParser('[]', jsData);
          fCount := query.Fields.Count;
          while not query.Eof do
          begin
            for i := 0 to fCount - 1 do
            begin
              jsData.AddVar(query.Fields[i].FieldName, query.Fields[i].AsString);
            end;
            query.Next;
          end;
          jsResult.Add('data', jsData);
        end;
        jsResult.Add('code', 0);
      except
        on Ex: Exception do
        begin
          jsResult.Add('code', 1);
          jsResult.Add('msg', Ex.Message);
        end;
      end;

    strResult := JSONEncode(jsResult, False, False);
    pvRequest.Response.ContentType := 'text/json';
    pvRequest.Response.WriteString(strResult);
    pvRequest.ResponseEnd();

  finally
    query.Free;
    tmpMd.FIsBusy := False;

    // 释放数据
    jsRequestData.Free;
    jsData.Free;
    jsResult.Free;

    listMM.Free;
  end;
end;

procedure TDbHttpServer.responseEmpty(pvRequest: TDiocpHttpRequest);
begin
  pvRequest.Response.ContentType := 'text/json';
  pvRequest.Response.WriteString('[]');
  pvRequest.ResponseEnd();
end;

procedure TDbHttpServer.start(iPort: Integer);
begin
  Self.FHttpServer.DefaultListenAddress := FHost;
  Self.FHttpServer.Port := iPort;
  Self.FHttpServer.Active := True;
end;

procedure TDbHttpServer.stop;
begin
  Self.FHttpServer.SafeStop;
end;

end.
