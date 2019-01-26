unit unCmdCli;

{
  workerman在cli模式下，如果程序有异常，进程将退出，不会重启进程，所以暂停开发
}

interface

uses
  Dialogs, SysUtils, utils_dvalue, Windows, Generics.Collections, Forms,
  Classes,
  ShellAPI, OtlTask, OtlTaskControl, OtlEventMonitor, OtlComm, OtlCommon;

const
  MSG_FINISH_TASK = 1; // 退出任务

type
  TCmdCli = class
  private
    FWorkerman: TDValue;
    listProgress: TList<Cardinal>;
    listTask: TList<IOmniTaskControl>;
    OmniEventMonitor: TOmniEventMonitor;
    // 监听task发过来的消息
    procedure OmniEventMonitorTaskMessage(const task: IOmniTaskControl;
      const msg: TOmniMessage);
  public
    constructor Create;
    destructor Destroy; override;
    // 启动workerman进程
    procedure runWork();
    // 关闭workerman进程
    procedure killWork();

    // 线程中运行exe且守护
    procedure runTask(const task: IOmniTask);
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

  listProgress := TList<Cardinal>.Create;
  listTask := TList<IOmniTaskControl>.Create;
  FWorkerman := unConfig.getWorkerman();
  OmniEventMonitor := TOmniEventMonitor.Create(nil);
  OmniEventMonitor.OnTaskMessage := OmniEventMonitorTaskMessage;
  Self.runWork;
end;

destructor TCmdCli.Destroy;
begin
  Self.killWork;
  FWorkerman.Free;
  OmniEventMonitor.Free;
  listTask.Free;
  listProgress.Free;

  inherited;
end;

procedure TCmdCli.killWork;
var
  i, iCount: integer;
begin
  iCount := listTask.Count - 1;
  for i := iCount downto 0 do
  begin
    listTask.Items[i].Comm.Send(1);
    OmniEventMonitor.Detach(listTask.Items[i]);
    //listTask.Items[i].Terminate(0)
  end;
  listTask.Clear;

  iCount := listProgress.Count - 1;
  for i := iCount downto 0 do
  begin
    TerminateProcess(listProgress.Items[i], 0);
    listProgress.Remove(listProgress.Items[i]);
    Application.ProcessMessages;
  end;
end;

procedure TCmdCli.OmniEventMonitorTaskMessage(const task: IOmniTaskControl;
  const msg: TOmniMessage);
var
  hProcess: Cardinal;
begin
  hProcess := msg.MsgData.AsCardinal;
  listProgress.Add(hProcess);
end;

procedure TCmdCli.runTask(const task: IOmniTask);
var
  zAppName: array [0 .. 512] of char;
  zCurDir: array [0 .. 255] of char;
  FileName, WorkDir: string;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  iExitCode: Cardinal;
  iVisibility: integer;

  MsgData: TOmniValue;
  msgID: word;

  //接收主线程发过来的消息，是否有退出信号
  procedure revTaskMsg();
  begin
    task.Comm.Receive(msgID, MsgData);
    if msgID = MSG_FINISH_TASK then
      Abort;//终止当前任务
  end;

begin
  FileName := task.Param.Item[0].AsString;
  iVisibility := task.Param.Item[1].AsInteger;

  StrPCopy(zAppName, FileName);
  GetDir(0, WorkDir);
  StrPCopy(zCurDir, WorkDir);
  FillChar(StartupInfo, Sizeof(StartupInfo), #0);
  StartupInfo.cb := Sizeof(StartupInfo);

  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := iVisibility;
  while True do
  begin
    CreateProcess(nil, zAppName, { pointer to command line string }
      nil, { pointer to process security attributes }
      nil, { pointer to thread security attributes }
      False, { handle inheritance flag }
      CREATE_NEW_CONSOLE or { creation flags }
      NORMAL_PRIORITY_CLASS, nil, { pointer to new environment block }
      nil, { pointer to current directory name }
      StartupInfo, { pointer to STARTUPINFO }
      ProcessInfo);

    // 被守护ID号传给主线程
    task.Comm.Send(0, ProcessInfo.hProcess);

    while True do
    begin
      Sleep(100);
      GetExitCodeProcess(ProcessInfo.hProcess, iExitCode);
      revTaskMsg();

      if iExitCode <> STILL_ACTIVE then
        Break;
    end;

    revTaskMsg();
  end;
end;

procedure TCmdCli.runWork;
var
  arrPHPCmd: TDValue;
  i: integer;
  progress: TProcessInformation;
  strCmdLine: string;
  task: IOmniTaskControl;
begin
  if FWorkerman.FindByPath('enable').AsInteger <> 1 then
    Exit;

  arrPHPCmd := FWorkerman.FindByPath('servers').AsArray;
  if not Assigned(arrPHPCmd) then
    Exit;

  for i := 0 to arrPHPCmd.Count - 1 do
  begin
    strCmdLine := arrPHPCmd.Items[i].AsString;
    task := CreateTask(runTask, 'runTask');
    task.Param.Add(strCmdLine);
    if FDebug = 1 then // 调试可查看调试日志
      task.Param.Add(SW_SHOWNORMAL)
    else // 非调试模式隐藏控制台
      task.Param.Add(SW_HIDE);
    OmniEventMonitor.Monitor(task); // 监听任务
    listTask.Add(task);
    task.Run; // 运行任务
  end;
end;

initialization

finalization

end.
