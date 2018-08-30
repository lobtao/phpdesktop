unit unCmdCli;

{
workerman在cli模式下，如果程序有异常，进程将退出，不会重启进程，所以暂停开发
}

interface

uses
  Dialogs, SysUtils, utils_dvalue, Windows, Generics.Collections, Forms;

type
  TCmdCli = class
  private
    FWorkerman: TDValue;
    listProgress: TList<TProcessInformation>;
  public
    constructor Create;
    destructor Destroy; override;
    function WinExecAndWait32(FileName: String; Visibility: integer;
      var mOutputs: string): Cardinal;
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

  FWorkerman := unConfig.getWorkerman();
  // ShowMessage(FWorkerman.Items[0].FindByName('php_cmd').AsString);
end;

destructor TCmdCli.Destroy;
begin
  FWorkerman.Free;

  inherited;
end;

function TCmdCli.WinExecAndWait32(FileName: String; Visibility: integer;
  var mOutputs: string): Cardinal;
var
  sa: TSecurityAttributes;
  hReadPipe, hWritePipe: THandle;
  ret: BOOL;
  strBuff: array [0 .. 255] of AnsiChar;
  lngBytesread: DWORD;

  WorkDir: String;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;

  zAppName: array [0 .. 512] of char;
  zCurDir: array [0 .. 255] of char;

  strTmp: AnsiString;
begin
  FillChar(sa, Sizeof(sa), #0);
  sa.nLength := Sizeof(sa);
  sa.bInheritHandle := True;
  sa.lpSecurityDescriptor := nil;
  ret := CreatePipe(hReadPipe, hWritePipe, @sa, 0);

  WorkDir := ExtractFileDir(Application.ExeName);
  FillChar(StartupInfo, Sizeof(StartupInfo), #0);
  StartupInfo.cb := Sizeof(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
  StartupInfo.wShowWindow := Visibility;

  StartupInfo.hStdOutput := hWritePipe;
  StartupInfo.hStdError := hWritePipe;

  FillChar(zAppName, Sizeof(zAppName), #0);
  StrPCopy(zAppName, FileName);
  FillChar(zCurDir, Sizeof(zCurDir), #0);
  StrPCopy(zCurDir, WorkDir);

  if not CreateProcess(nil, zAppName, { pointer to command line string }
    @sa, { pointer to process security attributes }
    @sa, { pointer to thread security attributes }
    True, { handle inheritance flag }
    // CREATE_NEW_CONSOLE or          { creation flags }
    NORMAL_PRIORITY_CLASS, nil, { pointer to new environment block }
    zCurDir, { pointer to current directory name, PChar }
    StartupInfo, { pointer to STARTUPINFO }
    ProcessInfo) { pointer to PROCESS_INF }
  then
    Result := INFINITE
  else
  begin
    ret := CloseHandle(hWritePipe);
    mOutputs := '';
    while ret do
    begin
      FillChar(strBuff, Sizeof(strBuff), #0);
      ret := ReadFile(hReadPipe, strBuff, 256, lngBytesread, nil);
      strTmp := StrPas(strBuff);
      if Length(strTmp) > 0 then
       mOutputs := mOutputs + AnsiToUtf8(strTmp);
      if Application.Terminated then
        break;
      Application.ProcessMessages;
    end;

    Application.ProcessMessages;
    WaitforSingleObject(ProcessInfo.hProcess, INFINITE);
    GetExitCodeProcess(ProcessInfo.hProcess, Result);
    CloseHandle(ProcessInfo.hProcess); { to prevent memory leaks }
    CloseHandle(ProcessInfo.hThread);
    ret := CloseHandle(hReadPipe);
  end;
end;

initialization

finalization

end.
