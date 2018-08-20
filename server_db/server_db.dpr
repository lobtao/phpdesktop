library server_db;

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
  unDbHttpServer in 'unDbHttpServer.pas',
  unAbsDbModule in 'unAbsDbModule.pas' {AbsDbModule: TDataModule},
  unConfig in '..\unConfig.pas';

{$R *.res}

procedure create_db_server();stdcall;
begin
  dbServer := TDbHttpServer.Create;
end;

procedure free_db_server(); stdcall;
begin
  dbServer.Free;
end;

procedure db_server_start(iPort:Integer); stdcall;
begin
  dbServer.start(iPort);
end;

procedure db_server_stop; stdcall;
begin
  dbServer.stop;
end;

exports
  create_db_server,
  free_db_server,
  db_server_start,
  db_server_stop;

begin
end.
