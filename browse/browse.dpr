program browse;

{$I cef.inc}

uses
  Windows,
  uCEFApplication,
  unCEF in '..\unCEF.pas',
  unV8Extension in '..\unV8Extension.pas',
  unConfig in '..\unConfig.pas';

// CEF3 needs to set the LARGEADDRESSAWARE flag which allows 32-bit processes to use up to 3GB of RAM.
{$SetPEFlags IMAGE_FILE_LARGE_ADDRESS_AWARE}

begin
   CreateGlobalCEFApp;
  try
    GlobalCEFApp.StartSubProcess;
  finally
    DestroyGlobalCEFApp;
  end;
end.

