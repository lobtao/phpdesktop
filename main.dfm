object Mainform: TMainform
  Left = 0
  Top = 0
  ActiveControl = PaintBox
  Caption = 'Mainform'
  ClientHeight = 493
  ClientWidth = 753
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PaintBox: TPaintBox32
    Left = 0
    Top = 0
    Width = 753
    Height = 493
    Align = alClient
    Options = [pboWantArrowKeys, pboAutoFocus]
    RepaintMode = rmOptimizer
    TabOrder = 0
    OnMouseDown = PaintBoxMouseDown
    OnMouseMove = PaintBoxMouseMove
    OnMouseUp = PaintBoxMouseUp
    OnMouseWheel = PaintBoxMouseWheel
    OnResize = PaintBoxResize
  end
  object chrmosr: TChromiumOSR
    DefaultUrl = 'http://www.google.com'
    OnGetRootScreenRect = chrmosrGetRootScreenRect
    OnGetViewRect = chrmosrGetRootScreenRect
    OnPaint = chrmosrPaint
    OnCursorChange = chrmosrCursorChange
    Left = 16
    Top = 8
  end
  object AppEvents: TApplicationEvents
    OnMessage = AppEventsMessage
    Left = 24
    Top = 64
  end
end
