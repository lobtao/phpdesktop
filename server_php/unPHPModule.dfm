object PHPModule: TPHPModule
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 260
  Width = 408
  object FPHPEngine: TPHPEngine
    OnScriptError = FPHPEngineScriptError
    SafeMode = True
    Constants = <>
    ReportDLLError = True
    Left = 72
    Top = 56
  end
end
