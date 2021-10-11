object FrmMain: TFrmMain
  Left = 313
  Top = 131
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Basic Image Transitions'
  ClientHeight = 428
  ClientWidth = 600
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 16
  object PnlCommands: TPanel
    Left = 0
    Top = 0
    Width = 243
    Height = 428
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    object RGTransition: TRadioGroup
      Left = 4
      Top = 0
      Width = 235
      Height = 391
      Caption = ' Transition '
      Items.Strings = (
        'Fade'
        'Scroll from Top-Left'
        'Scroll from Top'
        'Scroll from Top-RIght'
        'Scroll from Right'
        'Scroll from Bottom-Right'
        'Scroll from Bottom'
        'Scroll from Bottom-Left'
        'Scroll from Left'
        'Wipe Left to Right'
        'Wipe Right to Left'
        'Wipe Top to Bottom'
        'Wipe Bottom to Top'
        'Box In Wipe'
        'Box Wipe from Top-Left'
        'Box Wipe from Top-Right'
        'Box Wipe from Bottom-Left'
        'Box Wipe from Bottom-Right')
      TabOrder = 0
      OnClick = RGTransitionClick
    end
    object BtnReplay: TButton
      Left = 4
      Top = 394
      Width = 235
      Height = 30
      Caption = 'Replay transition'
      Enabled = False
      TabOrder = 1
      OnClick = BtnReplayClick
    end
  end
  object PnlClient: TPanel
    Left = 243
    Top = 0
    Width = 357
    Height = 428
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object PaintBox: TPaintBox
      Left = 0
      Top = 0
      Width = 357
      Height = 428
      Align = alClient
      OnPaint = PaintBoxPaint
    end
  end
end
