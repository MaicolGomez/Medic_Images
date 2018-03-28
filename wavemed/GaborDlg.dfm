object GaborForm: TGaborForm
  Left = 323
  Top = 143
  Width = 252
  Height = 268
  Caption = 'Gabor Conditions'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 48
    Width = 51
    Height = 13
    Caption = 'Orientation'
  end
  object Label2: TLabel
    Left = 24
    Top = 80
    Width = 31
    Height = 13
    Caption = 'Níveis'
  end
  object Edit1: TEdit
    Left = 95
    Top = 46
    Width = 81
    Height = 17
    TabOrder = 0
    Text = 'Edit1'
  end
  object Edit2: TEdit
    Left = 95
    Top = 78
    Width = 81
    Height = 17
    TabOrder = 1
    Text = 'Edit1'
  end
  object Button1: TButton
    Left = 80
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Processar >>'
    TabOrder = 2
    OnClick = Button1Click
  end
end
