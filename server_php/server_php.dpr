library server_php;

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
  Classes, Windows,
  unPHPModule in 'unPHPModule.pas',
  unConfig in '..\unConfig.pas';

{$R *.res}

procedure create_php_server(); stdcall;
begin
  phpServer := TPHPModule.Create(nil);
end;

procedure free_php_server(); stdcall;
begin
  phpServer.Free;
end;

procedure php_server_start(iPort: Integer; logHandle: HWND); stdcall;
begin
  phpServer.start(iPort,logHandle);
end;

procedure php_server_stop; stdcall;
begin
  phpServer.stop;
end;

exports
  create_php_server,
  free_php_server,
  php_server_start,
  php_server_stop;

begin

end.

