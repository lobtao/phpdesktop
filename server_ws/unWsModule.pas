unit unWsModule;

interface

uses
  SysUtils, Classes, diocp_ex_httpServer, Contnrs, utils_strings,
  diocp_ex_httpClient,
  utils_dvalue, Dialogs, utils_dvalue_json, unConfig;

type
  TwsModule = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    FTcpServer: TDiocpHttpServer;
    FHttpPort: Integer;//php web请求端口
    FHttpServerUrl: string;//php web网址

    function getPHPWeb(strData: string): string;
    procedure OnWebSocketSvrRequest(pvRequest: TDiocpHttpRequest);
  public
    { Public declarations }
    procedure start(iPort: Integer;iHttpPort: Integer);
    procedure stop();
  end;

var
  wsModule: TwsModule;

implementation

{$R *.dfm}
{ TwsModule }

procedure TwsModule.DataModuleCreate(Sender: TObject);
begin
  FTcpServer := TDiocpHttpServer.Create(nil);
  FTcpServer.Name := 'websocket';
  FTcpServer.OnDiocpHttpRequest := OnWebSocketSvrRequest;
  FTcpServer.DisableSession := True;
end;

procedure TwsModule.DataModuleDestroy(Sender: TObject);
begin
  FTcpServer.Free;
end;

function TwsModule.getPHPWeb(strData: string): string;
var
  httpClient: TDiocpHttpClient;
  strUrl: string;
begin
  httpClient :=  TDiocpHttpClient.Create(nil);
  try
    strUrl := Self.FHttpServerUrl+'&data='+URLEncode(UTF8Encode(strData));
    httpClient.Get(strUrl);
    Result := httpClient.GetResponseBodyAsString;
  finally
    httpClient.Free;
  end;
end;

procedure TwsModule.OnWebSocketSvrRequest(pvRequest: TDiocpHttpRequest);
var
  strData: string;
begin
  if pvRequest.CheckIsWebSocketRequest then
  begin // 检测是否为WebSocket的接入请求
    // 响应WebSocket握手
    pvRequest.ResponseForWebSocketShake;
    // 设置连接为WebSocket类型
    pvRequest.Connection.ContextType := Context_Type_WebSocket;
    Exit;
  end;

  if pvRequest.Connection.ContextType = Context_Type_WebSocket then
  begin // 如果连接为WebSocket类型
    // 接收到的WebSocket数据侦
    // s := TByteTools.varToHexString(pvRequest.InnerWebSocketFrame.Buffer.Memory^, pvRequest.InnerWebSocketFrame.Buffer.Length);
    // sfLogger.logMessage(s);
    try
      strData := pvRequest.WebSocketContentBuffer.DecodeUTF8;
      strData := Self.getPHPWeb(strData);
      pvRequest.Connection.PostWebSocketData(strData, True);
    except
      on e: Exception do
      begin
        strData := '解码失败:' + e.Message;
        // 发送字符串给客户端
        pvRequest.Connection.PostWebSocketData(strData, True);
        Exit;
      end;
    end;
  end;
end;

procedure TwsModule.start(iPort: Integer;iHttpPort: Integer);
begin
  Self.FHttpPort := iHttpPort;
  if (unConfig.FHost = '127.0.0.1') then // 只有设置了127.0.0.1，才监听本地端口，其它值为网络端口，可做为服务端
    Self.FTcpServer.DefaultListenAddress := unConfig.FHost;
  Self.FHttpServerUrl := Format('http://%s:%d/%s',[Self.FTcpServer.DefaultListenAddress,Self.FHttpPort, unConfig.FWsPHPUrl]);
  Self.FTcpServer.Port := iPort;
  Self.FTcpServer.Active := True;
end;

procedure TwsModule.stop;
begin
  Self.FTcpServer.SafeStop;
end;

end.
