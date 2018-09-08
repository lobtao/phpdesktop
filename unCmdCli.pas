unit unCmdCli;

{
  workerman在cli模式下，如果程序有异常，进程将退出，不会重启进程，所以暂停开发
}

interface

uses
  Dialogs, SysUtils, utils_dvalue, Windows, Generics.Collections, Forms,
  Classes,
  ShellAPI;

type
  TCmdCli = class
  private
    FWorkerman: TDValue;
    listProgress: TList<TProcessInformation>;

    function winExecute(const FileName: string;
      Visibility: integer = SW_NORMAL): TProcessInformation;

  public
    constructor Create;
    destructor Destroy; override;
    // 启动workerman进程
    procedure runExe();
    // 关闭workerman进程
    procedure killExe();
  end;

var
  cmdCli: TCmdCli;

implementation

uses
  unConfig;

{ TCmdCli }

constructor TCmdCli.Create;
begin
  inherited;

  listProgress := TList<TProcessInformation>.Create;
  FWorkerman := unConfig.getWorkerman();
  Self.runExe;
end;

destructor TCmdCli.Destroy;
begin
  Self.killExe;
  FWorkerman.Free;
  listProgress.Free;

  inherited;
end;

procedure TCmdCli.killExe;
var
  i: integer;
begin
  for i := 0 to listProgress.Count - 1 do
    TerminateProcess(listProgress.Items[i].hProcess, 0);
end;

procedure TCmdCli.runExe;
var
  arrPHPCmd: TDValue;
  i: integer;
  progress: TProcessInformation;
begin
  if FWorkerman.FindByPath('enable').AsInteger <> 1 then
    Exit;

  arrPHPCmd := FWorkerman.FindByPath('servers').AsArray;
  if not Assigned(arrPHPCmd) then
    Exit;

  for i := 0 to arrPHPCmd.Count - 1 do
  begin
    if FDebug = 1 then
      progress := Self.winExecute(arrPHPCmd.Items[i].AsString, SW_SHOWNORMAL)
    else
      progress := Self.winExecute(arrPHPCmd.Items[i].AsString, SW_HIDE);
    listProgress.Add(progress);
  end;
end;

function TCmdCli.winExecute(const FileName: string;
  Visibility: integer): TProcessInformation;
var
  zAppName: array [0 .. 512] of char;
  zCurDir: array [0 .. 255] of char;
  WorkDir: string;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
begin
  StrPCopy(zAppName, FileName);
  GetDir(0, WorkDir);
  StrPCopy(zCurDir, WorkDir);
  FillChar(StartupInfo, Sizeof(StartupInfo), #0);
  StartupInfo.cb := Sizeof(StartupInfo);

  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := Visibility;
  CreateProcess(nil, zAppName, { pointer to command line string }
    nil, { pointer to process security attributes }
    nil, { pointer to thread security attributes }
    False, { handle inheritance flag }
    CREATE_NEW_CONSOLE or { creation flags }
    NORMAL_PRIORITY_CLASS, nil, { pointer to new environment block }
    nil, { pointer to current directory name }
    StartupInfo, { pointer to STARTUPINFO }
    ProcessInfo);
  Result := ProcessInfo;
end;

initialization

finalization

end.
