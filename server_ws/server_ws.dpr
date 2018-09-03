library server_ws;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  SysUtils,
  Classes,
  unWsModule in 'unWsModule.pas' {wsModule: TDataModule},
  unConfig in '..\unConfig.pas';

{$R *.res}

procedure create_ws_server(); stdcall;
begin
   wsModule := TwsModule.Create(nil);
end;

procedure free_ws_server(); stdcall;
begin
  wsModule.Free;
end;

procedure ws_server_start(iPort: Integer;iHttpPort: Integer); stdcall;
begin
  wsModule.start(iPort, iHttpPort);
end;

procedure ws_server_stop; stdcall;
begin
  wsModule.stop;
end;

exports
  create_ws_server,
  free_ws_server,
  ws_server_start,
  ws_server_stop;


begin
end.
