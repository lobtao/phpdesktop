unit unCEF;

interface

uses
  uCEFv8Handler, uCEFApplication, uCEFConstants,
  uCEFInterfaces, uCEFMiscFunctions, unV8Extension, unConfig, SysUtils,Windows;

procedure CreateGlobalCEFApp;

implementation

procedure GlobalCEFApp_OnWebKitInitializedEvent;
begin
  TCefRTTIExtension.Register('app', TV8Extension);
end;

procedure CreateGlobalCEFApp;
var
  strFlashPath: string;
begin
  GlobalCEFApp := TCefApplication.Create;
  GlobalCEFApp.OnWebKitInitialized := GlobalCEFApp_OnWebKitInitializedEvent;

  GlobalCEFApp.Locale := 'zh-CN';
  strFlashPath := unConfig.FAppPath + 'PepperFlash';
  if DirectoryExists(strFlashPath) then
    GlobalCEFApp.CustomFlashPath := strFlashPath
  else
    GlobalCEFApp.FlashEnabled := True;
  GlobalCEFApp.EnableGPU := False;
  GlobalCEFApp.DisableWebSecurity := True;
  // GlobalCEFApp.MuteAudio := True;//开启后会导致flash播放没有声音
  // GlobalCEFApp.FastUnload := True;
   GlobalCEFApp.DisableSafeBrowsing := True;
  // GlobalCEFApp.LogFile := 'log\debug.log';
  // GlobalCEFApp.LogSeverity := LOGSEVERITY_INFO;
  GlobalCEFApp.EnableMediaStream := True;
  // GlobalCEFApp.EnableSpeechInput := False;
   GlobalCEFApp.NoSandbox := False;
  // GlobalCEFApp.SingleProcess := True;
  // GlobalCEFApp.Cookies := 'cookies';
  GlobalCEFApp.Cache := 'cache';
  GlobalCEFApp.SetCurrentDir := True;
//  GlobalCEFApp.BrowserSubprocessPath := 'browse.exe';
  // ShowMessage(IntToStr(GlobalCEFApp.ChildProcessesCount));

  //解决启用flash插件时，有黑窗闪过的问题
  SetEnvironmentVariable('ComSpec', pchar(GetCurrentDir+'/cmd.exe'));

end;

end.
