unit unRunOne;

interface

(* 程序是否已经运行，如果运行则激活它 *)
function AppHasRun(AppHandle: THandle; MapFileName: string): Boolean;

implementation

uses
  Windows, Forms;

//const
//  MapFileName = '{153CBD7A-C36B-4DB8-8163-2E5FE4C79E07}';

type
  //共享内存
  PShareMem = ^TShareMem;
  TShareMem = record
    AppHandle: THandle; //保存程序的句柄
  end;

var
  hMapFile: THandle;
  PSMem: PShareMem;

procedure CreateMapFile(MapFileName: string);
begin
  hMapFile := OpenFileMapping(FILE_MAP_ALL_ACCESS, False, PChar(MapFileName));
  if hMapFile = 0 then
  begin
    hMapFile := CreateFileMapping($FFFFFFFF, nil, PAGE_READWRITE, 0,
      SizeOf(TShareMem), PChar(MapFileName));
    PSMem := MapViewOfFile(hMapFile, FILE_MAP_WRITE or FILE_MAP_READ, 0, 0, 0);
    if PSMem = nil then
    begin
      CloseHandle(hMapFile);
      Exit;
    end;
    PSMem^.AppHandle := 0;
  end
  else
  begin
    PSMem := MapViewOfFile(hMapFile, FILE_MAP_WRITE or FILE_MAP_READ, 0, 0, 0);
    if PSMem = nil then
    begin
      CloseHandle(hMapFile);
    end
  end;
end;

procedure FreeMapFile;
begin
  UnMapViewOfFile(PSMem);
  CloseHandle(hMapFile);
end;

function AppHasRun(AppHandle: THandle; MapFileName: string): Boolean;
var
  TopWindow: HWnd;
begin
  //创建句柄
  CreateMapFile(MapFileName);

  Result := False;
  if PSMem <> nil then
  begin
    if PSMem^.AppHandle <> 0 then
    begin
//      SendMessage(PSMem^.AppHandle, WM_SYSCOMMAND, SC_RESTORE, 0);
//      TopWindow := GetLastActivePopup(PSMem^.AppHandle);
//      if (TopWindow <> 0) and (TopWindow <> PSMem^.AppHandle) and
//        IsWindowVisible(TopWindow) and IsWindowEnabled(TopWindow) then
//        begin
//        SetForegroundWindow(TopWindow);
//        end;
      MessageBox(0, '该程序已经运行中！','提示', MB_OK+MB_ICONINFORMATION);
      Application.Terminate;
      Result := True;
    end
    else
      PSMem^.AppHandle := AppHandle;
  end;
end;

initialization
//  CreateMapFile;

finalization
  FreeMapFile;

end.
