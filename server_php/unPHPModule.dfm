object PHPModule: TPHPModule
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 421
  Width = 518
  object FPHPEngine: TPHPEngine
    OnScriptError = FPHPEngineScriptError
    SafeMode = True
    Constants = <>
    ReportDLLError = True
    Left = 248
    Top = 136
  end
end
